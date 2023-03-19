local wezterm = require('wezterm')

local SOLID_LEFT_ARROW = ''
local SOLID_RIGHT_ARROW = ''

wezterm.on('update-right-status', function(window, pane)
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
  local function push(text, is_last)
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

wezterm.on('toggle-opacity', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  if not overrides.window_background_opacity then
    overrides.window_background_opacity = 0.5
  else
    overrides.window_background_opacity = nil
  end
  window:set_config_overrides(overrides)
end)

wezterm.on('toggle-tab-bar', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  if overrides.enable_tab_bar then
    overrides.enable_tab_bar = false
  else
    overrides.enable_tab_bar = true
  end
  window:set_config_overrides(overrides)
end)

return {
  -- tab_bar_style = {
  --   new_tab_left = 'x',
  --   active_tab_right = 'x',
  --   inactive_tab_left = 'x',
  --   inactive_tab_right = 'x',
  -- },
  tab_max_width = 30,
  initial_rows = 28,
  initial_cols = 114,
  set_environment_variables = {
    EDITOR = 'nvim',
  },
  status_update_interval = 1000,
  font = wezterm.font_with_fallback({
    {
      family = 'OperatorMonoLig Nerd Font',
      weight = 'Bold',
    },
    'Cascadia Code',
    'Consolas',
  }),
  font_size = 13.5,
  default_prog = { 'C:\\Program Files\\Git\\bin\\bash.exe' },
  default_cwd = 'E:\\repoes',
  -- default_gui_startup_args = {'start'}
  color_scheme = 'OneHalfDark',
  hide_tab_bar_if_only_one_tab = false,
  window_background_opacity = 0.98,
  -- window_background_image = 'C:\\Users\\hasan\\Pictures\\do-more-y3.jpg'
  -- tab_bar_at_bottom = true,
  unzoom_on_switch_pane = true,
  exit_behavior = 'Close',
  enable_tab_bar = true,
  window_close_confirmation = 'NeverPrompt',
  adjust_window_size_when_changing_font_size = false,
  window_decorations = 'NONE',
  leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 1000 },
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  inactive_pane_hsb = {
    saturation = 0.9,
    brightness = 0.8,
  },
  keys = {
    -- { key = ',', mods = 'ALT', action = 'ShowTabNavigator' },
    { key = 'p', mods = 'SHIFT|CTRL', action = 'ShowLauncher' },
    { key = ' ', mods = 'CTRL', action = { SendString = '\x11' } },
    { key = 'Backspace', mods = 'CTRL', action = { SendKey = { key = 'w', mods = 'CTRL' } } },
    {
      key = 'F11',
      action = wezterm.action_callback(function(window, pane)
        -- local overrides = window:get_config_overrides() or {}
        -- if not window:get_dimensions().is_full_screen then
        --   overrides.enable_tab_bar = false
        -- else
        --   overrides.enable_tab_bar = true
        -- end
        -- window:set_config_overrides(overrides)
        window:perform_action('ToggleFullScreen', pane)
      end),
    },
    {
      key = 'l',
      mods = 'SHIFT|CTRL',
      action = wezterm.action({
        SpawnCommandInNewTab = {
          args = { 'lf' },
          cwd = '.',
          label = 'List all the files!',
        },
      }),
    },
    -- { key = 'b', mods = 'LEADER', action = wezterm.action({ EmitEvent = 'toggle-opacity' }) },
    { key = 'b', mods = 'LEADER', action = wezterm.action({ EmitEvent = 'toggle-tab-bar' }) },
    { key = 'w', mods = 'SHIFT|CTRL', action = wezterm.action({ CloseCurrentPane = { confirm = false } }) },
    -- tabs
    { key = '[', mods = 'ALT', action = wezterm.action({ ActivateTabRelative = -1 }) },
    { key = ']', mods = 'ALT', action = wezterm.action({ ActivateTabRelative = 1 }) },
    { key = '{', mods = 'SHIFT|ALT', action = wezterm.action({ MoveTabRelative = -1 }) },
    { key = '}', mods = 'SHIFT|ALT', action = wezterm.action({ MoveTabRelative = 1 }) },
    -- tmux style key bindings
    { key = 'c', mods = 'LEADER', action = wezterm.action({ SpawnTab = 'CurrentPaneDomain' }) },
    { key = 'x', mods = 'LEADER', action = wezterm.action({ CloseCurrentPane = { confirm = false } }) },
    { key = 'z', mods = 'LEADER', action = 'TogglePaneZoomState' },
    { key = '-', mods = 'LEADER', action = wezterm.action({ SplitVertical = { domain = 'CurrentPaneDomain' } }) },
    { key = '\\', mods = 'LEADER', action = wezterm.action({ SplitHorizontal = { domain = 'CurrentPaneDomain' } }) },
    { key = 'h', mods = 'LEADER', action = wezterm.action({ ActivatePaneDirection = 'Left' }) },
    { key = 'j', mods = 'LEADER', action = wezterm.action({ ActivatePaneDirection = 'Down' }) },
    { key = 'k', mods = 'LEADER', action = wezterm.action({ ActivatePaneDirection = 'Up' }) },
    { key = 'l', mods = 'LEADER', action = wezterm.action({ ActivatePaneDirection = 'Right' }) },
    { key = 'H', mods = 'LEADER|SHIFT', action = wezterm.action({ AdjustPaneSize = { 'Left', 5 } }) },
    { key = 'J', mods = 'LEADER|SHIFT', action = wezterm.action({ AdjustPaneSize = { 'Down', 5 } }) },
    { key = 'K', mods = 'LEADER|SHIFT', action = wezterm.action({ AdjustPaneSize = { 'Up', 5 } }) },
    { key = 'L', mods = 'LEADER|SHIFT', action = wezterm.action({ AdjustPaneSize = { 'Right', 5 } }) },
    { key = '1', mods = 'LEADER', action = wezterm.action({ ActivateTab = 0 }) },
    { key = '2', mods = 'LEADER', action = wezterm.action({ ActivateTab = 1 }) },
    { key = '3', mods = 'LEADER', action = wezterm.action({ ActivateTab = 2 }) },
    { key = '4', mods = 'LEADER', action = wezterm.action({ ActivateTab = 3 }) },
    { key = '5', mods = 'LEADER', action = wezterm.action({ ActivateTab = 4 }) },
    { key = '6', mods = 'LEADER', action = wezterm.action({ ActivateTab = 5 }) },
    { key = '7', mods = 'LEADER', action = wezterm.action({ ActivateTab = 6 }) },
    { key = '8', mods = 'LEADER', action = wezterm.action({ ActivateTab = 7 }) },
    { key = '9', mods = 'LEADER', action = wezterm.action({ ActivateTab = 8 }) },
    { key = '&', mods = 'LEADER|SHIFT', action = wezterm.action({ CloseCurrentTab = { confirm = true } }) },
    -- tmux custom bindings
    { key = 'o', mods = 'LEADER', action = 'ActivateLastTab' },
    { key = 'v', mods = 'LEADER', action = wezterm.action({ SplitHorizontal = {} }) },
    { key = 's', mods = 'LEADER', action = wezterm.action({ SplitVertical = {} }) },
  },
  mouse_bindings = {
    { event = { Up = { streak = 1, button = 'Left' } }, mods = 'CTRL', action = 'OpenLinkAtMouseCursor' },
    { event = { Drag = { streak = 1, button = 'Left' } }, mods = 'CTRL|SHIFT', action = 'StartWindowDrag' },
  },
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
