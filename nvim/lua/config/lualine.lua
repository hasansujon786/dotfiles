local sl = require('hasan.utils.statusline')

local onedark = require('lualine.themes.onedark')
onedark.normal.c.fg = '#68707E'
local only_pad_right = { left = 1, right = 0 }

local filename = function(file_status)
  return {
    'filename',
    file_status = file_status,
    path = 0,
    shorting_target = 40,
    symbols = {
      modified = '*',
      readonly = '-',
      unnamed = '[No Name]',
    },
  }
end
local filetype = {
  'filetype',
  colored = true,
  icon_only = true,
  padding = { left = 1, right = 0 },
}

require('lualine').setup({
  options = {
    theme = onedark,
    component_separators = '',
    section_separators = { left = '', right = '' },
    globalstatus = true,
  },
  sections = {
    lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
    lualine_b = { filetype, filename(false) },
    lualine_c = {},
    lualine_x = {
      sl.lsp_status.fn,
      { sl.harpoon.fn, cond = sl.harpoon.toggle },
      { sl.task_timer.fn, cond = sl.task_timer.toggle },
      { 'branch', icon = '' },
      sl.space_info,
      -- { 'filetype', icons_enabled = false },
    },
    lualine_y = {
      { sl.readonly.fn, cond = sl.readonly.toggle, padding = only_pad_right },
      { sl.spell.fn, cond = sl.spell.toggle, padding = only_pad_right },
      { sl.wrap.fn, cond = sl.wrap.toggle, padding = only_pad_right },
      'progress',
    },
    lualine_z = { { 'location', separator = { right = '' }, left_padding = 2 } },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { filename(true) },
    lualine_x = { 'progress' },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = { 'fern', 'quickfix', 'nvim-tree', 'symbols-outline', 'toggleterm' },
})
