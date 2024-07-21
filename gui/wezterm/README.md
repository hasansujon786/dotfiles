## dotfiles
https://github.com/yutkat/dotfiles/blob/main/.config/wezterm/wezterm.lua
https://gist.github.com/gsuuon/5511f0aa10c10c6cbd762e0b3e596b71

## plugins
https://github.com/sei40kr/wez-status-generator
https://github.com/sei40kr/wez-per-project-workspace

## Theme
https://github.com/neapsix/wezterm
hi Normal guibg=#FAF4EC
hi Normal guibg=#F2E9E0

## cli
wezterm ls-fonts --text "✘"
wezterm cli spawn nvim
wezterm cli spawn --window-id=0 --cwd=E:/repoes/lua/peep.nvim nvim

## Log Files
You can find log files in $XDG_RUNTIME_DIR/wezterm on unix systems,
or $HOME/.local/share/wezterm on macOS and Windows systems.

## Custom keymap
- https://www.reddit.com/r/neovim/comments/12hyi9t/make_scr_cscr_stab_ctab_work_in_neovim_kitty/
- using: https://stackoverflow.com/questions/16359878/how-to-map-shift-enter
map shift+enter              send_text all \x1b[13;2u      # <s-cr>
map ctrl+enter               send_text all \x1b[13;5u      # <c-cr>
map ctrl+shift+enter         send_text all \x1b[13;6u      # <c-s-cr>
map shift+tab                send_text all \x1b[9;2u       # <s-tab>
map ctrl+tab                 send_text all \x1b[9;5u       # <c-tab>
map ctrl+shift+tab           send_text all \x1b[9;6u       # <c-s-tab>

- using: https://www.reddit.com/r/neovim/comments/mbj8m5/how_to_setup_ctrlshiftkey_mappings_in_neovim_and/
map ctrl+shift+j             send_text all \x1b[74;5u      # <c-s-j> (not <c-J>, like <m-J> which works differently from <m-j>)
map ctrl+shift+k             send_text all \x1b[75;5u      # <c-s-k>
map ctrl+shift+h             send_text all \x1b[72;5u      # <c-s-h>
map ctrl+shift+l             send_text all \x1b[76;5u      # <c-s-l>
act.SendKey({ key = '\x1b' }), -- escape

## lua code
```lua
wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

local multiple_actions = function(keys)
  local actions = {}
  for key in keys:gmatch('.') do
    table.insert(actions, act.SendKey({ key = key }))
  end
  table.insert(actions, act.SendKey({ key = '\n' }))
  return act.Multiple(actions)
end

  action = wezterm.action_callback(function(window, pane)
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
    window:perform_action(wezterm.action({ SendString = '\x11' }), pane)
    -- window:perform_action(wezterm.action{SendKey={key='q', mods='CTRL'}}, pane)
  end),

  local ssh_domains = {
    {
      name = "linode.arch",
      remote_address = "139.144.54.146",
      username = "root",
      ssh_option = {
        identityfile = [[C:\Users\kevin\.ssh\linode]],
      },
    },
  }
   -- wsl
   local  wsl_domains = {
     {
       name = "WSL:Ubuntu",
       distribution = "Ubuntu",
       username = "kevin",
       default_cwd = "/home/kevin",
       default_prog = { "fish" },
     },
   }

-- Custm command
wezterm.on('augment-command-palette', function(window, pane)
  return {
    {
      brief = 'Rename tab',
      icon = 'md_rename_box',

      action = act.PromptInputLine({
        description = 'Enter new name for tab',
        action = wezterm.action_callback(function(window, pane, line)
          if line then
            window:active_tab():set_title(line)
          end
        end),
      }),
    },
  }
end)

-- { key = 'b', mods = 'LEADER', action = act({ EmitEvent = 'toggle-opacity' }) },
wezterm.on('toggle-opacity', function(window, _)
  local overrides = window:get_config_overrides() or {}
  if not overrides.window_background_opacity then
    overrides.window_background_opacity = 0.5
  else
    overrides.window_background_opacity = nil
  end
  window:set_config_overrides(overrides)
end)

-- wezterm.on('window-config-reloaded', function(window, pane)
--   window:toast_notification('wezterm', 'configuration reloaded!', nil, 4000)
-- end)

-- wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
--   return ' ' .. tab.active_pane.title .. ' '
-- end)

```

## Debug
```lua
-- debug_key_events = true,
wezterm.on('update-status', function(window, pane)
  local mods, leds = window:keyboard_modifiers()
  window:set_right_status('mods=' .. mods .. ' leds=' .. leds)
end)
```

## Tab Compnents
```lua
local cell_num = 1 -- How many cells have been formatted
local function stacked(text, _)
  local colors = { '#3c1361', '#52307c', '#663a82', '#7c5295', '#b491c8' }

  table.insert(elements, { Foreground = { Color = colors[cell_num] } })
  table.insert(elements, { Text = SOLID_LEFT_ARROW })

  table.insert(elements, { Foreground = { Color = text_fg } })
  table.insert(elements, { Background = { Color = colors[cell_num] } })
  table.insert(elements, { Text = ' ' .. text .. ' ' })

  -- if not is_last then
  --   table.insert(elements, { Foreground = { Color = colors[cell_num + 1] } })
  --   table.insert(elements, { Text = SOLID_LEFT_ARROW })
  -- end
  cell_num = cell_num + 1
end

local function simple(text, _)
  table.insert(elements, { Foreground = { Color = text_fg } })
  table.insert(elements, { Text = text })
end
```

## Text format
```lua
wezterm.format({
  -- turn on underlines
  { Attribute = { Underline = 'Single' } },
  -- make the underline red
  { Text = '\x1b[58:2::255:0:0m' },
  -- { Attribute = { Intensity = 'Bold' } },
  { Foreground = { AnsiColor = 'Fuchsia' } },
  { Text = 'Enter name for tab' },
})
```
## theme onedarkhalf
                        light     dark
0   normal  black       #383a42   #282c34
1   normal  red         #e45649   #e06c75
2   normal  green       #50a14f   #98c379
3   normal  yellow      #c18401   #e5c07b
4   normal  blue        #0184bc   #61afef
5   normal  magenta     #a626a4   #c678dd
6   normal  cyan        #0997b3   #56b6c2
7   normal  white       #fafafa   #dcdfe4
            foreground  #383a42   #dcdfe4
            background  #fafafa   #282c34
