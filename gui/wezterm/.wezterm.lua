local wezterm = require('wezterm')
local act = wezterm.action

-- local SOLID_LEFT_ARROW = ''
-- local SOLID_RIGHT_ARROW = ''

local key_stack_mode = nil
local function exit_key_stack(window, pane)
  key_stack_mode = nil
  window:perform_action('PopKeyTable', pane)
end

wezterm.on('update-right-status', function(window, _)
  local time = wezterm.strftime('  %I:%M %p     ')
  local date = wezterm.strftime('  %a %b %-d    ')
  local cells = { time, date }

  -- Color palette for the backgrounds of each cell
  local text_fg = '#c0c0c0' -- Foreground color for the text across the fade
  local elements = {} -- The elements to be formatted
  -- Translate a cell into elements
  local function simple(text, _)
    table.insert(elements, { Foreground = { Color = text_fg } })
    table.insert(elements, { Text = text })
  end

  while #cells > 0 do
    local cellText = table.remove(cells, 1)
    simple(cellText, #cells == 0)
  end

  if key_stack_mode then
    table.insert(elements, 1, { Text = '    ' })
    table.insert(elements, 1, { Text = key_stack_mode })
    table.insert(elements, 1, { Foreground = { Color = '#97CA72' } })
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

return {
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
  window_background_opacity = bg_opacity,
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

    -- stack mode
    {
      key = 'w',
      mods = 'LEADER',
      action = wezterm.action_callback(function(window, pane)
        key_stack_mode = 'Win Stack'
        window:perform_action({ ActivateKeyTable = { name = 'resize_pane', one_shot = false } }, pane)
      end),
      -- action = act.ActivateKeyTable({ name = 'resize_pane', one_shot = false }),
    },

    -- { key = ',', mods = 'ALT', action = 'ShowTabNavigator' },
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
    { key = 'b', mods = 'LEADER', action = 'ShowLauncher' },
    { key = '.', mods = 'LEADER', action = 'TogglePaneZoomState' },
    { key = 'o', mods = 'LEADER', action = 'ActivateLastTab' },
    { key = 'v', mods = 'LEADER', action = act({ SplitHorizontal = {} }) },
    { key = 's', mods = 'LEADER', action = act({ SplitVertical = {} }) },
    { key = 'b', mods = 'LEADER|CTRL', action = wezterm.action_callback(toggle_opacity) },

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
  key_tables = {
    -- name="resize_pane", one_shot=false.
    resize_pane = {
      -- { key = 'LeftArrow', action = act.AdjustPaneSize({ 'Left', 1 }) },
      -- { key = 'RightArrow', action = act.AdjustPaneSize({ 'Right', 1 }) },
      -- { key = 'UpArrow', action = act.AdjustPaneSize({ 'Up', 1 }) },
      -- { key = 'DownArrow', action = act.AdjustPaneSize({ 'Down', 1 }) },

      { key = 'h', action = act.AdjustPaneSize({ 'Left', 1 }) },
      { key = 'l', action = act.AdjustPaneSize({ 'Right', 1 }) },
      { key = 'k', action = act.AdjustPaneSize({ 'Up', 1 }) },
      { key = 'j', action = act.AdjustPaneSize({ 'Down', 1 }) },

      -- Cancel the mode by pressing escape
      { key = 'Escape', action = wezterm.action_callback(exit_key_stack) },
    },

    -- Defines the keys that are active in our activate-pane mode.
    -- 'activate_pane' here corresponds to the name="activate_pane" in
    -- the key assignments above.
    -- activate_pane = {
    --   { key = 'LeftArrow', action = act.ActivatePaneDirection('Left') },
    --   { key = 'h', action = act.ActivatePaneDirection('Left') },

    --   { key = 'RightArrow', action = act.ActivatePaneDirection('Right') },
    --   { key = 'l', action = act.ActivatePaneDirection('Right') },

    --   { key = 'UpArrow', action = act.ActivatePaneDirection('Up') },
    --   { key = 'k', action = act.ActivatePaneDirection('Up') },

    --   { key = 'DownArrow', action = act.ActivatePaneDirection('Down') },
    --   { key = 'j', action = act.ActivatePaneDirection('Down') },
    -- },
  },
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
