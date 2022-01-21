set shellpipe=2>&1\|tee
if has('win32') || has('win64')
    set shell=sh
    set shellcmdflag=-c
    set shellquote=
    set shellxquote=
    set noshelltemp
    set shellslash

    let g:python3_host_prog = 'c:/Windows/py.exe'
    let g:loaded_python_provider = 1
endif



let g:window_key_prefix = "<space>"
" the first value is the key and the second is the new window command
let g:window_key_mappings = [
            \ ["h", "aboveleft vsplit"],
            \ ["j", "belowright split"],
            \ ["k", "aboveleft split"],
            \ ["l", "belowright vsplit"],
            \ [",",
            \ "let buf = bufnr('%') <bar> tabnew <bar> execute 'buffer' buf"],
            \ [".", ""],
            \ ["H", "topleft vsplit"],
            \ ["J", "botright split"],
            \ ["K", "topleft split"],
            \ ["L", "botright vsplit"],
            \ ]

" Create an additional set of window maps for some command.
" If user_enter is truthy (typically 1), then the command won't be automatically
" executed; the user will have to press enter. This is useful for commands
" which require user input (edit for example).
function! MapWinCmd(key, command, user_enter)
  if a:user_enter
    let suffix = ""
  else
    let suffix = "<cr>"
  endif

  for key_mapping in g:window_key_mappings
      execute "nnoremap " . g:window_key_prefix . key_mapping[0] . a:key .
                  \ " <Cmd>" . key_mapping[1] . "<cr>:<c-u>" . a:command .
                  \ suffix
  endfor
endfunction

" new window edit (:edit)
call MapWinCmd("e", "e ", 1)

" new scratch
call MapWinCmd("w", "enew <bar> setlocal bufhidden=hide nobuflisted " .
      \ "buftype=nofile", 0)

" new view into the current buffer
call MapWinCmd("c", "", 0)

" new terminal (neovim)
call MapWinCmd("t", "terminal", 0)

" example mapping for fzf.vim:
call MapWinCmd("f", "Files", 0)

" or dirvish
call MapWinCmd("D", "Dirvish", 0)

" or startify
call MapWinCmd("s", "Startify", 0)

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
