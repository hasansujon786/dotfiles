require('indent_blankline').setup({
  buftype_exclude = { 'terminal', 'prompt' },
  filetype_exclude = { 'help', 'dashboard', 'packer', 'NvimTree', 'Trouble', 'WhichKey', 'lsp-installer' },
  show_first_indent_level = false,
  -- show_current_context = true,
  -- space_char_blankline = ' ',
})

-- For wrapping mappings related to folding and horizontal shifting so that
-- indent-blankline.nvim can update immediately. See:
-- https://github.com/lukas-reineke/indent-blankline.nvim/issues/118
local maps = require('hasan.utils.maps')
local indent_wrap_mapping = function(mapping)
  if vim.g.loaded_indent_blankline == 1 then
    return mapping .. ':IndentBlanklineRefresh<CR>'
  else
    return mapping
  end
end

maps.nnoremap('0', indent_wrap_mapping('0'))
maps.nnoremap('zA', indent_wrap_mapping('zA'))
maps.nnoremap('zC', indent_wrap_mapping('zC'))
maps.nnoremap('zM', indent_wrap_mapping('zM'))
maps.nnoremap('z.', indent_wrap_mapping(':%foldclose<CR>'))
maps.nnoremap('zO', indent_wrap_mapping('zO'))
maps.nnoremap('zR', indent_wrap_mapping('zR'))
maps.nnoremap('zX', indent_wrap_mapping('zX'))
maps.nnoremap('za', indent_wrap_mapping('za'))
maps.nnoremap('zc', indent_wrap_mapping('zc'))
maps.nnoremap('zm', indent_wrap_mapping('zm'))
maps.nnoremap('zo', indent_wrap_mapping('zo'))
maps.nnoremap('zr', indent_wrap_mapping('zr'))
maps.nnoremap('zv', indent_wrap_mapping('zv'))
maps.nnoremap('zx', indent_wrap_mapping('zx'))
maps.nnoremap('<<', indent_wrap_mapping('<<'))
maps.nnoremap('>>', indent_wrap_mapping('>>'))
maps.nnoremap('<Tab>', indent_wrap_mapping('za'))
maps.nnoremap('<s-tab>', indent_wrap_mapping('zA'))
