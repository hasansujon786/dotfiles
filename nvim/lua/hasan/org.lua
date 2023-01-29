local utils = require('hasan.utils')
local Layout = require('nui.layout')
local Popup = require('nui.popup')
local event = require('nui.utils.autocmd').event
local api = vim.api
local opt = vim.opt
if package.loaded['nvim-treesitter'] == nil then
  vim.cmd([[Lazy load nvim-treesitter]])
end

local M = {}

---------------- Org float state --------------------
local last_layout = nil
local last_main_pop = nil
local last_bufnr = 0
_G.org_onWinResized = nil

local fn = {
  set_winbar = function()
    vim.wo.winbar = '%{%v:lua.require("hasan.org").winbar()%}'
  end,
  is_cur_win_org_float = function()
    return utils.is_floting_window(0) and vim.bo.filetype == 'org'
  end,
  remove_autocmds = function()
    if last_layout then
      last_layout:unmount()
    end
    last_layout = nil
    _G.org_onWinResized = nil
    vim.cmd([[
      augroup OrgFloatWin
        au!
      augroup END
      ]])
  end,
  get_popup = function(fullscreen)
    local pop_config = {
      side = {
        border = 'none',
        focusable = false,
        zindex = 49,
        -- win_options = { winhighlight = 'Normal:CursorColumn' },
      },
      main = {
        -- bufnr = vim.api.nvim_get_current_buf(),
        bufnr = last_bufnr,
        zindex = 49,
        relative = 'editor',
        enter = true,
        focusable = true,
        border = { style = { '│', ' ', '│', '│', '│', ' ', '│', '│' } },
        -- position = {
        --   row = '40%',
        --   col = '50%',
        -- },
        -- size = {
        --   width = '80%',
        --   height = '70%',
        -- },
        -- buf_options = { modifiable = true, readonly = false, },
        win_options = {
          number = true,
          relativenumber = true,
          signcolumn = 'yes',
          numberwidth = 2,
          concealcursor = 'n',
          conceallevel = 2,
          winhighlight = 'FloatBorder:ZenBorder,Folded:OrgHeadlineLevel1',
        },
      },
    }

    local pop_main = Popup(pop_config.main)
    -- if not fullscreen then
    --   return pop_main, pop_main
    -- end

    local pop_left, pop_right = Popup(pop_config.side), Popup(pop_config.side)
    local panes = {
      Layout.Box(pop_left, { size = '14%' }),
      Layout.Box(pop_main, { size = '74%' }),
      Layout.Box(pop_right, { size = '13%' }),
    }
    local layout = Layout({
      relative = 'editor',
      position = {
        row = 0,
        col = 0,
      },
      size = {
        width = '100%',
        height = '96%',
      },
    }, Layout.Box(panes, { dir = 'row' }))

    _G.org_onWinResized = function()
      layout:update(Layout.Box(panes, { dir = 'row' }))
      vim.defer_fn(function()
        M.onOrgWinEnter()
      end, 50)
    end

    return layout, pop_main
  end,
  -- get_title_text = function(bufnr)
  --   local text = vim.fn.fnamemodify(api.nvim_buf_get_name(bufnr), ':t')
  --   return Text(text, 'TextInfo')
  -- end
}

function M.open_org_home()
  vim.cmd('edit ' .. org_home_path)
end

function M.open_org_float()
  -- get the bufnr if the buffer was cleared from buflist
  if last_bufnr == 0 or vim.fn.bufexists(last_bufnr) == 0 then
    last_bufnr = vim.fn.bufadd(_G.org_home_path)
  end
  fn.remove_autocmds()
  local layout, pop_main = fn.get_popup(false)

  layout:mount()
  require('hasan.utils.win').restore_cussor_pos()
  fn.set_winbar()
  if vim.bo.filetype == '' then
    vim.bo.filetype = 'org'
  end

  pop_main:on({ event.WinLeave }, function()
    vim.schedule(function()
      if utils.is_floting_window(0) then
        return
      end

      fn.remove_autocmds()
    end)
  end)
  -- end, { once = true })

  vim.cmd([[
    augroup OrgFloatWin
      au!
      au WinEnter,BufWinEnter,BufEnter *.org lua require('hasan.org').onOrgWinEnter()
      au VimResized * lua _G.org_onWinResized()
    augroup END
    ]])

  pop_main:map('n', '<leader>u', fn.remove_autocmds, {})
  pop_main:map('n', '<leader>q', fn.remove_autocmds, {})

  -- vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, { 'Hello World' })
  return layout, pop_main
end

function M.toggle_org_float()
  if fn.is_cur_win_org_float() or last_layout ~= nil then
    fn.remove_autocmds()
  else
    last_layout, last_main_pop = M.open_org_float()
  end
end

function M.onOrgWinEnter()
  if fn.is_cur_win_org_float() then
    last_bufnr = api.nvim_buf_get_number(0)
    fn.set_winbar()
    -- last_pop.border:set_text('top', get_title_text(last_bufnr), 'center')

    opt.number = true
    opt.relativenumber = true
    opt.signcolumn = 'yes'
    opt.numberwidth = 2
  end
end

function M.winbar()
  local title = vim.fn.fnamemodify(api.nvim_buf_get_name(0), ':t')
  local width = vim.api.nvim_win_get_width(0)
  local pad = (width / 2) - (string.len(title) / 2)
  local color = vim.bo.modified and '%#TSRed#' or '%#TextInfo#'

  return string.format('%s%s%s', string.rep(' ', pad), color, title)
end

-- ------------------------------------------------
-- => create org note
-- ------------------------------------------------
function M.create_link()
  local template = '[[%s][%s]]'
  local title = require('hasan.utils').get_visual_selection()
  feedkeys('"zdiW')

  vim.defer_fn(function()
    local link = vim.fn.getreg('z')
    vim.fn.setreg('z', string.format(template, link, title), 'v')
    vim.cmd([[normal! "zp]])
  end, 100)
end

return M
