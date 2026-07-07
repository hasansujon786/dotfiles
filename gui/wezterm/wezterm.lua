local wezterm = require('wezterm')
local colors = require('colors')
local constants = require('constants')
local keymaps = require('keymaps')
local events = require('events')

local config = wezterm.config_builder()

config.keys = keymaps.keys
config.mouse_bindings = keymaps.mouse_bindings
config.key_tables = keymaps.key_tables

-- General =============================================
config.max_fps = 120
config.check_for_updates = true
config.warn_about_missing_glyphs = false
config.status_update_interval = 1000
config.adjust_window_size_when_changing_font_size = false
config.set_environment_variables = {
  EDITOR = 'nvim',
}

-- Window =============================================
config.initial_rows = 35
config.initial_cols = 138
config.window_background_opacity = 0.96
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.hide_mouse_cursor_when_typing = true
config.enable_scroll_bar = false

-- Tab Bar ============================================
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.tab_max_width = 60
config.use_fancy_tab_bar = false
config.enable_tab_bar = true
config.show_new_tab_button_in_tab_bar = false

-- Font ===============================================
config.font = wezterm.font_with_fallback({
  { family = 'JetBrains Mono', weight = 'Medium' },
  'Cascadia Code',
  'Consolas',
  'Flog Symbols',
})
config.freetype_load_flags = 'NO_HINTING'
config.harfbuzz_features = { 'zero' }
config.underline_thickness = '2pt'
config.underline_position = '-4pt'
-- harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }, -- Disable ligatures
-- config.line_height = 0.88

-- Colors & Appearance ================================
config.color_scheme = 'OneHalfDark'
config.colors = colors.one_half
config.inactive_pane_hsb = { brightness = 0.8 }
config.command_palette_bg_color = '#222222'
config.command_palette_fg_color = '#abb2bf'
config.command_palette_font_size = 16.0
config.command_palette_rows = 24

-- Input ==============================================
config.leader = { key = 'q', mods = 'ALT', timeout_milliseconds = 2000 }
config.use_dead_keys = false
config.unzoom_on_switch_pane = true
config.pane_focus_follows_mouse = false
config.tab_and_split_indices_are_zero_based = false

-- Cursor =============================================
-- animation_fps = 1,
-- cursor_blink_ease_in = 'Constant',
-- cursor_blink_ease_out = 'Constant',
-- cursor_blink_rate = 0,

if wezterm.target_triple == 'x86_64-unknown-linux-gnu' then
  -- Linux settings =========================================
elseif wezterm.target_triple == 'x86_64-apple-darwin' then
  -- macOS settings =========================================
  config.font_size = 20
  config.default_prog = { 'zsh' }
  config.window_decorations = 'INTEGRATED_BUTTONS' -- NONE, INTEGRATED_BUTTONS
  config.launch_menu = {
    { label = 'Zsh', args = { 'zsh' } },
    { label = 'Bash', args = { 'bash' } },
  }
else -- wezterm.target_triple == 'x86_64-pc-windows-msvc'
  -- Windows & Default settings =======================================
  config.font_size = 14
  config.default_prog = { 'bash' }
  config.window_decorations = 'RESIZE' -- NONE, INTEGRATED_BUTTONS
  config.launch_menu = {
    { label = 'Bash', args = { 'bash' } },
    { label = 'Zsh', args = { 'zsh' } },
    { label = 'PowerShell Core', args = { 'pwsh' } },
    { label = 'Command Prompt', args = { 'cmd' } },
    { label = 'PowerShell', args = { 'powershell.exe', '-NoLogo' } },
  }
end

return config
