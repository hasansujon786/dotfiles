﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
; SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;Reload/Execute this script.ahk file
::rscript::
!f5::
Run, "C:\Users\hasan\dotfiles\scripts\ahk\main.ahk"
Return
;Suspend hotkeys
^f5::
suspend, toggle
return

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
PgUp::Send !{ESC}
PgDn::Send +!{ESC}
#InputLevel 1
!\::Send \
\::alternateTab()

capslock::Esc
+capslock::capslock
$Escape::superEscape()
#SPACE::toggleAlwaysOnTop()       ; Always on Top
#z::rebootMiWiFi()
#p::AppsKey
;Transparency toggle,
#o::toggleTransparency()
#^.::increaseTransparency()
#^,::decreaseTransparency()
; Change Volume:
#WheelUP::volup()
#WheelDown::voldown()
$Volume_Up::volup()
$Volume_Down::voldown()
; Explorer
f1::switchToExplorer()
!f1::switchToSavedApp()
!z::closeAllExplorers()

#IfWinNotActive, ahk_class CASCADIA_HOSTING_WINDOW_CLASS
!h:: SendInput,{LEFT}
!j:: SendInput,{DOWN}
!k:: SendInput,{UP}
!l:: SendInput,{RIGHT}
!Backspace::Send ^{Backspace}
#IfWinNotActive

; Adobe XD
#IfWinActive, ahk_class ApplicationFrameWindow
`::Send ^1
#IfWinActive

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

;******************************************************************************
; Window Move Mode
;******************************************************************************
#if !winMoveMode
  #Esc::
    winMoveMode := 1
    beep()
    TaskBar_SetAttr(1, 0xff79C398)
    Return
#if
#if winMoveMode
  Esc::
    winMoveMode := 0
    beep()
    TaskBar_SetAttr(1, 0xff1D1D1D)
    Return

  l::moveWinRight(25)
  h::moveWinLeft(25)
  k::moveWinUp(25)
  j::moveWinDown(25)
  RIGHT::moveWinRight(200)
  LEFT::moveWinLeft(200)
  UP::moveWinUp(200)
  DOWN::moveWinDown(200)
#if

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

;******************************************************************************
; Explorer functions
;******************************************************************************
; Press middle mouse button to move up a folder in Explorer
#IfWinActive, ahk_class CabinetWClass
`::Send !{Up}
#IfWinActive

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
    WinHWND := WinActive("A")    ; Active window
    for Item in objShell.Windows
        if (Item.HWND = WinHWND)
            return Item        ; Return active window object
    return -1    ; No explorer windows match active window
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
volup() {
  SoundGet, volume
  Send {Volume_Up}
  ;SoundBeep, 300, 150
  SoundSet, volume + 10
}
voldown() {
  SoundGet, volume
  Send {Volume_Down}
  ;SoundBeep, 300, 150
  SoundSet, volume - 10
}
; Long press (> 0.5 sec) on Esc closes window - but if you change your mind you can keep it pressed for 3 more seconds
superEscape() {
  KeyWait, Escape, T0.5                         ; Wait no more than 0.5 sec for key release (also suppress auto-repeat)
  If ErrorLevel                                 ; timeout, so key is still down...
  {
    SoundPlay *64                               ; Play an asterisk (Doesn't work for me though!)
    WinGet, X, ProcessName, A
    SplashTextOn,,150,,`nRelease button to close %x%`n`nKeep pressing it to NOT close window...
    KeyWait, Escape, T3                         ; Wait no more than 3 more sec for key to be released
    SplashTextOff
    If !ErrorLevel                              ; No timeout, so key was released
    {
      PostMessage, 0x112, 0xF060,,, A           ; ...so close window
      Return
    }
    ; Otherwise,
    SoundPlay *64
    KeyWait, Escape                             ; Wait for button to be released
    Return                                      ; Then do nothing...
  }
  Send {Esc}
}
toggleTransparency() {
  WinGetActiveTitle, Title
  WinGet, TN, Transparent, %Title%
  ; MsgBox, TN of %Title% is %TN%

  if (TN == "") {
    WinSet, Transparent, 230, A
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
print(msg) {
  msgbox,,, %msg%, 1
}
tooltipClear() {
  ToolTip
}
beep() {
  SoundBeep, 300, 150
}
TaskBar_SetAttr(accent_state := 0, gradient_color := "0x01000000")
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

;******************************************************************************
; Automations
;******************************************************************************
rebootMiWiFi() {
  Run, http://router.miwifi.com/
  sleep 3000
  MouseMove, 559, 600
  Click
  SendInput,hasan007007{ENTER}
  sleep 4000
  MouseMove, 1160, 150
  Click
  SendInput,{tab}{tab}{tab}{tab}{enter}
  sleep 4000
  MouseMove, 700, 522
  Click
  sleep 1000
  MouseMove, 596, 420
  Click
}
