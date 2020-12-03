let g:win_ctrl_buf_list = {} "{ctrlId : [job_id, bufnr]}
fun! hasan#term#SetBuffer(ctrlId)
  if has_key(b:, "terminal_job_id") == 0
    echo "You must be in a terminal to execute this command"
    return
  end
  if (len(a:ctrlId) != 1)
    echo "CtrlID must be a single character"
    return
  end

  let g:win_ctrl_buf_list[a:ctrlId] = [b:terminal_job_id, nvim_win_get_buf(0)]
  execute("nmap <silent><leader>[".a:ctrlId." :GoToTerminal ".a:ctrlId."<CR>")

  echo "Terminal CtrlID: " .a:ctrlId
endfun

fun! hasan#term#GotoBuffer(ctrlId)
  if (len(a:ctrlId) != 1)
    echo "CtrlID must be a single character"
    return
  end
  if has_key(g:win_ctrl_buf_list, a:ctrlId) == 0
    echo "There is no terminal with CtrlID: ".a:ctrlId
    execute("unmap <silent><leader>[".a:ctrlId)
    return
  end
  let termBufNum = g:win_ctrl_buf_list[a:ctrlId][1]
  if !buflisted(l:termBufNum)
    echo "Buffer ".l:termBufNum." dose not exist anymore"
    return
  endif

  execute("buffer " .l:termBufNum)
  normal! G
endfun

fun! hasan#term#SendTerminalCommand(...)
  let ctrlId = a:1
  if (len(l:ctrlId) != 1)
    echo "CtrlID must be a single character"
    return
  end
  if has_key(g:win_ctrl_buf_list, l:ctrlId) == 0
    echo "There is no terminal with CtrlID: ".l:ctrlId
    return
  end
  if len(a:000) < 2
    echo "There is no command to run"
    return
  end

  let command = join(a:000[1:], ' ')
  let job_id = g:win_ctrl_buf_list[l:ctrlId][0]

  call chansend(l:job_id, l:command."\n")
endfun
