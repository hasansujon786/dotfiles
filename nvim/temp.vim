" Don't fold automatically https://stackoverflow.com/a/8316817
autocmd BufRead * normal zR

if has("macunix") || has('win32')
  set clipboard=unnamed
elseif has("unix")
  set clipboard=unnamedplus
endif

" https://stackoverflow.com/a/20418591
au FocusGained,BufEnter * :silent! !
au FocusLost,WinLeave * :silent! w

" EDIT: If you want to speed up the write by disabling any hooks that run on save (e.g. linters), you can prefix the w command with noautocmd:
au FocusLost,WinLeave * :silent! noautocmd w
au FocusGained,BufEnter,CursorHold * checktime                                       " Update a buffer's contents on focus if it changed outside of Vim.
au CursorHold,CursorHoldI * checktime
" set -g focus-events on
"
"A bit late to the party, but vim nowadays has timers, and you can do:
if ! exists("g:CheckUpdateStarted")
  let g:CheckUpdateStarted=1
  call timer_start(1,'CheckUpdate')
endif
function! CheckUpdate(timer)
  silent! checktime
  call timer_start(1000,'CheckUpdate')
endfunction

augroup vimrc-incsearch-highlight
  autocmd!
  autocmd CmdlineEnter /,\? :set hlsearch
  autocmd CmdlineLeave /,\? :set nohlsearch
augroup END

" https://github.com/junegunn/fzf.vim/issues/162
let g:fzf_commands_expect = 'alt-enter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" Delete buffers
" https://github.com/junegunn/fzf.vim/pull/733#issuecomment-559720813
function! s:list_buffers()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction
function! s:delete_buffers(lines)
  execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction
command! BD call fzf#run(fzf#wrap({
      \ 'source': s:list_buffers(),
      \ 'sink*': { lines -> s:delete_buffers(lines) },
      \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
      \ }))


highlight NonText ctermfg=white guifg=#5C6370
