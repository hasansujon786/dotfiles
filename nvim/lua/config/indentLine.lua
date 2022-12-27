require('indent_blankline').setup({
  buftype_exclude = { 'terminal', 'prompt' },
  filetype_exclude = {
    'help',
    'dashboard',
    'packer',
    'NvimTree',
    'Trouble',
    'WhichKey',
    'lsp-installer',
    'mason',
    'Outline',
    'alpha',
    'ccc-ui',
    '2048',
    'lazy',
  },
  show_first_indent_level = false,
  -- show_current_context = true,
  -- space_char_blankline = ' ',
})

-- For wrapping mappings related to folding and horizontal shifting so that
-- indent-blankline.nvim can update immediately. See:
-- https://github.com/lukas-reineke/indent-blankline.nvim/issues/118
local indent_wrap_mapping = function(mapping)
  if vim.g.loaded_indent_blankline == 1 then
    return mapping .. ':IndentBlanklineRefresh<CR>'
  else
    return mapping
  end
end

keymap('n', '0', indent_wrap_mapping('0'))
keymap('n', 'zA', indent_wrap_mapping('zA'))
keymap('n', 'zC', indent_wrap_mapping('zC'))
keymap('n', 'zM', indent_wrap_mapping('zM'))
keymap('n', 'z.', indent_wrap_mapping(':%foldclose<CR>'))
keymap('n', 'zO', indent_wrap_mapping('zO'))
keymap('n', 'zR', indent_wrap_mapping('zR'))
keymap('n', 'zX', indent_wrap_mapping('zX'))
keymap('n', 'za', indent_wrap_mapping('za'))
keymap('n', 'zc', indent_wrap_mapping('zc'))
keymap('n', 'zm', indent_wrap_mapping('zm'))
keymap('n', 'zo', indent_wrap_mapping('zo'))
keymap('n', 'zr', indent_wrap_mapping('zr'))
keymap('n', 'zv', indent_wrap_mapping('zv'))
keymap('n', 'zx', indent_wrap_mapping('zx'))
keymap('n', '<<', indent_wrap_mapping('<<'))
keymap('n', '>>', indent_wrap_mapping('>>'))
keymap('n', '<Tab>', indent_wrap_mapping('za'))
keymap('n', '<s-tab>', indent_wrap_mapping('zA'))
