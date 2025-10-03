local wezterm = require('wezterm')
local colors = require('colors')
local constants = require('constants')
local keysmaps = require('wez_keys')

local config = wezterm.config_builder()

config.max_fps = 120
config.keys = keysmaps.keys
config.mouse_bindings = keysmaps.mouse_bindings
config.key_tables = keysmaps.key_tables
config.initial_rows = 35
config.initial_cols = 138
config.hide_tab_bar_if_only_one_tab = false
config.window_decorations = 'RESIZE' -- NONE,INTEGRATED_BUTTONS
config.check_for_updates = true
config.use_dead_keys = false
config.warn_about_missing_glyphs = false
--   -- animation_fps = 1,
--   -- cursor_blink_ease_in = 'Constant',
--   -- cursor_blink_ease_out = 'Constant',
--   -- cursor_blink_rate = 0,
config.hide_mouse_cursor_when_typing = true
config.tab_and_split_indices_are_zero_based = false
config.enable_scroll_bar = false
config.set_environment_variables = {
  EDITOR = 'nvim',
}
config.status_update_interval = 1000
config.freetype_load_flags = 'NO_HINTING'
config.font_size = 14
-- config.line_height = 0.88
config.font = wezterm.font_with_fallback({
  { family = 'JetBrains Mono', weight = 'Medium' },
  'Cascadia Code',
  'Consolas',
  'Flog Symbols',
})
config.harfbuzz_features = { 'zero' }
config.underline_thickness = '2pt'
config.underline_position = '-2pt'
config.adjust_window_size_when_changing_font_size = false
-- harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }, -- Disable ligatures
config.default_prog = { constants.bash_path }
-- default_gui_startup_args = {'start'}
config.window_background_opacity = 0.96
-- window_background_image = 'C:\\Users\\hasan\\Pictures\\do-more-y3.jpg'
config.tab_bar_at_bottom = true
config.tab_max_width = 60
config.use_fancy_tab_bar = false
config.unzoom_on_switch_pane = true
--   -- exit_behavior = 'Close',
--   -- window_close_confirmation = 'NeverPrompt',
config.enable_tab_bar = true
config.leader = { key = 'q', mods = 'ALT', timeout_milliseconds = 2000 }
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.pane_focus_follows_mouse = false
config.inactive_pane_hsb = { brightness = 0.8 }
config.launch_menu = {
  { label = 'Git Bash', args = { constants.bash_path } },
  { label = 'PowerShell Core', args = { 'pwsh' } },
  { label = 'Command Prompt', args = { 'cmd' } },
  { label = 'PowerShell', args = { 'powershell.exe', '-NoLogo' } },
}
config.command_palette_bg_color = '#222222'
config.command_palette_fg_color = '#abb2bf'
config.command_palette_font_size = 16.0
config.command_palette_rows = 24
config.color_scheme = 'OneHalfDark'
config.colors = colors.one_half
-- config.window_frame = colors.window_frame
config.show_new_tab_button_in_tab_bar = false

-- -- The filled in variant of the < symbol
-- local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
-- -- The filled in variant of the > symbol
-- local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

-- config.tab_bar_style = {
--   -- active_tab_left = wezterm.format({
--   --   { Background = { Color = '#0b0022' } },
--   --   { Foreground = { Color = '#2b2042' } },
--   --   { Text = SOLID_LEFT_ARROW },
--   -- }),
--   -- active_tab_right = wezterm.format({
--   --   { Background = { Color = '#0b0022' } },
--   --   { Foreground = { Color = '#2b2042' } },
--   --   { Text = SOLID_RIGHT_ARROW },
--   -- }),
--   -- inactive_tab_left = wezterm.format({
--   --   { Background = { Color = '#0b0022' } },
--   --   { Foreground = { Color = '#1b1032' } },
--   --   { Text = SOLID_LEFT_ARROW },
--   -- }),
--   inactive_tab_right = wezterm.format({
--     { Background = { Color = '#0b0022' } },
--     { Foreground = { Color = '#1b1032' } },
--     { Text = SOLID_RIGHT_ARROW },
--   }),
-- }

-- unix_domains = {
--   { name = 'unix' },
-- },
-- default_gui_startup_args = { 'connect', 'unix' },

return config
