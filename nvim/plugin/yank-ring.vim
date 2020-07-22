Plug 'vim-scripts/YankRing.vim', { 'on': 'YRShow' }

" => vim-scripts/YankRing.vim ==============================
nnoremap <silent> <leader>y :YRShow<CR>
vnoremap <silent> <leader>y y:YRShow<CR>:close<CR>
let g:yankring_replace_n_pkey = '<M-S-y>'
let g:yankring_replace_n_nkey = '<M-y>'

function! YRRunAfterMaps()
  nnoremap <silent> Y :<C-U>YRYankCount 'y$'<CR>
  vnoremap p pgvy
  vnoremap y ygv<Esc>
endfunction

