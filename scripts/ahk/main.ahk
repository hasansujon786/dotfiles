#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
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
!]:: SendInput,^{tab}
![:: SendInput,^+{tab}
#InputLevel 1
!\::Send \
\::alternateTab()
#Enter::SetCapsLockState, % (t:=!t) ?  "On" beep() :  "Off" beep()
$Escape::superEscape()
#SPACE::toggleAlwaysOnTop()       ; Always on Top
#z::rebootMiWiFi()
#p::AppsKey
PrintScreen::#+s
#`::takeScreenshot()
; #`::#PrintScreen
;Transparency toggle,
#o::toggleTransparency()
#^.::increaseTransparency()
#^,::decreaseTransparency()
; Scroll horizontally
; ~RButton & WheelUP::scroll_left()
; ~RButton & WheelDown::scroll_right()
; Change Volume:
#If MouseIsOver("ahk_class Shell_TrayWnd")
WheelUP::volup()
WheelDown::voldown()
#If
; Explorer
f1::switchToExplorer()
!f1::switchToSavedApp()
!z::closeAllExplorers()
; Global arrow controls
#If not WinActive("ahk_exe WindowsTerminal.exe") and not WinActive("ahk_exe alacritty.exe") and not WinActive("ahk_exe Code.exe")
!h:: SendInput,{LEFT}
!j:: SendInput,{DOWN}
!k:: SendInput,{UP}
!l:: SendInput,{RIGHT}
!Backspace::Send ^{Backspace}
#If
#If WinActive("ahk_exe Code.exe")
!Backspace::Send ^{Backspace}
!SPACE::Send ^{SPACE}
#If
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
  +l::moveWinRight(200)
  +h::moveWinLeft(200)
  +k::moveWinUp(200)
  +j::moveWinDown(200)
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
