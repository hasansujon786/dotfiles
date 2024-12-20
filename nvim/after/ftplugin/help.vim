setlocal nonumber norelativenumber
setlocal readonly nomodifiable nolist

nnoremap <buffer>           <CR>    <C-]>
" Go to new curret word
nnoremap <buffer>         <A-CR>    /<C-R><C-W><CR>:nohl<CR>
" Next link
nnoremap <nowait><buffer>    ]      /\v\\|[^\|]+\\|<CR>:nohl<CR>
nnoremap <nowait><buffer>    [      ?\v\\|[^\|]+\\|<CR>:nohl<CR>
nnoremap <buffer>         <A-]>     /\v\<Bar>[^<Bar>]+\<Bar><CR>
nnoremap <buffer>         <A-[>     ?\v\<Bar>[^<Bar>]+\<Bar><CR>
" nnoremap <buffer>         <Tab>     /\|\zs\S\{-}\|/<CR><C-]>

" Reading mode
nmap <nowait><buffer> d <C-d>
nmap <nowait><buffer> u <C-u>
