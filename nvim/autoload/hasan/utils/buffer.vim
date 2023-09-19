
function! hasan#utils#buffer#_save() abort "{{{
  write
  call timer_start(800, '_echo')
endfunction
function! _echo(...) abort
  echo ''
endfunction
" }}}

function! hasan#utils#buffer#_clear() abort "{{{
  " Don't close window, when deleting a buffer
  let cur_buf = bufnr('%')
  let alt_buf = bufnr('#')
  let buf_del_cmd = 'silent bdelete '

  if (&modified)
    let choice = confirm('>>> Save this buffer before close? <<<', "&Yes\n&No\n&Cancel", 3)
    if (choice == 1)
      exec('silent w')
    elseif (choice == 2)
      let buf_del_cmd = 'silent bdelete! '
    elseif(choice == 3)
      return
    endif
  endif

  " Destroy win if it is not modifiable window
  if &modifiable == 0
    execute(buf_del_cmd.cur_buf)
    return
  endif

  if buflisted(alt_buf)
    buffer #
  else
    try
      bnext
    catch
      call _#echoWarn('There is no buffer anymore')
      return
    endtry
  endif

  " Show dashboard if there is no other buffer
  if bufnr('%') == cur_buf || bufname('%') == ''
    execute('Alpha')
  endif

  if buflisted(cur_buf)
    execute(buf_del_cmd.cur_buf)
  endif
endfunction " }}}

function! hasan#utils#buffer#_clear_other() abort "{{{
  if confirm('>>> Kill other buffers? <<<', "&Yes\n&No", 2) == 1
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
  if confirm('>>> Kill all buffers? <<<', "&Yes\n&No", 2) == 1
    :silent wa
    let blisted = filter(range(1, bufnr('$')), 'buflisted(v:val)')
    for i in blisted
      try
        exe 'bw ' . i
      catch
      endtry
    endfor
    execute('Alpha')
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


