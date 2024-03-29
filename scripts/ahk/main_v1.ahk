﻿#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
; SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
#SingleInstance Force
; C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\

;Reload/Execute this script.ahk file
::rscript::
!f5::
  SplashTextOn,,60,, reloaded
  sleep 300
  SplashTextOff
  Run, C:\Users\%A_UserName%\dotfiles\scripts\ahk\main_v1.ahk
Return
;Suspend hotkeys
^f5::
  suspend, toggle
return

::]dd::
  SendInput %A_MM%-%A_DD%-%A_YYYY%
return

; Utils
^#`::Send #+{s}
+#`::Send #+{s}
#`::takeScreenshot()
PrintScreen::Send #+{s}
#\::toggleCapsLosck()
#Capslock::toggleCapsLosck()
#q::bt()
#+q::bt()bt()
#y::quake_nvim(true) ; edit from current input field
#+y::quake_nvim(false) ; edit from last clipboard text
#^y::quake_nvim(false) ; edit from last clipboard text
#;::SendInput {AppsKey}
;Transparency toggle,
#^/::toggleTransparency()
#^.::increaseTransparency()
#^,::decreaseTransparency()
; Scroll horizontally
; ~RButton & WheelUP::scroll_left()
; ~RButton & WheelDown::scroll_right()
; Change Volume:
!Del::Volume_Mute
!PgUp::volup()
!PgDn::voldown()
#If MouseIsOver("ahk_class Shell_TrayWnd")
  ~LAlt & WheelUP::volup()
  ~LAlt & WheelDown::voldown()
  ~LAlt & RButton::openVolumeController()
#If
; Explorer
f1::switchToExplorer()
!f1::switchToSavedApp()
!z::closeAllExplorers()
; Global arrow controls
!Backspace::Send ^{Backspace}
!SPACE::Send ^{SPACE}
!j:: SendInput,{DOWN}
!k:: SendInput,{UP}
#If not WinActive("ahk_exe WindowsTerminal.exe")
  and not WinActive("ahk_exe alacritty.exe")
  and not WinActive("ahk_exe wezterm-gui.exe")
  ; and not WinActive("ahk_exe Code.exe")
  !h:: SendInput,{LEFT}
  !l:: SendInput,{RIGHT}
#If
#If WinActive("ahk_exe Code.exe")
  !Backspace::Send ^{Backspace}
#If
; Adobe XD
#IfWinActive, ahk_class ApplicationFrameWindow
  `::Send ^1
#IfWinActive

;******************************************************************************
; Window manazement
;******************************************************************************
!1::Send #1
!2::Send #2
!3::Send #3
!4::Send #4
!5::Send #5
!6::Send #6
!7::Send #7
!8::Send #8
!9::Send #9
!0::Send #0
#InputLevel 1
!\::Send \
\::alternateTab()
Capslock::alternateTab()
!`::switchBetweenSameApps()

#m::WinMinimize,a
^#m::Send #{m}
!x::toggleWinRestore()
![::SendInput,^+{tab}
!]::SendInput,^{tab}
+![::SendInput,^+{PgUp}
+!]::SendInput,^+{PgDn}
!Enter::Send {f11}
!Escape::resetWin()
$Escape::superEscape()
#SPACE::toggleAlwaysOnTop() ; Always on Top
; Vertual Desktop
#h::navToDesktop("left")
#l::navToDesktop("right")
#[::navToDesktop("left")
#]::navToDesktop("right")

;******************************************************************************
; Layout
;******************************************************************************
#p::
  current_layout := 0
  layoutCode()
Return
#o::
  current_layout := 1
  layoutCodeFloat()
Return
#if !current_layout
  #'::
    current_layout := 1
    layoutCodeFloat()
  Return
  !'::
    current_layout := 1
    layoutCodeFloat()
  Return
#if
#if current_layout
  #'::
    current_layout := 0
    layoutCode()
  Return
  !'::
    current_layout := 0
    layoutCode()
  Return
#if
; #[::winPinToSide("left", true)
; #]::winPinToSide("right", true)

;******************************************************************************
; AltTabMenu & TaskView
;******************************************************************************
#/::SendInput,^!{Tab}
#If WinActive("ahk_class MultitaskingViewFrame") ; or WinActive("ahk_class Windows.UI.Core.CoreWindow")
  ; *WheelDown::Send {Blind}{Tab}
  ; *WheelUp::Send {Blind}+{Tab}
  q::Send {Esc}
  l::Send {Right}
  h::Send {Left}
  j::Send {Down}
  k::Send {Up}
  o::Send {Enter}
  x::Send {Delete}
  d::Send {PgDn}
  u::Send {PgUp}
  [::navToDesktop("left")
  ]::navToDesktop("right")
  n::Send ^#d
 +x::Send ^#{F4}
#If

;******************************************************************************
; Window Move Mode
;******************************************************************************
#if !winMode
  !w::
    winMode := 1
    beep()
    TaskBar_SetAttr(1, 0xff79C398)
  Return
#if
#if winMode
  r::resetWin()
  c::center_current_window()

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

  q::
    winMode := 0
    beep()
    TaskBar_SetAttr(1, 0xff101010)
  Return
  Esc::
    winMode := 0
    beep()
    TaskBar_SetAttr(1, 0xff101010)
  Return
  LWin::
    winMode := 0
    beep()
    TaskBar_SetAttr(1, 0xff101010)
  Return
#if

navToDesktop(side) {
  if (side == "left") {
    Send ^#{Left}
  }  else if  (side == "right"){
    Send ^#{Right}
  }
}
resetWin() {
  ; winmove, A,, , ,1216, 660 ; 768
  winmove, A,, , ,1406, 834 ; 1080
  center_current_window()
}
changeWinSize(direction, val) {
  WinGetPos,,, Width, Height, A
  if (direction == "width") {
    winmove, A,, , ,Width + val,
  }  else {
    winmove, A,, , , , Height + val
  }
  ; WinMove, %WinTitle%,, (A_ScreenWidth/2)-(Width/2), (A_ScreenHeight/2)-(Height/2)
}

moveWinRight(val) {
  wingetpos x, y,,, A
  moveWindowX_and_Y(x+val, y)
}
moveWinLeft(val) {
  wingetpos x, y,,, A
  moveWindowX_and_Y(x-val, y)
}
moveWinUp(val) {
  wingetpos x, y,,, A
  moveWindowX_and_Y(x, y-val)
}
moveWinDown(val) {
  wingetpos x, y,,, A
  moveWindowX_and_Y(x, y+val)
}
moveWindowX_and_Y(x, y){
  mousegetpos, mx, my
  winmove, A,,%x%, %y%
  ; mousemove, %mx%, %my%, 0
}
center_current_window() {
  WinGetTitle, active_window_title, A
  WinGetPos,,, w_width, w_height, %active_window_title%
    targetX := (A_ScreenWidth/2)-(w_width/2)
    targetY := (A_ScreenHeight/2)-(w_height/2)
  WinMove, %active_window_title%,, %targetX%, %targetY%
}
winPinToSide(side, checkFullscreen) {
  if (checkFullscreen) {
    autoToggleFullScreen()
    sleep 50
  }

  WinRestore, A
  if (side == "left") {
    Send #{Left}
  }  else if  (side == "right"){
    Send #{Right}
  }
}
winPinToSide_custom(side) {
  tb_height = 24
  y_start := 0
  x_start := 0
  s_height := A_ScreenHeight - tb_height
  s_half := (A_ScreenWidth / 2) + 16 ; Increase 16px width to fill right side margin

  if (side == "left") {
    x_start := -8 ; remove default left margin
  } else if  (side == "right") {
    x_start := s_half - 24 ; remove default left margin
  }

  WinRestore, A
  WinMove, A,, x_start, y_start, s_half, s_height
}
;******************************************************************************
; Window Switcher functions
;******************************************************************************
alternateTab() {
  Send {alt down}
  Sleep, 5
  Send {tab}
  Sleep, 5
  Send {alt up}
}
global savedCLASS = "ahk_exe brave.exe"
global savedEXE = "brave.exe"
#IfWinActive
windowSaver() {
  WinGet, lolexe, ProcessName, A
  ;global savedCLASS = "ahk_class "lolclass
  global savedCLASS = "ahk_exe "lolexe
  WinGetClass, lolclass, A ; "A" refers to the currently active window
  global savedEXE = lolexe ;is this the way to do it? IDK.
  ;msgbox, %savedCLASS%
  ;msgbox, %savedEXE%
}
#IfWinActive
windowSwitcher(theClass, theEXE) {
  ;msgbox,,, switching to `nsavedCLASS = %theClass% `nsavedEXE = %theEXE%, 0.5
  IfWinNotExist, %theClass%
    Run, % theEXE
  if not WinActive(theClass)
    WinActivate %theClass%
}
switchToSavedApp() {
  windowSwitcher(savedCLASS, savedEXE)
}
; Extracts the application title from the window's full title
ExtractAppTitle(FullTitle) {
  return SubStr(FullTitle, InStr(FullTitle, " ", false, -1) + 1)
}
switchBetweenSameApps() {
  WinGet, activeProcessName, ProcessName, A
  if (activeProcessName = "chrome.exe") {
    ; Switch a "Chrome App or Chrome Website Shortcut" open windows based on the same application title
    WinGetTitle, FullTitle, A
    AppTitle := ExtractAppTitle(FullTitle)
    SetTitleMatchMode, 2
    WinGet, windowsWithSameTitleList, List, %AppTitle%
    WinActivate, % "ahk_id " windowsWithSameTitleList%windowsWithSameTitleList%
  } else {
    ; Switch "App" open windows based on the same process and class
    WinGetClass, activeClass, A
    SetTitleMatchMode, 2
    WinGet, windowsListWithSameProcessAndClass, List, ahk_exe %activeProcessName% ahk_class %activeClass%
    WinActivate, % "ahk_id " windowsListWithSameProcessAndClass%windowsListWithSameProcessAndClass%
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
  Send {ESC}
  layout_winAction("ahk_exe wezterm-gui.exe", "wezterm-gui.exe", "left")
  ; layout_winAction("ahk_exe WindowsTerminal.exe", "wt.exe", "left")
  ; layout_winAction("ahk_exe Code.exe", "Code.exe", "left")
}
layout_winAction(EXE_FULL, EXE, side) {
  autoToggleFullScreen()

  if (not WinExist(EXE_FULL)) {
    if (EXE == "Code.exe") {
      Run, C:\Users\%A_UserName%\AppData\Local\Programs\Microsoft VS Code\Code.exe
    } else {
      Run, %EXE%
    }
    WinWait, %EXE_FULL%
    layout_selectWin(EXE_FULL, EXE, side)
    return
  }
  layout_selectWin(EXE_FULL, EXE, side)
}
layout_selectWin(EXE_FULL, EXE, side) {
  if (WinExist(EXE_FULL)) {
    WinActivate, %EXE_FULL%

    if(side == "center") {
      resetWin()
    } else if (side == "full") {
      WinMaximize, A
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
  global
  If explorerInsertMode
  {
    ToolTip
    explorerInsertMode := false
  } else {
    WinGetPos, X, Y, Width, Height
    ToolTip, INSERT, 10, Height - 35
    explorerInsertMode := true
  }
}

#If WinActive("ahk_class CabinetWClass") && explorerInsertMode
  Esc::
  ~Enter::
    explorerToggleInsert()
  return
#If

#If WinActive("ahk_class CabinetWClass") && !explorerInsertMode
  i:: explorerToggleInsert()
  j:: Send, {Down}
  k:: Send, {Up}
  h:: Send, {Left}
  l:: Send, {Right}
  ^u:: Send, {PgUp}
  ^d:: Send, {PgDn}
  +h:: Send, !{Up}
  +l:: Send, !{Left}
  g:: Send, {Home}
  +g:: Send, {End}
  q:: Send, !{F4}
  /:: Send, ^f
  x:: Send, {Delete}
  u:: Send, ^z
  ^r:: Send, ^y
  ^k::
    Send {F2}
    Send {RIGHT}
    SendInput -%A_MM%-%A_DD%
  return

  f::
    explorerInsertMode := true
    Input, findChar, T1 L1
    Send, %findChar%
    explorerInsertMode := false
  return

  r::
  c::
    Send, {F2}
    explorerToggleInsert()
  return

  o::
  +o::
    Send, ^+n
    explorerToggleInsert()
  return

  Space::
    ControlGetFocus, focusedControl
    If (focusedControl == "DirectUIHWND2")
    {
      ControlFocus, SysTreeView321, A
    } else {
      ControlFocus, DirectUIHWND2, A
    }
  return

  ~Enter::
    ControlGetFocus, focusedControl
    If (focusedControl == "SysTreeView321")
    {
      Sleep, 100
      ControlFocus, DirectUIHWND2, A
      Send, {Down}
      Send, {Up}
      Send, {Right}
      Send, {Left}
    }
  return
#If

closeAllExplorers() {
  ;SoundBeep, 1000, 500
  WinClose,ahk_group taranexplorers
}
switchToExplorer() {
  ;IfWinNotExist, ahk_class CabinetWClass
  IfWinNotActive, ahk_class CabinetWClass
    windowSaver()

  IfWinNotExist, ahk_class CabinetWClass
    Run, explorer.exe
  GroupAdd, taranexplorers, ahk_class CabinetWClass
  if WinActive("ahk_exe explorer.exe")
    GroupActivate, taranexplorers, r
  else
    WinActivate ahk_class CabinetWClass ;you have to use WinActivatebottom if you didn't create a window group.
}

sortExplorerByDate(){
  IfWinActive, ahk_class CabinetWClass
  {
    ;Send,{LCtrl down}{NumpadAdd}{LCtrl up} ;expand name field
    send {alt}vo{down}{enter} ;sort by date modified, but it functions as a toggle...
    ;tippy2("sort Explorer by date")
  }
}

; http://msdn.microsoft.com/en-us/library/bb774094
GetActiveExplorer() {
  static objShell := ComObjCreate("Shell.Application")
  WinHWND := WinActive("A") ; Active window
  for Item in objShell.Windows
    if (Item.HWND = WinHWND)
      return Item ; Return active window object
  return -1 ; No explorer windows match active window
}

NavRun(Path) {
  if (-1 != objIE := GetActiveExplorer())
    objIE.Navigate(Path)
  else
    Run, % Path
}

;******************************************************************************
; Utils
;******************************************************************************
toggleWinRestore() {
  ; WinGet WindowID, ID, A
  ; WinGet WindowSize, MinMax, ahk_id %WindowID%
  WinGet MX, MinMax, A
  if (MX) {
    WinRestore A
  } else {
    WinMaximize A
  }
}
toggleCapsLosck() {
  SplashTextOn,200,60,, Toggle Capslock
  beep()
  SetCapsLockState % !GetKeyState("CapsLock", "T")
  Sleep, 300
  SplashTextOff
}
bt(onOff := "On") {
  SysGet, mWidth, 78
  SysGet, mHeight, 79
  Progress, b w200,, Toggling Bluetooth, BluetoothStatus
  WinMove, BluetoothStatus,, mWidth - 220, mHeight - 70
  Progress, 70
  Static ps := "C:\\Users\\hasan\\dotfiles\\scripts\\ahk\\toggle_bluetooth.ps1"

  If !FileExist(ps) {
    Progress, Off
    MsgBox, 48, Error, File not found.`n%ps%
    Return
  } Else SoundBeep, 1500 - 500 * (onOff = "On")
    ; RunWait, powershell -command %ps% -BluetoothStatus %onOff%,, Hide
    RunWait, powershell -command %ps%,, Hide
  SoundBeep, 1000 + 500 * (onOff = "On")

  Progress, 100
  Sleep, 600
  Progress, Off
}
takeScreenshot() {
  SendInput,#{PrintScreen}
  beep()
  SplashTextOn,,60,, Your screenshort has saved
  sleep 300
  SplashTextOff
}
MouseIsOver(WinTitle) {
  MouseGetPos,,, Win
  return WinExist(WinTitle . " ahk_id " . Win)
}
volup() {
  SoundSet, +18
  SendInput {Volume_Up}
}
voldown() {
  SoundSet, -18
  SendInput {Volume_Down}
}
openVolumeController() {
  Run C:\Windows\System32\SndVol.exe
  WinWait, ahk_exe SndVol.exe
  If WinExist("ahk_exe SndVol.exe")
  WinActivate, ahk_exe SndVol.exe
  WinMove, ahk_exe SndVol.exe,, 880, 400
}
scroll_left() {
  MouseGetPos,,,id, fcontrol,1
  Loop 8 ; <-- Increase for faster scrolling
    SendMessage, 0x114, 0, 0, %fcontrol%, ahk_id %id% ; 0x114 is WM_HSCROLL and the 0 after it is SB_LINERIGHT.
}
scroll_right() {
  MouseGetPos,,,id, fcontrol,1
  Loop 8 ; <-- Increase for faster scrolling
    SendMessage, 0x114, 1, 0, %fcontrol%, ahk_id %id% ;  0x114 is WM_HSCROLL and the 1 after it is SB_LINELEFT.
}
; Long press (> 0.5 sec) on Esc closes window - but if you change your mind you can keep it pressed for 3 more seconds
superEscape() {
  KeyWait, Escape, T0.5 ; Wait no more than 0.5 sec for key release (also suppress auto-repeat)
  If ErrorLevel ; timeout, so key is still down...
  {
    SoundPlay *64 ; Play an asterisk (Doesn't work for me though!)
    WinGet, X, ProcessName, A
    SplashTextOn,,150,,`nRelease button to close %x%`n`nKeep pressing it to NOT close window...
    KeyWait, Escape, T3 ; Wait no more than 3 more sec for key to be released
    SplashTextOff
    If !ErrorLevel ; No timeout, so key was released
    {
      PostMessage, 0x112, 0xF060,,, A ; ...so close window
      Return
    }
    ; Otherwise,
    SoundPlay *64
    KeyWait, Escape ; Wait for button to be released
    Return ; Then do nothing...
  }
  Send {Esc}
}
toggleTransparency() {
  WinGetActiveTitle, Title
  WinGet, TN, Transparent, %Title%
  ; MsgBox, TN of %Title% is %TN%

  if (TN == "") {
    WinSet, Transparent, 245, A
    beep()
  }
  else {
    WinSet, Transparent, OFF, A
  }
}
decreaseTransparency() {
  WinGetActiveTitle, Title
  WinGet, TN, Transparent, %Title%
  if(TN == "") {
    beep()
    return
  }

  if TN < 255
    EnvAdd, TN, 5
  WinSet, Transparent, %TN%, %Title%
}
increaseTransparency() {
  WinGetActiveTitle, Title
  WinGet, TN, Transparent, %Title%
  if(TN == "") {
    beep()
    return
  }

  if TN > 0
    EnvSub, TN, 5
  WinSet, Transparent, %TN%, %Title%
}
toggleAlwaysOnTop() {
  Winset, Alwaysontop, , A
  WinGet, title, ProcessName, A
  WinGet, win_id, ID, A
  beep()

  WinGet, ExStyle, ExStyle, ahk_id %win_id%
  If (ExStyle & 0x8)
    ExStyle = AlwaysOnTop
  Else
    ExStyle = Not AlwaysOnTop

  SplashTextOn,,100,,`n%exstyle%`n------------`n%title%
  sleep 300
  SplashTextOff
}
getMousePos() {
  MouseGetPos, xpos, ypos
  xy := "x" xpos " y" ypos
  ToolTip %xy%
  Clipboard := xy
  SetTimer toolTipClear, -1000
}
P(msg) {
  msgbox,,, %msg%, 1
}
tooltipClear() {
  ToolTip
}
beep() {
  SoundBeep, 300, 150
}
TaskBar_SetAttr(accent_state := 0, gradient_color := "0xff101010")
{
  static init, hTrayWnd, ver := DllCall("GetVersion") & 0xff < 10
  static pad := A_PtrSize = 8 ? 4 : 0, WCA_ACCENT_POLICY := 19

  if !(init) {
    if (ver)
      throw Exception("Minimum support client: Windows 10", -1)
    if !(hTrayWnd := DllCall("user32\FindWindow", "str", "Shell_TrayWnd", "ptr", 0, "ptr"))
      throw Exception("Failed to get the handle", -1)
    init := 1
  }

  accent_size := VarSetCapacity(ACCENT_POLICY, 16, 0)
  NumPut((accent_state > 0 && accent_state < 4) ? accent_state : 0, ACCENT_POLICY, 0, "int")

  if (accent_state >= 1) && (accent_state <= 2) && (RegExMatch(gradient_color, "0x[[:xdigit:]]{8}"))
    NumPut(gradient_color, ACCENT_POLICY, 8, "int")

  VarSetCapacity(WINCOMPATTRDATA, 4 + pad + A_PtrSize + 4 + pad, 0)
    && NumPut(WCA_ACCENT_POLICY, WINCOMPATTRDATA, 0, "int")
    && NumPut(&ACCENT_POLICY, WINCOMPATTRDATA, 4 + pad, "ptr")
    && NumPut(accent_size, WINCOMPATTRDATA, 4 + pad + A_PtrSize, "uint")
  if !(DllCall("user32\SetWindowCompositionAttribute", "ptr", hTrayWnd, "ptr", &WINCOMPATTRDATA))
    throw Exception("Failed to set transparency / blur", -1)
  return true
}
isWindowFullScreen( winTitle ) {
  ;checks if the specified window is full screen
  winID := WinExist( winTitle )

  If ( !winID )
  Return false

  WinGet style, Style, ahk_id %WinID%
  WinGetPos ,,,winW,winH, %winTitle%
  ; 0x7fffff is WS_BORDER.
  ; 0x1fffffff is WS_MINIMIZE.
  ; no border and not minimized
  Return ((style & 0x207fffff) or winH < A_ScreenHeight or winW < A_ScreenWidth) ? false : true
}
autoToggleFullScreen() {
  isFullScreen := isWindowFullScreen( "A" )
  if (isFullScreen) {
    Send {f11}
  }
}

;******************************************************************************
; Automations
;******************************************************************************
quake_nvim(copy := false) {
  Static ps := "C:\\Users\\hasan\\dotfiles\\scripts\\ahk\\quaka.ps1"
  Static file := "C:\\Users\\hasan\\dotfiles\\scripts\\ahk\\clip.txt"
  if WinActive("quake_nvim") {
    SendInput,{Esc}:w{Enter}
    sleep 500
    FileRead, file_content, %file%
    Clipboard := file_content
    file_content := ""
    WinClose ; alternateTab()
    return
  }

  if !WinActive("quake_nvim") {
    FileDelete, %file%
  }

  ; copy contents from current focused input
  if (copy == true) {
    Send, {Ctrl down}ac{Ctrl up}
  }

  SplashTextOn,,60,, Opening nvim
  Fileappend, %clipboard%, %file%
  sleep 100
  SplashTextOff
  RunWait, powershell -command %ps%,, Hide
}
;******************************************************************************
; Youtube
;******************************************************************************
+^#RButton::
  Run, C:\Users\%A_UserName%\dotfiles\scripts\ahk\automation_mode.ahk
Return
