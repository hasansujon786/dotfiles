
" TrimWhitespace  {{{
function! hasan#autocmd#trimWhitespace(...)
  let l:save = winsaveview()
  %s/\\\@<!\s\+$//e
  call winrestview(l:save)
endfunction
" }}}
"
" FzfStatusLine {{{
function! hasan#autocmd#fzf_statusline()
  highlight fzf1 guifg=#E5C07B guibg=#3B4048
  highlight fzf2 guifg=#98C379 guibg=#3B4048
  highlight fzf3 guifg=#ABB2BF guibg=#3B4048
  setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
endfunction
" }}}

function! hasan#autocmd#restore_position(...)
  if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") && expand('%:t') != 'COMMIT_EDITMSG'
    exe "normal g`\""
  endif
endfunction
