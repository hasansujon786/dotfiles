sideBarCnn :=  "SysTreeView321"
explorerCnn := ["DirectUIHWND2", "DirectUIHWND3", "Microsoft.UI.Content.DesktopChildSiteBridge1"]

;******************************************************************************
; Explorer Vim Mode
;******************************************************************************
isExplInsertMode := false
explorerToggleInsert() {
  if (isExplInsertMode) {
    ToolTip()
    Global isExplInsertMode := false
  } else {
    WinGetPos(&X, &Y, &Width, &Height)
    ToolTip("INSERT", 10, Height - 35)
    Global isExplInsertMode := true
  }
}
; Show focus item
focusFirstItem(using := "") {
  if (using == "tab" or WinActive("This PC - File Explorer")) {
    Send("{Tab}")
    Send("+{Tab}")
  } else {
    Send("{Down}{Up}{Right}{Left}")
  }
}
focusExplorer(index := 1, action := "") {
  global explorerCnn
  if (index > explorerCnn.Length)  ; Stop recursion if all options fail
    return

  try {
    local cnn := explorerCnn[index]
    ControlFocus(cnn, "A") ; Attempt to focus
    if (action == "focus") {
      local isHomeOrGalleryTab := cnn == explorerCnn[3]
      Sleep(isHomeOrGalleryTab ? 500 : 100)
      focusFirstItem(isHomeOrGalleryTab ? "tab" : "")
    }
    return true
  } catch {
    focusExplorer(index + 1, action)  ; Recursively call next option on error
  }
}
; http://msdn.microsoft.com/en-us/library/bb774094
GetActiveExplorer() {
  static objShell := ComObject("Shell.Application")
  WinHWND := WinActive("A") ; Active window
  for Item in objShell.Windows
    if (Item.HWND = WinHWND)
      return Item ; Return active window object
  return -1 ; No explorer windows match active window
}
; 2::NavRun(A_MyDocuments)
NavRun(Path) {
  if (-1 != objIE := GetActiveExplorer())
    objIE.Navigate(Path)
  else
    Run(Path)
}
#HotIf (WinActive("ahk_class CabinetWClass") or WinActive("Save As")) && isExplInsertMode
  Esc::{
    if(ControlGetClassNN(ControlGetFocus("A")) == "Windows.UI.Core.CoreWindow1") {
      explorerToggleInsert()
      focusExplorer()
    } else {
      explorerToggleInsert()
      Send("{Esc}")
    }
  }
  ~Enter::{
    explorerToggleInsert()
    ; if(ControlGetClassNN(ControlGetFocus("A")) == "Windows.UI.Core.CoreWindow1") {
    ;   explorerToggleInsert()
    ;   sleep(700)
    ;   focusExplorer()
    ; } else {
    ;   explorerToggleInsert()
    ; }
  }
#HotIf
#HotIf (WinActive("ahk_class CabinetWClass") or WinActive("Save As")) && !isExplInsertMode
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
  -::Send("!{Up}")

  ; Scroll
  ^u::
  !u::Send("{PgUp}")
  ^d::
  !o::
  !d::Send("{PgDn}")

  ; File management
  y::Send("^c")
  p::Send("^v")
  x::Send("^x")
  d::Send("{Delete}")
  +d::Send("{Delete}")
  r::{
    Send("{F2}")
    explorerToggleInsert()
  }
  ^+n::
  +o::{
    Send("^+n")
    explorerToggleInsert()
  }


  m::Send("{AppsKey}")
  q::Send("!{F4}")
  u::Send("^z")
  ^r::Send("^y")
  ^k::{
    Send("{F2}")
    Send("{RIGHT}")
    SendInput("-" A_MM "-" A_DD)
  }

  /::{
    explorerToggleInsert()
    Send("^f")
  }
  f::{
    Global isExplInsertMode := true
    ihfindChar := InputHook("T1 L1"), ihfindChar.Start(), ihfindChar.Wait(), findChar := ihfindChar.Input
    Send(findChar)
    Global isExplInsertMode := false
  }

  '::{
    local focusedControl := ControlGetClassNN(ControlGetFocus())
    if (focusedControl == sideBarCnn) {
      focusExplorer()
    } else {
      ControlFocus(sideBarCnn, "A")
    }
  }

  o::Send("{Enter}")
  ~Enter::{ ; move cursor to content
    focusedControl := ControlGetClassNN(ControlGetFocus())
    if (focusedControl == sideBarCnn) {
      Sleep(100)
      focusExplorer(1, "focus")
    } else {
      Sleep(100)
      focusFirstItem("tab")
    }
  }
#HotIf

