#Requires AutoHotkey v2.0

PosX(place, offset, itemWidth) {
	screenWidth := A_ScreenWidth
	if (place == "right") {
		return screenWidth - (itemWidth + offset)
	} else if (place == "center") {
		return (screenWidth / 2) - (itemWidth / 2)
	}
	return offset ; place == "left"
}
PosY(place, offset, itemWidth) {
	screenHeight := A_ScreenHeight
	if (place == "bottom") {
		return screenHeight - (itemWidth + offset)
	} else if (place == "center") {
		return (screenHeight / 2) - (itemWidth / 2)
	}
	return offset ; place == "top"
}

;******************************************************************************
; Utils
;******************************************************************************
RunPowerShellScript(filePath) {
	if !FileExist(filePath) {
		MsgBox "PowerShell script not found: " filePath
		return
	}

	tempOutput := A_Temp "\ps_output.txt"
	if FileExist(tempOutput)
		FileDelete tempOutput

	cmd := Format(
		"powershell -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -Command `"& { & '{1}' | Out-File -FilePath '{2}' -Encoding utf8 }`"",
		filePath, tempOutput
	)

	RunWait(cmd, , "Hide")

	try output := FileRead(tempOutput)
	catch {
		MsgBox "Output file not found or could not be read."
		output := ""
	}
	return output
}
RunInlinePowerShell(cmd) {
	shell := ComObject("WScript.Shell")
	exec := shell.Exec('powershell -NoProfile -WindowStyle Hidden -Command "' cmd '"')
	output := exec.StdOut.ReadAll()
	return output
}
getMousePos() {
	MouseGetPos(&xpos, &ypos)
	xy := "x" xpos " y" ypos
	ToolTip(xy)
	A_Clipboard := xy
	SetTimer(toolTipClear, -1000)
}
dd(msg) {
	MsgBox(msg, "", "T1")
}
splashMessage(msg := "") {
	spGui := Gui("+ToolWindow +AlwaysOnTop -Sysmenu Disabled", "")
	spGui.SetFont("s10", "Segoe UI")
	spGui.Add("Text", "Center", msg "`n`n")
	spGui.Show("NoActivate AutoSize")
	return spGui
}
tooltipClear() {
	ToolTip()
}
beep() {
	SoundBeep(300, 150)
}
;******************************************************************************
; Different Actions
;******************************************************************************
toggleKanata() {
	beep()
	onOff := RunPowerShellScript("C:/Users/hasan/dotfiles/scripts/ahk/kanata-toggle.ps1")
	boardUpdateMsgLabel(onOff, 16)
}
suspendAHK() {
	Suspend()
	if A_IsSuspended
		ToolTip("Hotkeys Suspended")
	else
		ToolTip("Hotkeys Active")
	SetTimer(() => ToolTip(), -2000)
}
; Long press (> 0.5 sec) on Esc closes window - but if you change your mind you can keep it pressed for 3 more seconds
superEscape() {
	ErrorLevel := !KeyWait("Escape", "T0.5") ; Wait no more than 0.5 sec for key release (also suppress auto-repeat)
	if ErrorLevel { ; timeout, so key is still down...
		SoundPlay("*64") ; Play an asterisk (Doesn't work for me though!)
		appName := StrUpper(StrReplace(WinGetProcessName("A"), ".exe"))
		SplashTextGui := splashMessage("Release button to close`n" appName "`n`n    Keep pressing it to NOT    `nclose window...")
		ErrorLevel := !KeyWait("Escape", "T3") ; Wait no more than 3 more sec for key to be released
		SplashTextGui.Destroy
		If !ErrorLevel ; No timeout, so key was released
		{
			PostMessage(0x112, 0xF060, , , "A") ; ...so close window
			Return
		}
		; Otherwise,
		SoundPlay("*64")
		ErrorLevel := !KeyWait("Escape") ; Wait for button to be released
		Return ; Then do nothing...
	}
	Send("{Esc}")
}
toggleCapsLosck() {
	isCapsOn := !GetKeyState("CapsLock", "T")
	SetCapsLockState(isCapsOn)

	beep()
	winCloseByTitle("caps_losck_status_border")
	winCloseByTitle("caps_losck_status")

	if (isCapsOn) {
		height := 24
		width := 100
		x := PosX("center", 0, width)
		y := PosY("bottom", 54, height)

		Border := Gui("ToolWindow +AlwaysOnTop -Sysmenu Disabled -Caption -Owner", "caps_losck_status_border") ; Border GUI
		Border.BackColor := 0xff4DB434

		SLine := Gui("ToolWindow +AlwaysOnTop -Sysmenu Disabled -Caption -Owner", "caps_losck_status")
		SLine.BackColor := 0xff424242
		title := SLine.AddText("cWhite y4 x0 w100 h24 Center", "Caps Lock ON")
		title.SetFont("s10", "Arial")

		Border.Show("NoActivate x" (x - 2) " y" (y - 2) " w" (width + 4) " h" (height + 4)) ; Slightly larger
		SLine.Show("NoActivate x" x " y" y "w" width " h" height " NA")
	}
}
toggleBluetooth(onOff := "On") {
	winCloseByTitle("bt_status")

	height := 64
	width := 200
	x := PosX("right", 8, width)
	y := PosY("top", 8, height)

	ui := Gui("ToolWindow +AlwaysOnTop -Sysmenu Disabled -Caption -Owner", "bt_status")
	ui.BackColor := '2C2C2C'
	ui.SetWindowAttribute(33, 2)
	ui.SetWindowColor(, , 0xff151820)

	title := ui.AddText("cWhite y6 x0 w210 h24 Center", "Toggling Bluetooth")
	title.SetFont("s11 cDFDFDF", "Segoe UI")

	SoundBeep(300)
	curProgress := ui.AddProgress("x15 w170 h15", 70)
	ui.Show("NoActivate  x" x " y" y "w" width " h" height " NA")

	onOff := RunPowerShellScript("C:\\Users\\hasan\\dotfiles\\scripts\\ahk\\deps\\toggle_bluetooth.ps1")
	title.Text := "Bluetooth " onOff
	SoundBeep(1000)
	curProgress.Value := 100
	Sleep(800)
	ui.Destroy()
}

getNewestFilePath(folderPath) {
	newestFile := ""
	newestTime := 0
	Loop Files folderPath {
		fileTime := FileGetTime(A_LoopFileFullPath, "M")  ; Get file modification time
		if (fileTime > newestTime) {  ; Compare timestamps
			newestTime := fileTime
			newestFile := A_LoopFileFullPath
		}
	}
	return newestFile
}
openNewestFile(path) {
	newestFile := getNewestFilePath(path)
	Run(newestFile)
	; Run('C:\Users\hasan\AppData\Local\Programs\QuickLook\QuickLook.exe "' screenshotPath '"')
}
takeScreenshot() {
	SendInput("#{PrintScreen}")
	beep()
	spGui := splashMessage("  Your screenshort has saved  ")
	Sleep(300)
	spGui.Destroy
}
showCalendar() {
	; Send("#b")
	; Send("{left}")
	; Send("{left}")
	; Send("{Space}")
	Send("#n")
	sleep(800)
	Send("+{tab}")
	Send("+{tab}")
	Send("+{tab}")
	Send("+{tab}")
}
volup() {
	SoundSetVolume("+8") ;; Increase speed
	Send("{Volume_Up}")

}
voldown() {
	SoundSetVolume(-8)
	Send("{Volume_Down}")
}
showVolMixer() {
	Run("C:\Windows\System32\SndVol.exe")
	ErrorLevel := !WinWait("ahk_exe SndVol.exe")
	If WinExist("ahk_exe SndVol.exe")
		WinActivate("ahk_exe SndVol.exe")
	centerCurrentWindow("ahk_exe SndVol.exe")
}
showSoundOutput() {
	Send("{ctrl down}")
	Send("{lwin down}")
	Send("{v down}")

	Send("{ctrl up}")
	Send("{lwin up}")
	Send("{v up}")
}
selectPlaybackDeviceWin10() {
	Send("#b")
	Send("{left}")
	Send("{left}")
	Send("{left}")
	Send("{Space}")
	sleep(300)
	Send("{tab}")
	Send("{Enter}")
	sleep(100)
	Send("{tab}")
}
showMicPanel() {
	Run("control mmsys.cpl,,1")
	beep()
	ErrorLevel := !WinWait("ahk_exe rundll32.exe")
	if WinExist("ahk_exe rundll32.exe") {
		WinActivate("ahk_exe rundll32.exe")
		centerCurrentWindow("ahk_exe rundll32.exe")
	}
}
