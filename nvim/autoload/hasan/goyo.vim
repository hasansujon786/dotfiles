function! hasan#goyo#goyo_enter()
  let g:goyo_is_running = v:true
  " let g:background_before_goyo = &background

  call hasan#focus#disable()
  if has('gui_running')
    set linespace=7
  elseif exists('$TMUX')
    silent !tmux set status off
  endif
endfunction

function! hasan#goyo#goyo_leave()
  let g:goyo_is_running = v:false
  " execute 'set background=' . g:background_before_goyo
  source ~/dotfiles/nvim/config/tabline.vim
  call hasan#color#load_custom_highlight()

  call hasan#focus#eneble()
  if has('gui_running')
    set linespace=0
  elseif exists('$TMUX')
    silent !tmux set status on
  endif
endfunction

function! hasan#goyo#is_running() abort
  return exists('g:goyo_is_running') && g:goyo_is_running
endfunction
