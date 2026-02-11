$processName = "kanata-tray"
$exePath = "C:\Users\hasan\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\kanata-tray.exe"

# Check if process is running
if (Get-Process -Name $processName -ErrorAction SilentlyContinue) {
    # Process is running, kill it (and related processes)
    Stop-Process -Name "kanata-tray", "kanata", "kanata-cmd" -Force -ErrorAction SilentlyContinue
    Write-Output "Disabled"
} else {
    # Process is not running, start it
    Start-Process $exePath
    Write-Output "Enabled"
}
