require('onedark').setup({
  style = 'cool',
  transparent = vim.g.bg_tranparent,
  term_colors = false,
  toggle_style_key = '<leader>tB',
  toggle_style_list = { 'light', 'cool', 'deep', 'dark', 'darker' },
  -- colors = {},
  -- highlights = {},
  -- Options are italic, bold, underline, none
  code_style = {
    comments = 'italic',
    keywords = 'italic',
    functions = 'italic',
    strings = 'none',
    variables = 'none',
  },
  -- Plugins Config --
  diagnostics = {
    darker = true,
    undercurl = true,
    background = true,
  },
})

require('onedark').load()

vim.g.onedark_theme_colors = {
  dark = { normal = { bg = '#282c34', fg = '#abb2bf' } },
  cool = { normal = { bg = '#242b38', fg = '#a5b0c5' } },
}