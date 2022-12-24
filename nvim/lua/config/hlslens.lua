require('hlslens').setup({
  calm_down = true,
  nearest_only = true,
  -- enable_incsearch = false,
  -- nearest_float_when = 'always',
  -- float_shadow_blend = 10
})

keymap('n', 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]])
keymap('n', 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]])
keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]])
keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]])
keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]])
keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]])

vim.cmd([[
  aug VMlens
    au!
    au User visual_multi_start lua require('config.vmlens').start()
    au User visual_multi_exit lua require('config.vmlens').exit()
  aug END
]])
