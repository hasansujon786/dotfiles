## dotfiles
https://github.com/yutkat/dotfiles/blob/main/.config/wezterm/wezterm.lua

## Theme
https://github.com/neapsix/wezterm
hi Normal guibg=#FAF4EC
hi Normal guibg=#F2E9E0

## cli
wezterm ls-fonts --text "✘"

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

```
