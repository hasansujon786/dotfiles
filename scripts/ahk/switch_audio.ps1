# Switch-Audio.ps1
Import-Module AudioDeviceCmdlets -ErrorAction Stop

# Friendly names
$deviceMap = @{
    "Speakers" = "Speakers (Realtek(R) Audio)"
    "G436 Headset" = "Headset Earphone (G435 Wireless Gaming Headset)"
    # "Digital Output" = "Realtek Digital Output (Realtek(R) Audio)"
    "QCY Headphones" = "Headphones (3- QCY MeloBuds Pro)"
}

# Get playback devices
$devices = Get-AudioDevice -List | Where-Object { $_.Type -eq 'Playback' }

if (-not $devices) { Write-Error "No playback devices found."; exit 1 }

# Build selection list
$choices = @()
foreach ($key in $deviceMap.Keys) {
    if ($devices | Where-Object { $_.Name -eq $deviceMap[$key] }) { $choices += $key }
}
# Add any unmapped devices
$unmapped = $devices | Where-Object { $deviceMap.Values -notcontains $_.Name } | ForEach-Object { $_.Name }
$choices += $unmapped

# fzf selection
$selected = $choices | fzf --prompt="Select audio output: "

if ($selected) {
    $actualName = if ($deviceMap.ContainsKey($selected)) { $deviceMap[$selected] } else { $selected }
    $device = $devices | Where-Object { $_.Name -eq $actualName }
    Set-AudioDevice -Index $device.Index
    Write-Output "✅ Switched to: $selected ($actualName)"
} else {
    Write-Output "❌ No device selected."
}

#
# switchAudioDevice() {
# 	RunWaitOne(command) {
# 		DetectHiddenWindows(1)
# 		Run(A_ComSpec, , "Hide", &pid)
# 		WinWait("ahk_pid" pid)
# 		DllCall("AttachConsole", "UInt", pid)
#
# 		shell := ComObject("WScript.Shell")
# 		exec := shell.Exec(A_ComSpec " /C " command)
# 		result := exec.StdOut.ReadAll()
#
# 		DllCall("FreeConsole")
# 		ProcessClose(pid)
# 		return result
# 	}
#
# 	ToolTip("getting data")
# 	cmd := "pwsh -command C:\\Users\\hasan\\dotfiles\\scripts\\ahk\\quaka.ps1"
# 	dd(RunWaitOne(cmd))
# }
# ; switchAudioDevice()
# #i:: switchAudioDevice()
