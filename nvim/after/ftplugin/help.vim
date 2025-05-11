setlocal nonumber norelativenumber
setlocal readonly nomodifiable nolist

let b:snacks_indent = v:false

nnoremap <buffer>           <CR>    <C-]>
" Next link
nnoremap <nowait><buffer>    ]t      /\v\\|[^\|]+\\|<CR><cmd>nohl<CR>
nnoremap <nowait><buffer>    [t      ?\v\\|[^\|]+\\|<CR><cmd>nohl<CR>
" nnoremap <buffer>         <A-]>     /\v\<Bar>[^<Bar>]+\<Bar><CR>
" nnoremap <buffer>         <A-[>     ?\v\<Bar>[^<Bar>]+\<Bar><CR>
" nnoremap <buffer>         <Tab>     /\|\zs\S\{-}\|/<CR><C-]>

" Reading mode
nmap <nowait><buffer> d <C-d>
nmap <nowait><buffer> u <C-u>
