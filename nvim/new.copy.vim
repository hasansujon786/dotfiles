" " UPPERCASE WORD
" nnoremap <silent> <M-u> gUiww
" " lowercase WORD
" nnoremap <silent> <M-U> guiww

" " UPPERCASE word in insert mode
" inoremap <silent> <M-u> <ESC>gUiw`]a
" " lowercase word in insert mode
" inoremap <silent> <M-U> <ESC>guiw`]a


" " Move line up/down nnoremap <silent> <M-p> :<C-u>silent! exe "move-2"<CR>== nnoremap <silent> <M-n> :<C-u>silent! exe "move+1"<CR>==
" inoremap <silent> <M-p> <ESC>:<C-u>silent! exe "move-2"<CR>==gi
" inoremap <silent> <M-n> <ESC>:<C-u>silent! exe "move+1"<CR>==gi
" " Move selected lines up/down
" xnoremap <silent> <M-p> :<C-u>silent! exe "'<,'>move-2"<CR>gv=gv
" xnoremap <silent> <M-n> :<C-u>silent! exe "'<,'>move'>+"<CR>gv=gv

" " Scrolling
" nnoremap <M-f> <C-d>
" xnoremap <M-f> <C-d>
" nnoremap <M-b> <C-u>
" xnoremap <M-b> <C-u>

"  " Window management
"  " switch to windows
"  tnoremap <M-h> <C-\><C-N><C-w>h
"  tnoremap <M-j> <C-\><C-N><C-w>j
"  tnoremap <M-k> <C-\><C-N><C-w>k
"  tnoremap <M-l> <C-\><C-N><C-w>l
"  inoremap <M-h> <C-\><C-N><C-w>h
"  inoremap <M-j> <C-\><C-N><C-w>j
"  inoremap <M-k> <C-\><C-N><C-w>k
"  inoremap <M-l> <C-\><C-N><C-w>l
"  nnoremap <M-h> <C-w>h
"  nnoremap <M-j> <C-w>j
"  nnoremap <M-k> <C-w>k
"  nnoremap <M-l> <C-w>l

"  nnoremap <leader>q <C-w>c
"  nnoremap <leader>ws <C-w>s
"  nnoremap <leader>wv <C-w>v
"  nnoremap <leader>wn <C-w>n
"  nnoremap <leader>wo <C-w>o
"  " maximize window
"  nnoremap <leader>wm <C-w>_<C-w>\|

"  " goto window
"  for wnr in range(1, 9)
"    exe printf("nnoremap <space>%s %s<C-w>w", wnr, wnr)
"    exe printf("nnoremap %s<space> %s<C-w>w", wnr, wnr)
"  endfor


"  nnoremap <silent> <F2> :echo win#layout_toggle()<CR>
"  nnoremap <silent> <leader>w1 :echo win#layout_horizontal()<CR>
"  nnoremap <silent> <leader>w2 :echo win#layout_vertical()<CR>
"  nnoremap <silent> <leader>w3 :echo win#layout_main_horizontal()<CR>
"  nnoremap <silent> <leader>w4 :echo win#layout_main_vertical()<CR>
"  nnoremap <silent> <leader>w5 :echo win#layout_tile()<CR>

"  nnoremap <silent> <F11> :echo win#layout_save()<CR>
"  nnoremap <silent> <F12> :echo win#layout_restore()<CR>

"  " CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
"  " so that you can undo CTRL-U after inserting a line break.
"  inoremap <C-U> <C-G>u<C-U>

"  " spell correction for the first suggested
"  " https://castel.dev/post/lecture-notes-1/
"  inoremap <M-s> <c-g>u<C-\><C-o>[s<ESC>1z=`]a<c-g>u

"  " scroll other window
"  nnoremap <silent> <M-F> :call win#scroll_other(1)<CR>
"  nnoremap <silent> <M-B> :call win#scroll_other(0)<CR>

"  nnoremap <silent> gof :call os#file_manager()<CR>
"  nnoremap gx :call os#open_url(expand('<cWORD>'))<CR>
"
" nnoremap <BS> <C-^>
" nnoremap <M-BS> :%bd<CR><C-^>:bd#<CR>

