let s:close_bufnr = 0

function! hasan#float#_createCenteredFloatingWindow(edit_file_bufnr, listed, user_options)
  let width = min([&columns - 4, max([80, &columns - 20])])
  let height = min([&lines - 4, max([20, &lines - 10])])
  let top = ((&lines - height) / 2) - 1
  let left = (&columns - width) / 2
  let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal', 'focusable': 0 }

  " Border window
  let top = "╭" . repeat("─", width - 2) . "╮"
  let mid = "│" . repeat(" ", width - 2) . "│"
  let bot = "╰" . repeat("─", width - 2) . "╯"
  if get(a:user_options, 'bufname', '') != ''
    let label = '[ '. a:user_options.bufname .' ]'
    let bot = "╰" . repeat("─", width - (2 + 1 + len(label))) .label. "─╯"
  endif
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
  call setwinvar(s:winnr, '&winhighlight', 'Normal:Fedit')
  " set user configs
  let style = get(a:user_options, 'style', 0)
  if _#isDict(style)
    for key in keys(style)
      call setwinvar(s:winnr, key, get(style, key))
    endfor
  endif

  " autocmd: close window & buffer
  au WinLeave * ++once call nvim_win_close(s:bd_winnr,1) | call nvim_win_close(s:winnr,1)
  if a:listed == 0
    " if user runs Fedit! in sequence
    if s:close_bufnr != 0
      call timer_stop(s:close_buf_timer)
      if s:close_bufnr != a:edit_file_bufnr | call s:unload_float_buffer() | endif
    endif

    let s:close_bufnr = a:edit_file_bufnr
    au WinLeave * ++once let s:close_buf_timer = timer_start(500, function('s:unload_float_buffer'))
  endif
endfunction

function s:unload_float_buffer(...) abort
  if s:close_bufnr != 0
    exec 'bd '.s:close_bufnr
    let s:close_bufnr = 0
  endif
endfunction

" bang !: remove buffer for buflist
function! hasan#float#_fedit(fname, bang)
  if !filereadable(a:fname)
    call _#echoError('File not found')
    return
  endif

  " get bufnr
  exe 'pedit '. a:fname
  wincmd P
  let edit_file_bufnr = bufnr()
  quit

  let options = {
    \'bufname': fnamemodify(bufname(edit_file_bufnr), ':.'),
    \'style': {
    \  '&nu': '1',
    \  '&rnu': '1',
    \  '&cursorline': '1',
    \  '&signcolumn': 'yes',
    \  }
    \}
  let listed = a:bang == '!' ? 0 : 1
  call hasan#float#_createCenteredFloatingWindow(edit_file_bufnr, listed, options)
endfunction


