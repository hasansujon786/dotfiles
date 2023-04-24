setlocal nobuflisted norelativenumber signcolumn=no

nmap     <silent><buffer> <C-s> <C-x>
nnoremap <silent><nowait><buffer> q :cclose<Bar>:lclose<CR>
nnoremap <silent><buffer> { :colder<CR>
nnoremap <silent><buffer> } :cnewer<CR>
" nnoremap <silent><buffer> <CR> <CR>:cclose<Bar>:lclose<Bar>setlocal signcolumn=yes nu rnu<CR>
" nnoremap <silent><buffer> o <CR>:cclose<Bar>:lclose<Bar>setlocal signcolumn=yes nu rnu<CR>

