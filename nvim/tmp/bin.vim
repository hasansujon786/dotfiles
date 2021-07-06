
" function! nebulous#block(...) abort
"  let s:nebulous_disabled = v:true
" endfunction

" function! nebulous#unblock(...) abort
"  let s:nebulous_disabled = v:false
" endfunction

" function! nebulous#onTelescopeStart() abort
"   if nebulous#is_disabled() | return | endif

"   call nebulous#blur_current_window()
"   call nebulous#block()
"   augroup NebulousTelescope
"     autocmd!
"     autocmd WinClosed * call nebulous#onTelescopeClosed()
"   augroup end
" endfunction

" function! nebulous#onTelescopeClosed() abort
"   call nebulous#unblock()
"   autocmd! NebulousTelescope
" endfunction

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

function! s:warn(message)
  echohl WarningMsg
  echom a:message
  echohl None
  return 0
endfunction

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
let s:is_win = 1

function! s:shortpath()
  let short = fnamemodify(getcwd(), ':~:.')
  if !has('win32unix')
    let short = pathshorten(short)
  endif
  let slash = (s:is_win && !&shellslash) ? '\' : '/'
  return empty(short) ? '~'.slash : short . (short =~ escape(slash, '\').'$' ? '' : slash)
endfunction
