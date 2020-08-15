" Toggle Goyo
nnoremap <silent> gz :Goyo<CR>
nnoremap <silent> <C-k>z :Goyo<CR>

let g:background_before_goyo = &background
function! s:goyo_enter()
  let g:background_before_goyo = &background
  if has('gui_running')
    set linespace=7
  elseif exists('$TMUX')
    silent !tmux set status off
  endif
endfunction

function! s:goyo_leave()
  if has('gui_running')
    set linespace=0
  elseif exists('$TMUX')
    silent !tmux set status on
  endif
  execute 'set background=' . g:background_before_goyo
endfunction

augroup GOYO
  autocmd! User GoyoEnter nested call <SID>goyo_enter()
  autocmd! User GoyoLeave nested call <SID>goyo_leave()
augroup END

