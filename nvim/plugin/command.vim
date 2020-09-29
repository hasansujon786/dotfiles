command! -nargs=1 PlaceholderImgTag call hasan#utils#placeholderImgTag(<f-args>)
command! Bclose call hasan#utils#bufcloseCloseIt()
command! ClearRegister call hasan#utils#clear_register()
command! -bang Delview call hasan#utils#delete_view(<q-bang>)
command! GetChar call hasan#utils#getchar()
command! AutoZoomWin call hasan#utils#auto_zoom_window()


