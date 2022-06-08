#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;Reload/Execute this script.ahk file
::rscript::
!f5::
Run, "C:\Users\hasan\dotfiles\scripts\ahk\main.ahk"
Return

#z::
Run, brave.exe https://google.com/ https://www.wikipedia.org/ https://twitter.com/?lang=en/
Return

#j:: SendInput,{DOWN}
#l:: SendInput,{RIGHT}
#h:: SendInput,{LEFT}
#k:: SendInput,{UP}

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

f1::switchToExplorer()
!f1::switchToSavedApp()
!Esc::closeAllExplorers()
!z::rebootMiWiFi()

; Change Volume:
!WheelUP::volup()
!WheelDown::voldown()
$Volume_Up::volup()
$Volume_Down::voldown()

; RButton & WheelDown::Send ^{Tab}
; RButton & WheelUp::Send ^+{Tab}
; RButton::RButton

capslock::Esc
+capslock::capslock

$Escape::superEscape()
#SPACE::toggleAlwaysOnTop()       ; Always on Top

; sc046::Scroll Lock
#o::toggleTransparency()       ;Transparency toggle,
#^.::increaseTransparency()
#^,::decreaseTransparency()

; CapsLock::LCtrl
; Capslock Up::capsAsCtrl()
; Enter::RCtrl
; Enter Up::enterAsCtrl()


;1::NavRun("C:\")
;2::NavRun(A_MyDocuments)

^+r::Send ^r{tab}{tab}{space}{enter}
;;the top rightmost keys on my K95.
;Media_Stop::^numpad7
;Media_Prev::^numpad8
;Media_Play_Pause::^numpad9
;Media_Next::^numpadMult
;Volume_Mute::^numpadDiv

;******************************************************************************
; Window Switcher functions
;******************************************************************************
switchToChrome() {
  IfWinNotExist, ahk_exe chrome.exe
    Run, chrome.exe

    if WinActive("ahk_exe chrome.exe")
      Sendinput ^{tab}
    else
      WinActivate ahk_exe chrome.exe
}

switchToBrave() {
  IfWinNotExist, ahk_exe brave.exe
    Run, brave.exe

    if WinActive("ahk_exe brave.exe")
      Sendinput ^{tab}
    else
      WinActivate ahk_exe brave.exe
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
p(msg) {
  msgbox,,, %msg%, 3
}

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

capsAsCtrl() {
  SendInput, {LControl Up}  ;--For stability
  If A_TimeSincePriorHotkey < 150
  {
    SendInput, {Escape}
  }
  Else
  return
}

enterAsCtrl() {
  SendInput, {RControl Up}  ;--For stability
  If A_TimeSincePriorHotkey < 150
  {
    SendInput, {Enter}
  }
  Else
  return
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
  Winset, Alwaysontop, , A ; win + space
}

getMousePos() {
  MouseGetPos, xpos, ypos
    xy := "x" xpos " y" ypos
    ToolTip %xy%
    Clipboard := xy
    SetTimer toolTipClear, -1000
}

tooltipClear() {
  ToolTip
}

beep() {
  SoundBeep, 300, 150
}

;Suspend hotkeys
!s::
suspend, toggle
return

;******************************************************************************
; Automations
;******************************************************************************
rebootMiWiFi() {
  Run, brave.exe http://miwifi.com/
  sleep 2000
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
