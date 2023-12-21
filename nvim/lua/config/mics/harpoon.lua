return {
  'hasansujon786/harpoon',
  lazy = true,
  module = 'harpoon',
  keys = {
    { '<leader>M', '<cmd>lua require("harpoon.mark").add_file()<CR>', desc = 'Harpoon: Add file' },
    { '<leader><tab>', '<cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>', desc = 'Harpoon: Toggle menu' },
    { '[<tab>', '<cmd>lua require("harpoon.ui").nav_prev()<CR>', desc = 'Harpoon: Prev item' },
    { ']<tab>', '<cmd>lua require("harpoon.ui").nav_next()<CR>', desc = 'Harpoon: Next item' },
  },
  init = function()
    local harpoon_ls, harpoon_rs = '<leader>%s', '<cmd>lua require("harpoon.ui").nav_file(%s)<CR>'
    local win_ls, win_rs = '<leader>w%s', '%s<C-w>w'
    for i = 0, 9 do
      keymap('n', harpoon_ls:format(i), harpoon_rs:format(i), { desc = 'which_key_ignore' })
      keymap('n', win_ls:format(i), win_rs:format(i), { desc = 'which_key_ignore' })
    end
  end,
  opts = {
    menu = { width = 80 },
  },
}
