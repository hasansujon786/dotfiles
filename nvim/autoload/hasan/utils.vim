" ConfirmQuit {{{
function! hasan#utils#confirmQuit(writeFile)
  let isLastTab = winnr('$')==1 && tabpagenr('$')==1

  if (expand('%:t')=="" && isLastTab && &modified)
    echohl ErrorMsg | echo  "E32: No file name" | echohl None
    return
  endif
  if (a:writeFile == '!' && &modified) | :silent write | endif

  if (isLastTab && &modified)
    call _#echoWarn('>>> Save this buffer & quit the app? <<<')
    if (confirm("", "&Yes\n&No", 2) == 1)| :wq |endif
  elseif (isLastTab)
    call _#echoSuccess('>>> Do you want to quit the app? <<<')
    if (confirm("", "&Yes\n&No", 2)==1)| :quit |endif
  else
    :quit
  endif
endfunction
" }}}

" Toggle quickfix window {{{
function! hasan#utils#quickFix_toggle()
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

" Toggle wrap {{{
" Allow j and k to work on visual lines (when wrapping)
function! hasan#utils#toggleWrap()
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

" PlaceholderImgTag 300x200 {{{
function! hasan#utils#placeholderImgTag(size)
  let url = 'http://dummyimage.com/' . a:size . '/000000/555555'
  let [width,height] = split(a:size, 'x')
  execute "normal a<img src=\"".url."\" width=\"".width."\" height=\"".height."\" />"
endfunction
" }}}

" Bclose {{{
" Don't close window, when deleting a buffer
function! hasan#utils#bufcloseCloseIt()
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
function! hasan#utils#clear_register() abort
  let rs = split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
  for r in rs
    call setreg(r, [])
  endfor
endfunction
" }}}

" Delete view {{{
function! hasan#utils#delete_view(bang) abort
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
" }}}

" GetChar {{{
function! hasan#utils#getchar() abort
  redraw | echo 'Press any key: '
  let c = getchar()
  while c ==# "\<CursorHold>"
    redraw | echo 'Press any key: '
    let c = getchar()
  endwhile
  redraw | echo printf('Raw: "%s" | Char: "%s"', c, nr2char(c))
endfunction
" }}}

" Insert UUID by {{{
" @todo: fix this
function! s:Utils_uuid() abort
  let r = system('uuidgen')
  let r = substitute(r, '^[\r\n\s]*\|[\r\n\s]*$', '', 'g')
  return r
endfunction
" inoremap <silent> <F2> <C-r>=<SID>s:Utils_uuid()<CR>
" }}}

" Auto Zoom Widnow {{{

" this is new to set for autocmd
function! hasan#utils#azw() abort
  if exists('g:auto_zoom_window') && g:auto_zoom_window == 1
    wincmd _
    wincmd |
  endif
endfunction

function! hasan#utils#auto_zoom_window() abort
  if !exists('g:auto_zoom_window') || g:auto_zoom_window == 0
    let g:auto_zoom_window = 1
    wincmd _
    wincmd |
    echo 'Auto zoom on'
  else
    let g:auto_zoom_window = 0
    wincmd =
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
function! hasan#utils#visualSelection(direction, extra_filter) range
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

" Cycle through relativenumber + number, number (only), and no numbering {{{
function!  hasan#utils#cycle_numbering() abort
  if exists('+relativenumber')
    execute {
          \ '00': 'set relativenumber   | set number',
          \ '01': 'set norelativenumber | set number',
          \ '10': 'set norelativenumber | set nonumber',
          \ '11': 'set norelativenumber | set number' }[&number . &relativenumber]
  else
    " No relative numbering, just toggle numbers on and off.
    set number!
  endif
endfunction
" }}}

" Move VISUAL LINE selection within buffer {{{
function! s:Visual()
  return visualmode() == 'V'
endfunction
function! s:Move(address, should_move)
  if s:Visual() && a:should_move
    execute "'<,'>move " . a:address
    call feedkeys('gv=', 'n')
  endif
  call feedkeys('gv', 'n')
endfunction
function! hasan#utils#visual_move_up() abort range
  let l:count=v:count ? -v:count : -1
  let l:max=(a:firstline - 1) * -1
  let l:movement=max([l:count, l:max])
  let l:address="'<" . (l:movement - 1)
  let l:should_move=l:movement < 0
  call s:Move(l:address, l:should_move)
endfunction
function! hasan#utils#visual_move_down() abort range
  let l:count=v:count ? v:count : 1
  let l:max=line('$') - a:lastline
  let l:movement=min([l:count, l:max])
  let l:address="'>+" . l:movement
  let l:should_move=l:movement > 0
  call s:Move(l:address, l:should_move)
endfunction
" }}}

" CopyFileNameToClipBoard {{{ "
function! hasan#utils#CopyFileNameToClipBoard(bang) abort
  if expand('%') == ''
    call _#echoWarn('Couldn’t copy the filename')
    return
  endif

  if a:bang ==# '!'
    let @+ = expand('%:t')
  else
    let @+ = expand('%:~')
  endif
  call _#Echo(['TextInfo', 'Copied to clipboard:'], '“'.@+.'”')
endfunction
" }}} CopyFileNameToClipBoard "

" clear_buffers {{{ "
function! hasan#utils#clear_buffers() abort
  if confirm('Kill all other buffers?', "&Yes\n&No\n&Cancel", 3) == 1
    let blisted = filter(range(1, bufnr('$')), 'buflisted(v:val)')
    for i in blisted
      if i != bufnr('%')
        try
          exe 'bw ' . i
        catch
        endtry
      endif
    endfor
  endif
endfunction
" }}} clear_buffers "

" MaximizesWinToggle {{{
function! hasan#utils#MaximizesWinToggle()
  if(winnr('$') > 1)
    if exists('t:maximize_win_sizes')
      call s:restore()
    elseif ((&columns - 5) > winwidth(0) || (&lines - 5) > winheight(0))
      let t:maximize_win_sizes = { 'before': winrestcmd() , 'winnr': winnr('$')}
      vert resize | resize
      let t:maximize_win_sizes.after = winrestcmd()
      normal! ze
    else
      wincmd =
    endif
  endif
endfunction

function! hasan#utils#JumpToWin(direction)
  exe 'wincmd '.a:direction
  if exists('t:maximize_win_sizes')
    call s:restore()
  endif
endfunction

function! s:restore()
  if exists('t:maximize_win_sizes')
    if (t:maximize_win_sizes.winnr == winnr('$'))
      silent! exe t:maximize_win_sizes.before
    else
      wincmd =
    endif
    unlet t:maximize_win_sizes
    normal! ze
  endif
endfunction
" }}}

" file_info {{{
function! hasan#utils#file_info()
  let fname = ['', expand('%') == '' ? '“[No Name]“' : '“'.expand('%:.').'“']
  let lines = ['WarningMsg', line('$').' lines']
  let scroll = ['TextSuccess', '--'.(line('.') * 100) / line('$').'%--']
  let readAndMod = ['ErrorMsg', &readonly ? '[Readonly]' : &modified ? '[Modified]' : '']

  call _#Echo(['TextInfo','File Info:'], fname, lines, scroll, readAndMod)
endfunction
" }}}

" RefactorWordInProject {{{
function! hasan#utils#refactorWordInProject(...)
  let args = join(a:000, '\ ')
  let @/ = args
  exe 'CocSearch -F '.args
endfunction
" }}}

