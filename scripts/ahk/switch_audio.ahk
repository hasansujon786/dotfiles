; AutoHotkey v2 script
; Capture audio devices from PowerShell

; Run PowerShell and get output
cmd := 'powershell -NoProfile -Command "Get-AudioDevice -List | Format-Table Index,Name,Type -HideTableHeaders"'
output := ""
RunWait('cmd.exe /c ' cmd, "", "", &output)

; Initialize devices array
Devices := []
MsgBox(output)

; ; Parse each line
; for line in StrSplit(output, "`n") {
; 	line := StrTrim(line)
; 	if line =
; 		continue
;
; 	; Split by whitespace/tab
; 	parts := StrSplit(line, "`t")
; 	index := parts[1]
; 	type := parts[parts.MaxIndex()]
;
; 	; Reconstruct name (all middle parts)
; 	name := ""
; 	for i, part in parts {
; 		if i = 1 || i = parts.MaxIndex()
; 			continue
; 		name .= part " "
; 	}
; 	name := StrTrim(name)
;
; 	Devices.Push({ Index: index, Name: name, Type: type })
; }
;
; ; Show parsed devices
; for device in Devices {
; 	MsgBox("Index: " device.Index "`nName: " device.Name "`nType: " device.Type)
; }
