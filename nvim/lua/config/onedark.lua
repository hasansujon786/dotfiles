vim.g.onedark_italic_comment = false -- By default it is true
require('onedark').setup()

vim.fn['hasan#highlight#load_custom_highlight']()
vim.cmd[[source ~/dotfiles/nvim/config/tabline.vim]]
