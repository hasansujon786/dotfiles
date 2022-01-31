local Popup = require('nui.popup')
local Text = require('nui.text')
local event = require('nui.utils.autocmd').event
local api = vim.api
local opt = vim.opt

local M = {}

---------------- Org float --------------------
local last_bufnr = vim.fn.bufadd('C:\\Users\\hasan\\vimwiki\\home.org')
local last_pop = nil

local function get_title_text()
  local text = vim.fn.fnamemodify(api.nvim_buf_get_name(last_bufnr), ':t')
  return Text(text, 'FloatBorder')
end
local function remove_autocmds()
  print('removed autocmd')
  last_pop = nil
  vim.cmd[[
      augroup OpenOrg
      au!
      augroup END
      ]]
end


M.open_org_home = function ()
  if vim.bo.filetype == 'org' then
    vim.cmd('edit ~/vimwiki/home.org')
  else
    last_pop = M.open_org_float()
  end
end

M.open_org_float = function()
  if last_pop ~= nil then
    last_pop:unmount()
    remove_autocmds()
  end

  local popup = Popup({
    -- bufnr = vim.api.nvim_get_current_buf(),
    bufnr = last_bufnr,
    zindex = 40,
    relative = 'editor',
    enter = true,
    focusable = true,
    border = {
      style = 'double',
      text = {
        top = get_title_text(),
        top_align = "center",
      },
    },
    position = {
      row = "40%",
      col = "50%",
    },
    size = {
      width = '80%',
      height = '70%',
    },
    -- buf_options = { modifiable = true, readonly = false, },
    win_options = {
      winblend = 5,
      number = true,
      relativenumber = true,
      signcolumn='yes',
      numberwidth=2,
      -- winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
    },
  })

  popup:mount()

  popup:on({ event.WinClosed }, function()
    vim.schedule(function()
      popup:unmount()
      remove_autocmds()
    end)
  end, { once = true })

  vim.cmd[[
    augroup OpenOrg
    au!
    au WinEnter,BufWinEnter,BufEnter *.org lua OrgOnFileChange()
    augroup END
    ]]

  -- vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, { 'Hello World' })
  return popup
end

function OrgOnFileChange()
  last_bufnr = api.nvim_buf_get_number(0)
  last_pop.border:set_text('top', get_title_text(), 'center')

  opt.number = true
  opt.relativenumber = true
  opt.signcolumn='yes'
  opt.numberwidth=2
end

M.toggle_org_float = function()
  if vim.bo.filetype == 'org' then
    -- pop:set_size({ width = 20, height = 20 })
    last_pop:unmount()
    remove_autocmds()
  else
    last_pop = M.open_org_float()
  end
end

return M
