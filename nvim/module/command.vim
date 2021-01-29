" Active all plugins
command! BootPlug CocStart

" untitled {{{
command! -nargs=1 PlaceholderImgTag call hasan#utils#placeholderImgTag(<f-args>)
command! Bclose call hasan#utils#bufcloseCloseIt()
command! ClearRegister call hasan#utils#clear_register()
command! -bang Delview call hasan#utils#delete_view(<q-bang>)
command! GetChar call hasan#utils#getchar()
command! AutoZoomWin call hasan#utils#auto_zoom_window()
command! AlternateFile exe "normal! \<c-^>"
command! -bang Quit call hasan#utils#confirmQuit(<q-bang>)
command! -nargs=1 JumpToWin call hasan#utils#JumpToWin(<f-args>)
command! -nargs=0 CycleNumber call hasan#utils#cycle_numbering()
command! -nargs=0 KillOtherBuffers call hasan#utils#clear_buffers()
command! -nargs=0 QfixToggle call hasan#utils#quickFix_toggle()
command! -bang CopyFileNameToClipBoard call hasan#utils#CopyFileNameToClipBoard(<q-bang>)
command! -nargs=+ RefactorWordInProject call hasan#utils#refactorWordInProject(<f-args>)
command! -nargs=1 TaskWikiAdvancedEdit call hasan#utils#tastwiki_edit(<f-args>)
command! -nargs=1 -complete=file Fedit call hasan#float#_fedit(<f-args>)
" }}}

" quick_term.vim {{{
command! -nargs=1 SetTerminal call hasan#term#SetBuffer(<f-args>)
command! -nargs=1 GoToTerminal call hasan#term#GotoBuffer(<f-args>)
command! -nargs=+ SendTerminalCommand call hasan#term#SendTerminalCommand(<f-args>)
command! AllTerminalIds echo keys(g:term_ctrlId_buf_list)
command! GoToPreviousTerminal call hasan#term#GotoPreviousTerm()
command! GoToNextTerminal call hasan#term#GotoNextTerm()
" }}}

