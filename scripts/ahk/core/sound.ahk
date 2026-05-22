selectedMic := EnvGet("SELECTED_MIC")
selectedMic := selectedMic ? selectedMic : ""

selectMic() {
  global selectedMic

  devices := []
  deviceList := ""

  i := 1
  Loop {
    try {
      name := SoundGetName("", i)

      if InStr(name, "Microphone") {
        devices.Push(name)
        deviceList .= devices.Length ". " name "`n"
      }

      i++
    } catch {
      break
    }
  }

  if (devices.Length = 0) {
    MsgBox("No microphone devices found.")
    return false
  }

  result := InputBox(
    "Select microphone number:`n`n" deviceList,
    "Select Microphone"
  )

  if (result.Result != "OK")
    return false

  index := Integer(result.Value)

  if (index < 1 || index > devices.Length) {
    MsgBox("Invalid selection.")
    return false
  }

  selectedMic := devices[index]
  return true
}

togleSelectedMic() {
  global selectedMic

  ; auto-open selector if not set
  if (selectedMic = "") {
    if !selectMic()
      return
  }

  SoundSetMute(-1, , selectedMic)
  muted := SoundGetMute(, selectedMic)

  if (muted)
    beepOff()
  else
    beepOn()
}


volup() {
  SoundSetVolume("+8") ;; Increase speed
  Send("{Volume_Up}")
}
voldown() {
	SoundSetVolume(-8)
	Send("{Volume_Down}")
}
showVolMixer() {
	Run("C:\Windows\System32\SndVol.exe")
	ErrorLevel := !WinWait("ahk_exe SndVol.exe")
	If WinExist("ahk_exe SndVol.exe")
		WinActivate("ahk_exe SndVol.exe")
	centerCurrentWindow("ahk_exe SndVol.exe")
}
showMicPanel() {
	Run("control mmsys.cpl,,1")
	beep()
	ErrorLevel := !WinWait("ahk_exe rundll32.exe")
	if WinExist("ahk_exe rundll32.exe") {
		WinActivate("ahk_exe rundll32.exe")
		centerCurrentWindow("ahk_exe rundll32.exe")
	}
}
