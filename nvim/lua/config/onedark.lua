vim.g.onedark_style = 'cool'
vim.g.onedark_italic_comment = false -- default true
vim.g.onedark_transparent_background = vim.g.bg_tranparent -- default false
require('onedark').setup()

vim.fn['hasan#highlight#load_custom_highlight']()
vim.cmd[[source ~/dotfiles/nvim/legacy/config/tabline.vim]]
