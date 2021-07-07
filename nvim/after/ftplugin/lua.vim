call hasan#formatoptions#setup()
nnoremap <buffer><F9> :write<CR>:luafile %<CR>
nnoremap <buffer><S-F9> :lua require("hasan.utils").reload_this_module()<CR>
