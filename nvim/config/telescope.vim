command! ProjectFiles lua require("hasan.telescope.custom").project_files()

nnoremap <silent> <C-p> :lua require("telescope.builtin").oldfiles({cwd_only = true})<CR>

nnoremap <silent> <C-k>m :Telescope filetypes<CR>
" nnoremap <A-/> :RG!<space>
" xnoremap <A-/> "zy:RG! <C-r>z<CR>
nnoremap <silent> // :lua require("hasan.telescope.custom").curbuf()<CR>

nnoremap <silent> <space>w/ :lua require("hasan.telescope.custom").search_wiki_files()<CR>
nnoremap <silent> <space>/w :lua require("hasan.telescope.custom").search_wiki_files()<CR>
nnoremap <silent> <space>vpp :lua require("hasan.telescope.custom").search_plugins()<CR>

if !exists('g:hasan_telescope_buffers')
  let g:hasan_telescope_buffers = {}
endif

augroup hasan_telescope_buffers
  autocmd!
  if exists('*reltimefloat')
    autocmd BufWinEnter,WinEnter * let g:hasan_telescope_buffers[bufnr('')] = reltimefloat(reltime())
  else
    autocmd BufWinEnter,WinEnter * let g:hasan_telescope_buffers[bufnr('')] = localtime()
  endif
  autocmd BufDelete * silent! call remove(g:hasan_telescope_buffers, expand('<abuf>'))
augroup END
