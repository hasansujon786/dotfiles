
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
