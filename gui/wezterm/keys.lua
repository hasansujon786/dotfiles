local wezterm = require('wezterm')
local events = require('custom_events')
local act = wezterm.action

return {
  mouse_bindings = {
    { event = { Up = { streak = 1, button = 'Left' } }, mods = 'CTRL', action = 'OpenLinkAtMouseCursor' },
    { event = { Drag = { streak = 1, button = 'Left' } }, mods = 'CTRL|SHIFT', action = 'StartWindowDrag' },
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
      key = 'F2',
      mods = 'ALT|CTRL',
      action = act.PromptInputLine({
        description = wezterm.format({
          { Attribute = { Intensity = 'Bold' } },
          { Foreground = { AnsiColor = 'Fuchsia' } },
          { Text = 'Enter name for workspace' },
        }),
        action = wezterm.action_callback(function(_, _, line)
          if line then
            wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
          end
        end),
      }),
    },
    { key = 'F11', action = wezterm.action_callback(events.toggle_full_screen) },
    { key = 'l', mods = 'SHIFT|CTRL', action = wezterm.action_callback(events.toggle_quick_pane) },
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
    { key = 'Tab', mods = 'SHIFT|CTRL', action = act({ SwitchWorkspaceRelative = -1 }) },
    { key = 'Tab', mods = 'CTRL', action = act({ SwitchWorkspaceRelative = 1 }) },
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
    { key = 'n', mods = 'LEADER', action = act({ ActivateTabRelative = 1 }) },
    { key = 'p', mods = 'LEADER', action = act({ ActivateTabRelative = -1 }) },
    { key = '[', mods = 'LEADER', action = 'ActivateCopyMode' },
    { key = 'z', mods = 'LEADER', action = 'TogglePaneZoomState' },

    -- Leader custom bindings
    { key = '.', mods = 'LEADER', action = 'TogglePaneZoomState' },
    { key = 'o', mods = 'LEADER', action = 'ActivateLastTab' },
    { key = 'v', mods = 'LEADER', action = act({ SplitHorizontal = {} }) },
    { key = 's', mods = 'LEADER', action = act({ SplitVertical = {} }) },
    { key = 'b', mods = 'LEADER', action = wezterm.action_callback(events.toggle_opacity) },
    { key = 'r', mods = 'LEADER', action = act.RotatePanes('Clockwise') },
    { key = 'R', mods = 'LEADER', action = act.RotatePanes('CounterClockwise') },
    {
      key = 'X',
      mods = 'LEADER',
      action = wezterm.action_callback(function(win, _)
        -- Close other tabs
        local tab = win:active_tab()
        local activeTabId = tab:tab_id()
        local muxWin = win:mux_window()
        local tabs = muxWin:tabs()
        for _, t in ipairs(tabs) do
          if t:tab_id() ~= activeTabId then
            t:activate()
            for _, p in ipairs(t:panes()) do
              win:perform_action(act.CloseCurrentTab({ confirm = false }), p)
            end
          end
        end
      end),
    },

    -- Workspace
    { key = 's', mods = 'LEADER|CTRL', action = act({ EmitEvent = 'save-session' }) },
    { key = 'r', mods = 'LEADER|CTRL', action = act({ EmitEvent = 'restore-session' }) },
    { key = 'l', mods = 'LEADER|CTRL', action = act({ EmitEvent = 'load-session' }) },
    { key = 'f', mods = 'LEADER|CTRL', action = act({ EmitEvent = 'sessionizer-find-repoes' }) },
    { key = 'a', mods = 'LEADER|CTRL', action = act.ShowLauncherArgs({ flags = 'WORKSPACES' }) },

    -- Custom inputs
    { key = ' ', mods = 'CTRL', action = { SendString = '\x11' } },
    { key = 'i', mods = 'CTRL', action = { SendString = '\x1b[105;5u' } },
    { key = 'm', mods = 'CTRL', action = { SendString = '\x1b[109;5u' } },
    { key = 'Enter', mods = 'SHIFT', action = { SendString = '\x1b[13;2u' } },
    { key = 'Enter', mods = 'CTRL', action = { SendString = '\x1b[13;5u' } },
    { key = 'Backspace', mods = 'CTRL', action = { SendKey = { key = 'w', mods = 'CTRL' } } },

    -- stacks
    { key = 'w', mods = 'LEADER', action = wezterm.action_callback(events.activate_win_stack) },
  },
  key_tables = {
    win_stack = {
      { key = 'h', action = act.AdjustPaneSize({ 'Left', 1 }) },
      { key = 'l', action = act.AdjustPaneSize({ 'Right', 1 }) },
      { key = 'k', action = act.AdjustPaneSize({ 'Up', 1 }) },
      { key = 'j', action = act.AdjustPaneSize({ 'Down', 1 }) },
      -- Cancel the mode by pressing escape
      { key = 'Escape', action = wezterm.action_callback(events.exit_key_stack) },
    },
  },
}
