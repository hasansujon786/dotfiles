﻿#Requires AutoHotkey v2.0
#Warn ; Enable warnings to assist with detecting common errors.
; SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir(A_ScriptDir) ; Ensures a consistent starting directory.
#SingleInstance Force ; C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\

#Include %A_ScriptDir%\core\GuiEnhancerKit.ahk
#Include %A_ScriptDir%\core\utils.ahk
#Include %A_ScriptDir%\core\win_layout.ahk
#Include %A_ScriptDir%\core\win_control.ahk
; #Include %A_ScriptDir%\core\vert_desktop.ahk
#Include %A_ScriptDir%\core\vim_explorer.ahk
#Include %A_ScriptDir%\core\automation_mode.ahk
#Include %A_ScriptDir%\leader.ahk
#Include %A_ScriptDir%\grid.ahk

;Reload/Execute this script.ahk file
::rscript::
!f5:: {
  spGui := Gui("+ToolWindow +AlwaysOnTop -Sysmenu Disabled", "")
  spGui.SetFont("s10", "Segoe UI")
  spGui.Add("Text", "Center", "    AHK Reloaded...    `n`n")
  spGui.Show("NoActivate AutoSize")
  Sleep(300)
  spGui.Destroy
  Run("C:\Users\" A_UserName "\dotfiles\scripts\ahk\main.ahk")
}
^f5::Suspend(-1)

;******************************************************************************
; Keymaps
;******************************************************************************
+PgUp::Home
+PgDn::End
!SPACE::Send("^{SPACE}")

; Show menu (use #; for emoji)
#.::SendInput("{AppsKey}")
; Screenshot
#`::takeScreenshot()
^#`::openNewestFile("C:\Users\" A_UserName "\Pictures\Screenshots\*.*")
PrintScreen::Send("#+{s}")
; Window Transparency
^#/::toggleTransparency()
^#.::increaseTransparency()
^#,::decreaseTransparency()
; Volume Control
#Del::Volume_Mute
#Esc::Volume_Mute
#PgUp::volup()
#PgDn::voldown()
#^+v::showMicPanel()
#s::showSoundOutput()
#HotIf winIsMouseOver("ahk_class Shell_TrayWnd")
  ~LAlt & WheelUP::volup()
  ~LAlt & WheelDown::voldown()
#HotIf
~LAlt & MButton::showVolMixer()

; Global arrow with homerow
#HotIf not WinActive("ahk_exe WindowsTerminal.exe")
  and not WinActive("ahk_exe alacritty.exe")
  and not WinActive("ahk_exe wezterm-gui.exe")
  and not WinActive("ahk_exe Code.exe")
  !j::SendInput("{DOWN}")
  !k::SendInput("{UP}")
  !h::SendInput("{LEFT}")
  !l::SendInput("{RIGHT}")

  ; emacs-standard
  !f::Send("^{Right}")
  !b::Send("^{Left}")
  +!f::Send("^+{Right}")
  +!b::Send("^+{Left}")
#HotIf
!Backspace::SendInput("^{Backspace}")

; Other
^#b::showCalendar()
#q::toggleBluetooth()
#k::toggleKanata()
#Capslock::toggleCapsLosck()

;******************************************************************************
; Window manazement
;******************************************************************************
#InputLevel 1
; !\::Send("\")
; \::alternateTab()
!`::switchBetweenSameApps()

^#m::Send("#{m}")
#m::toggleWinMinimize()
!x::toggleWinMaximize()
#HotIf not WinActive("ahk_exe wezterm-gui.exe")
  ; Nav through tabs
  ![::SendInput("^+{tab}")
  !]::SendInput("^{tab}")
  ; Move tabs
  +![::SendInput("^+{PgUp}")
  +!]::SendInput("^+{PgDn}")
#HotIf
!Enter::Send("{f11}")
!Escape::winRestoreAndCenter()
#HotIf IsSet(mouseGridActive) && mouseGridActive == 0
  $Escape::superEscape()
#HotIf
#SPACE::toggleAlwaysOnTop()
; Vertual Desktop
#h::navToDesktop("left")
#l::navToDesktop("right")
#[::navToDesktop("left")
#]::navToDesktop("right")

;******************************************************************************
; Leader
;******************************************************************************
#a::ActiveLeaderMode()
#HotIf leaderPressed
  b::leader("b", () => toggleBluetooth())
  p::leader("p", () => toggleAlwaysOnTop())
  a::leader("a", () => send("#{a}"))
  s::leader("s", () => showVolMixer())
  MButton::leader("🖱️", () => enterAutoClikMode())
  LWin::return
#HotIf

;******************************************************************************
; Layout
;******************************************************************************
layout_loading := 0
current_layout := 0
#p::changeLayoutTo("code")
#o::changeLayoutTo("focus_custom")
#'::toggleLayout()

#HotIf layout_loading
  LWin::{
    return
  }
#HotIf

; #[::winPinToSide("left", true)
; #]::winPinToSide("right", true)

;******************************************************************************
; AltTabMenu & TaskView Vim Mode
;******************************************************************************
#/::SendInput("^!{Tab}")
#HotIf (WinActive("Volume Control")
  or WinActive("Quick settings")
  or WinActive("Task View") ; win+tab
  or WinActive("Task Switching") ; ctrl+alt+tab
  or WinActive("Notification Center")
  or WinActive("ahk_class PotPlayer64")
  or WinActive("ahk_class PotPlayer64")
  or WinActive("ahk_exe zen.exe") and WinActive("Picture-in-Picture"))
  and IsSet(mouseGridActive) && mouseGridActive == 0
  ; or (winIsMouseOver("ahk_class ApplicationFrameWindow") or winIsMouseOver("ahk_class Shell_LightDismissOverlay")) and winIsMouseOver("ahk_exe explorer.exe") and winIsMouseOver("") ; clipboard & backdrop
  ; or WinActive("ahk_class MultitaskingViewFrame")  ; ctrl+alt+tab
  ; or WinActive("ahk_class Windows.UI.Core.CoreWindow") ; win+tab/StartScreen
  ; or WinActive("ahk_exe ShellExperienceHost.exe")
  ; ahk_exe ApplicationFrameHost.exe

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

