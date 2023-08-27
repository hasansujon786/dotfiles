local M = {}

function M.restore_cussor_pos()
  local mark = vim.api.nvim_buf_get_mark(0, '"')
  local lcount = vim.api.nvim_buf_line_count(0)
  if mark[1] > 0 and mark[1] <= lcount then
    pcall(vim.api.nvim_win_set_cursor, 0, mark)
  end
end

function M.focusWinIfExists(ft)
  for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(winid)
    if vim.bo[buf].filetype == ft then
      vim.api.nvim_set_current_win(winid)
      return winid
    end
  end
end

return M
