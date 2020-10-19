function! s:ChangeTmuxActiveTab(mode)
  if exists('$TMUX')
    if(a:mode == 'i')
      let bg = v:insertmode == 'i' ? 'blue' : 'red'
      let g:vimuxline_mode = 'i'
    elseif (a:mode == 't')
      let bg = 'blue'
      let g:vimuxline_mode = 't'
    elseif (a:mode == 'v')
      let bg = 'magenta'
      let g:vimuxline_mode = 'v'
    elseif (a:mode == 'n')
      let bg = 'green'
      let g:vimuxline_mode = 'n'
    elseif (a:mode == 'fl')
      let bg = 'white'
    endif

    call system('tmux set -g window-status-current-format "#[fg=#282C34,bg='.bg.',noitalics]#[fg=black,bg='.bg.'] #I #[fg=black, bg='.bg.'] #W #[fg='.bg.', bg=#282C34]"')
  endif
endfunction

augroup Vimmuxline
  autocmd!
  autocmd InsertEnter * call <SID>ChangeTmuxActiveTab('i')
  autocmd TermEnter * call <SID>ChangeTmuxActiveTab('t')
  autocmd InsertLeave,TermLeave * call <SID>ChangeTmuxActiveTab('n')
  autocmd VimEnter,FocusGained,VimResume * call <SID>OnFocusGained()
  autocmd VimLeave,FocusLost,VimSuspend * call <SID>ChangeTmuxActiveTab('fl')

  autocmd CursorHold *
        \ if exists('g:is_visual_mode') && g:is_visual_mode == 1 |
        \   exe "call <SID>VisualLeave()" |
        \ endif
augroup end

let g:vimuxline_mode = 'n'
" vnoremap <silent> <expr> <SID>VisualEnter VisualEnter()
nnoremap <silent> <script> v :call <SID>VisualEnter()<CR>v
nnoremap <silent> <script> V :call <SID>VisualEnter()<CR>V
nnoremap <silent> <script> <C-v> :call <SID>VisualEnter()<CR><C-v>

function! s:VisualEnter()
  let g:is_visual_mode = 1
  let s:updatetime = &updatetime
  set updatetime=0
  call <SID>ChangeTmuxActiveTab('v')
endfunction

function! s:VisualLeave()
  let g:is_visual_mode = 0
  exe 'set updatetime=' . s:updatetime
  call <SID>ChangeTmuxActiveTab('n')
endfunction

function! s:OnFocusGained()
  func! VimuxLineTimerHabdler(timer)
    call <SID>ChangeTmuxActiveTab(g:vimuxline_mode)
  endfunc
  let timer = timer_start(10, 'VimuxLineTimerHabdler')
endfunction

