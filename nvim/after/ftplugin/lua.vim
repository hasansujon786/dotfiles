call hasan#formatoptions#setup()
nnoremap <buffer><F9> :write<CR>:lua require("hasan.utils").reload_this_module()<CR>
