call hasan#formatoptions#setup()
nnoremap <F9> <cmd>write<CR>:lua require("hasan.utils").reload_this_module()<CR>
let b:treesitter_import_syntax = "local"
