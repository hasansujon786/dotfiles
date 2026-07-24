local wezterm = require('wezterm')
local act = wezterm.action

local actions = {}

local key_stack_mode = nil
actions.exit_key_stack = function(window, pane)
  key_stack_mode = nil
  window:perform_action('PopKeyTable', pane)
end

actions.activate_win_stack = function(window, pane)
  key_stack_mode = 'Win Stack'
  window:perform_action({ ActivateKeyTable = { name = 'win_stack', one_shot = false } }, pane)
end

local bg_opacity = 0.96
actions.toggle_opacity = function(win, _)
  local overrides = win:get_config_overrides() or {}

  bg_opacity = bg_opacity > 0.9 and 0.9 or 0.96
  overrides.window_background_opacity = bg_opacity
  win:set_config_overrides(overrides)
end

local is_forced_fullscreen = false
actions.toggle_full_screen = function(window, pane)
  window:perform_action('ToggleFullScreen', pane)
  is_forced_fullscreen = window:get_dimensions().is_full_screen

  if not is_tab_bar_forced_hidden then
    local overrides = window:get_config_overrides() or {}

    overrides.enable_tab_bar = not window:get_dimensions().is_full_screen

    window:set_config_overrides(overrides)
  end
end

actions.toggle_quick_pane = function(window, pane)
  local function is_quick_pane(pane)
    -- pane:get_foreground_process_name() and pane:get_foreground_process_name():find('yazi')
    local d = pane:get_dimensions()
    return d['viewport_rows'] == 20
  end

  local panes = window:active_tab():panes()

  if is_quick_pane(pane) then
    wezterm.log_info('quick_pane#hide_pane')
    window:perform_action(act.Multiple({ act.ActivatePaneDirection('Up'), act.SetPaneZoomState(true) }), pane)
    return
  end

  for _, p in ipairs(panes) do
    -- Check if the quick pane already exists
    if is_quick_pane(p) then
      wezterm.log_info('quick_pane#show_pane')
      p:activate()
      window:perform_action(wezterm.action.SetPaneZoomState(false), pane)
      -- window:perform_action(wezterm.action.ActivatePaneByIndex(index - 1), pane)
      return
    end
  end

  wezterm.log_info('quick_pane#create_new_pane')
  window:perform_action(act.SplitPane({ direction = 'Down', size = { Cells = 20 } }), pane) -- command = { cwd = '.', args = { 'yazi' } },

  local new_pane = window:active_pane()
  window:perform_action(wezterm.action({ Multiple = { { SendString = 'ytm\r' } } }), new_pane)
end

return {
  mouse_bindings = {
    { event = { Up = { streak = 1, button = 'Left' } }, mods = 'CTRL', action = 'OpenLinkAtMouseCursor' },
    { event = { Drag = { streak = 1, button = 'Left' } }, mods = 'CTRL|SHIFT', action = 'StartWindowDrag' },
  },
  keys = {
    -- Toggle Quick Pane ===================================
    { key = 'e', mods = 'SHIFT|CTRL', action = wezterm.action_callback(actions.toggle_quick_pane) },

    -- Send Key Sequences ==================================
    {
      key = 'q',
      mods = 'SHIFT|CTRL',
      action = wezterm.action.Multiple({
        wezterm.action.SendKey({ key = 'q', mods = '' }),
        wezterm.action.SendKey({ key = 'UpArrow', mods = '' }),
        wezterm.action.SendKey({ key = 'Enter', mods = '' }),
      }),
    },

    -- Control wezterm =====================================
    { key = 'F11', action = wezterm.action_callback(actions.toggle_full_screen) },
    { key = 'r', mods = 'SHIFT|CTRL', action = wezterm.action_callback(wezterm.reload_configuration) },
    { key = 'w', mods = 'SHIFT|CTRL', action = act({ CloseCurrentPane = { confirm = false } }) },
    { key = 't', mods = 'SHIFT|ALT', action = act({ EmitEvent = 'toggle-tab-bar' }) },

    -- Scroll lines ========================================
    { key = 'UpArrow', mods = 'SHIFT|CTRL', action = act.ScrollByLine(-1) },
    { key = 'DownArrow', mods = 'SHIFT|CTRL', action = act.ScrollByLine(1) },
    { key = 'PageUp', mods = 'SHIFT|CTRL', action = act.ScrollByPage(-1) },
    { key = 'PageDown', mods = 'SHIFT|CTRL', action = act.ScrollByPage(1) },

    -- TMUX style key bindings (LEADER) ====================
    { key = 'c', mods = 'LEADER', action = act({ SpawnTab = 'CurrentPaneDomain' }) },
    { key = 'x', mods = 'LEADER', action = act({ CloseCurrentPane = { confirm = false } }) },
    { key = '-', mods = 'LEADER', action = act({ SplitVertical = { domain = 'CurrentPaneDomain' } }) },
    { key = '\\', mods = 'LEADER', action = act({ SplitHorizontal = { domain = 'CurrentPaneDomain' } }) },
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

    -- Leader custom bindings ==============================
    { key = 'v', mods = 'LEADER', action = act({ SplitHorizontal = {} }) },
    { key = 's', mods = 'LEADER', action = act({ SplitVertical = {} }) },
    { key = '.', mods = 'LEADER', action = 'TogglePaneZoomState' },
    { key = 'o', mods = 'LEADER', action = 'ActivateLastTab' },
    { key = 'b', mods = 'LEADER', action = wezterm.action_callback(actions.toggle_opacity) },
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

    -- Navigate panes ======================================
    { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection('Left') },
    { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection('Down') },
    { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection('Up') },
    { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection('Right') },
    { key = 'h', mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection('Left') },
    { key = 'j', mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection('Down') },
    { key = 'k', mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection('Up') },
    { key = 'l', mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection('Right') },

    -- Resize panes ========================================
    { key = 'LeftArrow', mods = 'SHIFT|ALT', action = act.AdjustPaneSize({ 'Left', 5 }) },
    { key = 'DownArrow', mods = 'SHIFT|ALT', action = act.AdjustPaneSize({ 'Down', 5 }) },
    { key = 'UpArrow', mods = 'SHIFT|ALT', action = act.AdjustPaneSize({ 'Up', 5 }) },
    { key = 'RightArrow', mods = 'SHIFT|ALT', action = act.AdjustPaneSize({ 'Right', 5 }) },
    { key = 'h', mods = 'SHIFT|ALT', action = act.AdjustPaneSize({ 'Left', 5 }) },
    { key = 'j', mods = 'SHIFT|ALT', action = act.AdjustPaneSize({ 'Down', 5 }) },
    { key = 'k', mods = 'SHIFT|ALT', action = act.AdjustPaneSize({ 'Up', 5 }) },
    { key = 'l', mods = 'SHIFT|ALT', action = act.AdjustPaneSize({ 'Right', 5 }) },

    -- Tabs ================================================
    { key = '[', mods = 'ALT', action = act({ ActivateTabRelative = -1 }) },
    { key = ']', mods = 'ALT', action = act({ ActivateTabRelative = 1 }) },
    { key = '{', mods = 'SHIFT|ALT', action = act({ MoveTabRelative = -1 }) },
    { key = '}', mods = 'SHIFT|ALT', action = act({ MoveTabRelative = 1 }) },
    -- { key = 'q', mods = 'LEADER|ALT', action = 'ShowTabNavigator' },

    -- Workspace ===========================================
    { key = '[', mods = 'CTRL', action = act({ SwitchWorkspaceRelative = -1 }) },
    { key = ']', mods = 'CTRL', action = act({ SwitchWorkspaceRelative = 1 }) },
    { key = 's', mods = 'LEADER|ALT', action = act({ EmitEvent = 'save-session' }) },
    { key = 'r', mods = 'LEADER|ALT', action = act({ EmitEvent = 'restore-session' }) },
    { key = 'l', mods = 'LEADER|ALT', action = act({ EmitEvent = 'load-session' }) },
    { key = 'f', mods = 'LEADER|ALT', action = act({ EmitEvent = 'sessionizer-find-repoes' }) },
    { key = 'q', mods = 'LEADER|ALT', action = act.ShowLauncherArgs({ flags = 'WORKSPACES' }) },

    -- Rename tab ==========================================
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
    -- Rename workspace
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

    -- Custom inputs =======================================
    { key = 'i', mods = 'CTRL', action = { SendString = '\x1b[105;5u' } },
    { key = 'm', mods = 'CTRL', action = { SendString = '\x1b[109;5u' } },
    { key = 'Enter', mods = 'SHIFT', action = { SendString = '\x1b[13;2u' } },
    { key = 'Enter', mods = 'CTRL', action = { SendString = '\x1b[13;5u' } },
    { key = 'Space', mods = 'CTRL', action = { SendKey = { key = 'Space', mods = 'CTRL' } } },
    { key = 'Backspace', mods = 'CTRL', action = { SendKey = { key = 'w', mods = 'CTRL' } } },
    { key = '.', mods = 'CTRL', action = { SendKey = { key = '.', mods = 'CTRL' } } },
    { key = 'p', mods = 'SHIFT|CTRL', action = { SendKey = { key = 'F1' } } },

    -- Opacity =============================================
    {
      key = '+',
      mods = 'SHIFT|CTRL',
      action = wezterm.action_callback(function(window, _)
        local current = window:effective_config().window_background_opacity
        local opacity = math.min(1.0, current + 0.02)
        window:set_config_overrides({ window_background_opacity = opacity })
      end),
    },
    {
      key = '_',
      mods = 'SHIFT|CTRL',
      action = wezterm.action_callback(function(window, _)
        local current = window:effective_config().window_background_opacity
        local opacity = math.max(0.0, current - 0.02)
        window:set_config_overrides({ window_background_opacity = opacity })
      end),
    },
    {
      key = '0',
      mods = 'LEADER',
      action = wezterm.action_callback(function(window, _)
        local opacity = 0.96
        window:set_config_overrides({ window_background_opacity = opacity })
      end),
    },

    -- Win stack ===========================================
    { key = 'w', mods = 'LEADER', action = wezterm.action_callback(actions.activate_win_stack) },
  },
  key_tables = {
    win_stack = {
      { key = 'h', action = act.AdjustPaneSize({ 'Left', 1 }) },
      { key = 'l', action = act.AdjustPaneSize({ 'Right', 1 }) },
      { key = 'k', action = act.AdjustPaneSize({ 'Up', 1 }) },
      { key = 'j', action = act.AdjustPaneSize({ 'Down', 1 }) },
      -- Cancel the mode by pressing escape
      { key = 'Escape', action = wezterm.action_callback(actions.exit_key_stack) },
    },
  },
}
