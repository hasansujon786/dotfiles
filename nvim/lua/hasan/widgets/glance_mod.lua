local NuiLine = require('nui.line')
local NuiText = require('nui.text')
local Popup = require('nui.popup')

--------------------------------------------------
-- cursor_pointer --------------------------------
--------------------------------------------------
local cursor_pointer_pop = nil
local parent_col = 0

local M = {}

function M.initialize_before_open()
  local parent_win = vim.api.nvim_get_current_win()

  local win_cursor = vim.api.nvim_win_get_cursor(parent_win)
  local win_position = vim.api.nvim_win_get_position(parent_win)
  local number_column_width = vim.fn.getwininfo(parent_win)[1].textoff

  parent_col = win_position[2] + win_cursor[2] + number_column_width
end

function M.attach_cursor_pointer(glance_row)
  dd('asdf')
  local line = NuiLine({ NuiText('', 'GlanceBorderCursor') })
  local opts = {
    enter = false,
    focusable = false,
    win_options = {
      sidescrolloff = 0,
      winblend = 0,
      winhighlight = '',
    },
    relative = 'editor',
    zindex = 21,
    position = { row = glance_row, col = parent_col },
    size = { width = 2, height = 1 },
  }
  dd('asdfsadf')

  local pop = Popup(opts)

  local bufnr, ns_id, linenr_start = pop.bufnr, -1, 1
  line:render(bufnr, ns_id, linenr_start)
  pop:mount()

  cursor_pointer_pop = pop
end

function M.detatch_cursor_pointer()
  if cursor_pointer_pop ~= nil then
    cursor_pointer_pop:unmount()
  end
end

local augroup = vim.api.nvim_create_augroup('GlanceFocus', {})
vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = augroup,
  pattern = { 'Glance' },
  callback = function()
    local win = vim.api.nvim_get_current_win()
    local win_cursor = vim.api.nvim_win_get_cursor(win)
    local win_position = vim.api.nvim_win_get_position(win)

    local absolute_row = win_position[1] + win_cursor[1] - 1

    M.attach_cursor_pointer(absolute_row)
  end,
})

return M
