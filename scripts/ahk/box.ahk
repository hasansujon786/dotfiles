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
  height := 80
  width := 800
  xPos := PosX("center", 0, width)
  yPos := PosY("center", 0, height)

  MyGui := Gui(, "Title of Window"), MyGui.BackColor := "White", MyGui.Opt("+AlwaysOnTop -Caption +ToolWindow")
  ; MyGui.Add("Text",, "reloaded"),
  ; MyGui.Show("x" xPos " y" ypos "w" width " h" height " NA")

  ; MyGui.SetFont(, "Arial")
  ; MyGui.AddEdit("vName")


  ; MyGui.Add("Edit",)  ; Add a fairly wide edit control at the top of the window.
  ; ; MyGui.Add("Text", "Section", "First Name:")  ; Save this control's position and start a new section.
  ; ; MyGui.Add("Text",, "Last Name:")
  ; MyGui.Add("Edit", "ys")  ; Start a new column within this section.
  ; MyGui.Add("Edit")

  ; MyGui.MarginX := "200"
  ; FileMenu := Menu()
  ; FileMenu.Add "&Open`tCtrl+O", (*) => FileSelect()  ; See remarks below about Ctrl+O.
  ; FileMenu.Add "E&xit", (*) => ExitApp()
  ; HelpMenu := Menu()
  ; HelpMenu.Add "&About", (*) => MsgBox("Not implemented")
  ; Menus := MenuBar()
  ; Menus.Add "&File", FileMenu  ; Attach the two submenus that were created above.
  ; Menus.Add "&Help", HelpMenu
  ; MyGui := Gui()
  ; MyGui.MenuBar := Menus
  ; MyGui.Show "w300 h200"

  ; MyGui.SetFont("s18", "Arial")  ; Set a large font size (32-point).
  ; MyGui.Add("Text",, "reloaded"),
  MyGui.Add("Text", "cRed", "XXXXX YYYYY")  ; XX & YY serve to auto-size the window.

  MyGui.Show("x" xPos " y" ypos "w" width " h" height " NA")
  Sleep(1000)
  ; MyGui.Maximize()
  Sleep(5000)
  MyGui.Destroy
}

f2::{
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
