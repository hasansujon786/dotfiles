let s:status_color={
    \ 'green'  : '#98C379',
    \ 'magenta': '#C678DD',
    \ 'blue'   : '#61AFEF',
    \ 'red'    : '#E06C75',
    \}

function! s:OnModeChange(mode)
  if(a:mode == 'i')
    let bg = v:insertmode == 'i' ? 'blue' : 'red'
  elseif (a:mode == 't')
    let bg = 'blue'
  elseif (a:mode == 'v')
    let bg = 'magenta'
  elseif (a:mode == 'n')
    let bg = 'green'
  endif

  exe 'hi User1 guibg='.s:status_color[bg].' guifg=#2C323C gui=bold'
  exe 'hi User2 guifg='.s:status_color[bg].' guibg=#3E4452 gui=bold'

  if exists('$TMUX')
    let g:vimuxline_mode = a:mode
    call s:updateVimuxLine(bg)
  endif
endfunction

augroup DetectCurrentMode
  autocmd!
  autocmd InsertEnter * call <SID>OnModeChange('i')
  autocmd InsertLeave,TermLeave * call <SID>OnModeChange('n')
  autocmd TermEnter * call <SID>OnModeChange('t')
  " Custom VisualLeave
  autocmd CursorHold *
        \ if exists('g:is_visual_mode') && g:is_visual_mode == 1 |
        \   exe "call <SID>VisualLeave()" |
        \ endif


  autocmd VimEnter,FocusGained,VimResume * call <SID>OnFocusGained()
  autocmd VimLeave,FocusLost,VimSuspend * call <SID>OnFocusLost()
augroup end

function! s:OnFocusGained()
  func! VimuxLineTimerHabdler(timer)
    call <SID>OnModeChange(g:vimuxline_mode)
  endfunc
  let timer = timer_start(10, 'VimuxLineTimerHabdler')
endfunction

function! s:OnFocusLost()
  if exists('$TMUX')
    call s:updateVimuxLine('white')
  endif
endfunction

" vnoremap <silent> <expr> <SID>VisualEnter VisualEnter()
nnoremap <silent> <script> v :call <SID>VisualEnter()<CR>v
nnoremap <silent> <script> V :call <SID>VisualEnter()<CR>V
nnoremap <silent> <script> <C-v> :call <SID>VisualEnter()<CR><C-v>

function! s:VisualEnter()
  let g:is_visual_mode = 1
  let s:updatetime = &updatetime
  set updatetime=0
  call <SID>OnModeChange('v')
endfunction

function! s:VisualLeave()
  let g:is_visual_mode = 0
  exe 'set updatetime=' . s:updatetime
  call <SID>OnModeChange('n')
endfunction

let g:vimuxline_mode = 'n'
function s:updateVimuxLine(bg)
  call system('tmux set -g window-status-current-format "#[fg=#282C34,bg='.a:bg.',noitalics]#[fg=black,bg='.a:bg.'] #I #[fg=black, bg='.a:bg.'] #W #[fg='.a:bg.', bg=#282C34]"')
endfunction
