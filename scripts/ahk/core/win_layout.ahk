;******************************************************************************
; Custom layout
;******************************************************************************

Global TASKBAR_HEIGHT := 0 ;; 40

; "wt.exe", "ahk_exe WindowsTerminal.exe" ; "Code.exe", "ahk_exe Code.exe"
Global EDITOR_EXE := ["wezterm-gui.exe", "ahk_exe wezterm-gui.exe"]
Global BROWSER_EXE := ["zen.exe", "ahk_class MozillaWindowClass"] ; chrome.exe brave.exe

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
  ; winExitIfFullScreen()
  if (WinExist(EXE_FULL)) {
    runLayoutAction(EXE_FULL, EXE, side)
    return
  }

  if (EXE == "Code.exe") {
    ; Run("C:\Users\" A_UserName "\AppData\Local\Programs\Microsoft VS Code\Code.exe")
    Run("C:\Users\" A_UserName "\scoop\apps\vscode\current\Code.exe")
  } else {
    Run(EXE)
  }
  ErrorLevel := !WinWait(EXE_FULL)
  runLayoutAction(EXE_FULL, EXE, side)
}
runLayoutAction(EXE_FULL, EXE, side) {
  if (!WinExist(EXE_FULL)) {
    return
  }

  if (EXE_FULL == BROWSER_EXE[2]) {
    activateNonPrivateBrowserWindow(EXE_FULL)
  } else {
    WinActivate(EXE_FULL)
  }

  if(side == "center") {
    winRestoreAndCenter()
  } else if (side == "maximized") {
    WinMaximize("A")
  } else if (side == "maximized_custom") {
    ;           ↓ here 0 hides the video behind the window
    WinMove(-8, 1, A_ScreenWidth + 16, A_ScreenHeight + 8 - TASKBAR_HEIGHT, "A")
    ; WinMove(, , A_ScreenWidth + 8, A_ScreenHeight - 36, "A")
    ; centerCurrentWindow()
  } else {
    ; winPinToSide(side, false)
    tbHeight := TASKBAR_HEIGHT == 0 ? -8 : TASKBAR_HEIGHT
    winPinToSide_custom(side, tbHeight)
  }
}

activateNonPrivateBrowserWindow(EXE_FULL) {
  ; Get all windows with zen.exe
  windows := WinGetList(EXE_FULL)

  ; Loop through each window
  for hwnd in windows {
    title := WinGetTitle(hwnd)
    ; Check if the title does NOT contain "Private Browsing"
    if !InStr(title, "Private Browsing") {
      ; Activate the non-private window
      WinActivate(hwnd)
      return hwnd
    }
  }
  ; No non-private window found
  return false
}
