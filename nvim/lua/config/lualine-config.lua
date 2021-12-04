local sl = require('hasan.utils.statusline')

local onedark = require'lualine.themes.onedark'
-- onedark.normal.b.bg = '#68707E'
onedark.normal.c.fg = '#68707E'

require('lualine').setup {
  options = {
    theme = onedark,
    component_separators = '',
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
    lualine_b = {
      { 'filetype', colored = true, icon_only = true, padding = { left = 1, right = 0 }, },
      { 'filename', file_status = false, path = 1, shorting_target = 40 }
    },
    lualine_c = {
      { sl.readonly.fn, cond = sl.readonly.toggle },
      { sl.wrap.fn, cond = sl.wrap.toggle },
      { sl.spell.fn, cond = sl.spell.toggle },
    },
    lualine_x = {
      { sl.harpoon.fn, cond = sl.harpoon.toggle },
      sl.lsp_status.fn,
      {'branch', icon = '' },
      sl.space_info,
      { 'filetype', icons_enabled = false }
    },
    lualine_y = { 'progress' },
    lualine_z = { { 'location', separator = { right = '' }, left_padding = 2 },  },
  },
  inactive_sections = {
    lualine_a = { 'filename' },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'progress' },
  },
  tabline = { },
  extensions = {'fern', 'quickfix'},
}
