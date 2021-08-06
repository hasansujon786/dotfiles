command! ProjectFiles lua require("hasan.telescope.custom").project_files()

nnoremap <silent> <C-k>m :Telescope filetypes<CR>
nnoremap <silent> <C-p> :lua require("telescope.builtin").oldfiles()<CR>
nnoremap <silent> <C-space> :lua require('telescope.builtin').lsp_code_actions(require('telescope.themes').get_cursor())<CR>
" nnoremap <A-/> :RG!<space>
" xnoremap <A-/> "zy:RG! <C-r>z<CR>
nnoremap <silent> // :lua require("hasan.telescope.custom").curbuf()<CR>

" for hasan#utils#_buflisted_sorted()
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
