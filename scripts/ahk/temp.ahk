
::]dd::{
  SendInput(A_MM "-" A_DD "-" A_YYYY)
}

;******************************************************************************
; Window Switcher functions
;******************************************************************************
; Explorer
f1::switchToExplorer()
!f1::switchToSavedApp()
!z::closeAllExplorers()
alternateTab() {
  Send("{alt down}")
  Sleep(5)
  Send("{tab}")
  Sleep(5)
  Send("{alt up}")
}
savedCLASS := "ahk_exe brave.exe"
savedEXE := "brave.exe"
#HotIf
windowSaver() {
  ;lolexe := WinGetProcessName("A")
  ;;global savedCLASS = "ahk_class "lolclass
  ;global savedCLASS = "ahk_exe "lolexe
  ;lolclass := WinGetClass("A") ; "A" refers to the currently active window
  ;global savedEXE = lolexe ;is this the way to do it? IDK.
  ;;msgbox, %savedCLASS%
  ;;msgbox, %savedEXE%
}
#HotIf
windowSwitcher(theClass, theEXE) {
  ;msgbox,,, switching to `nsavedCLASS = %theClass% `nsavedEXE = %theEXE%, 0.5
  if !WinExist(theClass)
    Run(theEXE)
  if not WinActive(theClass)
    WinActivate(theClass)
}
switchToSavedApp() {
  windowSwitcher(savedCLASS, savedEXE)
}


#y::quake_nvim(true) ; edit from current input field
#+y::quake_nvim(false) ; edit from last clipboard text
#^y::quake_nvim(false) ; edit from last clipboard text
;******************************************************************************
; Automations
;******************************************************************************
quake_nvim(copy := false) {
  Static ps := "C:\\Users\\hasan\\dotfiles\\scripts\\ahk\\quaka.ps1"
  Static file := "C:\\Users\\hasan\\dotfiles\\scripts\\ahk\\clip.txt"
  if WinActive("quake_nvim") {
    SendInput("{Esc}:w{Enter}")
    Sleep(500)
    file_content := Fileread(file)
    A_Clipboard := file_content
    file_content := ""
    WinClose() ; alternateTab()
    return
  }

  if !WinActive("quake_nvim") {
    FileDelete(file)
  }

  ; copy contents from current focused input
  if (copy == true) {
    Send("{Ctrl down}ac{Ctrl up}")
  }

  SplashTextGui := Gui("ToolWindow -Sysmenu Disabled", ), SplashTextGui.Add("Text",, "Opening nvim"), SplashTextGui.Show("w200 h60")
  FileAppend(A_Clipboard, file)
  Sleep(100)
  SplashTextGui.Destroy
  RunWait("powershell -command " ps, , "Hide")
}
;******************************************************************************
; Youtube
;******************************************************************************
+^#RButton::
{ ; V1toV2: Added bracket
  Run("C:\Users\" A_UserName "\dotfiles\scripts\ahk\automation_mode.ahk")
Return
} ; V1toV2: Added bracket in the end


;******************************************************************************
; Utils
;******************************************************************************
scroll_left() {
  MouseGetPos(, , &id, &fcontrol, 1)
  Loop 8 ; <-- Increase for faster scrolling
    ErrorLevel := SendMessage(0x114, 0, 0, fcontrol, "ahk_id " id) ; 0x114 is WM_HSCROLL and the 0 after it is SB_LINERIGHT.
}
scroll_right() {
  MouseGetPos(, , &id, &fcontrol, 1)
  Loop 8 ; <-- Increase for faster scrolling
    ErrorLevel := SendMessage(0x114, 1, 0, fcontrol, "ahk_id " id) ;  0x114 is WM_HSCROLL and the 1 after it is SB_LINELEFT.
}
