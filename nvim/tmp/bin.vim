
" function! nebulous#block(...) abort
"  let s:nebulous_disabled = v:true
" endfunction

" function! nebulous#unblock(...) abort
"  let s:nebulous_disabled = v:false
" endfunction

" function! nebulous#onTelescopeStart() abort
"   if nebulous#is_disabled() | return | endif

"   call nebulous#blur_current_window()
"   call nebulous#block()
"   augroup NebulousTelescope
"     autocmd!
"     autocmd WinClosed * call nebulous#onTelescopeClosed()
"   augroup end
" endfunction

" function! nebulous#onTelescopeClosed() abort
"   call nebulous#unblock()
"   autocmd! NebulousTelescope
" endfunction

