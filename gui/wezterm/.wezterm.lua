local wezterm = require 'wezterm';

local SOLID_LEFT_ARROW = '';
local SOLID_RIGHT_ARROW = '';

local color_tabbar_background = '#242b38'
-- meh: chars and width are only broadly related...
local tab_max_width = 50
local tab_max_chars = 30


local tab_bar = {
  background = '#242b38',  -- The color of the strip that goes along the top of the window
  active_tab = {
    bg_color = '#52307c',
    fg_color = '#c0c0c0',
    intensity = 'Bold',
    underline = 'None',
  },
  inactive_tab = {
    bg_color = '#1b1032',
    fg_color = '#808080',
    intensity = 'Half',
    underline = 'None',
  },
  inactive_tab_hover = {
    bg_color = '#3c1361',
    fg_color = '#909090',
    intensity = 'Bold',
    underline = 'None',
  },
  new_tab = {
    bg_color = '#242b38',
    fg_color = '#808080',
  },
  new_tab_hover = {
    bg_color = '#3b3052',
    fg_color = '#909090',
  }
}


wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover)
  local c, bg, fg, b, u, title
  local tab_is_hover = hover;
  local tab_is_active = tab.is_active;

  if tab_is_active then
    c = tab_bar.active_tab;
  elseif tab_is_hover then
    c=tab_bar.inactive_tab_hover;
  else
    c=tab_bar.inactive_tab;
  end

  bg=c.bg_color
  fg=c.fg_color
  b=c.intensity
  u=c.underline

  title = tab.active_pane.title;
  -- title = os.getenv('PWD');
  -- we can at maximum only display some predefined chars and have to add
  -- the numbering ('xx: ', 4 chars) and maybe a dot + space (3 chars))
  local available_chars = tab_max_chars - 4 - 3;
  local title_chars = string.len(title)
  if title_chars > available_chars then
    title = '…' .. string.sub(title, title_chars - available_chars) ;
  end

  if #tabs > 1 then
    title = string.format('%d: %s', tab.tab_index + 1, title);
  end

  return {
    {Background={Color=color_tabbar_background}},
    {Foreground={Color=bg}},
    {Text=SOLID_LEFT_ARROW},
    {Background={Color=bg}},
    {Foreground={Color=fg}},
    {Text=' '},
    {Attribute={Underline=u}},
    {Attribute={Intensity=b}},
    {Text=title},
    {Attribute={Intensity='Normal'}},
    {Attribute={Underline='None'}},
    {Text=' '},
    {Background={Color=color_tabbar_background}},
    {Foreground={Color=bg}},
    {Text=SOLID_RIGHT_ARROW},
  }
end)

wezterm.on('update-right-status', function(window, pane)
  -- Each element holds the text for a cell in a 'powerline' style << fade
  local cells = {};

  local date = wezterm.strftime('%a %b %-d %H:%M');
  table.insert(cells, date);
  table.insert(cells, 'foo');

  -- The powerline < symbol
  local LEFT_ARROW = utf8.char(0xe0b3);
  -- The filled in variant of the < symbol
  local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

  -- Color palette for the backgrounds of each cell
  local colors = {
    '#3c1361',
    '#52307c',
    '#663a82',
    '#7c5295',
    '#b491c8',
  };

  -- Foreground color for the text across the fade
  local text_fg = '#c0c0c0';

  -- The elements to be formatted
  local elements = {};
  -- How many cells have been formatted
  local num_cells = 0;

  -- Translate a cell into elements
  local function push(text, is_last)
    local cell_no = num_cells + 1
    table.insert(elements, {Foreground={Color=text_fg}})
    table.insert(elements, {Background={Color=colors[cell_no]}})
    table.insert(elements, {Text=' '..text..' '})
    if not is_last then
      table.insert(elements, {Foreground={Color=colors[cell_no+1]}})
      table.insert(elements, {Text=SOLID_LEFT_ARROW})
    end
    num_cells = num_cells + 1
  end

  while #cells > 0 do
    local cell = table.remove(cells, 1)
    push(cell, #cells == 0)
  end

  window:set_right_status(wezterm.format(elements));
  --   window:set_right_status(wezterm.format({
  --     -- {Attribute={Underline='Single'}},
  --     -- {Attribute={Italic=true}},
  --     {Text=' '..date},
end);

-- wezterm.on('window-config-reloaded', function(window, pane)
--   window:toast_notification('wezterm', 'configuration reloaded!', nil, 4000)
-- end)

-- wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
--   return ' ' .. tab.active_pane.title .. ' '
-- end)

wezterm.on('toggle-opacity', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  if not overrides.window_background_opacity then
    overrides.window_background_opacity = 0.5;
  else
    overrides.window_background_opacity = nil
  end
  window:set_config_overrides(overrides)
end)

wezterm.on('toggle-tab-bar', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  if overrides.enable_tab_bar then
    overrides.enable_tab_bar = false;
  else
    overrides.enable_tab_bar = true;
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
  tab_max_width = tab_max_width,
  initial_rows = 28,
  initial_cols = 114,
  set_environment_variables = {
    EDITOR = 'nvim'
  },
  status_update_interval = 1000,
  font = wezterm.font_with_fallback({
    {
      family='FiraCode NF',
      weight='Medium',
    },
    'Cascadia Code',
    'Consolas',
  }),
  font_size = 13.5,
  default_prog = {'C:\\Program Files\\Git\\bin\\bash.exe'},
  default_cwd = 'E:\\repoes',
  -- default_gui_startup_args = {'start'}
  color_scheme = 'OneHalfDark',
  hide_tab_bar_if_only_one_tab = false,
  window_background_opacity = 0.98,
  -- window_background_image = 'C:\\Users\\hasan\\Pictures\\do-more-y3.jpg'
  -- tab_bar_at_bottom = true,
  unzoom_on_switch_pane = true,
  exit_behavior='Close',
  enable_tab_bar = true,
  window_close_confirmation = 'NeverPrompt',
  adjust_window_size_when_changing_font_size = false,
  window_decorations = 'NONE',
  leader = { key='b', mods='CTRL', timeout_milliseconds=1000 },
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
    -- {key='l', mods='ALT', action='ShowLauncher'},
    {key=' ', mods='CTRL', action={SendString='\x11'}},
    {key='Backspace', mods='CTRL', action={SendKey={key='w', mods='CTRL'}}},
    {
      key='k',
      mods='CTRL',
      action = wezterm.action_callback(function(window, pane)
        -- local overrides = window:get_config_overrides() or {}
        -- if not window:get_dimensions().is_full_screen then
        --   overrides.enable_tab_bar = false;
        -- else
        --   overrides.enable_tab_bar = true;
        -- end
        -- window:set_config_overrides(overrides)
        -- window:perform_action('ToggleFullScreen', pane)
        -- window:perform_action(wezterm.action{Multiple={
        --   -- {SendKey={mods='CTRL', key='l'}},
        --   -- {SendString='\x1b'},
        --   -- {SendString='ls'},
        --   -- {SendString='\32'},
        --   SendKey={key='q', mods='CTRL'}
        --   -- {SplitHorizontal={}},
        --   -- {SplitHorizontal={}},
        --   -- {SendString='\x1bb'}

        --   -- {SendString='Hello'},
        -- }}, pane)
        -- window:perform_action(wezterm.action{SendString='Hello'}, pane)
        --   -- {}
        window:perform_action(wezterm.action{SendString='\x11'}, pane)
        -- window:perform_action(wezterm.action{SendKey={key='q', mods='CTRL'}}, pane)
      end)
    },
    {
      key='Enter',
      mods='ALT',
      action = wezterm.action_callback(function(window, pane)
        local overrides = window:get_config_overrides() or {}
        if not window:get_dimensions().is_full_screen then
          overrides.enable_tab_bar = false;
        else
          overrides.enable_tab_bar = true;
        end
        window:set_config_overrides(overrides)
        window:perform_action('ToggleFullScreen', pane)
      end)
    },
    {key='\\', mods='ALT', action='ShowTabNavigator'},
    {key=',', mods='ALT', action='ShowTabNavigator'},
    {key='l', mods='SHIFT|CTRL', action=wezterm.action{SpawnCommandInNewTab={

      args={'lf'},
      cwd = '.',
      label = 'List all the files!',
    }}},
    -- {key='b', mods='LEADER', action=wezterm.action{EmitEvent='toggle-opacity'}},
    {key='b', mods='LEADER', action=wezterm.action{EmitEvent='toggle-tab-bar'}},
    {key='w', mods='SHIFT|CTRL', action=wezterm.action{CloseCurrentPane={confirm=false}}},
    -- tabs
    {key='[', mods='ALT', action=wezterm.action{ActivateTabRelative=-1}},
    {key=']', mods='ALT', action=wezterm.action{ActivateTabRelative=1}},
    {key='{', mods='SHIFT|ALT', action=wezterm.action{MoveTabRelative=-1}},
    {key='}', mods='SHIFT|ALT', action=wezterm.action{MoveTabRelative=1}},
    -- tmux key bindings
    {key='c', mods='LEADER', action=wezterm.action{SpawnTab='CurrentPaneDomain'}},
    {key='x', mods='LEADER', action=wezterm.action{CloseCurrentPane={confirm=false}}},
    {key='z', mods='LEADER', action='TogglePaneZoomState'},
    {key='-', mods='LEADER', action=wezterm.action{SplitVertical={domain='CurrentPaneDomain'}} },
    {key='\\', mods='LEADER', action=wezterm.action{SplitHorizontal={domain='CurrentPaneDomain'}} },
    {key='h', mods='LEADER', action=wezterm.action{ActivatePaneDirection='Left'}},
    {key='j', mods='LEADER', action=wezterm.action{ActivatePaneDirection='Down'}},
    {key='k', mods='LEADER', action=wezterm.action{ActivatePaneDirection='Up'}},
    {key='l', mods='LEADER', action=wezterm.action{ActivatePaneDirection='Right'}},
    {key='H', mods='LEADER|SHIFT', action=wezterm.action{AdjustPaneSize={'Left', 5}}},
    {key='J', mods='LEADER|SHIFT', action=wezterm.action{AdjustPaneSize={'Down', 5}}},
    {key='K', mods='LEADER|SHIFT', action=wezterm.action{AdjustPaneSize={'Up', 5}}},
    {key='L', mods='LEADER|SHIFT', action=wezterm.action{AdjustPaneSize={'Right', 5}}},
    {key='1', mods='LEADER', action=wezterm.action{ActivateTab=0}},
    {key='2', mods='LEADER', action=wezterm.action{ActivateTab=1}},
    {key='3', mods='LEADER', action=wezterm.action{ActivateTab=2}},
    {key='4', mods='LEADER', action=wezterm.action{ActivateTab=3}},
    {key='5', mods='LEADER', action=wezterm.action{ActivateTab=4}},
    {key='6', mods='LEADER', action=wezterm.action{ActivateTab=5}},
    {key='7', mods='LEADER', action=wezterm.action{ActivateTab=6}},
    {key='8', mods='LEADER', action=wezterm.action{ActivateTab=7}},
    {key='9', mods='LEADER', action=wezterm.action{ActivateTab=8}},
    {key='&', mods='LEADER|SHIFT', action=wezterm.action{CloseCurrentTab={confirm=true}}},
    -- tmux custom bindings
    {key='o', mods='LEADER', action='ActivateLastTab'},
    {key='v', mods='LEADER', action=wezterm.action{SplitHorizontal={}}},
    {key='s', mods='LEADER', action=wezterm.action{SplitVertical={}}},
  },
  mouse_bindings = {
    {
      event={Up={streak=1, button='Left'}},
      mods='CTRL',
      action='OpenLinkAtMouseCursor',
    },
    {
      event={Drag={streak=1, button='Left'}},
      mods='CTRL|SHIFT',
      action='StartWindowDrag'
    },
  },
  colors = {
    tab_bar = tab_bar
  }
}
