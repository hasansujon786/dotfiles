$ahkScript = "C:\Users\$env:USERNAME\dotfiles\scripts\ahk\main.ahk"

# Check if AutoHotkey is available in PATH
if (-Not (Get-Command "autohotkey.exe" -ErrorAction SilentlyContinue)) {
    Write-Error "AutoHotkey is not found in PATH. Make sure it's installed and added to your system PATH."
    exit 1
}

if (-Not (Test-Path $ahkScript)) {
    Write-Error "AHK script not found at '$ahkScript'"
    exit 1
}

Start-Process -FilePath "autohotkey.exe" -ArgumentList "`"$ahkScript`""
# Start-Process -FilePath "autohotkey.exe" -ArgumentList "`"$ahkScript`"" -Verb RunAs
