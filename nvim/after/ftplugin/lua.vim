call hasan#formatoptions#setup()
nnoremap <buffer> <leader>v. <cmd>write<CR><cmd>lua require("hasan.utils").reload_this_module()<CR>
let b:treesitter_import_syntax = "local"
setlocal includeexpr=substitute(v:fname,'\\.','/','g')
