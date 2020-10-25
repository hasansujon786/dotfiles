" compile & run c Code
nnoremap <leader>bb :w<CR>:!gcc % -o .lastbuild && ./.lastbuild<cr>
nnoremap <leader>bl :w<CR>:!./.lastbuild<cr>
