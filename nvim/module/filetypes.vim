augroup setSyntax
  autocmd!
  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile .babelrc set filetype=json
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile .eslintrc,.prettierrc set filetype=json
  autocmd BufRead,BufNewFile *.prisma set filetype=graphql

  " add support for comments in json (jsonc format used as configuration for
  " many utilities)
  autocmd FileType json syntax match Comment +\/\/.\+$+

  " Enable spellchecking for Markdown
  autocmd FileType markdown setlocal spell

  " Automatically wrap at 72 characters and spell check git commit messages
  autocmd FileType gitcommit setlocal textwidth=72
  autocmd FileType gitcommit setlocal spell

  " disable signcolumn for tagbar, nerdtree, as thats useless
  autocmd FileType tagbar,nerdtree setlocal signcolumn=no

  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass setlocal iskeyword+=-

augroup END
""""""""""""""""""""""""""""""
" => JavaScript
""""""""""""""""""""""""""""""
" Run js Code on node
autocmd FileType javascript nmap <leader>bb :!node %<CR>

" au FileType javascript imap <C-t> $log();<esc>hi
" au FileType javascript imap <C-a> alert();<esc>hi
" Jump to adjacent files
" nmap <leader>ip :e %:r.pug<CR>
" nmap <leader>is :e %:r.sass<CR>
" nmap <leader>it :e %:r.ts<CR>
" nmap <leader>ih :e %:r.html<CR>



""""""""""""""""""""""""""""""
" => C Program
""""""""""""""""""""""""""""""
" compile & run c Code
autocmd FileType c nmap <leader>bb :w<CR>:!gcc % -o .lastbuild && ./.lastbuild<cr>
autocmd FileType c nmap <leader>bl :w<CR>:!./.lastbuild<cr>

