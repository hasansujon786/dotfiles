" Maintainer:	Damian Conway

" Recommended to use a mapping similar to the following:
" nmap <silent> <BS> :call HLNextOff() <BAR> :nohlsearch<CR>

" " If already loaded, we're done...
if exists("loaded_HLNext")
    finish
endif
let g:loaded_HLNext = 1

" Preserve external compatibility options, then enable full vim compatibility...
let s:save_cpo = &cpo
set cpo&vim

"====[ INTERFACE ]=============================================

if maparg('/','n') == ""
  nnoremap  <unique>         /   :call HLNextSetTrigger()<CR>/
endif
if maparg('?','n') == ""
  nnoremap  <unique>         ?   :call HLNextSetTrigger()<CR>?
endif
if maparg('n','n') == ""
  nnoremap  <unique><silent> n  n:call HLNext()<CR>zzzv
endif
if maparg('N','n') == ""
  nnoremap  <unique><silent> N  N:call HLNext()<CR>zzzv
endif
if maparg('*','n') == ""
  nnoremap  <unique>         *   :call HLNextSetTrigger()<CR>*
endif
if maparg('#','n') == ""
  nnoremap  <unique>         #   :call HLNextSetTrigger()<CR>#
endif

" Default highlighting for next match...
highlight default HLNext guibg=#E06C75 guifg=#282C34 gui=bold ctermfg=235 ctermfg=204 cterm=bold

"====[ IMPLEMENTATION ]=======================================

" Clear previous highlighting and set up new highlighting...
function! HLNext ()
  " Remove the previous highlighting, if any...
  call HLNextOff()

  " Add the new highlighting...
  let target_pat = '\c\%#\%('.@/.'\)'
  let w:HLNext_matchnum = matchadd('HLNext', target_pat)
endfunction

" Clear previous highlighting (if any)...
function! HLNextOff ()
  if (exists('w:HLNext_matchnum') && w:HLNext_matchnum > 0)
    try | call matchdelete(w:HLNext_matchnum) | unlet! w:HLNext_matchnum | catch | endtry
  endif
endfunction

" Prepare to active next-match highlighting after cursor moves...
function! HLNextSetTrigger ()
  augroup HLNext
    autocmd!
    autocmd  CursorMoved  *  :call HLNextMovedTrigger()
  augroup END
endfunction

" Highlight and then remove activation of next-match highlighting...
function! HLNextMovedTrigger ()
  augroup HLNext
    autocmd!
  augroup END
  call HLNext()
endfunction


" Restore previous external compatibility options
let &cpo = s:save_cpo
