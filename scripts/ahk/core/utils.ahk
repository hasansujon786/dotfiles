#Requires AutoHotkey v2.0

PosX(place, offset, itemWidth) {
  screenWidth := A_ScreenWidth
  if (place == "right") {
    return screenWidth - (itemWidth + offset)
  } else if (place == "center") {
    return (screenWidth/2) - (itemWidth/2)
  }
  return offset ; place == "left"
}
PosY(place, offset, itemWidth) {
  screenHeight := A_ScreenHeight
  if (place == "bottom") {
    return screenHeight - (itemWidth + offset)
  } else if (place == "center") {
    return (screenHeight/2) - (itemWidth/2)
  }
  return offset ; place == "top"
}

;******************************************************************************
; Utils
;******************************************************************************
getMousePos() {
  MouseGetPos(&xpos, &ypos)
  xy := "x" xpos " y" ypos
  ToolTip(xy)
  A_Clipboard := xy
  SetTimer(toolTipClear,-1000)
}
dd(msg) {
  MsgBox(msg, "", "T1")
}
splashMessage(msg:="") {
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
TaskBar_SetAttr(accent_state := 0, gradient_color := "0xff101010") { ; TODO: fix
  static init, hTrayWnd, ver := DllCall("GetVersion") & 0xff < 10
  static pad := A_PtrSize = 8 ? 4 : 0, WCA_ACCENT_POLICY := 19

  if !(init) {
    if (ver)
      ; throw Exception("Minimum support client: Windows 10", -1) ; TODO: fix
    if !(hTrayWnd := DllCall("user32\FindWindow", "str", "Shell_TrayWnd", "ptr", 0, "ptr"))
      ; throw Exception("Failed to get the handle", -1)
    init := 1
  }

  accent_size := ACCENT_POLICY := Buffer(16, 0) ; V1toV2: if 'ACCENT_POLICY' is a UTF-16 string, use 'VarSetStrCapacity(&ACCENT_POLICY, 16)'
  NumPut("int", (accent_state > 0 && accent_state < 4) ? accent_state : 0, ACCENT_POLICY, 0)

  if (accent_state >= 1) && (accent_state <= 2) && (RegExMatch(gradient_color, "0x[[:xdigit:]]{8}"))
    NumPut("int", gradient_color, ACCENT_POLICY, 8)

  WINCOMPATTRDATA := Buffer(4 + pad + A_PtrSize + 4 + pad, 0) ; V1toV2: if 'WINCOMPATTRDATA' is a UTF-16 string, use 'VarSetStrCapacity(&WINCOMPATTRDATA, 4 + pad + A_PtrSize + 4 + pad)'
    && NumPut("int", WCA_ACCENT_POLICY, WINCOMPATTRDATA, 0)
    && NumPut("ptr", &ACCENT_POLICY, WINCOMPATTRDATA, 4 + pad)
    && NumPut("uint", accent_size, WINCOMPATTRDATA, 4 + pad + A_PtrSize)
  if !(DllCall("user32\SetWindowCompositionAttribute", "ptr", hTrayWnd, "ptr", WINCOMPATTRDATA))
    ; throw Exception("Failed to set transparency / blur", -1)
  return true
}
;******************************************************************************
; Different Actions
;******************************************************************************
toggleKanata() {
  kanataPID := ProcessExist("kanata.exe")
  trayPID := ProcessExist("kanata-tray.exe")
  if(trayPID) {
    ProcessClose(trayPID)
    ProcessClose(kanataPID)
    Global kanata_enable := 0
    TrayTip("Kanata", "Kanata Disabled", 2)
  } else {
    Run("C:\Users\" A_UserName "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\kanata-tray.exe")
    TrayTip("Kanata", "Kanata Enabled", 2)
    Global kanata_enable := 1
  }
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
    currentWinID := WinExist("A") ; Get the current active window

    Border := Gui("ToolWindow +AlwaysOnTop -Sysmenu Disabled -Caption -Owner",  "caps_losck_status_border") ; Border GUI
    Border.BackColor := 0xff4DB434

    SLine := Gui("ToolWindow +AlwaysOnTop -Sysmenu Disabled -Caption -Owner", "caps_losck_status")
    SLine.BackColor := 0xff424242
    title := SLine.AddText("cWhite y4 x0 w100 h24 Center", "Caps Lock ON")
    title.SetFont("s10", "Arial")

    Border.Show("x" (x-2) " y" (y-2) " w" (width+4) " h" (height+4)) ; Slightly larger
    SLine.Show("x" x " y" y "w" width " h" height " NA")

    WinActivate(currentWinID) ; Refocus the current active window
  }
}
toggleBluetooth(onOff := "On") {
  mWidth := SysGet(78)
  mHeight := SysGet(79)
  ProgressGui := Gui("-Caption +AlwaysOnTop"), ProgressGui.Title := "BluetoothStatus"
  ProgressGui.SetFont("Bold s10", "Arial"), ProgressGui.AddText("x0 w200 Center", "Toggling Bluetooth")
  gocProgress := ProgressGui.AddProgress("x10 w180 h20")
  ProgressGui.Show("W200 NA")
  WinMove(mWidth - 210, mHeight - 100, , , "BluetoothStatus")
  gocProgress.Value := 70
  Static ps := "C:\\Users\\hasan\\dotfiles\\scripts\\ahk\\deps\\toggle_bluetooth.ps1"

  if !FileExist(ps) {
    ProgressGui.Destroy
    MsgBox("File not found.`n" ps, "Error", 48)
    Return
  } else   {
    SoundBeep(1500 - 500 * (onOff = "On"))
    ; RunWait, powershell -command %ps% -BluetoothStatus %onOff%,, Hide
    RunWait("powershell -command " ps, , "Hide")
    SoundBeep(1000 + 500 * (onOff = "On"))
  }

  gocProgress.Value := 100
  Sleep(600)
  ProgressGui.Destroy
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
  SoundSetVolume("+8")
  SendInput("{Volume_Up}")
}
voldown() {
  SoundSetVolume(-8)
  SendInput("{Volume_Down}")
}
showVolMixer() {
  Run("C:\Windows\System32\SndVol.exe")
  ErrorLevel := !WinWait("ahk_exe SndVol.exe")
  If WinExist("ahk_exe SndVol.exe")
  WinActivate("ahk_exe SndVol.exe")
  WinMove(880, 400, , , "ahk_exe SndVol.exe")
}
showVolMixerTabbar() {
  Send("{ctrl down}")
  Send("{lwin down}")
  Send("{v down}")

  Send("{ctrl up}")
  Send("{lwin up}")
  Send("{v up}")
  sleep(300)

  if WinActive("ahk_class ControlCenterWindow") {
    Send("{tab}{tab}{tab}")
    Send("+{end}")
  }
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
  WinWait("Sound")
  WinActivate("Sound")
}
