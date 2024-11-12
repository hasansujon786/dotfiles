local M = {}

local modes = { 'i', 'a', 'o', 'I', 'A', 'O' }
local active = false

M.center_cursor = function(key)
  return function()
    local win = vim.api.nvim_get_current_win()
    local cursor_row = vim.api.nvim_win_get_cursor(win)[1]
    local top_line = vim.fn.line('w0')
    local relative_row = cursor_row - top_line -- + 1
    local middle_height = vim.api.nvim_win_get_height(win) / 2

    -- 4 line under from center
    if relative_row - 2 > middle_height then
      vim.api.nvim_feedkeys('zz' .. key, 'n', false)
    else
      vim.api.nvim_feedkeys(key, 'n', false)
    end
  end
end

M.remove_mappings = function()
  active = false
  for _, key in ipairs(modes) do
    vim.keymap.del('n', key)
  end
end

---Attach mappings for center window on insert
M.attach_mappings = function()
  active = true
  for _, key in ipairs(modes) do
    keymap('n', key, M.center_cursor(key))
  end
end

M.toggle = function()
  if active then
    M.remove_mappings()
  else
    M.attach_mappings()
  end
end

command('CenterCursorToggle', M.toggle, { desc = 'Toggle center cursor on insert' })

return M
