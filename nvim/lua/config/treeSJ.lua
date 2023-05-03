require('treesj').setup({
  use_default_keymaps = false,
  max_join_length = 120,
  -- langs = {},
  dot_repeat = true,
})

vim.keymap.set('n', '<leader>m', require('treesj').toggle)
