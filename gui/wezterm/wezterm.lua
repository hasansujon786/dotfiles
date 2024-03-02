local wezterm = require('wezterm')
local events = require('events')

-- local SOLID_LEFT_ARROW = ''
-- local SOLID_RIGHT_ARROW = ''

return {
  keys = events.keys,
  mouse_bindings = events.mouse_bindings,
  key_tables = events.key_tables,
  initial_rows = 29,
  initial_cols = 120,
  hide_tab_bar_if_only_one_tab = false,
  window_decorations = 'INTEGRATED_BUTTONS', -- NONE,RESIZE
  check_for_updates = true,
  use_dead_keys = false,
  warn_about_missing_glyphs = false,
  -- animation_fps = 1,
  -- cursor_blink_ease_in = 'Constant',
  -- cursor_blink_ease_out = 'Constant',
  -- cursor_blink_rate = 0,
  hide_mouse_cursor_when_typing = true,
  enable_scroll_bar = false,
  set_environment_variables = {
    EDITOR = 'nvim',
  },
  status_update_interval = 1000,
  freetype_load_flags = 'NO_HINTING',
  font_size = 13.4,
  font = wezterm.font_with_fallback({
    { family = 'OperatorMonoLig Nerd Font', weight = 700 }, -- Medium|Bold
    'Cascadia Code',
    'Consolas',
  }),
  font_rules = {
    { -- Bold
      intensity = 'Bold',
      italic = false,
      font = wezterm.font({
        family = 'OperatorMonoLig Nerd Font',
        weight = 700, -- Medium|Bold
      }),
    },
    { -- Bold Italic
      intensity = 'Bold',
      italic = true,
      font = wezterm.font({
        family = 'Monaspace Radon',
        weight = 500,
        -- style = 'Italic',
      }),
    },
  },
  underline_thickness = '2pt',
  underline_position = '-2pt',
  adjust_window_size_when_changing_font_size = false,
  -- harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }, -- Disable ligatures
  default_prog = { 'C:\\Program Files\\Git\\bin\\bash.exe' },
  default_cwd = 'E:\\repoes',
  -- default_gui_startup_args = {'start'}
  window_background_opacity = 0.96,
  -- window_background_image = 'C:\\Users\\hasan\\Pictures\\do-more-y3.jpg'
  -- tab_bar_at_bottom = true,
  unzoom_on_switch_pane = true,
  exit_behavior = 'Close',
  enable_tab_bar = true,
  window_close_confirmation = 'NeverPrompt',
  leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 1000 },
  window_padding = { left = 0, right = 0, top = 0, bottom = 0 },
  pane_focus_follows_mouse = false,
  inactive_pane_hsb = { saturation = 0.9, brightness = 0.8 },
  launch_menu = {
    { label = 'Git Bash', args = { 'C:\\Program Files\\Git\\bin\\bash.exe' } },
    { label = 'PowerShell Core', args = { 'pwsh' } },
    { label = 'Command Prompt', args = { 'cmd' } },
    { label = 'PowerShell', args = { 'powershell.exe', '-NoLogo' } },
  },
  command_palette_bg_color = '#222222',
  command_palette_fg_color = '#c0c0c0',
  command_palette_font_size = 16.0,
  command_palette_rows = 24,
  color_scheme = 'OneHalfDark',
  colors = {
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
    background = '#242B38',
    foreground = '#abb2bf',
    tab_bar = {
      active_tab = {
        bg_color = '#1E1C1C',
        fg_color = '#c0c0c0',
        intensity = 'Bold',
        underline = 'None',
      },
    },
  },
  -- window_frame = {
  --   inactive_titlebar_bg = 'none',
  --   active_titlebar_bg = 'none',
  -- },
}
