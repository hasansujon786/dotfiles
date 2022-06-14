
-- when pressing CapsLock alone, it will activate the Escpae button
#Include C:\AHK\2nd-keyboard\gui.ahk
Run, C:\Users\hasan\Downloads\Video

$^+v::
send, ^c
sleep 50
run, https://www.google.d...r#q=%clipboard%
return

;******************************************************************************
;   Computer information
;******************************************************************************
::]myid::
SendInput %A_UserName%
Return

::]myip::
SendInput %A_IPAddress1%
Return

::]mycomp::
SendInput %A_ComputerName%
Return

printwins() {
  msgbox,,, savedCLASS is %savedCLASS%,0.5
  msgbox,,, savedexe is %savedEXE%,0.5
}

; if GetKeyState("Shift")
;     MsgBox At least one Shift key is down.
; else
;     MsgBox Neither Shift key is down.
