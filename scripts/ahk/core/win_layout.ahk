;******************************************************************************
; Custom layout
;******************************************************************************

Global TASKBAR_HEIGHT := 40

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
  winExitIfFullScreen()

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
      winRestoreAndCenter()
    } else if (side == "maximized") {
      WinMaximize("A")
    } else if (side == "maximized_custom") {
      ;           ↓ here 0 hides the video behind the window
      WinMove(-8, 1, A_ScreenWidth + 16, A_ScreenHeight - TASKBAR_HEIGHT, "A")
      ; WinMove(, , A_ScreenWidth + 8, A_ScreenHeight - 36, "A")
      ; centerCurrentWindow()
    } else {
      ; winPinToSide(side, false)
      winPinToSide_custom(side)
    }
  }
}

