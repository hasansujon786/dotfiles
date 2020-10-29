setlocal nobuflisted
setlocal nonumber norelativenumber

nnoremap <buffer> <CR> <CR>
"nnoremap <buffer> j     :cprevious<CR>
"nnoremap <buffer> k     :cnext<CR>
nnoremap <buffer> p     :cprevious<CR>
nnoremap <buffer> n     :cnext<CR>
nnoremap <silent><nowait><buffer> q :wincmd c<CR>

