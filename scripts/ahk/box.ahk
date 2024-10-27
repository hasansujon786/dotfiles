#Requires AutoHotkey v2.0
#Warn ; Enable warnings to assist with detecting common errors.
; SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir(A_ScriptDir) ; Ensures a consistent starting directory.
#SingleInstance Force ; C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\
#Include %A_ScriptDir%\utils.ahk

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

f1::{
  Run("C:\Users\" A_UserName "\dotfiles\scripts\ahk\box.ahk")
}



f2::{
  closeWindowByTitle("autoclick_status_line")

  height := 30
  width := 200
  xPos := PosX("center", 0, width)
  yPos := PosY("top", 0, height)
  SLine := Gui(, "autoclick_status_line"), SLine.BackColor := 0xff5ab0f6, SLine.Opt("+AlwaysOnTop -Caption +ToolWindow")

  title := SLine.AddText("cBlack w185 h30 Center", "Automation")  ; XX & YY serve to auto-size the window.
  title.SetFont("s12 Bold", "Arial")

  SLine.Show("x" xPos " y" ypos "w" width " h" height " NA")
  ; Sleep(3000)
  ; SLine.Maximize()
  ; Sleep(5000)
  ; SLine.Destroy
}

f8::{
  color := "cBlack"
  msg := "Capslock Off"
  MyGui := Gui("ToolWindow +AlwaysOnTop -Sysmenu Disabled -Caption"), MyGui.Title := "CapsLosckStatus", MyGui.SetFont("s20", "Arial")
  ; if (isCapsOn) {
  ;   color := "cWhite"
  ;   msg := "Capslock On"
  ;   MyGui.BackColor := "Red"
  ; }
  MyGui.Add("Text" ,"w300 y70 Center " color, msg)
  MyGui.Show("h200 NA")
}

f4::{
  ; MyGui := Gui()
  ; MyGui.Opt("+AlwaysOnTop -Caption +ToolWindow")  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
  ; MyGui.BackColor := "EEAA99"  ; Can be any RGB color (it will be made transparent below).
  ; MyGui.SetFont("s32")  ; Set a large font size (32-point).
  ; CoordText := MyGui.Add("Text", "cLime", "XXXXX YYYYY")  ; XX & YY serve to auto-size the window.
  ; ; Make all pixels of this color transparent and make the text itself translucent (150):
  ; WinSetTransColor(MyGui.BackColor " 250", MyGui)
  ; SetTimer(UpdateOSD, 200)
  ; UpdateOSD()  ; Make the first update immediate rather than waiting for the timer.
  ; MyGui.Show("x0 y400 NoActivate")  ; NoActivate avoids deactivating the currently active window.

  ; UpdateOSD(*)
  ; {
  ;     MouseGetPos &MouseX, &MouseY
  ;     CoordText.Value := "X" MouseX ", Y" MouseY
  ; }

  myGui := Gui()
  myGui.Opt("+LastFound  +ToolWindow -Caption +Border")

  myGui.SetFont("norm underline")

  ogcWinText := myGui.Add("Text", "Center cBlue vWinText", "Click here to close.")
  ; ogcWinText.OnEvent("Click", CloseOps.Bind("Normal"))

  myGui.Show("NoActivate w300 h300") ;w200

}
