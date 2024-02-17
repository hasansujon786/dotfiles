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
