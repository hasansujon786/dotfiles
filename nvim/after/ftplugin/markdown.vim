" Enable spellchecking for Markdown
setlocal spell

" @todo: fix binding & dot (.) cmd support
" Toggle markdown checkList
nnoremap <buffer><leader>m 0f[ci[x<ESC>h
nnoremap <buffer><leader>M 0f[ci[<Space><ESC>h
