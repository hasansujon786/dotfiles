
; http://www.autohotkey.com/board/topic/119638-splashui-simple-ui-function-for-entering-text/

/*
This function is useful for minimalistic text input.
Call it by pass the number of rows, you wish to use, along with the text.
For example: splashUI(2, "Evaluation")
*/

#p::foo()

foo(){
Result := splashUI(1, "Evaluation")
; p(Result)
; MsgBox % Result
}

splashUI(rows, text){
	global ; Set variable as global - rename 'vinput' below if you use 'input' as a variable elsewhere.
	Progress, hide B1 x0 w300 h200 zy60 c00 fs22 zh0, %text%,,, Courier New ; Show splash text
	Progress, Show
	Gui, -Caption +Border
	Gui, Margin, 10, 10
	Gui, Font, s10, Verdana
	Gui, Add, Edit, r%rows% vinput -WantReturn ; Edit box with variable rows. Press ctrl+enter for new line and

;enter to submit.
	Gui, Add, Button, x-100 y-100 Default, OK ; OK button is hidden off the canvas, but is needed for submitting

;with enter.
	Gui, Show
	WinWaitClose, ahk_class AutoHotkeyGUI ; Wait until edit box has disappeared
	ButtonOK:
	Gui, Submit
	Gui, Destroy
	Progress, off
	Return
}

