local utils = require('hasan.utils')
local Layout = require('nui.layout')
local Popup = require('nui.popup')
local Text = require('nui.text')
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

local function set_winbar(pop)
  local title = vim.fn.fnamemodify(api.nvim_buf_get_name(last_bufnr), ':t')
  local width = pop.win_config.width
  local pad = (width / 2) - (string.len(title) / 2)
  vim.wo.winbar = string.format('%s%s%s', string.rep(' ', pad), '%#TextInfo#', title)
end
local function restore_cussor_pos()
  local mark = vim.api.nvim_buf_get_mark(0, '"')
  local lcount = vim.api.nvim_buf_line_count(0)
  if mark[1] > 0 and mark[1] <= lcount then
    pcall(vim.api.nvim_win_set_cursor, 0, mark)
  end
end
local function get_title_text(bufnr)
  local text = vim.fn.fnamemodify(api.nvim_buf_get_name(bufnr), ':t')
  return Text(text, 'TextInfo')
end
local function is_cur_win_org_float()
  return utils.is_floting_window(0) and vim.bo.filetype == 'org'
end
local function remove_autocmds()
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
end

M.open_org_home = function()
  vim.cmd('edit ' .. org_home_path)
end

local function get_popup(fullscreen)
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
      border = {
        style = { '│', ' ', '│', '│', '│', ' ', '│', '│' },
        -- style = 'double',
        -- text = { top = get_title_text(last_bufnr), top_align = 'center' },
      },
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
        -- winhighlight = 'Normal:NuiNormalFloat,FloatBorder:NuiFloatBorder,Folded:TextInfo',
        winhighlight = 'FloatBorder:ZenBorder',
      },
    },
  }

  local pop_main = Popup(pop_config.main)
  -- if not fullscreen then
  --   return pop_main, pop_main
  -- end

  local pop_left, pop_right = Popup(pop_config.side), Popup(pop_config.side)
  local layout = Layout(
    {
      relative = 'editor',
      position = {
        row = 0,
        col = 0,
      },
      size = {
        width = '100%',
        height = '100%',
      },
    },
    Layout.Box({
      Layout.Box(pop_left, { size = '14%' }),
      Layout.Box(pop_main, { size = '74%' }),
      Layout.Box(pop_right, { size = '13%' }),
    }, { dir = 'row' })
  )

  _G.org_onWinResized = function()
    layout:update(Layout.Box({
      Layout.Box(pop_left, { size = '14%' }),
      Layout.Box(pop_main, { size = '74%' }),
      Layout.Box(pop_right, { size = '13%' }),
    }, { dir = 'row' }))
    vim.defer_fn(function()
      Org_OnFloatWinEnter()
    end, 50)
  end

  return layout, pop_main
end

M.open_org_float = function()
  -- get the bufnr if the buffer was cleared from buflist
  if last_bufnr == 0 or vim.fn.bufexists(last_bufnr) == 0 then
    last_bufnr = vim.fn.bufadd(_G.org_home_path)
  end
  remove_autocmds()
  local layout, pop_main = get_popup(false)

  layout:mount()
  restore_cussor_pos()
  set_winbar(pop_main)
  if vim.bo.filetype == '' then
    vim.bo.filetype = 'org'
  end

  -- pop_main:on({ event.WinClosed }, function()
  --   vim.schedule(function()
  --     P('Closing')
  --     pop_main:unmount()
  --     layout:unmount()
  --     remove_autocmds()
  --   end)
  -- end, { once = true })

  vim.cmd([[
    augroup OrgFloatWin
      au!
      au WinEnter,BufWinEnter,BufEnter *.org lua Org_OnFloatWinEnter()
      au WinResized * lua _G.org_onWinResized()
    augroup END
    ]])

  pop_main:map('n', '<leader>u', remove_autocmds, {})
  pop_main:map('n', '<leader>q', remove_autocmds, {})

  -- vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, { 'Hello World' })
  return layout, pop_main
end
function Org_OnFloatWinEnter()
  if is_cur_win_org_float() then
    last_bufnr = api.nvim_buf_get_number(0)
    set_winbar(last_main_pop)
    -- last_pop.border:set_text('top', get_title_text(last_bufnr), 'center')

    opt.number = true
    opt.relativenumber = true
    opt.signcolumn = 'yes'
    opt.numberwidth = 2
  end
end

M.toggle_org_float = function()
  if is_cur_win_org_float() or last_layout ~= nil then
    remove_autocmds()
  else
    last_layout, last_main_pop = M.open_org_float()
  end
end

-- ------------------------------------------------
-- => create org note
-- ------------------------------------------------
M.create_link = function()
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
