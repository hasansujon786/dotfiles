function! hasan#float#_createCenteredFloatingWindow(edit_file_bufnr, user_options)
  let window = get(a:user_options, 'window', {'width': 0.8, 'height': 0.7})
  let listed = get(a:user_options, 'listed', 1)

  let winids = []
  let bufids = []
  let width = float2nr(&columns * window.width)
  let height = float2nr(&lines * window.height)
  let top = (&lines - height) / 2
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
  " bufids[0]
  call add(bufids, nvim_create_buf(v:false, v:true))
  call nvim_buf_set_lines(bufids[0], 0, -1, v:true, lines)
  " winids[0]
  call add(winids, nvim_open_win(bufids[0], v:false, opts))
  call setwinvar(winids[0], '&filetype', 'floating')
  call setwinvar(winids[0], '&winhighlight', 'Normal:FeditBorder')

  " Front window
  let opts.focusable = 1
  let opts.row += 1
  let opts.height -= 2
  let opts.col += 2
  let opts.width -= 4
  if _#isNumber(a:edit_file_bufnr) && a:edit_file_bufnr != 0
    " winids[1]
    call add(winids, nvim_open_win(a:edit_file_bufnr, v:true, opts))
    if listed == 0 | setlocal nobuflisted | endif
  else " create a scratch buffer
    " bufids[1]
    call add(bufids, nvim_create_buf(v:false, v:true))
    " winids[1]
    call add(winids, nvim_open_win(bufids[1], v:true, opts))
    call setwinvar(winids[1], '&filetype', 'fedit')
  endif
  call setwinvar(winids[1], '&winhighlight', 'Normal:Fedit')
  " set user configs
  let style = get(a:user_options, 'style', 0)
  if _#isDict(style)
    for key in keys(style)
      call setwinvar(winids[1], key, get(style, key))
    endfor
  endif

  " autocmd: close window
  exec printf('au WinLeave * ++once call s:close_float_window(%s, %s,)', winids, bufids)
endfunction

function s:close_float_window(winlist, buflist) abort
  for winid in a:winlist
    call nvim_win_close(winid, 0)
  endfor
  call timer_start(300, function('s:wipe_buffers', [a:buflist]))
endfunction

function s:wipe_buffers(buflist, ...) abort
  for bufid in a:buflist
    exec 'bw '.bufid
  endfor
endfunction


" bang !: remove buffer for buflist
function! hasan#float#_fedit(fname, listed, options)
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
    \ 'window': get(a:options, 'window', {'width': 0.9, 'height': 0.8}),
    \ 'bufname': get(a:options, 'bufname', fnamemodify(bufname(edit_file_bufnr), ':.')),
    \ 'listed': a:listed,
    \ 'style': get(a:options, 'style',{
    \   '&nu': '1',
    \   '&rnu': '1',
    \   '&cursorline': '1',
    \   '&signcolumn': 'auto',
    \  }),
    \}
  call hasan#float#_createCenteredFloatingWindow(edit_file_bufnr,  options)
endfunction
