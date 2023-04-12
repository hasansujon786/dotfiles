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

```
