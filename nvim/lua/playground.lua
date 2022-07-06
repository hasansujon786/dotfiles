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

