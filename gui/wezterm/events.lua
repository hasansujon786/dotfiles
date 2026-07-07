local wezterm = require('wezterm')
local constants = require('constants')
local utils = require('wez_utils')
local scheme = require('colors')
local act = wezterm.action

local M = {}

local tab_bar_scheme = scheme.one_half.tab_bar
local all_tabs_width = 0
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  if tab.tab_index == 0 then
    all_tabs_width = 0
  end
  local title = string.format('%d:%s', tab.tab_index + 1, utils.tab_title(tab))
  all_tabs_width = all_tabs_width + #title + 2
  -- title = utils.fit_to_length(title, tab_length - 2)

  local fg = tab_bar_scheme.inactive_tab.fg_color
  local bg = tab_bar_scheme.inactive_tab.bg_color
  if tab.is_active then
    bg = tab_bar_scheme.active_tab.bg_color
    fg = tab_bar_scheme.active_tab.fg_color
  end

  return {
    { Background = { Color = tab_bar_scheme.background } },
    { Foreground = { Color = bg } },
    { Text = '' },
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = string.format('%s', title) },
    { Background = { Color = tab_bar_scheme.background } },
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
    { workspace, color = '#8b95a7', icon_space = 0 },
    { date, color = '#68707E', icon_space = 3 },
  }

  local left_status_elements, right_status_elements = {}, {}

  -- Translate a cell into elements
  for index, value in ipairs(right_cells) do
    if index == 1 then
      table.insert(right_status_elements, { Foreground = { Color = layer } })
      table.insert(right_status_elements, { Text = '' })
      table.insert(right_status_elements, { Background = { Color = layer } })
      table.insert(right_status_elements, { Text = ' ' })
    else
      table.insert(right_status_elements, { Foreground = { Color = '#1e232e' } })
      table.insert(right_status_elements, { Text = '  ' })
    end
    table.insert(right_status_elements, { Foreground = { Color = value.color } })
    table.insert(right_status_elements, { Text = value[1] })
  end
  table.insert(right_status_elements, { Text = ' ' })

  local left_elements_width = (#left_cells * 3)
  if #left_cells > 0 then
    table.insert(left_status_elements, { Background = { Color = layer } })
    table.insert(left_status_elements, { Text = ' ' })
  end
  for cell_index, cell in ipairs(left_cells) do
    table.insert(left_status_elements, { Foreground = { Color = cell.color } })
    if cell_index == 1 and window:leader_is_active() then
      table.insert(left_status_elements, { Foreground = { Color = '#f0d197' } })
    end
    table.insert(left_status_elements, { Text = cell[1] })
    left_elements_width = left_elements_width + #cell[1] - cell.icon_space

    if cell_index == #left_cells then
      table.insert(left_status_elements, { Foreground = { Color = layer } })
      table.insert(left_status_elements, { Text = ' ' })
      table.insert(left_status_elements, { Background = { Color = tab_bar_scheme.background } })
      table.insert(left_status_elements, { Text = '' })
    else
      table.insert(left_status_elements, { Foreground = { Color = '#1e232e' } })
      table.insert(left_status_elements, { Text = '  ' })
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

  -- Center tabs
  local window_width = window:active_tab():get_size().cols
  local max_left = (window_width / 2) - (all_tabs_width / 2) - left_elements_width

  window:set_left_status(wezterm.format(left_status_elements) .. wezterm.pad_left(' ', max_left))
  window:set_right_status(wezterm.format(right_status_elements))
end)

local is_tab_bar_forced_hidden = false
wezterm.on('toggle-tab-bar', function(window, _)
  local overrides = window:get_config_overrides() or {}

  overrides.enable_tab_bar = not overrides.enable_tab_bar
  is_tab_bar_forced_hidden = not overrides.enable_tab_bar
  window:set_config_overrides(overrides)
end)

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
  require('plugin/wezterm-session-manager/session-manager').save_state(...)
end)
wezterm.on('load-session', function(...)
  require('plugin/wezterm-session-manager/session-manager').load_state(...)
end)
wezterm.on('restore-session', function(...)
  require('plugin/wezterm-session-manager/session-manager').restore_state(...)
end)
wezterm.on('sessionizer-find-repoes', function(...)
  require('plugin/sessionizer').find_repoes(constants.project_dirs, ...)
end)

return M
