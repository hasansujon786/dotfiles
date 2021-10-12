vim.g.onedark_style = 'cool'
vim.g.onedark_italic_comment = false -- default true
vim.g.onedark_transparent_background = vim.g.bg_tranparent -- default false
require('onedark').setup()

vim.fn['hasan#highlight#load_custom_highlight']()

vim.g.onedark_theme_colors ={
  dark = { bg='#282c34', fg='#abb2bf'},
  cool = { bg='#242b38', fg='#a5b0c5' },
}
