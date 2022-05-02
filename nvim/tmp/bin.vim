" set shellpipe=2>&1\|tee
" if has('win32') || has('win64')
"     set shell=sh
"     set shellcmdflag=-c
"     set shellquote=
"     set shellxquote=
"     set noshelltemp
"     set shellslash

"     let g:python3_host_prog = 'c:/Windows/py.exe'
"     let g:loaded_python_provider = 1
" endif

vim.opt.list = true
vim.opt.listchars:append("space:⋅")
vim.opt.listchars:append("eol:↴")

function! s:MakeHeader(level) abort
    " s/\v^(#* )?/\=repeat('#', a:level).' '/
  call setline('.', repeat('#', a:level) . ' ' . getline('.'))
endfunction
nnoremap <silent> # :<c-u>call <sid>MakeHeader(v:count)<cr>

function! s:fill_quickfix(list, ...)
  if len(a:list) > 1
    call setqflist(a:list)
    copen
    wincmd p
    if a:0
      execute a:1
    endif
  endif
endfunction

" Some Readline Keybindings When In Insertmode
inoremap <expr> <C-B> getline('.')=~'^\s*$'&&col('.')> strlen(getline('.'))?"0\<Lt>C-D>\<Lt>Esc>kJs":"\<Lt>Left>"

augroup vimrc-incsearch-highlight
  autocmd!
  autocmd CmdlineEnter /,\? :set hlsearch
  autocmd CmdlineLeave /,\? :set nohlsearch
augroup END

if has("macunix") || has('win32')
  set clipboard=unnamed
elseif has("unix")
  set clipboard=unnamedplus
endif

" https://stackoverflow.com/a/20418591
au FocusGained,BufEnter * :silent! !
au FocusLost,WinLeave * :silent! w

" ZoomToggle {{{1
function! ZoomToggle()
  if exists('t:maximize_session')
    " Zoom allow edit the same file {{{2
    " only an issue if the file has an extra swap value
    augroup ZOOM
      autocmd!
      autocmd SwapExists * let v:swapchoice='e'
    augroup end
    " 2}}} "Zoom
    exec 'source ' . t:maximize_session
    call delete(t:maximize_session)
    unlet t:maximize_session
    let &hidden=t:maximize_hidden_save
    unlet t:maximize_hidden_save
  else
    "check that there is more then one window
    if (winnr('$') == 1) | return | endif
    let t:maximize_hidden_save = &hidden
    let t:maximize_session = tempname()
    set hidden
    exec 'mksession! ' . t:maximize_session
    only
  endif
endfunction
" 1}}} "ZoomToggle

" HorizontalScrollMode {{{
" nnoremap <silent> zh :call HorizontalScrollMode('h')<CR>
" nnoremap <silent> zl :call HorizontalScrollMode('l')<CR>
" nnoremap <silent> zH :call HorizontalScrollMode('H')<CR>
" nnoremap <silent> zL :call HorizontalScrollMode('L')<CR>
function! HorizontalScrollMode( call_char )
    if &wrap
        return
    endif

    echohl Title
    let typed_char = a:call_char
    while index( [ 'h', 'l', 'H', 'L' ], typed_char ) != -1
        execute 'IndentBlanklineRefresh'
        execute 'normal! z'.typed_char
        redraws
        echon '-- Horizontal scrolling mode (h/l/H/L)'
        let typed_char = nr2char(getchar())
        execute 'IndentBlanklineRefresh'
    endwhile
    if (index( [ 'h', 'l', 'H', 'L' ], typed_char ) == -1)
      call hasan#utils#feedkeys(typed_char, 'n')
      execute 'IndentBlanklineRefresh'
    endif
    echohl None | echo '' | redraws

    " autocmd WinScrolled * IndentBlanklineRefreshScroll
endfunction
" }}}

" nebulous#onWinEnter {{{
let s:timer = 0
function! nebulous#onWinEnter(winId) abort
  call timer_stop(s:timer)
  let s:timer = timer_start(50, funcref('nebulous#focus_cursor', [a:winId]))
endfunction

let s:cursorline_disable_ftype = 'dashboard\|floaterm'
let s:cursorline_focus_ftype = 'list\|\<fern\>'
if ftype =~ s:cursorline_focus_ftype
  set winhighlight=CursorLine:CursorLineFocus
endif
"}}}

" Save current view settings on a per-window, per-buffer basis {{{
function! AutoSaveWinView()
  if !exists("w:SavedBufView")
    let w:SavedBufView = {}
  endif
  let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction

" Restore current view settings.
function! AutoRestoreWinView()
  let buf = bufnr("%")
  if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
    let v = winsaveview()
    let atStartOfFile = v.lnum == 1 && v.col == 0
    if atStartOfFile && !&diff
      call winrestview(w:SavedBufView[buf])
    endif
    unlet w:SavedBufView[buf]
  endif
endfunction

" When switching buffers, preserve window view.
if v:version >= 700
  autocmd BufLeave * call AutoSaveWinView()
  autocmd BufEnter * call AutoRestoreWinView()
endif
" }}}
