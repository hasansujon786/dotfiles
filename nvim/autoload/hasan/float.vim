function! hasan#float#_createCenteredFloatingWindow(edit_bufnr)
  let width = min([&columns - 4, max([80, &columns - 20])])
  let height = min([&lines - 4, max([20, &lines - 10])])
  let top = ((&lines - height) / 2) - 1
  let left = (&columns - width) / 2
  let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal', 'focusable': 0 }

  " Border window
  let top = "╭" . repeat("─", width - 2) . "╮"
  let mid = "│" . repeat(" ", width - 2) . "│"
  let bot = "╰" . repeat("─", width - 2) . "╯"
  let lines = [top] + repeat([mid], height - 2) + [bot]
  let bd_bufnr = nvim_create_buf(v:false, v:true)
  call nvim_buf_set_lines(bd_bufnr, 0, -1, v:true, lines)
  let s:bd_winnr = nvim_open_win(bd_bufnr, v:false, opts)
  call setwinvar(s:bd_winnr, '&filetype', 'floating')
  call setwinvar(s:bd_winnr, '&winhighlight', 'Normal:Floating')

  " Front window
  let opts.focusable = 1
  let opts.row += 1
  let opts.height -= 2
  let opts.col += 2
  let opts.width -= 4
  if _#isNumber(a:edit_bufnr) && a:edit_bufnr != 0
    let s:winnr = nvim_open_win(a:edit_bufnr, v:true, opts)
  else
    let s:winnr = nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    call setwinvar(s:winnr, '&filetype', 'floating')
  endif
  call setwinvar(s:winnr, '&winhighlight', 'Normal:Floating')
  let b:Fedit_bufnr = bufnr()

  au WinLeave * ++once call nvim_win_close(s:bd_winnr,1) | call nvim_win_close(s:winnr,1)
endfunction

function! hasan#float#_fedit(fname)
  if !filereadable(a:fname)
    call _#echoError('File not found')
    return
  endif
  if(exists('b:Fedit_bufnr'))
    exe 'edit '.a:fname
    let b:Fedit_bufnr = bufnr()
    return
  endif

  exe 'pedit '. a:fname
  wincmd P
  let bufnr = bufnr()
  quit
  call hasan#float#_createCenteredFloatingWindow(bufnr)
endfunction


