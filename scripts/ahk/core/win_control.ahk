winIsMouseOver(WinTitle) {
  MouseGetPos(, , &Win)
  return WinExist(WinTitle . " ahk_id " . Win)
}
winIsFullScreen(winTitle) {
  ;checks if the specified window is full screen
  winID := WinExist( winTitle )

  If ( !winID )
  Return false

  style := WinGetStyle("ahk_id " WinID)
  WinGetPos(, , &winW, &winH, winTitle)
  ; 0x7fffff is WS_BORDER.
  ; 0x1fffffff is WS_MINIMIZE.
  ; no border and not minimized
  Return ((style & 0x207fffff) or winH < A_ScreenHeight or winW < A_ScreenWidth) ? false : true
}
winExitIfFullScreen() {
  isFullScreen := winIsFullScreen( "A" )
  if (isFullScreen) {
    Send("{f11}")
  }
}
winCloseByTitle(title) {
  if WinExist(title) {
    WinClose(title)
  }
}
winToggleRestore() {
  ; WinGet WindowID, ID, A
  ; WinGet WindowSize, MinMax, ahk_id %WindowID%
  MX := WinGetMinMax("A")
  if (MX) {
    WinRestore("A")
  } else {
    WinMaximize("A")
  }
}
toggleTransparency() {
  Title := WinGetTitle("A")
  TN := WinGetTransparent(Title)
  ; MsgBox, TN of %Title% is %TN%

  if (TN == "") {
    WinSetTransparent(245, "A")
    beep()
  }
  else {
    WinSetTransparent("OFF", "A")
  }
}
decreaseTransparency() {
  Title := WinGetTitle("A")
  TN := WinGetTransparent(Title)
  if(TN == "") {
    beep()
    return
  }

  if (TN < 255)
    TN += 5
  WinSetTransparent(TN, Title)
}
increaseTransparency() {
  Title := WinGetTitle("A")
  TN := WinGetTransparent(Title)
  if(TN == "") {
    beep()
    return
  }

  if (TN > 0)
    TN -= 5
  WinSetTransparent(TN, Title)
}
toggleAlwaysOnTop() {
  winCloseByTitle("always_on_top_status")

  active := WinGetTitle("A")
  appName := StrUpper(StrReplace(WinGetProcessName("A"), ".exe"))
  status := ""
  color := "DFDFDF"
  If !(WinGetMinMax(active)) {
    WinSetAlwaysOnTop -1, active
    ExStyle := WinGetExStyle(active)
    If (ExStyle & 0x8) {
      status := "Activated"
      color := "0C8CE9"
    } else {
      status := "Deactivated"
    }
  } else {
    status := "Window is Maximized"
  }

  spGui := Gui("+ToolWindow +AlwaysOnTop -Sysmenu Disabled -Caption", "always_on_top_status")
  spGui.BackColor := '2C2C2C'
  spGui.SetWindowAttribute(33, 2)
  spGui.SetWindowColor(, spGui.BackColor, 0xff1b222c)
  ;; Add title
  spGui.SetFont("s10", "Segoe UI")
  spGui.AddText("Center y24 w150 cDFDFDF", "Always On Top`n--------")
  ;; Add Status
  spGui.SetFont("s12 Bold", "Segoe UI")    ; Size 16, Bold
  spGui.Add("Text", "Center y+-2 w150 h40 c" color, status)

  spGui.Show("NoActivate AutoSize")
  SetTimer () => spGui.Destroy(), -1000
}

;******************************************************************************
; Window Switcher functions
;******************************************************************************
alternateTab() {
  Send("{alt down}")
  Send("{tab}")
  Send("{alt up}")
}
; Extracts the application title from the window's full title
ExtractAppTitle(FullTitle) {
  return SubStr(FullTitle, (InStr(FullTitle, " ", false, -2) + 1)<1 ? (InStr(FullTitle, " ", false, -2) + 1)-1 : (InStr(FullTitle, " ", false, -2) + 1))
}
switchBetweenSameApps() {
  activeProcessName := WinGetProcessName("A")
  if (activeProcessName = "chrome.exe") {
    ; Switch a "Chrome App or Chrome Website Shortcut" open windows based on the same application title
    FullTitle := WinGetTitle("A")
    AppTitle := ExtractAppTitle(FullTitle)
    SetTitleMatchMode(2)
    owindowsWithSameTitleList := WinGetList(AppTitle,,,)
    awindowsWithSameTitleList := Array()
    windowsWithSameTitleList := owindowsWithSameTitleList.Length
    For v in owindowsWithSameTitleList
    {   awindowsWithSameTitleList.Push(v)
    }
    WinActivate("ahk_id " awindowsWithSameTitleList[awindowsWithSameTitleList.Length])
  } else {
    ; Switch "App" open windows based on the same process and class
    activeClass := WinGetClass("A")
    SetTitleMatchMode(2)
    owindowsListWithSameProcessAndClass := WinGetList("ahk_exe " activeProcessName " ahk_class " activeClass,,,)
    awindowsListWithSameProcessAndClass := Array()
    windowsListWithSameProcessAndClass := owindowsListWithSameProcessAndClass.Length
    For v in owindowsListWithSameProcessAndClass
    {   awindowsListWithSameProcessAndClass.Push(v)
    }
    WinActivate("ahk_id " awindowsListWithSameProcessAndClass[awindowsListWithSameProcessAndClass.Length])
  }
}

;******************************************************************************
; Window Controll Vim Mode
;******************************************************************************
navToDesktop(side) {
  if (side == "left") {
    Send("^#{Left}")
  }  else if (side == "right"){
    Send("^#{Right}")
  }
}
winRestoreAndCenter() {
  MX := WinGetMinMax("A")
  if (MX) {
    WinRestore("A")
  }

  ; resize window
  if (A_ScreenHeight >= 1080) {
    ; old width: 834
    WinMove(, , 1406, 845, "A") ; 1080
  }  else {
    WinMove(, , 1216, 660, "A") ; 768
  }
  centerCurrentWindow()
}
changeWinSize(direction, val) {
  WinGetPos(, , &Width, &Height, "A")
  if (direction == "width") {
    WinMove(, , Width + val, , "A")
  }  else {
    WinMove(, , , Height + val, "A")
  }
  ; WinMove, %WinTitle%,, (A_ScreenWidth/2)-(Width/2), (A_ScreenHeight/2)-(Height/2)
}

moveWinRight(val) {
  WinGetPos(&x, &y, , , "A")
  moveWindowX_and_Y(x+val, y)
}
moveWinLeft(val) {
  WinGetPos(&x, &y, , , "A")
  moveWindowX_and_Y(x-val, y)
}
moveWinUp(val) {
  WinGetPos(&x, &y, , , "A")
  moveWindowX_and_Y(x, y-val)
}
moveWinDown(val) {
  WinGetPos(&x, &y, , , "A")
  moveWindowX_and_Y(x, y+val)
}
moveWindowX_and_Y(x, y){
  MouseGetPos(&mx, &my)
  WinMove(x, y, , , "A")
  ; mousemove, %mx%, %my%, 0
}
centerCurrentWindow() {
  try {
    win_title := WinGetTitle("A")
    WinGetPos(, , &win_width, &win_height, win_title)

    targetX := (A_ScreenWidth/2) - (win_width/2)
    targetY := ((A_ScreenHeight - 30)/2) - (win_height/2)
    WinMove(targetX, targetY, , , win_title)
  } catch Error as err {
    dd("Error found, could not center the window")
  }
}
winPinToSide(side, checkFullscreen) {
  if (checkFullscreen) {
    winExitIfFullScreen()
    Sleep(50)
  }

  WinRestore("A")
  if (side == "left") {
    Send("#{Left}")
  }  else if (side == "right"){
    Send("#{Right}")
  }
}
winPinToSide_custom(side) {
  tb_height := 24
  y_start := 0
  x_start := 0
  s_height := A_ScreenHeight - tb_height
  s_half := (A_ScreenWidth / 2) + 16 ; Increase 16px width to fill right side margin

  if (side == "left") {
    x_start := -8 ; remove default left margin
  } else if (side == "right") {
    x_start := s_half - 24 ; remove default left margin
  }

  WinRestore("A")
  WinMove(x_start, y_start, s_half, s_height, "A")
}
