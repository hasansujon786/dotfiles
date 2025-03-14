local wezterm = require('wezterm')
local constants = require('constants')
local scheme = require('colors')
local act = wezterm.action

local M = {}

local key_stack_mode = nil
M.exit_key_stack = function(window, pane)
  key_stack_mode = nil
  window:perform_action('PopKeyTable', pane)
end

M.activate_win_stack = function(window, pane)
  key_stack_mode = 'Win Stack'
  window:perform_action({ ActivateKeyTable = { name = 'win_stack', one_shot = false } }, pane)
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

local is_forced_fullscreen = false
wezterm.on('user-var-changed', function(window, pane, name, value)
  local overrides = window:get_config_overrides() or {}
  if name == 'ZEN_MODE' then
    local show_tab_bar = nil
    local incremental = value:find('+')
    local number_value = tonumber(value)

    local map_start = value:find('_minimap')
    if map_start then
      number_value = tonumber(value:sub(0, map_start - 1))
    end

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

    -- if not is_forced_fullscreen then
    --   overrides.enable_tab_bar = show_tab_bar
    --   if window:get_dimensions().is_full_screen or (not map_start and number_value == 0) then
    --     window:perform_action('ToggleFullScreen', pane)
    --   end
    -- end
  end

  window:set_config_overrides(overrides)
end)

wezterm.on('save-session', function(...)
  require('wezterm-session-manager/session-manager').save_state(...)
end)
wezterm.on('load-session', function(...)
  require('wezterm-session-manager/session-manager').load_state(...)
end)
wezterm.on('restore-session', function(...)
  require('wezterm-session-manager/session-manager').restore_state(...)
end)
wezterm.on('sessionizer-find-repoes', function(...)
  require('sessionizer').find_repoes(constants.project_dirs, ...)
end)

local bg_opacity = 0.96
M.toggle_opacity = function(win, _)
  local overrides = win:get_config_overrides() or {}

  bg_opacity = bg_opacity > 0.9 and 0.9 or 0.96
  overrides.window_background_opacity = bg_opacity
  win:set_config_overrides(overrides)
end

M.toggle_full_screen = function(window, pane)
  window:perform_action('ToggleFullScreen', pane)
  is_forced_fullscreen = window:get_dimensions().is_full_screen

  if not is_tab_bar_forced_hidden then
    local overrides = window:get_config_overrides() or {}

    overrides.enable_tab_bar = not window:get_dimensions().is_full_screen

    window:set_config_overrides(overrides)
  end
end

local function is_quick_pane(pane)
  -- pane:get_foreground_process_name() and pane:get_foreground_process_name():find('yazi')
  local d = pane:get_dimensions()
  return d['viewport_rows'] == 15
end

M.toggle_quick_pane = function(window, pane)
  local panes = window:active_tab():panes()

  if is_quick_pane(pane) then
    wezterm.log_info('quick_pane#hide_pane')
    window:perform_action(
      act.Multiple({
        act.ActivatePaneDirection('Up'),
        act.SetPaneZoomState(true),
      }),
      pane
    )
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

  wezterm.log_info('quick_pane#crate_new_pane')
  window:perform_action(
    act.SplitPane({
      direction = 'Down',
      size = { Cells = 15 },
      command = {
        cwd = '.',
        -- args = { 'yazi' },
      },
    }),
    pane
  )
end

return M
