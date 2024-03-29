-- ╭──────────────────────────────────────────────────────────╮
-- │ Keymappings                                              │
-- ╰──────────────────────────────────────────────────────────╯
-- use { 'akinsho/git-conflict.nvim', config = "require('plugins.git.conflict')" }
-- use { 'ThePrimeagen/git-worktree.nvim', config = "require('plugins.git.worktree')" }

-- nnoremap <silent> <F5> <Cmd>lua require'dap'.continue()<CR>
-- nnoremap <silent> <F10> <Cmd>lua require'dap'.step_over()<CR>
-- nnoremap <silent> <F11> <Cmd>lua require'dap'.step_into()<CR>
-- nnoremap <silent> <F12> <Cmd>lua require'dap'.step_out()<CR>
-- nnoremap <silent> <Leader>b <Cmd>lua require'dap'.toggle_breakpoint()<CR>
-- nnoremap <silent> <Leader>B <Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
-- nnoremap <silent> <Leader>lp <Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
-- nnoremap <silent> <Leader>dr <Cmd>lua require'dap'.repl.open()<CR>
-- nnoremap <silent> <Leader>dl <Cmd>lua require'dap'.run_last()<CR>

-- require("dap.ext.vscode").load_launchjs()
-- lua require'dap'.status()
--   dap.defaults.fallback.external_terminal = {
--     command = '/usr/bin/alacritty';
--     args = {'-e'};
--   }

-- local function smart_d()
--   P('i m working')
--   local l, c = unpack(vim.api.nvim_win_get_cursor(0))
--   for _, line in ipairs(vim.api.nvim_buf_get_lines(0, l - 1, l, true)) do
--     if line:match('^%s*$') then
--       return '"_d'
--     end
--   end
--   return 'd'
-- end
-- local function smart_dd()
--   if vim.api.nvim_get_current_line():match('^%s*$') then
--     return '"_dd'
--   else
--     return 'dd'
--   end
-- end

-- vim.keymap.set('v', 'd', smart_d, { noremap = true, expr = true })
-- vim.keymap.set('n', 'dd', smart_dd, { noremap = true, expr = true })

-- local function delete_special()
--   local line_data = vim.api.nvim_win_get_cursor(0) -- returns {row, col}
--   local current_line = vim.api.nvim_buf_get_lines(0, line_data[1] - 1, line_data[1], false)
--   if current_line[1] == '' then
--     return '"_dd'
--   else
--     return 'dd'
--   end
-- end

keymap('n', '<leader>n', function()
  vim.cmd([[wa]])
  R('2048')
  vim.defer_fn(function()
    require('2048').startGame()
  end, 500)
end)
