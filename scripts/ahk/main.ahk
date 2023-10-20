#Requires AutoHotkey v2.0
; REMOVED: #NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
; SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir(A_ScriptDir) ; Ensures a consistent starting directory.
#SingleInstance Force
; C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\

;Reload/Execute this script.ahk file
::rscript::
f5:: {
  SplashTextGui := Gui("ToolWindow -Sysmenu Disabled", ), SplashTextGui.Add("Text",, "reloaded"), SplashTextGui.Show("w200 h60")
  Sleep(300)
  SplashTextGui.Destroy
  Run("C:\Users\" A_UserName "\dotfiles\scripts\ahk\main.ahk")
}
^f5::Suspend(-1)

#`::takeScreenshot()
PrintScreen::Send("#+{s}")
#\::toggleCapsLosck()
#Capslock::toggleCapsLosck()
#q::bt()
#+q::bt() bt()
#;::SendInput("{AppsKey}")
;Transparency toggle,
#^/::toggleTransparency()
#^.::increaseTransparency()
#^,::decreaseTransparency()
; Change Volume:
!Del::Volume_Mute
!PgUp::volup()
!PgDn::voldown()
#HotIf MouseIsOver("ahk_class Shell_TrayWnd")
  ~LAlt & WheelUP::volup()
  ~LAlt & WheelDown::voldown()
  ~LAlt & RButton::openVolumeController()
#HotIf
; Global arrow controls
!Backspace::Send("^{Backspace}")
!SPACE::Send("^{SPACE}")
!j::SendInput("{DOWN}")
!k::SendInput("{UP}")
#HotIf not WinActive("ahk_exe WindowsTerminal.exe")
  and not WinActive("ahk_exe alacritty.exe")
  and not WinActive("ahk_exe wezterm-gui.exe")
  ; and not WinActive("ahk_exe Code.exe")
  !h::  SendInput("{LEFT}")
  !l::  SendInput("{RIGHT}")
#HotIf

;******************************************************************************
; Window manazement
;******************************************************************************
!1::Send("#1")
!2::Send("#2")
!3::Send("#3")
!4::Send("#4")
!5::Send("#5")
!6::Send("#6")
!7::Send("#7")
!8::Send("#8")
!9::Send("#9")
!0::Send("#0")
#InputLevel 1
!\::Send("\")
\::alternateTab()
Capslock::alternateTab()
!`::switchBetweenSameApps()

^#m::Send("#{m}")
#m::WinMinimize("a")
!x::toggleWinRestore()
![::SendInput("^+{tab}")
!]::SendInput("^{tab}")
+![::SendInput("^+{PgUp}")
+!]::SendInput("^+{PgDn}")
!Enter::Send("{f11}")
!Escape::resetWin()
$Escape::superEscape()
#SPACE::toggleAlwaysOnTop() ; TODO: fix
; Vertual Desktop
#h::navToDesktop("left")
#l::navToDesktop("right")
#[::navToDesktop("left")
#]::navToDesktop("right")

;******************************************************************************
; Layout
;******************************************************************************
current_layout := 0
#p::{
  Global current_layout := 0
  layoutCode()
}
#o::{
  Global current_layout := 1
  layoutCodeFloat()
}
#'::{
  if (current_layout == 0) {
    Global current_layout := 1
    layoutCodeFloat()
  }  else if (current_layout == 1){
    Global current_layout := 0
    layoutCode()
  }
}
; #[::winPinToSide("left", true)
; #]::winPinToSide("right", true)

;******************************************************************************
; AltTabMenu & TaskView
;******************************************************************************
#/::SendInput("^!{Tab}")
#HotIf WinActive("ahk_class MultitaskingViewFrame") ; or WinActive("ahk_class Windows.UI.Core.CoreWindow")
  ; *WheelDown::Send {Blind}{Tab}
  ; *WheelUp::Send {Blind}+{Tab}
  q::Send("{Esc}")
  l::Send("{Right}")
  h::Send("{Left}")
  j::Send("{Down}")
  k::Send("{Up}")
  o::Send("{Enter}")
  x::Send("{Delete}")
  d::Send("{PgDn}")
  u::Send("{PgUp}")
  ; manage workspace
  +n::Send("^#d")
  +x::Send("^#{F4}")
  [::navToDesktop("left")
  ]::navToDesktop("right")
#HotIf

;******************************************************************************
; Window Move Mode
;******************************************************************************
winMode := 0
#HotIf !winMode
  !w::{
    Global winMode := 1
    beep()
    TaskBar_SetAttr(1, 0xff79C398)
  }
#HotIf
#HotIf winMode
  r::resetWin()
  c::centerCurrentWindow()

  l::moveWinRight(25)
  h::moveWinLeft(25)
  k::moveWinUp(25)
  j::moveWinDown(25)
  +l::moveWinRight(200)
  +h::moveWinLeft(200)
  +k::moveWinUp(200)
  +j::moveWinDown(200)
  .::changeWinSize("width", 10)
  ,::changeWinSize("width", -10)
  =::changeWinSize("height", 10)
  -::changeWinSize("height", -10)
  +.::changeWinSize("width", 50)
  +,::changeWinSize("width", -50)
  +=::changeWinSize("height", 50)
  +-::changeWinSize("height", -50)

  [::navToDesktop("left")
  ]::navToDesktop("right")

  q::{
    Global winMode := 0
    beep()
    TaskBar_SetAttr(1, 0xff101010)
  }
  Esc::{
    Global winMode := 0
    beep()
    TaskBar_SetAttr(1, 0xff101010)
  }
  LWin::{
    Global winMode := 0
    beep()
    TaskBar_SetAttr(1, 0xff101010)
  }
#HotIf

navToDesktop(side) {
  if (side == "left") {
    Send("^#{Left}")
  }  else if (side == "right"){
    Send("^#{Right}")
  }
}
resetWin() {
  if (A_ScreenHeight >= 1080) {
    WinMove(, , 1406, 834, "A") ; 1080
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
  win_title := WinGetTitle("A")
  WinGetPos(, , &win_width, &win_height, win_title)

  targetX := (A_ScreenWidth/2) - (win_width/2)
  targetY := (A_ScreenHeight/2) - (win_height/2)
  WinMove(targetX, targetY, , , win_title)
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
;******************************************************************************
; Window Switcher functions
;******************************************************************************
alternateTab() {
  Send("{alt down}")
  Sleep(5)
  Send("{tab}")
  Sleep(5)
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
layoutCodeFloat() {
  beep()
  layout_winAction("ahk_exe brave.exe", "brave.exe", "full")
  ; layout_winAction("ahk_exe chrome.exe", "chrome.exe", "full")

  layout_winAction("ahk_exe wezterm-gui.exe", "wezterm-gui.exe", "center")
  ; layout_winAction("ahk_exe WindowsTerminal.exe", "wt.exe", "center")
  ; layout_winAction("ahk_exe Code.exe", "Code.exe", "center")
}
layoutCode() {
  beep()
  layout_winAction("ahk_exe brave.exe", "brave.exe", "right")
  ; layout_winAction("ahk_exe chrome.exe", "chrome.exe", "right")
  Send("{ESC}")
  layout_winAction("ahk_exe wezterm-gui.exe", "wezterm-gui.exe", "left")
  ; layout_winAction("ahk_exe WindowsTerminal.exe", "wt.exe", "left")
  ; layout_winAction("ahk_exe Code.exe", "Code.exe", "left")
}
layout_winAction(EXE_FULL, EXE, side) {
  autoExitFullScreen()

  if (not WinExist(EXE_FULL)) {
    if (EXE == "Code.exe") {
      Run("C:\Users\" A_UserName "\AppData\Local\Programs\Microsoft VS Code\Code.exe")
    } else {
      Run(EXE)
    }
    ErrorLevel := !WinWait(EXE_FULL)
    layout_selectWin(EXE_FULL, EXE, side)
    return
  }
  layout_selectWin(EXE_FULL, EXE, side)
}
layout_selectWin(EXE_FULL, EXE, side) {
  if (WinExist(EXE_FULL)) {
    WinActivate(EXE_FULL)

    if(side == "center") {
      resetWin()
    } else if (side == "full") {
      WinMaximize("A")
    } else {
      ; winPinToSide(side, false)
      winPinToSide_custom(side)
    }
  }
}
;******************************************************************************
; Explorer functions
;******************************************************************************
explorerInsertMode := false
explorerToggleInsert() {
  if (explorerInsertMode) {
    ToolTip()
    Global explorerInsertMode := false
  } else {
    WinGetPos(&X, &Y, &Width, &Height)
    ToolTip("INSERT", 10, Height - 35)
    Global explorerInsertMode := true
  }
}
#HotIf WinActive("ahk_class CabinetWClass") && explorerInsertMode
  Esc::
  ~Enter::explorerToggleInsert()
#HotIf
#HotIf WinActive("ahk_class CabinetWClass") && !explorerInsertMode
  i::explorerToggleInsert()

  ; Navigation
  j::Send("{Down}")
  k::Send("{Up}")
  h::Send("{Left}")
  l::Send("{Right}")
  g::Send("{Home}")
  +g::Send("{End}")
  +h::Send("!{Up}")
  +l::Send("!{Left}")

  ; Scroll
  ^u::
  !u::Send("{PgUp}")
  ^d::
  !d::Send("{PgDn}")

  q::Send("!{F4}")
  x::Send("{Delete}")
  u::Send("^z")
  ^r::Send("^y")
  ^k::{
    Send("{F2}")
    Send("{RIGHT}")
    SendInput("-" A_MM "-" A_DD)
  }

  /::{
    explorerToggleInsert() ; TODO: fix cursor moves to side nav on esc
    Send("^f")
  }
  f::{
    explorerInsertMode := true ; TODO: is not working
    ihfindChar := InputHook("T1 L1"), ihfindChar.Start(), ihfindChar.Wait(), findChar := ihfindChar.Input
    Send(findChar)
    explorerInsertMode := false
  }

  r::
  c::{
    Send("{F2}")
    explorerToggleInsert()
  }

  o::
  +o::{
    Send("^+n")
    explorerToggleInsert()
  }

  space::{
    focusedControl := ControlGetClassNN(ControlGetFocus())
    if (focusedControl == "DirectUIHWND2") {
      ControlFocus("SysTreeView321", "A")
    } else {
      ControlFocus("DirectUIHWND2", "A")
    }
  }

  ~Enter::{
    focusedControl := ControlGetClassNN(ControlGetFocus())
    if (focusedControl == "SysTreeView321") {
      Sleep(100)
      ControlFocus("DirectUIHWND2", "A")
      Send("{Down}") ; Show focus item
      Send("{Up}")
      Send("{Right}")
      Send("{Left}")
    }
  }
#HotIf

;******************************************************************************
; Utils
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
  SplashTextGui := Gui("ToolWindow -Sysmenu Disabled", ), SplashTextGui.Add("Text",, "Toggle Capslock"), SplashTextGui.Show("w200 h60")
  beep()
  SetCapsLockState(!GetKeyState("CapsLock", "T"))
  Sleep(300)
  SplashTextGui.Destroy
}
bt(onOff := "On") {
  mWidth := SysGet(78)
  mHeight := SysGet(79)
  ProgressGui := Gui("-Caption"), ProgressGui.Title := "BluetoothStatus" , ProgressGui.SetFont("Bold"), ProgressGui.AddText("x0 w200 Center", "Toggling Bluetooth"), gocProgress := ProgressGui.AddProgress("x10 w180 h20"), ProgressGui.Show("W200")
  WinMove(mWidth - 210, mHeight - 90, , , "BluetoothStatus")
  gocProgress.Value := 70
  Static ps := "C:\\Users\\hasan\\dotfiles\\scripts\\ahk\\toggle_bluetooth.ps1"

  If !FileExist(ps) {
    ProgressGui.Destroy
    MsgBox("File not found.`n" ps, "Error", 48)
    Return
  } Else   SoundBeep(1500 - 500 * (onOff = "On"))
    ; RunWait, powershell -command %ps% -BluetoothStatus %onOff%,, Hide
    RunWait("powershell -command " ps, , "Hide")
  SoundBeep(1000 + 500 * (onOff = "On"))

  gocProgress.Value := 100
  Sleep(600)
  ProgressGui.Destroy
}
takeScreenshot() {
  SendInput("#{PrintScreen}")
  beep()
  SplashTextGui := Gui("ToolWindow -Sysmenu Disabled", ), SplashTextGui.Add("Text",, "Your screenshort has saved"), SplashTextGui.Show("w200 h60")
  Sleep(300)
  SplashTextGui.Destroy
}
MouseIsOver(WinTitle) {
  MouseGetPos(, , &Win)
  return WinExist(WinTitle . " ahk_id " . Win)
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
; Long press (> 0.5 sec) on Esc closes window - but if you change your mind you can keep it pressed for 3 more seconds
superEscape() {
  ErrorLevel := !KeyWait("Escape", "T0.5") ; Wait no more than 0.5 sec for key release (also suppress auto-repeat)
  if ErrorLevel { ; timeout, so key is still down...
    SoundPlay("*64") ; Play an asterisk (Doesn't work for me though!)
    X := WinGetProcessName("A")
    SplashTextGui := Gui("ToolWindow -Sysmenu Disabled", ), SplashTextGui.Add("Text",, "`nRelease button to close " x "`n`nKeep pressing it to NOT close window..."), SplashTextGui.Show("w200 h150")
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
toggleAlwaysOnTop() { ; TODO: fix
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

