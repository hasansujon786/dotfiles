" compile & run c Code
nnoremap <buffer><leader>bb :w<CR>:!gcc % -o .lastbuild && ./.lastbuild<cr>
nnoremap <buffer><leader>bl :w<CR>:!./.lastbuild<cr>
