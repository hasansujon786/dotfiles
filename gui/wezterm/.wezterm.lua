local wezterm = require('wezterm')
local act = wezterm.action

local SOLID_LEFT_ARROW = ''
local SOLID_RIGHT_ARROW = ''

wezterm.on('update-right-status', function(window, _)
  local cells = {}

  local date = wezterm.strftime('  %a %b %-d   ')
  local time = wezterm.strftime('  %I:%M %p   ')
  table.insert(cells, time)
  table.insert(cells, date)

  -- Color palette for the backgrounds of each cell
  local colors = {
    '#3c1361',
    '#52307c',
    '#663a82',
    '#7c5295',
    '#b491c8',
  }
  local text_fg = '#c0c0c0' -- Foreground color for the text across the fade
  local elements = {} -- The elements to be formatted
  local num_cells = 0 -- How many cells have been formatted

  -- Translate a cell into elements
  local function push(text, _)
    local cell_no = num_cells + 1
    table.insert(elements, { Foreground = { Color = colors[cell_no] } })
    table.insert(elements, { Text = SOLID_LEFT_ARROW })

    table.insert(elements, { Foreground = { Color = text_fg } })
    table.insert(elements, { Background = { Color = colors[cell_no] } })
    table.insert(elements, { Text = ' ' .. text .. ' ' })
    -- if not is_last then
    --   table.insert(elements, { Foreground = { Color = colors[cell_no + 1] } })
    --   table.insert(elements, { Text = SOLID_LEFT_ARROW })
    -- end
    num_cells = num_cells + 1
  end

  while #cells > 0 do
    local cell = table.remove(cells, 1)
    push(cell, #cells == 0)
  end

  window:set_right_status(wezterm.format(elements))
end)

-- wezterm.on('window-config-reloaded', function(window, pane)
--   window:toast_notification('wezterm', 'configuration reloaded!', nil, 4000)
-- end)

-- wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
--   return ' ' .. tab.active_pane.title .. ' '
-- end)

wezterm.on('toggle-opacity', function(window, _)
  local overrides = window:get_config_overrides() or {}
  if not overrides.window_background_opacity then
    overrides.window_background_opacity = 0.5
  else
    overrides.window_background_opacity = nil
  end
  window:set_config_overrides(overrides)
end)

local fixed_tab_bar = false
wezterm.on('toggle-tab-bar', function(window, _)
  local overrides = window:get_config_overrides() or {}
  if not overrides.enable_tab_bar then
    overrides.enable_tab_bar = true
  else
    overrides.enable_tab_bar = false
  end
  fixed_tab_bar = overrides.enable_tab_bar
  window:set_config_overrides(overrides)
end)

return {
  initial_rows = 30,
  initial_cols = 120,
  tab_max_width = 30,
  hide_tab_bar_if_only_one_tab = false,
  window_decorations = 'NONE', -- RESIZE,INTEGRATED_BUTTONS
  check_for_updates = false,
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
  font = wezterm.font_with_fallback({
    {
      family = 'OperatorMonoLig Nerd Font',
      weight = 'Bold',
    },
    'Cascadia Code',
    'Consolas',
  }),
  font_size = 13,
  underline_thickness = '2pt',
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
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  pane_focus_follows_mouse = false,
  inactive_pane_hsb = {
    saturation = 0.9,
    brightness = 0.8,
  },
  keys = {
    {
      key = 'F2',
      mods = 'ALT',
      action = act.PromptInputLine({
        description = wezterm.format({
          { Attribute = { Intensity = 'Bold' } },
          { Foreground = { AnsiColor = 'Fuchsia' } },
          { Text = 'Enter name for tab' },
        }),
        action = wezterm.action_callback(function(window, _, line)
          if line then
            window:active_tab():set_title(line)
          end
        end),
      }),
    },
    {
      key = 'F11',
      action = wezterm.action_callback(function(window, pane)
        if not fixed_tab_bar then
          local overrides = window:get_config_overrides() or {}
          if not window:get_dimensions().is_full_screen then
            overrides.enable_tab_bar = false
          else
            overrides.enable_tab_bar = true
          end
          window:set_config_overrides(overrides)
        end

        window:perform_action('ToggleFullScreen', pane)
      end),
    },
    {
      key = 'l',
      mods = 'SHIFT|CTRL',
      action = act({
        SpawnCommandInNewTab = {
          args = { 'lf' },
          cwd = '.',
          label = 'List all the files!',
        },
      }),
    },
    -- { key = ',', mods  'ALT', action = 'ShowTabNavigator' },
    -- { key = 'b', mods = 'LEADER', action = act({ EmitEvent = 'toggle-opacity' }) },
    { key = 'r', mods = 'CTRL|SHIFT', action = wezterm.action_callback(wezterm.reload_configuration) },
    { key = 't', mods = 'SHIFT|ALT', action = act({ EmitEvent = 'toggle-tab-bar' }) },
    { key = 'w', mods = 'SHIFT|CTRL', action = act({ CloseCurrentPane = { confirm = false } }) },
    -- tabs
    { key = '[', mods = 'ALT', action = act({ ActivateTabRelative = -1 }) },
    { key = ']', mods = 'ALT', action = act({ ActivateTabRelative = 1 }) },
    { key = '{', mods = 'SHIFT|ALT', action = act({ MoveTabRelative = -1 }) },
    { key = '}', mods = 'SHIFT|ALT', action = act({ MoveTabRelative = 1 }) },
    -- tmux style key bindings
    { key = 'c', mods = 'LEADER', action = act({ SpawnTab = 'CurrentPaneDomain' }) },
    { key = 'x', mods = 'LEADER', action = act({ CloseCurrentPane = { confirm = false } }) },
    { key = 'z', mods = 'LEADER', action = 'TogglePaneZoomState' },
    { key = '-', mods = 'LEADER', action = act({ SplitVertical = { domain = 'CurrentPaneDomain' } }) },
    { key = '\\', mods = 'LEADER', action = act({ SplitHorizontal = { domain = 'CurrentPaneDomain' } }) },
    { key = 'h', mods = 'LEADER', action = act({ ActivatePaneDirection = 'Left' }) },
    { key = 'j', mods = 'LEADER', action = act({ ActivatePaneDirection = 'Down' }) },
    { key = 'k', mods = 'LEADER', action = act({ ActivatePaneDirection = 'Up' }) },
    { key = 'l', mods = 'LEADER', action = act({ ActivatePaneDirection = 'Right' }) },
    { key = 'H', mods = 'LEADER|SHIFT', action = act({ AdjustPaneSize = { 'Left', 5 } }) },
    { key = 'J', mods = 'LEADER|SHIFT', action = act({ AdjustPaneSize = { 'Down', 5 } }) },
    { key = 'K', mods = 'LEADER|SHIFT', action = act({ AdjustPaneSize = { 'Up', 5 } }) },
    { key = 'L', mods = 'LEADER|SHIFT', action = act({ AdjustPaneSize = { 'Right', 5 } }) },
    { key = '1', mods = 'LEADER', action = act({ ActivateTab = 0 }) },
    { key = '2', mods = 'LEADER', action = act({ ActivateTab = 1 }) },
    { key = '3', mods = 'LEADER', action = act({ ActivateTab = 2 }) },
    { key = '4', mods = 'LEADER', action = act({ ActivateTab = 3 }) },
    { key = '5', mods = 'LEADER', action = act({ ActivateTab = 4 }) },
    { key = '6', mods = 'LEADER', action = act({ ActivateTab = 5 }) },
    { key = '7', mods = 'LEADER', action = act({ ActivateTab = 6 }) },
    { key = '8', mods = 'LEADER', action = act({ ActivateTab = 7 }) },
    { key = '9', mods = 'LEADER', action = act({ ActivateTab = 8 }) },
    { key = '&', mods = 'LEADER|SHIFT', action = act({ CloseCurrentTab = { confirm = true } }) },
    -- tmux custom bindings
    { key = 'o', mods = 'LEADER', action = 'ActivateLastTab' },
    { key = 'v', mods = 'LEADER', action = act({ SplitHorizontal = {} }) },
    { key = 's', mods = 'LEADER', action = act({ SplitVertical = {} }) },

    -- Custom inputs
    { key = ' ', mods = 'CTRL', action = { SendString = '\x11' } },
    { key = 'i', mods = 'CTRL', action = { SendString = '\x1b[105;5u' } },
    { key = 'm', mods = 'CTRL', action = { SendString = '\x1b[109;5u' } },
    { key = 'Enter', mods = 'SHIFT', action = { SendString = '\x1b[13;2u' } },
    { key = 'Enter', mods = 'CTRL', action = { SendString = '\x1b[13;5u' } },
    { key = 'Backspace', mods = 'CTRL', action = { SendKey = { key = 'w', mods = 'CTRL' } } },
  },
  mouse_bindings = {
    { event = { Up = { streak = 1, button = 'Left' } }, mods = 'CTRL', action = 'OpenLinkAtMouseCursor' },
    { event = { Drag = { streak = 1, button = 'Left' } }, mods = 'CTRL|SHIFT', action = 'StartWindowDrag' },
  },
  launch_menu = {
    {
      label = 'Git Bash',
      args = { 'C:\\Program Files\\Git\\bin\\bash.exe' },
    },
    {
      label = 'PowerShell Core',
      args = { 'pwsh' },
    },
    {
      label = 'Command Prompt',
      args = { 'cmd' },
    },
    {
      label = 'PowerShell',
      args = { 'powershell.exe', '-NoLogo' },
    },
  },
  command_palette_bg_color = '#222222',
  command_palette_fg_color = '#c0c0c0',
  command_palette_font_size = 14.0,
  color_scheme = 'OneHalfDark',
  colors = {
    background = '#242B38',
    tab_bar = {
      active_tab = {
        bg_color = '#1E1C1C',
        fg_color = '#c0c0c0',
        intensity = 'Bold',
        underline = 'None',
      },
    },
  },
}
