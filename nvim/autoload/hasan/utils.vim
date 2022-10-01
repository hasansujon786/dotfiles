function! hasan#utils#confirmQuit(writeFile) "{{{
  let list_open_wins = filter(nvim_list_wins(), {k,v->nvim_win_get_config(v).relative == ""})
  let isLastTab = len(list_open_wins)==1 && list_open_wins[0] == win_getid() && tabpagenr('$')==1
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
endfunction "}}}

" Allow j and k to work on visual lines (when wrapping)
function! hasan#utils#toggleWrap() "{{{
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
endfunction "}}}

function! hasan#utils#placeholderImgTag(size) "{{{
  let url = 'http://dummyimage.com/' . a:size . '/000000/555555'
  let [width,height] = split(a:size, 'x')
  return "<img src=\"".url."\" width=\"".width."\" height=\"".height."\" />"
endfunction "}}}

function! hasan#utils#clear_register() abort "{{{
  let rs = split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
  for r in rs
    call setreg(r, [])
  endfor
endfunction "}}}

function! hasan#utils#delete_view(bang) abort "{{{
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
endfunction "}}}

" Pressing * or # searches for the current selection
function! hasan#utils#visualSelection(direction, extra_filter) range "{{{
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
endfunction "}}}

" Move VISUAL LINE selection within buffer
function! hasan#utils#visual_move_up() abort range "{{{
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
function! s:Visual()
  return visualmode() == 'V'
endfunction
function! s:Move(address, should_move)
  if s:Visual() && a:should_move
    execute "'<,'>move " . a:address
    call feedkeys('gv=', 'n')
  endif
  call feedkeys('gv', 'n')
endfunction "}}}

function! hasan#utils#CopyFileNameToClipBoard(bang) abort "{{{
  if expand('%') == ''
    call _#echoWarn('Couldn’t copy the filename')
    return
  endif

  if a:bang ==# 0
    let @+ = expand('%:t')
  else
    let @+ = expand('%:~')
  endif
  call _#Echo(['TextInfo', 'Copied to clipboard:'], '“'.@+.'”')
endfunction "}}}

function! hasan#utils#file_info() "{{{
  let fname = ['', expand('%') == '' ? '“[No Name]“' : '“'.expand('%:.').'“']
  let lines = ['WarningMsg', line('$').' lines']
  let scroll = ['TextSuccess', '--'.(line('.') * 100) / line('$').'%--']
  let readAndMod = ['ErrorMsg', &readonly ? '[Readonly]' : &modified ? '[Modified]' : '']

  call _#Echo(['TextInfo','File Info:'], fname, lines, scroll, readAndMod)
endfunction "}}}

function! hasan#utils#_filereadable_and_create(file, create) abort "{{{
  let file_path = fnamemodify(a:file, ':p')
  let exists = filereadable(file_path)
  if !exists && a:create
    call system('mkdir -p '.fnamemodify(file_path, ':h'))
    call system('touch '.file_path)
  endif
  return exists
endfunction "}}}

function! hasan#utils#_buflisted_sorted() abort "{{{
  return sort(s:list_bufs(), 's:sort_buffers')
endfunction

function! s:list_bufs()
  return filter(nvim_list_bufs(), 'buflisted(v:val) && getbufvar(v:val, "&filetype") != "qf"')
endfunction
function! s:sort_buffers(...)
  let [b1, b2] = map(copy(a:000), 'get(g:hasan_telescope_buffers, v:val, v:val)')
  " Using minus between a float and a number in a sort function causes an error
  return b1 < b2 ? 1 : -1
endfunction
"}}}

function! hasan#utils#_uniq(list) " {{{
  let visited = {}
  let ret = []
  for l in a:list
    if !empty(l) && !has_key(visited, l)
      call add(ret, l)
      let visited[l] = 1
    endif
  endfor
  return ret
endfunction
" }}}

function! hasan#utils#foldtext() " {{{
  let line = getline(v:foldstart)
  let nucolwidth = &fdc + &number * &numberwidth
  let windowwidth = winwidth(0) - nucolwidth - 3
  let foldedlinecount = (v:foldend-v:foldstart+1)

  " expand tabs into spaces
  let onetab = strpart('          ', 0, &tabstop)
  let line = substitute(line, '\t', onetab, 'g')

  let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
  let fillcharcount = windowwidth - len(line)

  return line .' ['.foldedlinecount.'ℓ]'. repeat(" ",fillcharcount)
endfunction
" }}}

function! hasan#utils#get_visual_selection() "{{{
  if mode()=="v"
    let [line_start, column_start] = getpos("v")[1:2]
    let [line_end, column_end] = getpos(".")[1:2]
  else
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
  end
  if (line2byte(line_start)+column_start) > (line2byte(line_end)+column_end)
    let [line_start, column_start, line_end, column_end] =
          \   [line_end, column_end, line_start, column_start]
  end
  let lines = getline(line_start, line_end)
  if len(lines) == 0
    return ''
  endif
  let lines[-1] = lines[-1][: column_end - 1]
  let lines[0] = lines[0][column_start - 1:]
  return join(lines, "\n")
endfunction "}}}

function! hasan#utils#feedkeys(key, mode) abort "{{{
  call nvim_feedkeys(nvim_replace_termcodes(a:key, v:true, v:true, v:true), a:mode, v:true)
endfunction "}}}

function! hasan#utils#better_substitute() "{{{
  if mode() == 'v'
    let word = hasan#utils#get_visual_selection()
    call hasan#utils#feedkeys(':<c-u>%s/'.. word ..'//gc<Left><Left><Left>', 'n')
  else
    call hasan#utils#feedkeys(':%s/\<<C-r><C-w>\>//gc<Left><Left><Left>', 'n')
  endif
endfunction "}}}
