local M = {}

M.colors = {
  bg = '#242B38',
  fg = '#abb2bf',
  fg1 = '#c0c0c0',
  muted = '#68707E',
  light_grey = '#8b95a7',
}

M.one_half = {
  ansi = {
    '#546178',
    '#e06c75',
    '#98c379',
    '#e5c07b',
    '#61afef',
    '#c678dd',
    '#56b6c2',
     M.colors.fg,
  },
  brights = {
    '#546178', -- '#282c34',
    '#e06c75',
    '#98c379',
    '#e5c07b',
    '#61afef',
    '#c678dd',
    '#56b6c2',
    '#dcdfe4',
  },
  background = M.colors.bg,
  foreground = M.colors.fg,
  cursor_bg = '#5ab0f6',
  cursor_fg = M.colors.bg,
  cursor_border = '#5ab0f6',
  split = '#3E425D',
  selection_fg = 'none',
  selection_bg = 'rgb(171 178 191 / 20%)',

  quick_select_label_bg = { Color = '#0000ff' },
  quick_select_label_fg = { Color = '#ffffff' },
  quick_select_match_bg = { Color = '#4C4944' },
  quick_select_match_fg = { Color = '#ebc275' },

  tab_bar = {
    background = '#242A37',
    active_tab = {
      bg_color = '#32354b',
      fg_color = M.colors.light_grey,
      intensity = 'Bold',
      underline = 'None',
    },
    inactive_tab = {
      bg_color = '#242A37',
      fg_color = M.colors.muted,
    },
  },
}

M.window_frame = {
  inactive_titlebar_bg = '#242A37',
  active_titlebar_bg = '#242A37',
  font_size = 12,
}

return M
