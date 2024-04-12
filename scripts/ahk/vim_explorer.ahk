sideBarCnn :=  "SysTreeView321"
explorerCnn := "DirectUIHWND3" ; DirectUIHWND2
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
focusFirstItem() {
  ; Show focus item
  Send("{Down}")
  Send("{Up}")
  Send("{Right}")
  Send("{Left}")
}
#HotIf WinActive("ahk_class CabinetWClass") && isExplInsertMode
  Esc::{
    if(ControlGetClassNN(ControlGetFocus("A")) == "Windows.UI.Core.CoreWindow1") {
      explorerToggleInsert()
      ControlFocus(explorerCnn, "A")
    } else {
      explorerToggleInsert()
      Send("{Esc}")
    }
  }
  ~Enter::{
    if(ControlGetClassNN(ControlGetFocus("A")) == "Windows.UI.Core.CoreWindow1") {
      explorerToggleInsert()
      sleep(700)
      ControlFocus(explorerCnn, "A")
    } else {
      explorerToggleInsert()
    }
  }
#HotIf
#HotIf WinActive("ahk_class CabinetWClass") && !isExplInsertMode
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
  d::Send("^x")
  y::Send("^c")
  p::Send("^v")
  x::Send("{Delete}")
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
    focusedControl := ControlGetClassNN(ControlGetFocus())
    if (focusedControl == explorerCnn) {
      ControlFocus(sideBarCnn, "A")
    } else {
      ControlFocus(explorerCnn, "A")
    }
  }

  o::Send("{Enter}")
  ~Enter::{ ; move cursor to content
    focusedControl := ControlGetClassNN(ControlGetFocus())
    if (focusedControl == sideBarCnn) {
      Sleep(100)
      ControlFocus(explorerCnn, "A")
      focusFirstItem()
    }
  }
#HotIf


