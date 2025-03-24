#SingleInstance Force

leader(key, cmd) {
  boardUpdateMsg(key)
  ResetLeader(1)
  cmd()
}

global leaderPressed := 0
global leaderBoardExists := 0
global MyLeaderGui, MyLeaderText

global SCREEN_WIDTH := A_ScreenWidth
global SCREEN_HEIGHT := A_ScreenHeight
global BOARD_WIDTH := 130
global BOARD_HEIGHT := 100
global POS_X := (SCREEN_WIDTH - BOARD_WIDTH) / 2  ; Center horizontally
global POS_Y := BOARD_HEIGHT + SCREEN_HEIGHT / 2 ; Move to center


ActiveLeaderMode() {
  global leaderPressed, leaderBoardExists
  if(leaderPressed || leaderBoardExists) {
    return
  }

  global leaderPressed := 1
  boardShow()
  SetTimer(ResetLeader, -1500)  ; Reset after 1.5 seconds
}

ResetLeader(actionKePressed := 0) {
  global leaderPressed
  if(leaderPressed == 0) {
    return
  }
  leaderPressed := 0

  if (actionKePressed) {
    SetTimer(boardHide, -800)
  } else {
    boardHide() ; If no action key as pressed then hide the board
  }
}


boardShow() {
  global MyLeaderGui, MyLeaderText, leaderBoardExists
  global BOARD_WIDTH, BOARD_HEIGHT, SCREEN_HEIGHT, POS_Y
  if (leaderBoardExists) {
    return
  }

  MyLeaderGui := Gui("+ToolWindow +AlwaysOnTop -Sysmenu Disabled", "")
  MyLeaderGui.SetFont("Bold s28", "Arial")
  MyLeaderText := MyLeaderGui.Add("Text", "w60 h50 y16 Center", ":)")  ; Add text

  guiEnterFromBottom(MyLeaderGui, 130, 100, POS_X, SCREEN_HEIGHT, POS_X, POS_Y)
}

boardHide() {
  global BOARD_WIDTH, BOARD_HEIGHT, SCREEN_HEIGHT, POS_Y

  if (leaderBoardExists) {
    guiExitToBottom(MyLeaderGui, BOARD_WIDTH, BOARD_HEIGHT, POS_Y)
  }
}


boardUpdateMsg(key := "") {
  global MyLeaderText
  if MyLeaderText && leaderBoardExists {
    ; newText := "U"
    ; newText := "Updated: " A_TickCount  ; Example dynamic value
    MyLeaderText.Text := key  ; Update the text
  }
}

guiEnterFromBottom(hGui, width, height, startX, startY, posX, posY) {
  ; Show GUI off-screen initially
  if hGui {
    global leaderBoardExists := 1
    hGui.Show("NoActivate x" startX " y" startY " w" width " h" height)
  }

  ; Animate upwards
  Loop 10 {  ; Adjust loop count for speed
    startY := startY - (posY / 10)  ; Move step by step
    try {
      hGui.Move(, startY)  ; Update GUI position
      Sleep(2)  ; Adjust for smoother animation
    }
  }
}

guiExitToBottom(hGui, width, height, startFromYPos) {
  global SCREEN_WIDTH, SCREEN_HEIGHT

  StartX := (SCREEN_WIDTH - width) / 2  ; Center horizontally
  StartY := startFromYPos               ; Start from bottom

  ; Animate upwards
  Loop 10 {  ; Adjust loop count for speed
    StartY := StartY + (startFromYPos / 10)  ; Move step by step
    if IsSet(hGui) && hGui && leaderBoardExists {
      hGui.Move(, StartY)  ; Update GUI position
    }
    Sleep(2)  ; Adjust for smoother animation
  }

  if IsSet(hGui) && hGui {
    global leaderBoardExists := 0
    hGui.Destroy()
    hGui := ""
  }
}
