# 🏠 dotfiles

## Windows

1. Install Chocolatey & Git Bash with PowerShell

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')) ; choco install git -y
```

2. Install & setup dotfiles with Bash

```bash
git clone https://github.com/hasansujon786/dotfiles ~/dotfiles && cd ~/dotfiles && ./scripts/install.sh win
```

3. Install Winget with PowerShell

```powershell
& C:\Users\hasan\dotfiles\scripts\install_winget.ps1
```

## Linux

1. Install & setup dotfiles

```bash
git clone https://github.com/hasansujon786/dotfiles ~/dotfiles && cd ~/dotfiles && ./scripts/install.sh lin
```

<!-- -- . g v -->
      { '<leader>fu', group = 'update-permission' },
      { '<leader>fuW', '<cmd>Chmod -w<CR>', desc = 'Remove write permission' },
      { '<leader>fuX', '<cmd>Chmod -x<CR>', desc = 'Remove executable' },
      { '<leader>fuw', '<cmd>Chmod +w<CR>', desc = 'Add write permission' },
      { '<leader>fux', '<cmd>Chmod +x<CR>', desc = 'Make this file executable' },


-- b3: Could not map: gc (gc)  ->  <Plug>ContextCommentary
--   Warn  2:19:52 PM notify.warn Debug: ~\AppData\Local\nvim\lua\config\mics\snacks.lua:265 3

       ["]c"] = "OpenOrScrollDown",
       ["<c-k>"] = "PeekUp",
       ["<c-j>"] = "PeekDown",
       ["<c-n>"] = "NextSection",
       ["<c-p>"] = "PreviousSection",

        -- The equivalent of using `includeDeclaration` in lsp buf calls, e.g:
        -- :lua vim.lsp.buf.references({includeDeclaration = false})

              File          = "󰈙",
              Module        = "",
              Namespace     = "󰦮",
              Package       = "",
              Class         = "󰆧",
              Method        = "󰊕",
              Property      = "",
              Field         = "",
              Constructor   = "",
              Enum          = "",
              Interface     = "",
              Function      = "󰊕",
              Variable      = "󰀫",
              Constant      = "󰏿",
              String        = "",
              Number        = "󰎠",
              Boolean       = "󰨙",
              Array         = "󱡠",
              Object        = "",
              Key           = "󰌋",
              Null          = "󰟢",
              EnumMember    = "",
              Struct        = "󰆼",
              Event         = "",
              Operator      = "󰆕",
              TypeParameter = "󰗴",
