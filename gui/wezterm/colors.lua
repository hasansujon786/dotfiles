local M = {}

M.colors = {
  bg = '#242B38',
  fg = '#abb2bf',
  fg1 = '#c0c0c0',
  muted = '#68707E',
}

M.window_frame = {
  -- inactive_titlebar_bg = '#1E1C1C',
  inactive_titlebar_bg = '#242A37',
  active_titlebar_bg = '#242A37',
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
    '#dcdfe4',
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
  tab_bar = {
    active_tab = {
      -- bg_color = '#1E1C1C',
      bg_color = '#1a1b20',
      fg_color = M.colors.fg1,
      intensity = 'Bold',
      underline = 'None',
    },
    inactive_tab = {
      bg_color = M.window_frame.active_titlebar_bg,
      fg_color = M.colors.muted,
    },
  },
}

return M
