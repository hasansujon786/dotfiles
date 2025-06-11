Global isClikModeActive := 0
Global currentClikMode := 0
Global optionsList := ["Youtube Playlist", "Youtube queue", "Firebase Remove User", "Chatgpt remove chat thread"]
Global guiTitle := "autoclick_status_line"


#HotIf isClikModeActive
  #Esc::_exitAutoClikMode()
  LButton::_tryAutoClick()
  #LButton::_chooseAutoClikMode()
#HotIf

enterAutoClikMode() {
  if (isClikModeActive = 1) {
    return _exitAutoClikMode()
  }

  return _chooseAutoClikMode()
}

_exitAutoClikMode() {
  Global isClikModeActive := 0
  winCloseByTitle(guiTitle)
  beep()
}

_chooseAutoClikMode() {
  _exitAutoClikMode()

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
    _createStatusLine("Autoclick", optionsList[currentClikMode])
    beep()
  }
  cancel() {
    optionWin.Destroy()
  }

  optionWin.AddButton("w80", "OK").OnEvent("Click", (*) => submit(optionWin.Submit(0).RadioGroup))
  optionWin.AddButton("yp wp", "Cancel").OnEvent("Click", (*) => cancel())
  optionWin.Show()
}

_createStatusLine(title, submode) {
  winCloseByTitle(guiTitle)

  height := 30
  width := 320
  xPos := PosX("center", 0, width)
  yPos := PosY("top", 0, height)
  SLine := Gui(, guiTitle), SLine.BackColor := 0xff5ab0f6, SLine.Opt("+AlwaysOnTop -Caption +ToolWindow")

  title := SLine.AddText("cBlack w300 h30 Center", title . " | " . submode)
  title.SetFont("s12 Bold", "Arial")

  SLine.Show("x" xPos " y" ypos "w" width " h" height " NA")
}


_tryAutoClick() {
  if (currentClikMode = 0) {
    _chooseAutoClikMode()
    return
  }
  local option := optionsList[currentClikMode]

  Switch currentClikMode {
  Case "Youtube Playlist":
    _ytRemovetFromWL()
  Case "Youtube queue":
    _ytRemovetFromWL()
  Case "Firebase Remove User":
    _firebaseRemoveAuthUser()
  Case "Chatgpt remove chat thread":
    _removeChatThreadFromChatGpt()
  ; Default:
  }
}

_ytRemovetFromWL() {
  Send("{LButton}")
  sleep(100)
  if(currentClikMode = 1) {
    Send("{tab}{tab}{tab}")
  } else {
    Send("{tab}{tab}")
  }
  Send("{Enter}")
}

_firebaseRemoveAuthUser() {
  beep()
  Send("{LButton}")
  sleep(100)
  Send("{Down}{Down}{Enter}")
  sleep(400)
  Send("{tab}{tab}{tab}")
  sleep(100)
  Send("{Enter}")
}

_removeChatThreadFromChatGpt() {
  beep()
  Send("{LButton}")
  sleep(200)
  Send("{Down}")
  sleep(20)
  Send("{Down}")
  sleep(20)
  Send("{Down}")
  sleep(20)
  Send("{Down}")
  sleep(20)
  Send("{Enter}")
  sleep(100)
  Send("{Enter}")
}
