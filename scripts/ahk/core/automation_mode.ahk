Global isClikModeActive := 0
Global currentClikMode := 0
Global optionsList := ["Youtube Playlist", "Youtube queue", "Firebase Remove User"]


#HotIf isClikModeActive
  #Esc::exitAutoClikMode()
  LButton::tryAutoClick()
  x::chooseAutoClikMode()
#HotIf

createStatusLine(title, submode) {
  winCloseByTitle("autoclick_status_line")

  height := 30
  width := 320
  xPos := PosX("center", 0, width)
  yPos := PosY("top", 0, height)
  SLine := Gui(, "autoclick_status_line"), SLine.BackColor := 0xff5ab0f6, SLine.Opt("+AlwaysOnTop -Caption +ToolWindow")

  title := SLine.AddText("cBlack w300 h30 Center", title . " | " . submode)
  title.SetFont("s12 Bold", "Arial")

  SLine.Show("x" xPos " y" ypos "w" width " h" height " NA")
}

enterAutoClikMode() {
  if (isClikModeActive = 1) {
    return
  }

  if (currentClikMode = 0) {
    return chooseAutoClikMode()
  }

  beep()
  Global isClikModeActive := 1
  createStatusLine("Autoclick", optionsList[currentClikMode])
}
exitAutoClikMode() {
  Global isClikModeActive := 0
  winCloseByTitle("autoclick_status_line")
  beep()
}

chooseAutoClikMode() {
  exitAutoClikMode()

  defaultItemIndex := currentClikMode = 0 ? 1 : currentClikMode
  optionWin := Gui(), optionWin.SetFont("s12 Bold", "Arial"), optionWin.Title := "Auto Click Mode"

  for index, opt in optionsList {
    if(defaultItemIndex = 1 && index == 1) {
      optionWin.AddRadio("vRadioGroup Checked", opt)
    } else if (defaultItemIndex = index) {
      optionWin.AddRadio("Checked", opt)
    } else {
      optionWin.AddRadio(index = 1 ? "vRadioGroup" : "", opt)
    }
  }

  submit(selected) {
    if (selected = 0) {
      return dd("not selected")
    }

    Global currentClikMode := selected
    optionWin.Destroy()

    Global isClikModeActive := 1
    createStatusLine("Autoclick", optionsList[currentClikMode])
  }
  cancel() {
    optionWin.Destroy()
  }

  optionWin.AddButton("w80", "OK").OnEvent("Click", (*) => submit(optionWin.Submit(0).RadioGroup))
  optionWin.AddButton("yp wp", "Cancel").OnEvent("Click", (*) => cancel())
  optionWin.Show()
}

tryAutoClick() {
  if (currentClikMode = 0) {
    chooseAutoClikMode()
    return
  }

  Switch currentClikMode {
  Case 1:
    ytRemovetFromWL()
  Case 2:
    ytRemovetFromWL()
  Case 3:
    firebaseRemoveAuthUser()
  ; Default:
  }
}

ytRemovetFromWL() {
  Send("{LButton}")
  sleep(100)
  if(currentClikMode = 1) {
    Send("{tab}{tab}{tab}")
  } else {
    Send("{tab}{tab}")
  }
  Send("{Enter}")
}

firebaseRemoveAuthUser() {
  beep()
  Send("{LButton}")
  sleep(100)
  Send("{Down}{Down}{Enter}")
  sleep(400)
  Send("{tab}{tab}{tab}")
  sleep(100)
  Send("{Enter}")
}

