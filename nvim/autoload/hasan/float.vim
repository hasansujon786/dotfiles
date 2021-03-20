function! hasan#float#_createCenteredFloatingWindow(edit_file_bufnr, user_options)
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
  call setwinvar(s:bd_winnr, '&winhighlight', 'Normal:FeditBorder')

  " Front window
  let opts.focusable = 1
  let opts.row += 1
  let opts.height -= 2
  let opts.col += 2
  let opts.width -= 4
  if _#isNumber(a:edit_file_bufnr) && a:edit_file_bufnr != 0
    let s:winnr = nvim_open_win(a:edit_file_bufnr, v:true, opts)
  else
    " create a scratch buffer
    let s:winnr = nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    call setwinvar(s:winnr, '&filetype', 'fedit')
  endif
  let w:Fedit_bufnr = bufnr()
  call setwinvar(s:winnr, '&winhighlight', 'Normal:Fedit')
  " set user configs
  let style = get(a:user_options, 'style', 0)
  if _#isDict(style)
    for key in keys(style)
      call setwinvar(s:winnr, key, get(style, key))
    endfor
  endif

  au WinLeave * ++once call nvim_win_close(s:bd_winnr,1) | call nvim_win_close(s:winnr,1)
endfunction

function! hasan#float#_fedit(fname, bang)
  if !filereadable(a:fname)
    call _#echoError('File not found')
    return
  endif
  if(exists('w:Fedit_bufnr'))
    exe 'edit '.a:fname
    let w:Fedit_bufnr = bufnr()
    call setwinvar(0, '&winhighlight', 'Normal:Fedit')
    return
  endif

  exe 'pedit '. a:fname
  wincmd P
  let edit_file_bufnr = bufnr()
  quit
  let options = {
        \'style': {
        \  '&nu': '1',
        \  '&rnu': '1',
        \  '&cursorline': '1',
        \  '&signcolumn': 'yes',
        \}
        \}
  call hasan#float#_createCenteredFloatingWindow(edit_file_bufnr, a:bang == '!' ? {} : options)
endfunction


