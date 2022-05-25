#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;Reload/Execute this script.ahk file
::rscript::
!f5::
Run, "C:\Users\hasan\dotfiles\scripts\main.ahk"
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
!f1::closeAllExplorers()
f2::switchToSavedApp()

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

closeAllExplorers() {
  ;SoundBeep, 1000, 500
  WinClose,ahk_group taranexplorers
}

;BEGIN INSTANT APPLICATION SWITCHER SCRIPTS;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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
  ; if savedCLASS = ahk_class Notepad++ ; {
  ;   ;msgbox,,, is notepad++,0.5
  ;     if WinActive("ahk_class Notepad++")
  ;     {
  ;       sleep 5
  ;         Send ^{tab}
  ;     }
  ; }
  windowSwitcher(savedCLASS, savedEXE)
}



;******************************************************************************
;   Computer information
;******************************************************************************
::]myid::
SendInput %A_UserName%
Return

::]myip::
SendInput %A_IPAddress1%
Return

::]mycomp::
SendInput %A_ComputerName%
Return



printwins() {
  msgbox,,, savedCLASS is %savedCLASS%,0.5
  msgbox,,, savedexe is %savedEXE%,0.5
}
p(msg) {
  msgbox,,, savedCLASS is %msg%,0.8
}
^+r::Send ^r{tab}{tab}{space}{enter}
;;the top rightmost keys on my K95.
;Media_Stop::^numpad7
;Media_Prev::^numpad8
;Media_Play_Pause::^numpad9
;Media_Next::^numpadMult
;Volume_Mute::^numpadDiv
sortExplorerByDate(){
  IfWinActive, ahk_class CabinetWClass
  {
    ;Send,{LCtrl down}{NumpadAdd}{LCtrl up} ;expand name field
      send {alt}vo{down}{enter} ;sort by date modified, but it functions as a toggle...
      ;tippy2("sort Explorer by date")

  }
}

