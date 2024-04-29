local wezterm = require('wezterm')
local act = wezterm.action
local scheme = require('colors')

local key_stack_mode = nil
local function exit_key_stack(window, pane)
  key_stack_mode = nil
  window:perform_action('PopKeyTable', pane)
end

local text_fg = scheme.colors.fg1
local tab_bar_bg = scheme.window_frame.active_titlebar_bg
local right_colors = { '#32354b', '#3E425D', '#4c5272' }
wezterm.on('update-right-status', function(window, _)
  local time = wezterm.strftime('  %I:%M %p')
  local date = wezterm.strftime('  %a %b %-d    ')
  local workspace = wezterm.mux.get_active_workspace()
  local cells = { workspace, time, date }

  local elements = {} -- The elements to be formatted
  -- Translate a cell into elements
  local function simple(text, idx, _)
    local c = right_colors[idx]
    if idx == 1 then
      table.insert(elements, { Background = { Color = tab_bar_bg } })
    end
    table.insert(elements, { Foreground = { Color = c } })
    table.insert(elements, { Text = '  ' })
    table.insert(elements, { Foreground = { Color = text_fg } })
    table.insert(elements, { Background = { Color = c } })
    table.insert(elements, { Text = '   ' })
    table.insert(elements, { Text = text })
  end

  for i = 1, #cells, 1 do
    simple(cells[i], i, #cells == 0)
  end

  if key_stack_mode then
    table.insert(elements, 1, { Text = ' ] ' })
    table.insert(elements, 1, { Text = key_stack_mode })
    table.insert(elements, 1, { Text = '[ ' })
    table.insert(elements, 1, { Foreground = { Color = '#97CA72' } })
    table.insert(elements, 1, { Background = { Color = tab_bar_bg } })
  end
  window:set_right_status(wezterm.format(elements))
end)

local is_tab_bar_forced_hidden = false
wezterm.on('toggle-tab-bar', function(window, _)
  local overrides = window:get_config_overrides() or {}

  overrides.enable_tab_bar = not overrides.enable_tab_bar
  is_tab_bar_forced_hidden = not overrides.enable_tab_bar
  window:set_config_overrides(overrides)
end)

local bg_opacity = 0.96
local function toggle_opacity(window, _)
  local overrides = window:get_config_overrides() or {}

  bg_opacity = bg_opacity > 0.9 and 0.9 or 0.96
  overrides.window_background_opacity = bg_opacity
  window:set_config_overrides(overrides)
end

local is_forced_fullscreen = false
wezterm.on('user-var-changed', function(window, pane, name, value)
  local overrides = window:get_config_overrides() or {}
  if name == 'ZEN_MODE' then
    local show_tab_bar = nil
    local incremental = value:find('+')
    local number_value = tonumber(value)

    if incremental ~= nil then
      while number_value > 0 do
        window:perform_action(wezterm.action.IncreaseFontSize, pane)
        number_value = number_value - 1
      end
      show_tab_bar = false
    elseif number_value < 0 then
      window:perform_action(wezterm.action.ResetFontSize, pane)
      overrides.font_size = nil
      show_tab_bar = true
    else
      if number_value ~= 0 then
        overrides.font_size = number_value
      end
      show_tab_bar = false
    end

    if not is_forced_fullscreen then
      overrides.enable_tab_bar = show_tab_bar
      window:perform_action('ToggleFullScreen', pane)
    end
  end

  window:set_config_overrides(overrides)
end)

local M = {
  mouse_bindings = {
    { event = { Up = { streak = 1, button = 'Left' } }, mods = 'CTRL', action = 'OpenLinkAtMouseCursor' },
    { event = { Drag = { streak = 1, button = 'Left' } }, mods = 'CTRL|SHIFT', action = 'StartWindowDrag' },
  },
  keys = {
    {
      key = 'F1',
      action = act.ShowLauncherArgs({ flags = 'WORKSPACES' }),
    },
    {
      key = 'f',
      mods = 'LEADER',
      action = wezterm.action_callback(function(window, pane)
        require('sessionizer').start(window, pane)
      end),
    },
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
        window:perform_action('ToggleFullScreen', pane)
        is_forced_fullscreen = window:get_dimensions().is_full_screen

        if not is_tab_bar_forced_hidden then
          local overrides = window:get_config_overrides() or {}

          overrides.enable_tab_bar = not window:get_dimensions().is_full_screen

          window:set_config_overrides(overrides)
        end
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

    -- { key = ',', mods = 'ALT', action = 'ShowTabNavigator' },
    { key = 'r', mods = 'CTRL|SHIFT', action = wezterm.action_callback(wezterm.reload_configuration) },
    { key = 't', mods = 'SHIFT|ALT', action = act({ EmitEvent = 'toggle-tab-bar' }) },
    { key = 'w', mods = 'SHIFT|CTRL', action = act({ CloseCurrentPane = { confirm = false } }) },
    { key = 'k', mods = 'SHIFT|CTRL', action = act.ScrollByLine(-1) },
    { key = 'j', mods = 'SHIFT|CTRL', action = act.ScrollByLine(1) },
    { key = 'PageUp', mods = 'SHIFT', action = act.ScrollByPage(-1) },
    { key = 'PageDown', mods = 'SHIFT', action = act.ScrollByPage(1) },
    -- tabs
    { key = '[', mods = 'ALT', action = act({ ActivateTabRelative = -1 }) },
    { key = ']', mods = 'ALT', action = act({ ActivateTabRelative = 1 }) },
    { key = '{', mods = 'SHIFT|ALT', action = act({ MoveTabRelative = -1 }) },
    { key = '}', mods = 'SHIFT|ALT', action = act({ MoveTabRelative = 1 }) },
    { key = '{', mods = 'SHIFT|CTRL', action = act({ SwitchWorkspaceRelative = -1 }) },
    { key = '}', mods = 'SHIFT|CTRL', action = act({ SwitchWorkspaceRelative = 1 }) },
    { key = '<', mods = 'SHIFT|CTRL', action = act({ SwitchWorkspaceRelative = -1 }) },
    { key = '>', mods = 'SHIFT|CTRL', action = act({ SwitchWorkspaceRelative = 1 }) },
    -- tmux style key bindings
    { key = 'c', mods = 'LEADER', action = act({ SpawnTab = 'CurrentPaneDomain' }) },
    { key = 'x', mods = 'LEADER', action = act({ CloseCurrentPane = { confirm = false } }) },
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
    { key = 'n', mods = 'LEADER', action = wezterm.action({ ActivateTabRelative = 1 }) },
    { key = 'p', mods = 'LEADER', action = wezterm.action({ ActivateTabRelative = -1 }) },
    { key = '[', mods = 'LEADER', action = 'ActivateCopyMode' },
    { key = 'z', mods = 'LEADER', action = 'TogglePaneZoomState' },

    -- Leader custom bindings
    { key = '.', mods = 'LEADER', action = 'TogglePaneZoomState' },
    { key = 'o', mods = 'LEADER', action = 'ActivateLastTab' },
    { key = 'v', mods = 'LEADER', action = act({ SplitHorizontal = {} }) },
    { key = 's', mods = 'LEADER', action = act({ SplitVertical = {} }) },
    { key = 'b', mods = 'LEADER', action = act.ShowLauncherArgs({ flags = 'WORKSPACES' }) },
    { key = 'b', mods = 'LEADER|CTRL', action = wezterm.action_callback(toggle_opacity) },

    -- Custom inputs
    { key = ' ', mods = 'CTRL', action = { SendString = '\x11' } },
    { key = 'i', mods = 'CTRL', action = { SendString = '\x1b[105;5u' } },
    { key = 'm', mods = 'CTRL', action = { SendString = '\x1b[109;5u' } },
    { key = 'Enter', mods = 'SHIFT', action = { SendString = '\x1b[13;2u' } },
    { key = 'Enter', mods = 'CTRL', action = { SendString = '\x1b[13;5u' } },
    { key = 'Backspace', mods = 'CTRL', action = { SendKey = { key = 'w', mods = 'CTRL' } } },

    -- win_stack
    {
      key = 'w',
      mods = 'LEADER',
      action = wezterm.action_callback(function(window, pane)
        key_stack_mode = 'Win Stack'
        window:perform_action({ ActivateKeyTable = { name = 'win_stack', one_shot = false } }, pane)
        -- action = act.ActivateKeyTable({ name = 'win_stack', one_shot = false }),
      end),
    },
  },
  key_tables = {
    win_stack = {
      { key = 'h', action = act.AdjustPaneSize({ 'Left', 1 }) },
      { key = 'l', action = act.AdjustPaneSize({ 'Right', 1 }) },
      { key = 'k', action = act.AdjustPaneSize({ 'Up', 1 }) },
      { key = 'j', action = act.AdjustPaneSize({ 'Down', 1 }) },
      -- Cancel the mode by pressing escape
      { key = 'Escape', action = wezterm.action_callback(exit_key_stack) },
    },
  },
}

return M
