
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
  r::winRestoreAndCenter()
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

TaskBar_SetAttr(accent_state := 0, gradient_color := "0xff101010") { ; fix
  static init, hTrayWnd, ver := DllCall("GetVersion") & 0xff < 10
  static pad := A_PtrSize = 8 ? 4 : 0, WCA_ACCENT_POLICY := 19

  if !(init) {
    if (ver)
      ; throw Exception("Minimum support client: Windows 10", -1) ; fix
    if !(hTrayWnd := DllCall("user32\FindWindow", "str", "Shell_TrayWnd", "ptr", 0, "ptr"))
      ; throw Exception("Failed to get the handle", -1)
    init := 1
  }

  accent_size := ACCENT_POLICY := Buffer(16, 0) ; V1toV2: if 'ACCENT_POLICY' is a UTF-16 string, use 'VarSetStrCapacity(&ACCENT_POLICY, 16)'
  NumPut("int", (accent_state > 0 && accent_state < 4) ? accent_state : 0, ACCENT_POLICY, 0)

  if (accent_state >= 1) && (accent_state <= 2) && (RegExMatch(gradient_color, "0x[[:xdigit:]]{8}"))
    NumPut("int", gradient_color, ACCENT_POLICY, 8)

  WINCOMPATTRDATA := Buffer(4 + pad + A_PtrSize + 4 + pad, 0) ; V1toV2: if 'WINCOMPATTRDATA' is a UTF-16 string, use 'VarSetStrCapacity(&WINCOMPATTRDATA, 4 + pad + A_PtrSize + 4 + pad)'
    && NumPut("int", WCA_ACCENT_POLICY, WINCOMPATTRDATA, 0)
    && NumPut("ptr", &ACCENT_POLICY, WINCOMPATTRDATA, 4 + pad)
    && NumPut("uint", accent_size, WINCOMPATTRDATA, 4 + pad + A_PtrSize)
  if !(DllCall("user32\SetWindowCompositionAttribute", "ptr", hTrayWnd, "ptr", WINCOMPATTRDATA))
    ; throw Exception("Failed to set transparency / blur", -1)
  return true
}
