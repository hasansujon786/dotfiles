" quick_term.vim {{{
nmap <silent> ]t :GoToNextTerminal<CR>
nmap <silent> [t :GoToPreviousTerminal<CR>
command! -nargs=1 SetTerminal call hasan#term#SetBuffer(<f-args>)
command! -nargs=1 GoToTerminal call hasan#term#GotoBuffer(<f-args>)
command! -nargs=+ SendTerminalCommand call hasan#term#SendTerminalCommand(<f-args>)
command! AllTerminalIds echo keys(g:term_ctrlId_buf_list)
command! GoToPreviousTerminal call hasan#term#GotoPreviousTerm()
command! GoToNextTerminal call hasan#term#GotoNextTerm()
" }}}

if !exists('g:term_ctrlId_buf_list')
  let g:term_ctrlId_buf_list = {} "{ctrlId : [job_id, bufnr]}
  let g:term_last_term_ctrlId = ''
endif

fun! hasan#term#SetBuffer(ctrlId)
  if (len(a:ctrlId) != 1)
    echo "CtrlID must be a single character"
    return
  end
  if has_key(g:term_ctrlId_buf_list, a:ctrlId)
    echo 'CtrlID: '.a:ctrlId.' already been used with another term'
    return
  endif
  if !has_key(b:, "terminal_job_id")
    exe 'terminal'
  elseif has_key(b:, "terminal_job_id") && has_key(b:, 'term_ctrlId')
    echo 'This term already been used with CtrlID: '.b:term_ctrlId
    return
  end

  let b:term_ctrlId = a:ctrlId
  let g:term_last_term_ctrlId = a:ctrlId
  let g:term_ctrlId_buf_list[a:ctrlId] = [b:terminal_job_id, nvim_win_get_buf(0)]
  execute("nmap <silent><leader>[".a:ctrlId." :GoToTerminal ".a:ctrlId."<CR>")

  echo "Terminal CtrlID: " .a:ctrlId
endfun

fun! hasan#term#GotoBuffer(ctrlId)
  if (len(a:ctrlId) != 1)
    echo "CtrlID must be a single character"
    return
  end
  if has_key(g:term_ctrlId_buf_list, a:ctrlId) == 0
    echo "There is no terminal with CtrlID: ".a:ctrlId
    execute("unmap <silent><leader>[".a:ctrlId)
    return
  end
  let termBufNum = g:term_ctrlId_buf_list[a:ctrlId][1]
  if !buflisted(l:termBufNum)
    echo "Buffer ".l:termBufNum." dose not exist anymore"
    return
  endif

  let g:term_last_term_ctrlId = a:ctrlId
  execute("buffer " .l:termBufNum)
  normal! G
endfun

function! s:gotoLastTerm()
  if (g:term_last_term_ctrlId == '')
    echo "You haven't set any terminals yet"
    return
  endif
  call hasan#term#GotoBuffer(g:term_last_term_ctrlId)
endfunction

function! hasan#term#GotoPreviousTerm()
  if !has_key(b:, 'term_ctrlId')
    return s:gotoLastTerm()
  endif

  let allCtrlIds = keys(g:term_ctrlId_buf_list)
  let curIdx = index(allCtrlIds, b:term_ctrlId)
  let preIdx = curIdx == index(allCtrlIds, allCtrlIds[0]) ? -1 : curIdx - 1
  let preCtrlId = allCtrlIds[preIdx]

  return hasan#term#GotoBuffer(preCtrlId)
endfunction

function! hasan#term#GotoNextTerm()
  if !has_key(b:, 'term_ctrlId')
    return s:gotoLastTerm()
  endif

  let allCtrlIds = keys(g:term_ctrlId_buf_list)
  let curIdx = index(allCtrlIds, b:term_ctrlId)
  let nextIdx = curIdx == index(allCtrlIds, allCtrlIds[-1]) ? 0 : curIdx + 1
  let nextCtrlId = allCtrlIds[nextIdx]

  return hasan#term#GotoBuffer(nextCtrlId)
endfunction

fun! hasan#term#SendTerminalCommand(...)
  let ctrlId = a:1
  if (len(l:ctrlId) != 1)
    echo "CtrlID must be a single character"
    return
  end
  if has_key(g:term_ctrlId_buf_list, l:ctrlId) == 0
    echo "There is no terminal with CtrlID: ".l:ctrlId
    return
  end
  if len(a:000) < 2
    echo "There is no command to run"
    return
  end

  let command = join(a:000[1:], ' ')
  let job_id = g:term_ctrlId_buf_list[l:ctrlId][0]

  call chansend(l:job_id, l:command."\n")
endfun

function! Flatten(list)
  let val = []
  for elem in a:list
    if type(elem) == type([])
      call extend(val, Flatten(elem))
    else
      call add(val, elem)
    endif
    unlet elem
  endfor
  return val
endfunction
