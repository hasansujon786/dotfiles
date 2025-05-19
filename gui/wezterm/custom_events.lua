local wezterm = require('wezterm')
local constants = require('constants')
local utils = require('wez_utils')
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

local tab_bar = scheme.one_half.tab_bar
local tab_length = 20
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local title = string.format('%d:%s', tab.tab_index + 1, utils.tab_title(tab))
  title = utils.fit_to_length(title, tab_length - 2)

  local fg = tab_bar.inactive_tab.fg_color
  local bg = tab_bar.inactive_tab.bg_color
  if tab.is_active then
    bg = tab_bar.active_tab.bg_color
    fg = tab_bar.active_tab.fg_color
  end

  return {
    { Background = { Color = tab_bar.background } },
    { Foreground = { Color = bg } },
    { Text = '' },
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = string.format('%s', title) },
    { Background = { Color = tab_bar.background } },
    { Foreground = { Color = bg } },
    { Text = '' },
  }
end)

wezterm.on('update-status', function(window, pane)
  local time = wezterm.strftime('  %I:%M %p')
  local date = wezterm.strftime('󰸗  %b %-d, %a')
  local workspace = wezterm.mux.get_active_workspace()

  local layer = '#32354b'

  local right_cells = {
    { date, color = '#68707E' },
    { time, color = '#8b95a7' },
  }
  local left_cells = {
    { workspace, color = '#8b95a7' },
    { date, color = '#68707E' },
  }

  local left_elements, right_elements = {}, {}

  -- Translate a cell into elements
  for index, value in ipairs(right_cells) do
    if index == 1 then
      table.insert(right_elements, { Foreground = { Color = layer } })
      table.insert(right_elements, { Text = '' })
      table.insert(right_elements, { Background = { Color = layer } })
      table.insert(right_elements, { Text = ' ' })
    else
      table.insert(right_elements, { Foreground = { Color = '#1e232e' } })
      table.insert(right_elements, { Text = '  ' })
    end
    table.insert(right_elements, { Foreground = { Color = value.color } })
    table.insert(right_elements, { Text = value[1] })
  end
  table.insert(right_elements, { Text = ' ' })

  local left_elements_width = 0
  table.insert(left_elements, { Background = { Color = layer } })
  table.insert(left_elements, { Text = ' ' })
  for index, value in ipairs(left_cells) do
    table.insert(left_elements, { Foreground = { Color = value.color } })
    if index == 1 and window:leader_is_active() then
      table.insert(left_elements, { Foreground = { Color = '#f0d197' } })
    end
    table.insert(left_elements, { Text = value[1] })
    left_elements_width = left_elements_width + #value[1] + 2

    if index == #left_cells then
      table.insert(left_elements, { Foreground = { Color = layer } })
      table.insert(left_elements, { Text = ' ' })
      table.insert(left_elements, { Background = { Color = tab_bar.background } })
      table.insert(left_elements, { Text = '' })
    else
      table.insert(left_elements, { Foreground = { Color = '#1e232e' } })
      table.insert(left_elements, { Text = '  ' })
    end
  end

  -- if key_stack_mode then
  --   table.insert(elements, 1, { Text = ' ] ' })
  --   table.insert(elements, 1, { Text = key_stack_mode })
  --   table.insert(elements, 1, { Text = '[ ' })
  --   table.insert(elements, 1, { Foreground = { Color = '#97CA72' } })
  --   table.insert(elements, 1, { Background = { Color = tab_bar.background } })
  -- end
  -- #wezterm.format(left_elements)

  local left_status = wezterm.format(left_elements)

  -- Center tabs
  local tabs = window:mux_window():tabs()
  local mid_width = 0
  for _, _ in ipairs(tabs) do
    -- local title = tab:get_title()
    -- mid_width = mid_width + math.floor(math.log(idx, 10)) + 1
    -- mid_width = mid_width + 2 + #title + 1
    mid_width = mid_width + tab_length - 1
  end
  local tab_bar_width = window:active_tab():get_size().cols
  local max_left = tab_bar_width / 2 - mid_width / 2

  window:set_left_status(left_status .. wezterm.pad_left(' ', max_left - left_elements_width))
  window:set_right_status(wezterm.format(right_elements))
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

    overrides.enable_tab_bar = show_tab_bar
    -- if window:get_dimensions().is_full_screen or (number_value == 0) then
    --   window:perform_action('ToggleFullScreen', pane)
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
      -- command = { cwd = '.' }, -- args = { 'yazi' },
    }),
    pane
  )
end

return M
