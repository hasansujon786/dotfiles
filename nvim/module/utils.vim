" Toggle quickfix window {{{
function! Utils_QuickFix_toggle()
  for i in range(1, winnr('$'))
    let bnum = winbufnr(i)
    if getbufvar(bnum, '&buftype') == 'quickfix'
      cclose
      return
    endif
  endfor
  copen
endfunction
" }}}

" Toggle line numbers {{{
function! Utils_ToggleNumber()
  if &number
    echo 'Number OFF'
    set nonumber norelativenumber
  else
    echo 'Number ON'
    set number relativenumber
  endif
endfunction
" }}}

" Toggle wrap {{{
" Allow j and k to work on visual lines (when wrapping)
function! Utils_ToggleWrap()
  if &wrap
    echo 'Wrap OFF'
    setlocal nowrap
    set virtualedit=all
  else
    echo 'Wrap ON'
    setlocal wrap linebreak nolist
    set virtualedit=
    setlocal display+=lastline
    inoremap <buffer> <silent> <Up> <C-o>gk
    inoremap <buffer> <silent> <Down> <C-o>gj
  endif
endfunction
" }}}

" TrimWhitespace  {{{
function! Utils_TrimWhitespace()
  let l:save = winsaveview()
  %s/\\\@<!\s\+$//e
  call winrestview(l:save)
endfunction
autocmd BufWritePre *.vim :call Utils_TrimWhitespace()
" }}}

" PlaceholderImgTag 300x200 {{{
function! s:Utils_PlaceholderImgTag(size)
  let url = 'http://dummyimage.com/' . a:size . '/000000/555555'
  let [width,height] = split(a:size, 'x')
  execute "normal a<img src=\"".url."\" width=\"".width."\" height=\"".height."\" />"
endfunction
command! -nargs=1 PlaceholderImgTag call s:Utils_PlaceholderImgTag(<f-args>)
" }}}

" Bclose {{{
" Don't close window, when deleting a buffer
command! Bclose call <SID>Utils_BufcloseCloseIt()
function! <SID>Utils_BufcloseCloseIt()
  let l:currentBufNum = bufnr("%")
  let l:alternateBufNum = bufnr("#")

  if buflisted(l:alternateBufNum)
    buffer #
  else
    bnext
  endif

  if bufnr("%") == l:currentBufNum
    new
  endif

  if buflisted(l:currentBufNum)
    execute("bdelete! ".l:currentBufNum)
  endif
endfunction
" }}}

" Register {{{
function! s:Utils_clear_register() abort
  let rs = split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
  for r in rs
    call setreg(r, [])
  endfor
endfunction
command! ClearRegister call s:Utils_clear_register()
" }}}

" Delete view {{{
function! s:Utils_delete_view(bang) abort
  if &modified && a:bang !=# '!'
    echohl WarningMsg
    echo 'Use bang to forcedly remove view file on modified buffer'
    echohl None
    return
  endif
  let path = substitute(expand('%:p:~'), '=', '==', 'g')
  let path = substitute(path, '/', '=+', 'g') . '='
  let path = printf('%s/%s', &viewdir, path)
  if filewritable(path)
    call delete(path)
    silent edit! %
    echo 'View file has removed: ' . path
  endif
endfunction
command! -bang Delview call s:Utils_delete_view(<q-bang>)
" }}}

" GetChar {{{
function! s:Utils_getchar() abort
  redraw | echo 'Press any key: '
  let c = getchar()
  while c ==# "\<CursorHold>"
    redraw | echo 'Press any key: '
    let c = getchar()
  endwhile
  redraw | echo printf('Raw: "%s" | Char: "%s"', c, nr2char(c))
endfunction
command! GetChar call s:Utils_getchar()
" }}}

" Insert UUID by {{{
" TODO: fix this
function! s:Utils_uuid() abort
  let r = system('uuidgen')
  let r = substitute(r, '^[\r\n\s]*\|[\r\n\s]*$', '', 'g')
  return r
endfunction
" inoremap <silent> <F2> <C-r>=<SID>s:Utils_uuid()<CR>
" }}}

" Auto Zoom Widnow {{{
command! AutoZoomWin call s:Utils_Auto_zoom_window()

function! Utils_azw() abort
  if exists('g:auto_zoom_window') && g:auto_zoom_window == 1
    wincmd _
    wincmd |
    vertical resize -5
  endif
endfunction

function! s:Utils_Auto_zoom_window() abort
  if !exists('g:auto_zoom_window') || g:auto_zoom_window == 0
    let g:auto_zoom_window = 1
    echo 'Auto zoom on'
  else
    let g:auto_zoom_window = 0
    echo 'Auto zoom off'
  endif
endfunction
" }}}

" ToggleBackground {{{
fun! Utils_ToggleBackground()
  if (&background ==? 'dark')
    set background=light
  else
    set background=dark
  endif
endfun
" }}}

" Pressing * or # searches for the current selection {{{
function! Utils_VisualSelection(direction, extra_filter) range
  let l:saved_reg = @"
  execute "normal! vgvy"

  let l:pattern = escape(@", "\\/.*'$^~[]")
  let l:pattern = substitute(l:pattern, "\n$", "", "")

  if a:direction == 'gv'
    call CmdLine("Ack '" . l:pattern . "' " )
  elseif a:direction == 'replace'
    call CmdLine("%s" . '/'. l:pattern . '/')
  endif

  let @/ = l:pattern
  let @" = l:saved_reg
endfunction
" }}}
