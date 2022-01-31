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
