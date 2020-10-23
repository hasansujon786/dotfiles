" Active all plugins
command! BootPlug CocStart

command! -nargs=1 PlaceholderImgTag call hasan#utils#placeholderImgTag(<f-args>)
command! Bclose call hasan#utils#bufcloseCloseIt()
command! ClearRegister call hasan#utils#clear_register()
command! -bang Delview call hasan#utils#delete_view(<q-bang>)
command! GetChar call hasan#utils#getchar()
command! AutoZoomWin call hasan#utils#auto_zoom_window()
command! AlternateFile exe "normal! \<c-^>"
command! -bang Q call hasan#utils#confirmQuit(<q-bang>)

command! -nargs=1 SetTerminal call hasan#term#SetBuffer(<f-args>)
command! -nargs=1 GoToTerminal call hasan#term#GotoBuffer(<f-args>)
command! -nargs=+ SendTerminalCommand call hasan#term#SendTerminalCommand(<f-args>)

