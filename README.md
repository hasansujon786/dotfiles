# 🏠 dotfiles

## Windows

1. Install Scoop & Git Bash with PowerShell

```ps1
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force;
iwr -useb get.scoop.sh | iex;
scoop install git;
Start-Process "$env:USERPROFILE\scoop\apps\git\current\git-bash.exe" -Verb RunAs
```

2. Install & setup dotfiles with Bash

```bash
git clone --depth 1 https://github.com/hasansujon786/dotfiles ~/dotfiles && cd ~/dotfiles && ./scripts/install.sh
```

# vscode

```PowerShell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/hasansujon786/dotfiles/refs/heads/main/nvim/lua/core/keymaps/code.lua" -OutFile "$HOME\AppData\Local\nvim\init.lua"
```
