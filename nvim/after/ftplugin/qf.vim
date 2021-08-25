setlocal nobuflisted

nmap     <silent><buffer> <C-s> <C-x>
nnoremap <silent><buffer> <CR> <CR>:cclose<Bar>setlocal signcolumn=yes nu rnu<CR>
nnoremap <silent><buffer> o <CR>:cclose<Bar>setlocal signcolumn=yes nu rnu<CR>
nnoremap <silent><nowait><buffer> q :cclose<CR>
nnoremap <silent><nowait><buffer> <esc> :cclose<CR>

