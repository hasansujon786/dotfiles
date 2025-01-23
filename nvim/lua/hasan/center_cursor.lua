local M = {}

local is_active = false
local center_threshold = 0.3
local center_insert_keys = { 'i', 'a', 'o', 'I', 'A', 'O' }

M.center_cursor = function(key)
  return function()
    local win = vim.api.nvim_get_current_win()
    local top_line = vim.fn.line('w0')
    local cursor_row = vim.api.nvim_win_get_cursor(win)[1]

    local center_line = vim.api.nvim_win_get_height(win) / 2
    local vp_cursor_line = cursor_row - top_line + 1

    local should_center = vp_cursor_line >= center_line + math.floor(center_line * center_threshold)

    if should_center then
      return 'zz' .. key
    else
      return key
    end
  end
end

M.remove_mappings = function()
  is_active = false
  for _, key in ipairs(center_insert_keys) do
    vim.keymap.del('n', key)
  end
end

---Attach mappings for center window on insert
M.attach_mappings = function()
  is_active = true
  for _, key in ipairs(center_insert_keys) do
    keymap('n', key, M.center_cursor(key), { expr = true })
  end
end

M.toggle = function()
  if is_active then
    M.remove_mappings()
  else
    M.attach_mappings()
  end
end

command('CenterCursorToggle', M.toggle, { desc = 'Toggle center cursor on insert' })

return M
