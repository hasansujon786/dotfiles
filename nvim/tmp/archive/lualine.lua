local sl = require('hasan.utils.statusline')

local onedark = require('lualine.themes.onedark')
onedark.normal.c.fg = '#68707E'
onedark.normal.b.fg = '#8b95a7'
local only_pad_left = { left = 1, right = 0 }
vim.cmd([[
  hi LualineTabActive    guifg=#97CA72 guibg=#3E4452
  hi LualineTabInactive  guifg=#7386a5 guibg=#3E4452
  hi LualineTabSp        guifg=#2c3545 guibg=#3E4452
  hi WinbarTabGreen      guifg=#97CA72 guibg=#242B38
  hi WinbarTabMuted      guifg=#3d4451 guibg=#242B38
  hi WinbarTabItem       guifg=#5C6370 guibg=#242B38
]])

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

require('lualine').setup({
  options = {
    theme = onedark,
    component_separators = '',
    section_separators = { left = '', right = '' },
    globalstatus = true,
  },
  sections = {
    lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
    lualine_b = {
      { sl.tabs.fn, cond = sl.tabs.cond, padding = { left = 1, right = 0 } },
      {
        'filetype',
        colored = true,
        icon_only = true,
        padding = { left = 1, right = 0 },
      },
      filename(false),
    },
    lualine_c = {},
    lualine_x = {
      sl.lsp_status.fn,
      { sl.harpoon.fn, cond = sl.harpoon.toggle },
      { sl.task_timer.fn, cond = sl.task_timer.toggle },
      { 'branch', icon = '' },
      { 'fileformat', padding = only_pad_left },
      sl.space_info,
      -- { 'filetype', icons_enabled = false },
    },
    lualine_y = {
      { sl.readonly.fn, cond = sl.readonly.toggle, padding = only_pad_left },
      { sl.spell.fn, cond = sl.spell.toggle, padding = only_pad_left },
      { sl.wrap.fn, cond = sl.wrap.toggle, padding = only_pad_left },
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
