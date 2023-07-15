## Links
  https://lexikos.github.io/v2/docs/KeyList.htm
  https://lexikos.github.io/v2/docs/Hotkeys.htm
  - [Running AutoHotkey Scripts at a Specific Time](https://www.youtube.com/watch?v=UbX3QtGOsTU)
  - [How to Launch AutoHotkey Scripts At Startup](https://www.youtube.com/watch?v=0kGP8S9o7qI)

## Info

```
# = Windows
+ = Shift
^ = Ctrl
! = Alt
* = Wildcard (*CapsLock::)

#Include C:\AHK\2nd-keyboard\gui.ahk

$^+v::
send, ^c
sleep 50
run, https://www.google.d...r#q=%clipboard%
return
```

## Window Swicher

```
F4::
  Run, "C:\Users\Default\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\Window Switcher.lnk"
Return

\::AltTabMenu
LAlt & j::AltTab
LAlt & k::ShiftAltTab
#IfWinActive ahk_class Windows.UI.Core.CoreWindow ahk_exe Explorer.EXE ; #IfWinNotActive, ahk_class MultitaskingViewFrame

LAlt & ]::AltTab
LAlt & [::ShiftAltTab
```


## Other

; SoundPlay *64                               ;Default windows sound Play an asterisk (Doesn't work for me though!)
; tooltip, %exstyle%, % x + 5, % y + 5
# Show notification
TrayTip, Reloading Script..., %A_ScriptName%, , 1

;******************************************************************************
;   Computer information
;******************************************************************************
::]myid::
SendInput %A_UserName%
Return

::]myip::
SendInput %A_IPAddress1%
Return

::]mycomp::
SendInput %A_ComputerName%
Return

printwins() {
  msgbox,,, savedCLASS is %savedCLASS%,0.5
  msgbox,,, savedexe is %savedEXE%,0.5
}

; if GetKeyState("Shift")
;     MsgBox At least one Shift key is down.
; else
;     MsgBox Neither Shift key is down.

key  := "LWin" ; Any key can be used here.
name := GetKeyName(key)
vk   := GetKeyVK(key)
sc   := GetKeySC(key)

MsgBox, % Format("Name:`t{}`nVK:`t{:X}`nSC:`t{:X}", name, vk, sc)

```
^!s::
{
    Send "Sincerely,{enter}John Smith"  ; This line sends keystrokes to the active (foremost) window.
}
LControl & RAlt::MsgBox "You pressed AltGr itself."

activebackSlashActions:
 {
   if (count = 1)
    {
      SendInput, {\}
    }
   else if (count >= 2)
    {
      ; msgbox, Double press.
      Sendinput !{tab}
    }
   count := 0
 }
return
; \::
;  {
;   count++
;   settimer, activebackSlashActions, 300
;  }
; return

;1::NavRun("C:\")
;2::NavRun(A_MyDocuments)

; ^+r::Send ^r{tab}{tab}{space}{enter}
;;the top rightmost keys on my K95.
;Media_Stop::^numpad7
;Media_Prev::^numpad8
;Media_Play_Pause::^numpad9
;Media_Next::^numpadMult
;Volume_Mute::^numpadDiv
;RButton & WheelDown::Send ^{Tab}
;RButton & WheelUp::Send ^+{Tab}
;RButton::RButton
;CapsLock::LCtrl
;Capslock Up::capsAsCtrl()
;Enter::RCtrl
;Enter Up::enterAsCtrl()

/*
TaskBar_SetAttr(option, color)
option -> 0 = off
          1 = gradient    (+color)
          2 = transparent (+color)
          3 = blur
color  -> ABGR (alpha | blue | green | red) 0xffd7a78f
*/

switchToChrome() {
  IfWinNotExist, ahk_exe chrome.exe
    Run, chrome.exe

    if WinActive("ahk_exe chrome.exe")
      Sendinput ^{tab}
    else
      WinActivate ahk_exe chrome.exe
}
switchToBrave() {
  IfWinNotExist, ahk_exe brave.exe
    Run, brave.exe

    if WinActive("ahk_exe brave.exe")
      Sendinput ^{tab}
    else
      WinActivate ahk_exe brave.exe
}

capsAsCtrl() {
  SendInput, {LControl Up}  ;--For stability
  If A_TimeSincePriorHotkey < 150
  {
    SendInput, {Escape}
  }
  Else
  return
}

enterAsCtrl() {
  SendInput, {RControl Up}  ;--For stability
  If A_TimeSincePriorHotkey < 150
  {
    SendInput, {Enter}
  }
  Else
  return
}

# loop
x::
While (GetKeyState("x", "P")) {
  Send 123
    Sleep 500
}
Return

toggleWezterm() {
  WinGetClass, className, A
  if(className == "org.wezfurlong.wezterm") {
    WinMinimize, ahk_exe wezterm-gui.exe
    return
  }

  if (WinExist("ahk_exe wezterm-gui.exe")) {
    WinActivate, ahk_exe wezterm-gui.exe
  }
  else {
    Run wezterm-gui.exe
    WinWait, ahk_exe wezterm-gui.exe
    if (WinExist("ahk_exe wezterm-gui.exe")) {
      center_current_window()
    }
  }
}
```
