local M = {}

M.close_level = function(level)
  local last = vim.fn.line('$')

  for lnum = 1, last do
    if vim.fn.foldlevel(lnum) == level and vim.fn.foldclosed(lnum) == -1 then
      vim.api.nvim_win_set_cursor(0, { lnum, 0 })
      vim.cmd('normal! zc')
    end
  end
end

return M
