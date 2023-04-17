require('onedark').setup({
  style = 'cool',
  transparent = state.theme.bg_tranparent,
  term_colors = false,
  toggle_style_key = '<leader>tB',
  toggle_style_list = { 'light', 'cool', 'deep', 'dark', 'darker' },
  -- colors = {},
  highlights = {
    ['@variable.builtin'] = { fg = '$yellow' },
    ['@constant'] = { fg = '$yellow' },
    ['@variable'] = { fg = '$red' },
    ['@property'] = { fg = '$red' },
    ['@field'] = { fg = '$red' },
    ['@punctuation.special'] = { fg = '$purple' },
    ['OrgDone'] = { fg = '$green' },

    ['@tag'] = { fg = '$red' },
    ['@tag.delimiter'] = { fg = '$fg' },
    ['@tag.attribute'] = { fg = '$orange' },
    ['@text.title'] = { fg = '$fg' },

    -- custom extends highlights
    ['@css.class'] = { fg = '$orange' },
    ['@css.id'] = { fg = '$blue' },
    ['@css.pseudo_element'] = { fg = '$purple' },

    -- hi! link @punctuation.special @keyword
    -- ["@function"] = {fg = '#222222', sp = '$cyan', fmt = 'underline,italic,bold'},
  },
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
