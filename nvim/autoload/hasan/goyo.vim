function! s:hide_statsline_color()
  if( &background == 'dark' )
    hi User1 guibg=#282C34 guifg=#282C34 gui=bold
    hi User2 guibg=#282C34 guifg=#282C34
    " Secondary section color
    hi User3 guibg=#282C34 guifg=#282C34
    hi User4 guibg=#282C34 guifg=#282C34
    " Statusline middle
    hi User5 guibg=#282C34 guifg=#282C34
    " Secondary section color (inactive)
    hi User6 guibg=#282C34 guifg=#282C34
    " Default color
    hi statusline   guibg=#282C34 guifg=#282C34
    hi StatusLineNC guibg=#282C34 guifg=#282C34
  endif
endfunction

let g:background_before_goyo = &background
function! hasan#goyo#goyo_enter()
  let g:goyo_is_running = v:true
  let g:background_before_goyo = &background
  call s:hide_statsline_color()

  call hasan#focus#disable()
  if has('gui_running')
    set linespace=7
  elseif exists('$TMUX')
    silent !tmux set status off
  endif
endfunction

function! hasan#goyo#goyo_leave()
  let g:goyo_is_running = v:false
  execute 'set background=' . g:background_before_goyo
  source ~/dotfiles/nvim/config/customstatusline.vim
  source ~/dotfiles/nvim/config/tabline.vim

  call hasan#focus#eneble()
  if has('gui_running')
    set linespace=0
  elseif exists('$TMUX')
    silent !tmux set status on
  endif
endfunction

function! hasan#goyo#is_running() abort
  return exists('g:goyo_is_running') && g:goyo_is_running == v:true
endfunction
