local utils = require('hasan.utils')
local Popup = require('nui.popup')
local Text = require('nui.text')
local event = require('nui.utils.autocmd').event
local api = vim.api
local opt = vim.opt

local M = {}

---------------- Org float state --------------------
local last_pop = nil
local last_bufnr = 0

local function get_title_text(bufnr)
  local text = vim.fn.fnamemodify(api.nvim_buf_get_name(bufnr), ':t')
  return Text(text, 'TextInfo')
end
local function is_cur_win_org_float()
  return utils.is_floting_window(0) and vim.bo.filetype == 'org'
end
local function remove_autocmds()
  last_pop = nil
  vim.cmd([[
      augroup OrgFloatWin
      au!
      augroup END
      ]])
end

M.open_org_home = function()
  if vim.bo.filetype == 'org' then
    vim.cmd('edit ' .. org_home_path)
  else
    last_pop = M.open_org_float()
  end
end

M.open_org_float = function()
  -- get the bufnr if the buffer was cleared from buflist
  if vim.fn.bufexists(last_bufnr) == 0 then
    last_bufnr = vim.fn.bufadd(_G.org_home_path)
  end
  if last_pop ~= nil then
    last_pop:unmount()
    remove_autocmds()
  end

  local popup = Popup({
    -- bufnr = vim.api.nvim_get_current_buf(),
    bufnr = last_bufnr,
    zindex = 10,
    relative = 'editor',
    enter = true,
    focusable = true,
    border = {
      style = 'double',
      text = {
        top = get_title_text(last_bufnr),
        top_align = 'center',
      },
    },
    position = {
      row = '40%',
      col = '50%',
    },
    size = {
      width = '80%',
      height = '70%',
    },
    -- buf_options = { modifiable = true, readonly = false, },
    win_options = {
      number = true,
      relativenumber = true,
      signcolumn = 'yes',
      numberwidth = 2,
      winhighlight = 'Normal:NuiNormalFloat,FloatBorder:NuiFloatBorder,Folded:TextInfo',
    },
  })

  popup:mount()
  if vim.bo.filetype == '' then
    vim.bo.filetype = 'org'
  end

  popup:on({ event.WinClosed }, function()
    vim.schedule(function()
      popup:unmount()
      remove_autocmds()
    end)
  end, { once = true })

  vim.cmd([[
    augroup OrgFloatWin
    au!
    au WinEnter,BufWinEnter,BufEnter *.org lua OnFloatWinEnter()
    augroup END
    ]])

  -- vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, { 'Hello World' })
  return popup
end

function OnFloatWinEnter()
  if is_cur_win_org_float() then
    last_bufnr = api.nvim_buf_get_number(0)
    last_pop.border:set_text('top', get_title_text(last_bufnr), 'center')

    opt.number = true
    opt.relativenumber = true
    opt.signcolumn = 'yes'
    opt.numberwidth = 2
  end
end

M.toggle_org_float = function()
  if is_cur_win_org_float() or last_pop ~= nil then
    -- pop:set_size({ width = 20, height = 20 })
    last_pop:unmount()
    remove_autocmds()
  else
    last_pop = M.open_org_float()
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
