#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
; SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
#SingleInstance Force

SplashTextOn,,60,, YT Mode
sleep 300
SplashTextOff
activeYTmode := 1
TaskBar_SetAttr(1, 0xff0000ff)

#if activeYTmode
  Esc::
    activeYTmode := 0
    beep()
    TaskBar_SetAttr(1, 0xff101010)
    ExitApp
  Return

  ; RButton::ytRemovetFromWL()
  RButton::deleteFbaseCollection()
  x::deleteFbaseUser()
  #z::rebootMiWiFi()
#if


print(msg) {
  msgbox,,, %msg%, 1
}
ytRemovetFromWL() {
  ; Remove item from watch list
  Send {LButton}
  Sleep 2
  Send {tab}
  Sleep 1
  Send {tab}
  Sleep .5
  Send {tab}
  Sleep .5
  Send {Enter}
}
deleteFbaseUser() {
  Send {tab}
  Sleep 1
  Send {tab}
  Sleep 1
  Send {Space}
  Sleep 10
  Send {Down}
  Sleep 10
  Send {Down}
  Sleep 10
  Send {Space}
  Sleep 500
  Send {tab}
  Sleep 1
  Send {tab}
  Sleep 1
  Send {tab}
  Sleep 10
  Send {Space}
}
deleteFbaseCollection() {
  ; Remove item from firebase
  Send, {Ctrl down}c{Ctrl up}
  Send {tab}
  Sleep 1
  Send {tab}
  Sleep .5
  Send {tab}
  Sleep .5
  Send {tab}
  Sleep .5
  Send {Space}
  Sleep 1
  Send {Space}
  Sleep 500
  Send {tab}
  Send, {Ctrl down}v{Ctrl up}
  Sleep 500
  Send {tab}
  Sleep 10
  Send {tab}
  Sleep 10
  Send {Space}
}

rebootMiWiFi() {
  Run, http://router.miwifi.com/
  sleep 3000
  MouseMove, 559, 600
  Click
  SendInput,hasan007007{ENTER}
  sleep 4000
  MouseMove, 1160, 150
  Click
  SendInput,{tab}{tab}{tab}{tab}{enter}
  sleep 4000
  MouseMove, 700, 522
  Click
  sleep 1000
  MouseMove, 596, 420
  Click
}


beep() {
  SoundBeep, 300, 150
}
TaskBar_SetAttr(accent_state := 0, gradient_color := "0xff101010")
{
  static init, hTrayWnd, ver := DllCall("GetVersion") & 0xff < 10
  static pad := A_PtrSize = 8 ? 4 : 0, WCA_ACCENT_POLICY := 19

  if !(init) {
    if (ver)
      throw Exception("Minimum support client: Windows 10", -1)
    if !(hTrayWnd := DllCall("user32\FindWindow", "str", "Shell_TrayWnd", "ptr", 0, "ptr"))
      throw Exception("Failed to get the handle", -1)
    init := 1
  }

  accent_size := VarSetCapacity(ACCENT_POLICY, 16, 0)
  NumPut((accent_state > 0 && accent_state < 4) ? accent_state : 0, ACCENT_POLICY, 0, "int")

  if (accent_state >= 1) && (accent_state <= 2) && (RegExMatch(gradient_color, "0x[[:xdigit:]]{8}"))
    NumPut(gradient_color, ACCENT_POLICY, 8, "int")

  VarSetCapacity(WINCOMPATTRDATA, 4 + pad + A_PtrSize + 4 + pad, 0)
    && NumPut(WCA_ACCENT_POLICY, WINCOMPATTRDATA, 0, "int")
    && NumPut(&ACCENT_POLICY, WINCOMPATTRDATA, 4 + pad, "ptr")
    && NumPut(accent_size, WINCOMPATTRDATA, 4 + pad + A_PtrSize, "uint")
  if !(DllCall("user32\SetWindowCompositionAttribute", "ptr", hTrayWnd, "ptr", &WINCOMPATTRDATA))
    throw Exception("Failed to set transparency / blur", -1)
  return true
}
