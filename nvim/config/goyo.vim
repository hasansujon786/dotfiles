" Toggle Goyo
nnoremap <silent> gz :Goyo<CR>
nnoremap <silent> <C-k>z :Goyo<CR>

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
function! s:goyo_enter()
  let g:background_before_goyo = &background
  call s:hide_statsline_color()

  if has('gui_running')
    set linespace=7
  elseif exists('$TMUX')
    silent !tmux set status off
  endif
endfunction

function! s:goyo_leave()
  execute 'set background=' . g:background_before_goyo
  source ~/dotfiles/nvim/config/customstatusline.vim
  source ~/dotfiles/nvim/config/tabline.vim

  if has('gui_running')
    set linespace=0
  elseif exists('$TMUX')
    silent !tmux set status on
  endif
endfunction

augroup GOYO
  autocmd! User GoyoEnter nested call <SID>goyo_enter()
  autocmd! User GoyoLeave nested call <SID>goyo_leave()
augroup END

