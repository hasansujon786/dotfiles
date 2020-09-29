
" TrimWhitespace  {{{
function! hasan#autocmd#trimWhitespace()
  let l:save = winsaveview()
  %s/\\\@<!\s\+$//e
  call winrestview(l:save)
endfunction
" }}}

