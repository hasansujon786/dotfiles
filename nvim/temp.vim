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

" a is for actions
let g:which_key_map['a'] = {
      \ 'name' : '+actions' ,
      \ 'l' : [':Bracey'                 , 'start live server'],
      \ 'L' : [':BraceyStop'             , 'stop live server'],
      \ 'm' : [':MarkdownPreview'        , 'markdown preview'],
      \ 'M' : [':MarkdownPreviewStop'    , 'markdown preview stop'],
      \ 'v' : [':Codi'                   , 'virtual repl on'],
      \ 'V' : [':Codi!'                  , 'virtual repl off'],
      \ }

" exe "normal! \<c-w>\<c-w>"


" enable blinking mode-sensitive cursor
set guicursor=n-v-c:block-blinkon10,i-ci-ve:ver25-blinkon10,r-cr:hor20,o:hor50

" AutoSetCursorColor {{{
if &filetype =~ '\<fern\>'
  call s:defaultCursor('CursorLineFocus')
else
  call s:defaultCursor('default')
endif
function! s:defaultCursor(hl)
  if (a:hl == 'CursorLineFocus')
    highlight Cursor ctermfg=235 ctermbg=39 guifg=#282C34 guibg=#3E4452
  else
    highlight Cursor ctermfg=235 ctermbg=39 guifg=#282C34 guibg=#61AFEF
  endif
endfunction
" }}}

" function! MyLineInfo()
"   https://vi.stackexchange.com/questions/3894/get-percentage-through-file-of-displayed-window
"   let col = virtcol(".")
"   let line = line(".")
"   let leftpad = len(line) == 1 ? '  ' : len(line) == 2 ? ' ' : ''
"   let rightpad = len(col) == 1 ? ' ' : ''
"   return leftpad.line.':'.col.rightpad
"   " return winwidth(0) > 60 ? leftpad.line.':'.col.rightpad : ''
" endfunction


" From pickRelated
" nmap <leader>cv :!open % -a Google\ Chrome<CR><CR>
" " Surround with console.log();
" nmap <leader>cl :.s/\v[ \t]+\zs([^;]*);*/console.log\(\1\)\;/<CR>:noh<CR>
" " Diff current two windows
" nmap <leader>d :windo diffthis<CR>
" nmap <leader>D :diffoff!<CR>
" nmap <leader>du :diffupdate<CR>
" " Location list
" nmap ]w :lnext<CR>
" nmap [w :lprev<CR>
" nmap ]W :llast<CR>
" nmap [W :lfirst<CR>

" cscope
function! Cscope(option, query)
  let color = '{ x = $1; $1 = ""; z = $3; $3 = ""; printf "\033[34m%s\033[0m:\033[31m%s\033[0m\011\033[37m%s\033[0m\n", x,z,$0; }'
  let opts = {
  \ 'source':  "cscope -dL" . a:option . " " . a:query . " | awk '" . color . "'",
  \ 'options': ['--ansi', '--prompt', '> ',
  \             '--multi', '--bind', 'alt-a:select-all,alt-d:deselect-all',
  \             '--color', 'fg:188,fg+:222,bg+:#3a3a3a,hl+:104'],
  \ 'down': '40%'
  \ }
  function! opts.sink(lines)
    let data = split(a:lines)
    let file = split(data[0], ":")
    execute 'e ' . '+' . file[1] . ' ' . file[0]
  endfunction
  call fzf#run(opts)
endfunction

" Invoke command. 'g' is for call graph, kinda.
nnoremap <silent> <Leader>g :call Cscope('3', expand('<cword>'))<CR>
