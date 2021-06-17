command! ProjectFiles lua require("hasan.telescope.custom").project_files()

nnoremap <silent> <C-p> :Telescope oldfiles<CR>

nnoremap <silent> <C-k>m :Telescope filetypes<CR>
" nnoremap <A-/> :RG!<space>
" xnoremap <A-/> "zy:RG! <C-r>z<CR>
nnoremap <silent> // :lua require("hasan.telescope.custom").curbuf()<CR>

nnoremap <silent> <space>w/ :lua require("hasan.telescope.custom").search_wiki_files()<CR>
nnoremap <silent> <space>/w :lua require("hasan.telescope.custom").search_wiki_files()<CR>
nnoremap <silent> <space>vpp :lua require("hasan.telescope.custom").search_plugins()<CR>
