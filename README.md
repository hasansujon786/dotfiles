# 🏠 dotfiles

## Windows

1. Install Scoop & Git Bash with PowerShell

```ps1
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force; iwr -useb get.scoop.sh | iex; scoop install git
```

2. Install & setup dotfiles with Bash

```bash
git clone --depth 1 https://github.com/hasansujon786/dotfiles ~/dotfiles && cd ~/dotfiles && ./scripts/install.sh
```
