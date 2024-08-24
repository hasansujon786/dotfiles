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
MouseIsOver(WinTitle) {
  MouseGetPos(, , &Win)
  return WinExist(WinTitle . " ahk_id " . Win)
}
; Long press (> 0.5 sec) on Esc closes window - but if you change your mind you can keep it pressed for 3 more seconds
superEscape() {
  ErrorLevel := !KeyWait("Escape", "T0.5") ; Wait no more than 0.5 sec for key release (also suppress auto-repeat)
  if ErrorLevel { ; timeout, so key is still down...
    SoundPlay("*64") ; Play an asterisk (Doesn't work for me though!)
    X := WinGetProcessName("A")
    SplashTextGui := Gui("ToolWindow -Sysmenu Disabled", )
    Text := SplashTextGui.Add("Text", "Center h120", "Release button to close " x "`n`nKeep pressing it to NOT close window...")
    Text.SetFont("s12", "Segoe UI")
    SplashTextGui.Show()

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
getMousePos() {
  MouseGetPos(&xpos, &ypos)
  xy := "x" xpos " y" ypos
  ToolTip(xy)
  A_Clipboard := xy
  SetTimer(toolTipClear,-1000)
}
P(msg) {
  MsgBox(msg, "", "T1")
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
isWindowFullScreen( winTitle ) {
  ;checks if the specified window is full screen
  winID := WinExist( winTitle )

  If ( !winID )
  Return false

  style := WinGetStyle("ahk_id " WinID)
  WinGetPos(, , &winW, &winH, winTitle)
  ; 0x7fffff is WS_BORDER.
  ; 0x1fffffff is WS_MINIMIZE.
  ; no border and not minimized
  Return ((style & 0x207fffff) or winH < A_ScreenHeight or winW < A_ScreenWidth) ? false : true
}
autoExitFullScreen() {
  isFullScreen := isWindowFullScreen( "A" )
  if (isFullScreen) {
    Send("{f11}")
  }
}

;******************************************************************************
; Different Actions
;******************************************************************************
toggleWinRestore() {
  ; WinGet WindowID, ID, A
  ; WinGet WindowSize, MinMax, ahk_id %WindowID%
  MX := WinGetMinMax("A")
  if (MX) {
    WinRestore("A")
  } else {
    WinMaximize("A")
  }
}
toggleCapsLosck() {
  isCapsOn := !GetKeyState("CapsLock", "T")
  SetCapsLockState(isCapsOn)

  color := "cBlack"
  msg := "Capslock Off"
  SplashTextGui := Gui("ToolWindow +AlwaysOnTop -Sysmenu Disabled -Caption"), SplashTextGui.Title := "CapsLosckStatus", SplashTextGui.SetFont("s20", "Arial")
  if (isCapsOn) {
    color := "cWhite"
    msg := "Capslock On"
    SplashTextGui.BackColor := "Red"
  }
  SplashTextGui.Add("Text" ,"w300 y70 Center " color, msg)
  SplashTextGui.Show("h200 NA")
  beep()

  Sleep(700)
  SplashTextGui.Destroy
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
  Static ps := "C:\\Users\\hasan\\dotfiles\\scripts\\ahk\\toggle_bluetooth.ps1"

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
takeScreenshot() {
  SendInput("#{PrintScreen}")
  beep()
  SplashTextGui := Gui("ToolWindow -Sysmenu Disabled +AlwaysOnTop -Caption", ), SplashTextGui.SetFont("s14", "Arial"), SplashTextGui.Add("Text", "x0 Center w200", "Your screenshort has saved")
  SplashTextGui.Show("w200 h80 NA")
  Sleep(300)
  SplashTextGui.Destroy
}
select_playback_device() {
  Send("#b")
  Send("{left}")
  Send("{left}")
  Send("{left}")
  Send("{Space}")
  sleep(100)
  Send("{tab}")
  Send("{Enter}")
  sleep(100)
  Send("{tab}")
}
showCalendar() {
  Send("#b")
  Send("{left}")
  Send("{left}")
  Send("{Space}")
  sleep(300)
  Send("{tab}")
  Send("{tab}")
  Send("{tab}")
  Send("{tab}")
}
volup() {
  SoundSetVolume("+8")
  SendInput("{Volume_Up}")
}
voldown() {
  SoundSetVolume(-8)
  SendInput("{Volume_Down}")
}
openVolumeController() {
  Run("C:\Windows\System32\SndVol.exe")
  ErrorLevel := !WinWait("ahk_exe SndVol.exe")
  If WinExist("ahk_exe SndVol.exe")
  WinActivate("ahk_exe SndVol.exe")
  WinMove(880, 400, , , "ahk_exe SndVol.exe")
}
toggleTransparency() {
  Title := WinGetTitle("A")
  TN := WinGetTransparent(Title)
  ; MsgBox, TN of %Title% is %TN%

  if (TN == "") {
    WinSetTransparent(245, "A")
    beep()
  }
  else {
    WinSetTransparent("OFF", "A")
  }
}
decreaseTransparency() {
  Title := WinGetTitle("A")
  TN := WinGetTransparent(Title)
  if(TN == "") {
    beep()
    return
  }

  if (TN < 255)
    TN += 5
  WinSetTransparent(TN, Title)
}
increaseTransparency() {
  Title := WinGetTitle("A")
  TN := WinGetTransparent(Title)
  if(TN == "") {
    beep()
    return
  }

  if (TN > 0)
    TN -= 5
  WinSetTransparent(TN, Title)
}
toggleAlwaysOnTop() {
  WinSetAlwaysontop(, "A")
  title := WinGetProcessName("A")
  win_id := WinGetID("A")
  beep()

  ExStyle := WinGetExStyle("ahk_id " win_id)
  If (ExStyle & 0x8)
    ExStyle := "AlwaysOnTop"
  Else
    ExStyle := "Not AlwaysOnTop"

  SplashTextGui := Gui("ToolWindow -Sysmenu Disabled", ), SplashTextGui.Add("Text",, "`n" exstyle "`n------------`n" title), SplashTextGui.Show("w200 h100")
  Sleep(300)
  SplashTextGui.Destroy
}

;******************************************************************************
; Window Switcher functions
;******************************************************************************
alternateTab() {
  Send("{alt down}")
  Send("{tab}")
  Send("{alt up}")
}
; Extracts the application title from the window's full title
ExtractAppTitle(FullTitle) {
  return SubStr(FullTitle, (InStr(FullTitle, " ", false, -2) + 1)<1 ? (InStr(FullTitle, " ", false, -2) + 1)-1 : (InStr(FullTitle, " ", false, -2) + 1))
}
switchBetweenSameApps() {
  activeProcessName := WinGetProcessName("A")
  if (activeProcessName = "chrome.exe") {
    ; Switch a "Chrome App or Chrome Website Shortcut" open windows based on the same application title
    FullTitle := WinGetTitle("A")
    AppTitle := ExtractAppTitle(FullTitle)
    SetTitleMatchMode(2)
    owindowsWithSameTitleList := WinGetList(AppTitle,,,)
    awindowsWithSameTitleList := Array()
    windowsWithSameTitleList := owindowsWithSameTitleList.Length
    For v in owindowsWithSameTitleList
    {   awindowsWithSameTitleList.Push(v)
    }
    WinActivate("ahk_id " awindowsWithSameTitleList[awindowsWithSameTitleList.Length])
  } else {
    ; Switch "App" open windows based on the same process and class
    activeClass := WinGetClass("A")
    SetTitleMatchMode(2)
    owindowsListWithSameProcessAndClass := WinGetList("ahk_exe " activeProcessName " ahk_class " activeClass,,,)
    awindowsListWithSameProcessAndClass := Array()
    windowsListWithSameProcessAndClass := owindowsListWithSameProcessAndClass.Length
    For v in owindowsListWithSameProcessAndClass
    {   awindowsListWithSameProcessAndClass.Push(v)
    }
    WinActivate("ahk_id " awindowsListWithSameProcessAndClass[awindowsListWithSameProcessAndClass.Length])
  }
}

;******************************************************************************
; Custom layout
;******************************************************************************
; "wt.exe", "ahk_exe WindowsTerminal.exe" ; "Code.exe", "ahk_exe Code.exe"
EDITOR_EXE := ["wezterm-gui.exe", "ahk_exe wezterm-gui.exe"]
BROWSER_EXE := ["zen.exe", "ahk_class MozillaWindowClass"] ; chrome.exe brave.exe

changeLayoutTo(layoutName) {
  Global layout_loading := 1

  Switch layoutName {
  Case "code":
    Global current_layout := 0
    layoutAction(BROWSER_EXE[2], BROWSER_EXE[1], "right")
    Send("{ESC}")
    layoutAction(EDITOR_EXE[2], EDITOR_EXE[1], "left")

  Case "float":
    Global current_layout := 1
    layoutAction(BROWSER_EXE[2], BROWSER_EXE[1], "maximized")
    layoutAction(EDITOR_EXE[2], EDITOR_EXE[1], "center")

  Case "focus":
    Global current_layout := 1
    layoutAction(BROWSER_EXE[2], BROWSER_EXE[1], "maximized")
    layoutAction(EDITOR_EXE[2], EDITOR_EXE[1], "maximized")

  Case "focus_custom":
    Global current_layout := 1
    layoutAction(BROWSER_EXE[2], BROWSER_EXE[1], "maximized")
    layoutAction(EDITOR_EXE[2], EDITOR_EXE[1], "maximized_custom")

  ; Default:
  }
  Global layout_loading := 0
}
toggleLayout() {
  if (current_layout == 0) {
    changeLayoutTo("focus_custom")
  }  else if (current_layout == 1){
    changeLayoutTo("code")
  }
}
layoutAction(EXE_FULL, EXE, side) {
  autoExitFullScreen()

  if (not WinExist(EXE_FULL)) {
    if (EXE == "Code.exe") {
      Run("C:\Users\" A_UserName "\AppData\Local\Programs\Microsoft VS Code\Code.exe")
    } else {
      Run(EXE)
    }
    ErrorLevel := !WinWait(EXE_FULL)
    runLayoutAction(EXE_FULL, EXE, side)
    return
  }

  runLayoutAction(EXE_FULL, EXE, side)
}
runLayoutAction(EXE_FULL, EXE, side) {
  if (WinExist(EXE_FULL)) {
    WinActivate(EXE_FULL)

    if(side == "center") {
      resetWin()
    } else if (side == "maximized") {
      WinMaximize("A")
    } else if (side == "maximized_custom") {
      ;           ↓ here 0 hides the video behind the window
      WinMove(-8, 1, A_ScreenWidth + 16, A_ScreenHeight - 30, "A")
      ; WinMove(, , A_ScreenWidth + 8, A_ScreenHeight - 36, "A")
      ; centerCurrentWindow()
    } else {
      ; winPinToSide(side, false)
      winPinToSide_custom(side)
    }
  }
}

;******************************************************************************
; Window Controll Vim Mode
;******************************************************************************
navToDesktop(side) {
  if (side == "left") {
    Send("^#{Left}")
  }  else if (side == "right"){
    Send("^#{Right}")
  }
}
resetWin() {
  if (A_ScreenHeight >= 1080) {
    ; old width: 834
    WinMove(, , 1406, 845, "A") ; 1080
  }  else {
    WinMove(, , 1216, 660, "A") ; 768
  }
  centerCurrentWindow()
}
changeWinSize(direction, val) {
  WinGetPos(, , &Width, &Height, "A")
  if (direction == "width") {
    WinMove(, , Width + val, , "A")
  }  else {
    WinMove(, , , Height + val, "A")
  }
  ; WinMove, %WinTitle%,, (A_ScreenWidth/2)-(Width/2), (A_ScreenHeight/2)-(Height/2)
}

moveWinRight(val) {
  WinGetPos(&x, &y, , , "A")
  moveWindowX_and_Y(x+val, y)
}
moveWinLeft(val) {
  WinGetPos(&x, &y, , , "A")
  moveWindowX_and_Y(x-val, y)
}
moveWinUp(val) {
  WinGetPos(&x, &y, , , "A")
  moveWindowX_and_Y(x, y-val)
}
moveWinDown(val) {
  WinGetPos(&x, &y, , , "A")
  moveWindowX_and_Y(x, y+val)
}
moveWindowX_and_Y(x, y){
  MouseGetPos(&mx, &my)
  WinMove(x, y, , , "A")
  ; mousemove, %mx%, %my%, 0
}
centerCurrentWindow() {
  try {
    win_title := WinGetTitle("A")
    WinGetPos(, , &win_width, &win_height, win_title)

    targetX := (A_ScreenWidth/2) - (win_width/2)
    targetY := ((A_ScreenHeight - 30)/2) - (win_height/2)
    WinMove(targetX, targetY, , , win_title)
  } catch Error as err {
    P("Error found, could not center the window")
  }
}
winPinToSide(side, checkFullscreen) {
  if (checkFullscreen) {
    autoExitFullScreen()
    Sleep(50)
  }

  WinRestore("A")
  if (side == "left") {
    Send("#{Left}")
  }  else if (side == "right"){
    Send("#{Right}")
  }
}
winPinToSide_custom(side) {
  tb_height := 24
  y_start := 0
  x_start := 0
  s_height := A_ScreenHeight - tb_height
  s_half := (A_ScreenWidth / 2) + 16 ; Increase 16px width to fill right side margin

  if (side == "left") {
    x_start := -8 ; remove default left margin
  } else if (side == "right") {
    x_start := s_half - 24 ; remove default left margin
  }

  WinRestore("A")
  WinMove(x_start, y_start, s_half, s_height, "A")
}
