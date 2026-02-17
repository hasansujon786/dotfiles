#Requires AutoHotkey v2.0
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
^!#ESC:: suspendAHK()

;******************************************************************************
; Leader
;******************************************************************************
#a:: ActiveLeaderMode()
#HotIf leaderPressed
q:: leader("q", () => toggleBluetooth())
p:: leader("p", () => toggleAlwaysOnTop())
a:: leader("a", () => send("#{a}"))
s:: leader("s", () => showVolMixer())
m:: leader("m", () => showMicPanel())
#k:: leader("#k", () => toggleKanata())
MButton:: leader("MB", () => enterAutoClikMode())
LWin:: return
#HotIf

#InputLevel 1
!\:: Send("\")
\::ActiveLQuickeaderMode()
#HotIf qleaderPressed
\:: quickleader("\", () => alternateTab())
w:: quickleader("w", () => ToggleApp("wezterm-gui.exe"))
e:: quickleader("e", () => ToggleApp("wezterm-gui.exe"))
f:: quickleader("f", () => ToggleExplorer())
r:: quickleader("r", () => ToggleApp("zen.exe", "", "MozillaDialogClass"))
; \:: quickleader("\", () => ToggleApp("zen.exe", "", "MozillaDialogClass"))
b:: quickleader("b", () => ToggleApp("zen.exe", "", "MozillaDialogClass"))
j:: quickleader("j", () => ToggleApp("zen.exe", "", "MozillaDialogClass"))
g:: quickleader("g", () => ToggleApp("zen.exe", "", "MozillaDialogClass"))
d:: quickleader("d", () => ToggleApp("zen.exe", "", "MozillaDialogClass"))
c:: quickleader("c", () => ToggleApp("chrome.exe"))
i:: quickleader("i", () => ToggleApp("Insomnia-12.3.1.exe", "C:/Users/hasan/scoop/apps/insomnia/current/Insomnia.exe"))
t:: quickleader("t", () => ToggleApp("telegram.exe", "telegram"))
z:: quickleader("z", () => FocusZenPiP())
#HotIf

;******************************************************************************
; Keymaps
;******************************************************************************
!1:: Send("#1")
!2:: Send("#2")
!3:: Send("#3")
!4:: Send("#4")
!5:: Send("#5")
!6:: Send("#6")
!7:: Send("#7")
!8:: Send("#8")
!9:: Send("#9")
!PgUp::Home
!PgDn::End
!SPACE:: Send("^{SPACE}")

; Example hotkeys for different apps
; #e:: ToggleApp("explorer.exe")
#e:: ToggleExplorer()
#c:: ToggleApp("chrome.exe")
#t:: ToggleApp("telegram.exe", "telegram")
#i:: ToggleApp("Insomnia-12.3.1.exe", "C:/Users/hasan/scoop/apps/insomnia/current/Insomnia.exe")
#j:: ToggleApp("wezterm-gui.exe")
#b:: ToggleApp("zen.exe", "", "MozillaDialogClass")
!e:: ToggleApp("zen.exe")
!w:: ToggleApp("wezterm-gui.exe")
!r:: ToggleApp("Insomnia-12.3.1.exe", "C:/Users/hasan/scoop/apps/insomnia/current/Insomnia.exe")
!t:: ToggleApp("telegram.exe", "telegram")

; Screenshot
#`:: takeScreenshot()
^#`:: openNewestFile("C:\Users\" A_UserName "\Pictures\Screenshots\*.*")
!#`:: openNewestFile("C:\Users\" A_UserName "\Downloads\*.*")
PrintScreen:: Send("#+{s}")
~LWin & MButton:: Send("#+{s}")

; Audio Control
#s:: Send("^#v")
#Del:: Send("{Volume_Mute}")
#PgUp:: volup()
#PgDn:: voldown()
#HotIf winIsMouseOver("ahk_class Shell_TrayWnd")
~LAlt & WheelUP:: volup()
~LAlt & WheelDown:: voldown()
#HotIf

; Other
^#b:: showCalendar()
!;:: SendInput("{AppsKey}") ; Show menu
#Capslock:: toggleCapsLosck()
SetCapsLockState("AlwaysOff")

;******************************************************************************
; Window manazement
;******************************************************************************
; #InputLevel 1
; !\:: Send("\")
; \:: alternateTab()
!`:: switchBetweenSameApps()
*Capslock:: ctrlAndAltTab()
*Capslock up:: ctrlAndAltTabStop()

; Window Transparency
^#.:: toggleTransparency()
^#>:: increaseTransparency()
^#<:: decreaseTransparency()

; #m:: Minimize all windows
; +#m:: Restore only minimized windows
^#m:: toggleWinMinimize()
#Enter:: toggleWinMaximize()
#Esc:: winRestoreAndCenter()
#,:: Send("{f11}")
#HotIf not WinActive("ahk_exe wezterm-gui.exe")
; Nav through tabs
![:: SendInput("^+{tab}")
!]:: SendInput("^{tab}")
; Move tabs
+![:: SendInput("^+{PgUp}")
+!]:: SendInput("^+{PgDn}")
#HotIf
#HotIf isMouseGridInactive()
$Escape:: superEscape()
#HotIf
; ^#SPACE::toggleAlwaysOnTop()
; Vertual Desktop
#[:: navToDesktop("left")
#]:: navToDesktop("right")

;******************************************************************************
; Layout
;******************************************************************************
layout_loading := 0
current_layout := 0
#p:: changeLayoutTo("code")
#o:: changeLayoutTo("focus_custom")
#':: toggleLayout()

#HotIf layout_loading
LWin:: return
#HotIf

; #[::winPinToSide("left", true)
; #]::winPinToSide("right", true)

;******************************************************************************
; Vim Mode (AltTabMenu, TaskView)
;******************************************************************************
isMouseGridInactive() {
	return !IsSet(mouseGridActive) || mouseGridActive = 0
}

#/:: SendInput("^!{Tab}")
#HotIf (WinActive("Volume Control")
	or WinActive("Sound")
	or WinActive("Quick settings")
	or WinActive("Task View") ; win+tab
	or WinActive("Task Switching") ; ctrl+alt+tab
	or WinActive("Notification Center")
	or WinActive("ahk_class PotPlayer64")
	or WinActive("Picture-in-Picture") and WinActive("ahk_exe zen.exe"))
and isMouseGridInactive()
; or (winIsMouseOver("ahk_class ApplicationFrameWindow") or winIsMouseOver("ahk_class Shell_LightDismissOverlay")) and winIsMouseOver("ahk_exe explorer.exe") and winIsMouseOver("") ; clipboard & backdrop
; or WinActive("ahk_class MultitaskingViewFrame")  ; ctrl+alt+tab
; or WinActive("ahk_class Windows.UI.Core.CoreWindow") ; win+tab/StartScreen
; or WinActive("ahk_exe ShellExperienceHost.exe")
; ahk_exe ApplicationFrameHost.exe

; *WheelDown::Send {Blind}{Tab}
; *WheelUp::Send {Blind}+{Tab}
q:: Send("{Esc}")
l:: Send("{Right}")
h:: Send("{Left}")
j:: Send("{Down}")
k:: Send("{Up}")
o:: Send("{Enter}")
x:: Send("{Delete}")
d:: Send("{PgDn}")
u:: Send("{PgUp}")
#HotIf

#HotIf (WinActive("Task View") ; win+tab
	or WinActive("Task Switching")) ; ctrl+alt+tab
and isMouseGridInactive()
; manage workspace
+n:: Send("^#d")
+x:: Send("^#{F4}")
[:: navToDesktop("left")
]:: navToDesktop("right")
#HotIf

; Global arrow with homerow
#HotIf not WinActive("ahk_exe WindowsTerminal.exe")
	and not WinActive("ahk_exe alacritty.exe")
	and not WinActive("ahk_exe wezterm-gui.exe")
	and not WinActive("ahk_exe Code.exe")
!j:: SendInput("{DOWN}")
!k:: SendInput("{UP}")
!h:: SendInput("{LEFT}")
!l:: SendInput("{RIGHT}")
!p:: Send("{Up}")
!n:: Send("{Down}")

; emacs-standard
!f:: Send("^{Right}")
!b:: Send("^{Left}")
+!f:: Send("^+{Right}")
+!b:: Send("^+{Left}")
#HotIf
!Backspace:: SendInput("^{Backspace}")

#HotIf WinActive("ahk_class PotPlayer64") and isMouseGridInactive()
-:: Send("{F6}")
f:: Send("{Enter}")
; next/previous video
+p:: Send("{PgUp}")
+n:: Send("{PgDn}")
; Playback speed
<:: Send("{x}")
>:: Send("{c}")
; next/previous frame
,:: Send("{d}")
.:: Send("{f}")
; Subtitle
c:: Send("!{h}")
_:: Send("!{PgDn}")
+:: Send("!{PgUp}")
#HotIf

#HotIf WinActive("Command Palette") and isMouseGridInactive()
Tab:: Send("{Down}")
+Tab:: Send("{Up}")
!p:: Send("{Up}")
!n:: Send("{Down}")
#HotIf
