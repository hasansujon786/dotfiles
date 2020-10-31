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
command! -bang Q call hasan#utils#confirmQuit(<q-bang>)
" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" autoplug commands                                                       "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" better_term.vim {{{
command! -nargs=1 SetTerminal call hasan#term#SetBuffer(<f-args>)
command! -nargs=1 GoToTerminal call hasan#term#GotoBuffer(<f-args>)
command! -nargs=+ SendTerminalCommand call hasan#term#SendTerminalCommand(<f-args>)
command! AllTerminalIds echo keys(g:win_ctrl_buf_list)
" }}}

" exchange_operator.vim {{{
nnoremap <silent><Plug>(exchange-operator)  :set opfunc=autoplug#exchange_operator#_opfunc<CR>g@
vnoremap <silent><Plug>(exchange-operator)  :<C-U>call autoplug#exchange_operator#_opfunc(visualmode())<CR>
" }}}

" goto.vim {{{
command! -nargs=* -complete=expression Goto    call autoplug#goto#_goto(<q-args>)
command! -nargs=1 -complete=command    GotoCom call autoplug#goto#_goto('com '.<q-args>)
command! -nargs=1 -complete=function   GotoFu  call autoplug#goto#_goto('fu '.<q-args>)
command! -nargs=1 -complete=option     GotoSet call autoplug#goto#_goto('set '.<q-args>.'?')
command! -nargs=1 -complete=mapping    GotoNm  call autoplug#goto#_goto('nmap '.<q-args>)
command! -nargs=1 -complete=mapping    GotoMap call autoplug#goto#_goto('map '.<q-args>)
command! -nargs=1 -complete=highlight  GotoHi  call autoplug#goto#_goto('hi '.<q-args>)
" }}}

" string_transform.vim {{{
function! s:mapfunc (method)
    exec 'nmap <silent><Plug>(' . a:method . '_operator)  :set opfunc=autoplug#string_transform#_opfunc<CR>"="' . a:method . '"<CR>g@'
    exec 'vmap <silent><Plug>(' . a:method . '_operator)  :<C-U>call autoplug#string_transform#_opfunc(visualmode(), "' . a:method . '")<CR>'
endfunc

call <SID>mapfunc('snake_case')
call <SID>mapfunc('kebab_case')
call <SID>mapfunc('start_case')
call <SID>mapfunc('camel_case')
call <SID>mapfunc('upper_camel_case')
" }}}

