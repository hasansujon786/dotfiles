## dotfiles
https://github.com/yutkat/dotfiles/blob/main/.config/wezterm/wezterm.lua

## Theme
https://github.com/neapsix/wezterm
hi Normal guibg=#FAF4EC
hi Normal guibg=#F2E9E0

## cli
wezterm ls-fonts --text "✘"

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

## lua code
```lua
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
