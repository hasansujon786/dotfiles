
function! hasan#utils#buffer#_save() abort "{{{
  update
  call timer_start(800, '_echo')
endfunction
function! _echo(...) abort
  echo ''
endfunction
" }}}

function! hasan#utils#buffer#_clear() abort "{{{
  " Don't close window, when deleting a buffer
  let currentBufNum = bufnr('%')
  let alternateBufNum = bufnr('#')
  let bdcmd = 'bdelete '

  if (&modified)
    call _#echoWarn('>>> Save this buffer before close? <<<')
    let choice = confirm('', "&Yes\n&No\n&Cancel", 3)
    if (choice == 1)
      exec('silent w')
    elseif (choice == 2)
      let bdcmd = 'bdelete! '
    elseif(choice == 3)
      return 0
    endif
  endif

  if buflisted(alternateBufNum)
    buffer #
  else
    try
      bnext
    catch
      call _#echoWarn('There is no buffer anymore')
      return
    endtry
  endif

  if bufnr('%') == currentBufNum
    execute('Dashboard')
  endif

  if buflisted(currentBufNum)
    execute('silent '.bdcmd.currentBufNum)
  endif
endfunction " }}}

function! hasan#utils#buffer#_clear_other() abort "{{{
  call _#echoWarn('>>> Kill other buffers? <<<')
  if confirm('', "&Yes\n&No\n&Cancel", 3) == 1
    :silent wa
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
endfunction "}}}

function! hasan#utils#buffer#_clear_all() abort "{{{
  call _#echoWarn('>>> Kill all buffers? <<<')
  if confirm('', "&Yes\n&No\n&Cancel", 3) == 1
    :silent wa
    let blisted = filter(range(1, bufnr('$')), 'buflisted(v:val)')
    for i in blisted
      try
        exe 'bw ' . i
      catch
      endtry
    endfor
    exec('Dashboard')
  endif
endfunction "}}}

function! hasan#utils#buffer#_open_scratch_buffer() abort "{{{
  for winNr in range(1, winnr('$'))
    let bufNr = winbufnr(winNr)
    if getbufvar(bufNr, '&filetype') == 'scratchpad'
      exe winNr.'wincmd w'
      return
    endif
  endfor

  exe('sp '.stdpath('data').'/scratchpad')
  wincmd J
  set signcolumn=no
  set filetype=scratchpad
  set nobuflisted
  resize 8
  au! WinLeave,BufLeave <buffer> :silent w
endfunction "}}}


