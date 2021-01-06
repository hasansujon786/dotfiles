let g:vim_current_mode = 'n'

function! s:OnModeChange(mode)
  let g:vim_current_mode = a:mode
  if(a:mode == 'i')
    let g:vim_current_mode = v:insertmode == 'i' ? 'i' : 'r'
  endif

  " callbacks
  call _update_vim_mode_color(a:mode)
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
augroup end
" Custom VisualEnter
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

