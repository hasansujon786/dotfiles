return {
  'Wansmer/treesj',
  opts = {
    use_default_keymaps = false,
    max_join_length = 1000,
    -- langs = {},
    dot_repeat = true,
  },
  keys = {
    { '<leader>fm', '<cmd>TSJToggle<CR>', desc = 'TreeSJ: Toggle' },
    { '<leader>fj', '<cmd>TSJSplit<CR>', desc = 'TreeSJ: Split' },
    { '<leader>fJ', '<cmd>TSJJoin<CR>', desc = 'TreeSJ: Join' },
  },
}
