spGui := Gui("+ToolWindow +AlwaysOnTop -Sysmenu Disabled", "")
spGui.SetFont("s10", "Segoe UI")
spGui.Add("Text", "Center", "    AHK Reloaded...    `n`n")
spGui.Show("NoActivate AutoSize")
Sleep(300)
spGui.Destroy
Run("C:\Users\" A_UserName "\dotfiles\scripts\ahk\main.ahk")

