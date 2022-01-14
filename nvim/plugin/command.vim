command! -bang Delview call hasan#utils#delete_view(<q-bang>)
command! -bang Quit call hasan#utils#confirmQuit(<q-bang>)
command! -bang -nargs=1 -complete=file Fedit lua require("hasan.float").fedit(<f-args>)
command! ClearRegister call hasan#utils#clear_register()
command! OpenInVSCode    exe "silent !code --goto '" . expand("%") . ":" . line(".") . ":" . col(".") . "'"                    | redraw!
command! OpenCwdInVSCode exe "silent !code '" . getcwd() . "' --goto '" . expand("%") . ":" . line(".") . ":" . col(".") . "'" | redraw!
command! LspLogPath lua vim.cmd('edit '..vim.lsp.get_log_path())

nmap <silent> <Plug>(fix-current-world) :call hasan#repeat#fix_word()<CR>
