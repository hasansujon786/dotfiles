
function! hasan#utils#buffer#_clear() abort "{{{
  " Don't close window, when deleting a buffer
  let currentBufNum = bufnr('%')
  let alternateBufNum = bufnr('#')
  let bdcmd = 'bdelete '

  if (&modified)
    call _#echoWarn('>>> Save this buffer before close? <<<')
    let choice = confirm('', '&Yes\n&No', 1)
    if (choice == 2)
      let bdcmd = 'bdelete! '
    else
      :silent w
    endif
  endif

  if buflisted(alternateBufNum)
    buffer #
  else
    bnext
  endif

  if bufnr('%') == currentBufNum
    new
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
  endif
endfunction "}}}

