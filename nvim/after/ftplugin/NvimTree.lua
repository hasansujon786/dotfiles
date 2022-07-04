local opts = { buffer = vim.api.nvim_get_current_buf() }

keymap('n', 'o', '<cmd>lua require("hasan.utils.vinegar").actions.open()<CR>', opts)
keymap('n', '<2-LeftMouse>', '<cmd>lua require("hasan.utils.vinegar").actions.open()<CR>', opts)
keymap('n', '<CR>', '<cmd>lua require("hasan.utils.vinegar").actions.open_n_close()<CR>', opts)
