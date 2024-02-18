local M = {}
local Widget = require('hasan.widgets')
-- local utils = require('hasan.utils')
-- local Popup = require('nui.popup')
-- local NuiLine = require('nui.line')
-- local NuiText = require('nui.text')

local notify_popups = {}
local last_notifyf = nil

local function create_notify_win(callback, opts)
  if #notify_popups == 0 then
    last_notifyf = nil
  end
  local pop = Widget.init_notify_popup(opts or {}, last_notifyf)
  last_notifyf = pop
  if callback ~= nil then
    callback(pop)
  end
  -- mount/open the component
  pop:mount()
  table.insert(notify_popups, #notify_popups + 1)

  vim.defer_fn(function()
    table.remove(notify_popups, #notify_popups)
    pop:unmount()
  end, 3000)
end

_G.bar = function()
  local function showContent(pop)
    vim.api.nvim_buf_set_lines(pop.bufnr, 0, 1, false, { 'Hello World' })
  end
  create_notify_win(showContent, {})
end

return M
