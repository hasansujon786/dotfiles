nnoremap <silent><Plug>(exchange-operator)  :set opfunc=exchange_operator#_opfunc<CR>g@
vnoremap <silent><Plug>(exchange-operator)  :<C-U>call exchange_operator#_opfunc(visualmode())<CR>
