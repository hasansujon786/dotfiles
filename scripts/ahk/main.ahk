#Requires AutoHotkey v2.0
#Warn ; Enable warnings to assist with detecting common errors.
; SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir(A_ScriptDir) ; Ensures a consistent starting directory.
#SingleInstance Force ; C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\

#Include %A_ScriptDir%\utils.ahk

;Reload/Execute this script.ahk file
::rscript::
f5:: {
  SplashTextGui := Gui("ToolWindow -Sysmenu Disabled", ), SplashTextGui.Add("Text",, "reloaded"), SplashTextGui.Show("w200 h60")
  Sleep(300)
  SplashTextGui.Destroy
  Run("C:\Users\" A_UserName "\dotfiles\scripts\ahk\main.ahk")
}
^f5::Suspend(-1)

#`::takeScreenshot()
PrintScreen::Send("#+{s}")
#q::toggleBluetooth()
#+q::toggleBluetooth() toggleBluetooth()
#;::SendInput("{AppsKey}")
;Transparency toggle,
#^/::toggleTransparency()
#^.::increaseTransparency()
#^,::decreaseTransparency()
; Change Volume:
!Del::Volume_Mute
!PgUp::volup()
!PgDn::voldown()
#HotIf MouseIsOver("ahk_class Shell_TrayWnd")
  ~LAlt & WheelUP::volup()
  ~LAlt & WheelDown::voldown()
  ~LAlt & RButton::openVolumeController()
#HotIf
; Global arrow controls
!Backspace::Send("^{Backspace}")
!SPACE::Send("^{SPACE}")
!j::SendInput("{DOWN}")
!k::SendInput("{UP}")
#HotIf not WinActive("ahk_exe WindowsTerminal.exe")
  and not WinActive("ahk_exe alacritty.exe")
  and not WinActive("ahk_exe wezterm-gui.exe")
  ; and not WinActive("ahk_exe Code.exe")
  !h::  SendInput("{LEFT}")
  !l::  SendInput("{RIGHT}")
#HotIf

;******************************************************************************
; Window manazement
;******************************************************************************
!1::Send("#1")
!2::Send("#2")
!3::Send("#3")
!4::Send("#4")
!5::Send("#5")
!6::Send("#6")
!7::Send("#7")
!8::Send("#8")
!9::Send("#9")
!0::Send("#0")
#InputLevel 1
!\::Send("\")
\::alternateTab()
#\::toggleCapsLosck()
#Capslock::toggleCapsLosck()
*Capslock::alternateTab()
!`::switchBetweenSameApps()

^#m::Send("#{m}")
#m::WinMinimize("a")
!x::toggleWinRestore()
![::SendInput("^+{tab}")
!]::SendInput("^{tab}")
+![::SendInput("^+{PgUp}")
+!]::SendInput("^+{PgDn}")
!Enter::Send("{f11}")
!Escape::resetWin()
$Escape::superEscape()
#SPACE::toggleAlwaysOnTop() ; TODO: fix
; Vertual Desktop
#h::navToDesktop("left")
#l::navToDesktop("right")
#[::navToDesktop("left")
#]::navToDesktop("right")

;******************************************************************************
; Layout
;******************************************************************************
current_layout := 0
#p::{
  Global current_layout := 0
  layoutCode()
}
#o::{
  Global current_layout := 1
  layoutCodeFloat()
}
#'::{
  if (current_layout == 0) {
    Global current_layout := 1
    layoutCodeFloat()
  }  else if (current_layout == 1){
    Global current_layout := 0
    layoutCode()
  }
}
; #[::winPinToSide("left", true)
; #]::winPinToSide("right", true)

;******************************************************************************
; AltTabMenu & TaskView Vim Mode
;******************************************************************************
#/::SendInput("^!{Tab}")
#HotIf WinActive("ahk_class MultitaskingViewFrame") ; or WinActive("ahk_class Windows.UI.Core.CoreWindow")
  ; *WheelDown::Send {Blind}{Tab}
  ; *WheelUp::Send {Blind}+{Tab}
  q::Send("{Esc}")
  l::Send("{Right}")
  h::Send("{Left}")
  j::Send("{Down}")
  k::Send("{Up}")
  o::Send("{Enter}")
  x::Send("{Delete}")
  d::Send("{PgDn}")
  u::Send("{PgUp}")
  ; manage workspace
  +n::Send("^#d")
  +x::Send("^#{F4}")
  [::navToDesktop("left")
  ]::navToDesktop("right")
#HotIf

;******************************************************************************
; Window Controll Vim Mode
;******************************************************************************
winMode := 0
#HotIf !winMode
  !w::{
    Global winMode := 1
    beep()
    TaskBar_SetAttr(1, 0xff79C398)
  }
#HotIf
#HotIf winMode
  r::resetWin()
  c::centerCurrentWindow()

  l::moveWinRight(25)
  h::moveWinLeft(25)
  k::moveWinUp(25)
  j::moveWinDown(25)
  +l::moveWinRight(200)
  +h::moveWinLeft(200)
  +k::moveWinUp(200)
  +j::moveWinDown(200)
  .::changeWinSize("width", 10)
  ,::changeWinSize("width", -10)
  =::changeWinSize("height", 10)
  -::changeWinSize("height", -10)
  +.::changeWinSize("width", 50)
  +,::changeWinSize("width", -50)
  +=::changeWinSize("height", 50)
  +-::changeWinSize("height", -50)

  [::navToDesktop("left")
  ]::navToDesktop("right")

  q::{
    Global winMode := 0
    beep()
    TaskBar_SetAttr(1, 0xff101010)
  }
  Esc::{
    Global winMode := 0
    beep()
    TaskBar_SetAttr(1, 0xff101010)
  }
  LWin::{
    Global winMode := 0
    beep()
    TaskBar_SetAttr(1, 0xff101010)
  }
#HotIf

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
#HotIf WinActive("ahk_class CabinetWClass") && explorerInsertMode
  Esc::
  ~Enter::explorerToggleInsert()
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
    explorerToggleInsert() ; TODO: fix cursor moves to side nav on esc
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

  ~Enter::{
    focusedControl := ControlGetClassNN(ControlGetFocus())
    if (focusedControl == "SysTreeView321") {
      Sleep(100)
      ControlFocus("DirectUIHWND2", "A")
      Send("{Down}") ; Show focus item
      Send("{Up}")
      Send("{Right}")
      Send("{Left}")
    }
  }
#HotIf

; f1::{
;   height := 80
;   width := 200
;   xPos := PosX("center", 0, width)
;   yPos := PosY("bottom", 0, height)

;   myGui := Gui(), myGui.BackColor := "White", myGui.Opt("+AlwaysOnTop -Caption +ToolWindow")
;   myGui.Add("Text",, "reloaded"),
;   myGui.Show("x" xPos " y" ypos "w" width " h" height " NA")
;   Sleep(5000)
;   myGui.Destroy
; }
