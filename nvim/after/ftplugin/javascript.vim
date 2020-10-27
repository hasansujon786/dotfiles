" Run js Code on node
nnoremap <leader>bb :!node %<CR>
" Save current file and Format
nnoremap <F9> :Format<CR>:write<CR>
""""""""""""""""""""""""""""""
" => JavaScript
""""""""""""""""""""""""""""""
" au FileType javascript imap <C-t> $log();<esc>hi
" au FileType javascript imap <C-a> alert();<esc>hi
" Jump to adjacent files
" nmap <leader>ip :e %:r.pug<CR>
" nmap <leader>is :e %:r.sass<CR>
" nmap <leader>it :e %:r.ts<CR>
" nmap <leader>ih :e %:r.html<CR>
