local M = {}
local utils = require('hasan.utils')
local Popup = require('nui.popup')

local anchor = { 'NW', 'NE', 'SW', 'SE' }

M.init_notify_popup = function(opts, last_pop)
  local row = vim.o.lines - 1
  if last_pop ~= nil then
    row = last_pop.win_config.row - (last_pop.win_config.height + 2)
  end
  opts = utils.merge({
    enter = false,
    focusable = false,
    border = { style = 'single' },
    anchor = anchor[3],
    relative = 'editor',
    -- zindex = 1000,
    position = { row = row, col = '100%' },
    -- position = '80%',
    size = {
      width = 30,
      height = 1,
    },
  }, opts or {})

  return Popup(opts)
end

return M
