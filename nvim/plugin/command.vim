command! -bang Delview call hasan#utils#delete_view(<q-bang>)
command! -bang Quit call hasan#utils#confirmQuit(<q-bang>)
command! -bang -nargs=1 -complete=file Fedit lua require("hasan.float").fedit(<f-args>)
command! -nargs=1 PlaceholderImgTag call hasan#utils#placeholderImgTag(<f-args>)
command! ClearRegister call hasan#utils#clear_register()
command! OpenInVSCode    exe "silent !code --goto '" . expand("%") . ":" . line(".") . ":" . col(".") . "'"                    | redraw!
command! OpenCwdInVSCode exe "silent !code '" . getcwd() . "' --goto '" . expand("%") . ":" . line(".") . ":" . col(".") . "'" | redraw!

