function statusline#colorscheme#one#_set_colorscheme() abort
  " Mode color
  hi User1 guibg=#98C379 guifg=#2C323C gui=bold
  hi User2 guibg=#3E4452 guifg=#98C379
  " Secondary section color
  hi User3 guibg=#3E4452 guifg=#ABB2BF
  hi User4 guibg=#2C323C guifg=#3E4452
  " Statusline middle
  hi User5 guibg=#2C323C guifg=#717785
  " Secondary section color (inactive)
  hi User6 guibg=#3E4452 guifg=#717785
  " Banner section color
  hi User7 guibg=tomato guifg=white gui=bold
  " hi User8 guibg=tomato guifg=#ABB2BF
  " Default color
  hi statusline   guibg=#2C323C guifg=#ABB2BF
  hi StatusLineNC guibg=#2C323C guifg=#717785
endfunction

let s:status_color={
  \ 'n' :'#98C379',
  \ 'v' :'#C678DD',
  \ 'i' :'#61AFEF',
  \ 't' :'#61AFEF',
  \ 'r' :'#E06C75',
  \}
function _update_vim_mode_color(mode) abort
  " @todo: replace color update system in statsuline
  if (hasan#goyo#is_running()) | return | endif

  let bg = get(s:status_color, g:vim_current_mode, 'n')

  if (exists('g:statusline_banner_is_hidden') && !g:statusline_banner_is_hidden)
    exe 'hi User1 guibg='.bg.' guifg=#2C323C gui=bold'
    exe 'hi User2 guifg='.bg.' guibg=tomato gui=bold'
  else
    exe 'hi User1 guibg='.bg.' guifg=#2C323C gui=bold'
    exe 'hi User2 guifg='.bg.' guibg=#3E4452 gui=bold'
  endif
  " if exists('$TMUX')
  "   call s:updateVimuxLine(bg)
  " endif
endfunction

function s:updateVimuxLine(bg)
  call system('tmux set -g window-status-current-format "#[fg=#282C34,bg='.a:bg.',noitalics]#[fg=black,bg='.a:bg.'] #I #[fg=black, bg='.a:bg.'] #W #[fg='.a:bg.', bg=#282C34]"')
endfunction
