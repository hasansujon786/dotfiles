# 🏠 dotfiles

## Windows

1. Install Chocolatey & Git Bash with PowerShell

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')) ; choco install git -y
```

2. Install Winget with PowerShell on win10

```powershell
& C:\Users\hasan\dotfiles\scripts\install_winget.ps1
```

3. Install & setup dotfiles with Bash

```bash
git clone https://github.com/hasansujon786/dotfiles ~/dotfiles && cd ~/dotfiles && ./scripts/install.sh win
```
