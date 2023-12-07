;******************************************************************************
; Explorer Vim Mode
;******************************************************************************
explorerInsertMode := false
explorerToggleInsert() {
  if (explorerInsertMode) {
    ToolTip()
    Global explorerInsertMode := false
  } else {
    WinGetPos(&X, &Y, &Width, &Height)
    ToolTip("INSERT", 10, Height - 35)
    Global explorerInsertMode := true
  }
}
focusContent() {
  ControlFocus("DirectUIHWND2", "A")
  ; Show focus item
  Send("{Down}")
  Send("{Up}")
  Send("{Right}")
  Send("{Left}")
}
#HotIf WinActive("ahk_class CabinetWClass") && explorerInsertMode
  Esc::{
    if(ControlGetClassNN(ControlGetFocus("A")) == "Windows.UI.Core.CoreWindow1") {
      explorerToggleInsert()
      focusContent()
    } else {
      explorerToggleInsert()
      Send("{Esc}")
    }
  }
  ~Enter::{
    if(ControlGetClassNN(ControlGetFocus("A")) == "Windows.UI.Core.CoreWindow1") {
      explorerToggleInsert()
      sleep(700)
      focusContent()
    } else {
      explorerToggleInsert()
    }
  }
#HotIf
#HotIf WinActive("ahk_class CabinetWClass") && !explorerInsertMode
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

  ; Scroll
  ^u::
  !u::Send("{PgUp}")
  ^d::
  !d::Send("{PgDn}")

  q::Send("!{F4}")
  x::Send("{Delete}")
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
    Global explorerInsertMode := true
    ihfindChar := InputHook("T1 L1"), ihfindChar.Start(), ihfindChar.Wait(), findChar := ihfindChar.Input
    Send(findChar)
    Global explorerInsertMode := false
  }

  r::
  c::{
    Send("{F2}")
    explorerToggleInsert()
  }

  o::
  ^+n::
  +o::{
    Send("^+n")
    explorerToggleInsert()
  }

  space::{
    focusedControl := ControlGetClassNN(ControlGetFocus())
    if (focusedControl == "DirectUIHWND2") {
      ControlFocus("SysTreeView321", "A")
    } else {
      ControlFocus("DirectUIHWND2", "A")
    }
  }

  ~Enter::{ ; move cursor to content
    focusedControl := ControlGetClassNN(ControlGetFocus())
    if (focusedControl == "SysTreeView321") {
      Sleep(100)
      focusContent()
    }
  }
#HotIf


