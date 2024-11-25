local NuiLine = require('nui.line')
local NuiText = require('nui.text')
local Popup = require('nui.popup')

--------------------------------------------------
-- cursor_pointer --------------------------------
--------------------------------------------------
local cursor_pointer_pop = nil

local function create_pointer_pop()
  local cur_pos = vim.api.nvim_win_get_cursor(0)
  local opts = {
    enter = false,
    focusable = false,
    win_options = {
      sidescrolloff = 0,
      winblend = 0,
      winhighlight = '',
    },
    -- anchor = anchor[3],
    -- relative = 'cursor',
    relative = {
      type = 'buf',
      position = {
        row = cur_pos[1],
        col = 0,
      },
    },
    zindex = 21,
    position = { row = 0, col = cur_pos[2] },
    size = { width = 2, height = 1 },
  }

  return Popup(opts)
end

local M = {}
function M.set_cursor_pointer()
  local line = NuiLine({ NuiText('', 'GlanceBorderCursor') })
  local pop = create_pointer_pop()

  local bufnr, ns_id, linenr_start = pop.bufnr, -1, 1
  line:render(bufnr, ns_id, linenr_start)
  pop:mount()

  cursor_pointer_pop = pop
  return pop
end

function M.remove_cursor_pointer()
  if cursor_pointer_pop ~= nil then
    cursor_pointer_pop:unmount()
  end
end

return M
