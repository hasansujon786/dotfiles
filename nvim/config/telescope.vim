command! ProjectFiles lua require("hasan.telescope.custom").project_files({})

nnoremap <silent> <C-p>      :Telescope oldfiles<CR>
" nnoremap <silent> <C-k>p     :Telescope file_browser<CR>
" nnoremap <silent> <C-k><C-p> :Telescope file_browser<CR>

" nnoremap <silent> <C-k>b :Telescope buffers<CR>
" nnoremap <silent> <C-k>w :Windows<CR>
" nnoremap <silent> <C-k>m :Telescope filetypes<CR>

" nnoremap <silent> <C-k>' :Telescope marks<CR>
" nnoremap <silent> <C-k>? :GFile?<CR>
" nnoremap <silent> <C-k>/ :History/<CR>
" nnoremap <silent> <C-k>k :History:<CR>
" nnoremap <silent> <C-k><C-k> :History:<CR>

" nnoremap <A-/> :RG!<space>
" xnoremap <A-/> "zy:RG! <C-r>z<CR>
nnoremap <silent> // :lua require("hasan.telescope.custom").curbuf()<CR>
