#Requires AutoHotkey v2.0
#Warn ; Enable warnings to assist with detecting common errors.
; SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir(A_ScriptDir) ; Ensures a consistent starting directory.
#SingleInstance Force ; C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\

#Include %A_ScriptDir%\utils.ahk

;Reload/Execute this script.ahk file
::rscript::
!f5:: {
  SplashTextGui := Gui("ToolWindow -Sysmenu Disabled", ),
  Text := SplashTextGui.Add("Text", "Center w200 h40", "Reloaded...")
  Text.SetFont("s12", "Segoe UI")
  SplashTextGui.Show()
  Sleep(300)
  SplashTextGui.Destroy
  Run("C:\Users\" A_UserName "\dotfiles\scripts\ahk\main.ahk")
}
^f5::Suspend(-1)

#`::takeScreenshot()
^#b::showCalendar()
PrintScreen::Send("#+{s}")
#+q::toggleBluetooth()
#q::select_playback_device()
!#q::open_mic_panel()
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
!Backspace::Send("^{Backspace}")
!SPACE::Send("^{SPACE}")
; Global arrow controls
#HotIf not WinActive("ahk_exe WindowsTerminal.exe")
  and not WinActive("ahk_exe alacritty.exe")
  and not WinActive("ahk_exe wezterm-gui.exe")
  and not WinActive("ahk_exe Code.exe")
  !j::SendInput("{DOWN}")
  !k::SendInput("{UP}")
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
*Capslock::alternateTab()
!`::switchBetweenSameApps()
#\::toggleCapsLosck()
#Capslock::toggleCapsLosck()

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
; #SPACE::toggleAlwaysOnTop() ; TODO: fix
; Vertual Desktop
#h::navToDesktop("left")
#l::navToDesktop("right")
#[::navToDesktop("left")
#]::navToDesktop("right")

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
#HotIf WinActive("ahk_class MultitaskingViewFrame")     ; ctrl+alt+tab
  or MouseIsOver("ahk_class Shell_LightDismissOverlay") ; clipboard backdrop
  or WinActive("Volume Control")
  ; or WinActive("ahk_class Windows.UI.Core.CoreWindow")  ; win+tab/StartScreen
  ; or MouseIsOver("ahk_class ApplicationFrameWindow")
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

#Include %A_ScriptDir%\vim_explorer.ahk
#Include %A_ScriptDir%\automation_mode.ahk
