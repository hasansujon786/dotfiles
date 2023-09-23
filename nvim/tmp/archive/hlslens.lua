require('hlslens').setup({
  calm_down = true,
  nearest_only = true,
  -- enable_incsearch = false,
  -- nearest_float_when = 'always',
  -- float_shadow_blend = 10
})

vim.cmd([[
  aug VMlens
    au!
    au User visual_multi_start lua require('config.vmlens').start()
    au User visual_multi_exit lua require('config.vmlens').exit()
  aug END
]])

local kopts = { noremap = true, silent = true }
local hl_next = [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]]
local hl_prev = [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]]

vim.api.nvim_set_keymap('n', 'n', hl_next, kopts)
vim.api.nvim_set_keymap('n', 'N', hl_prev, kopts)
vim.api.nvim_set_keymap('x', 'n', hl_next, kopts)
vim.api.nvim_set_keymap('x', 'N', hl_prev, kopts)
vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
