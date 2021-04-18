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

if exists('g:started_by_firenvim')
  set laststatus=0
else
  set laststatus=2 "show statusbar
endif

" Some Readline Keybindings When In Insertmode
inoremap <expr> <C-B> getline('.')=~'^\s*$'&&col('.')> strlen(getline('.'))?"0\<Lt>C-D>\<Lt>Esc>kJs":"\<Lt>Left>"

" lorem ipsum
iabbrev <expr> lorem system('curl -s http://metaphorpsum.com/paragraphs/1')
" quickly print the date
iab <expr> dts strftime("%c")

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

let g:coc_global_extensions = [
      \'coc-diagnostic',
      \'coc-marketplace',
      \'coc-dictionary',
      \'coc-tag',
      \'coc-word',
      \'coc-go',
      \'coc-ccls',
      \'coc-java',
      \'coc-python',
      \'coc-tsserver',
      \'coc-html',
      \'coc-vimtex',
      \'coc-texlab',
      \'coc-json',
      \'coc-lists',
      \'coc-utils'
      \]

function! SourceAgendaFiles()
  let files = systemlist('rg --files -t org ~/Documents/org')
  echo files
endfunction

" ascii logos{{{

" let g:dashboard_custom_header = [
" \ '                  .                   ',
" \ '  ##############..... ##############  ',
" \ '  ##############......##############  ',
" \ '    ##########..........##########    ',
" \ '    ##########........##########      ',
" \ '    ##########.......##########       ',
" \ '    ##########.....##########..       ',
" \ '    ##########....##########.....     ',
" \ '  ..##########..##########.........   ',
" \ '....##########.#########............. ',
" \ '  ..################JJJ............   ',
" \ '    ################.............     ',
" \ '    ##############.JJJ.JJJJJJJJJJ     ',
" \ '    ############...JJ...JJ..JJ  JJ    ',
" \ '    ##########....JJ...JJ..JJ  JJ     ',
" \ '    ########......JJJ..JJJ JJJ JJJ    ',
" \ '    ######    .........               ',
" \ '                .....                 ',
" \ '                  .                   ',
" \ ''
" \ ]


" let g:dashboard_custom_header = [
"  \ '          //                 /*           ',
"  \ '       ,(/(//,               *###         ',
"  \ '     ((((((////.             /####%*      ',
"  \ '  ,/(((((((/////*            /########    ',
"  \ ' /*///((((((//////.          *#########/  ',
"  \ ' //////((((((((((((/         *#########/. ',
"  \ ' ////////((((((((((((*       *#########/. ',
"  \ ' /////////(/(((((((((((      *#########(. ',
"  \ ' //////////.,((((((((((/(    *#########(. ',
"  \ ' //////////.  /(((((((((((,  *#########(. ',
"  \ ' (////////(.    (((((((((((( *#########(. ',
"  \ ' (////////(.     ,#((((((((((##########(. ',
"  \ ' ((//////((.       /#((((((((##%%######(. ',
"  \ ' ((((((((((.         #(((((((####%%##%#(. ',
"  \ ' ((((((((((.          ,((((((#####%%%%%(. ',
"  \ '  .#(((((((.            (((((#######%%    ',
"  \ '     /(((((.             .(((#%##%%/*     ',
"  \ '       ,(((.               /(#%%#         ',
"  \ '         ./.                 #*           ',
"  \]


" let g:dashboard_custom_header = [
"  \ '                                                      ',
"  \ '                                        ▀▀            ',
"  \ '██▃▅▇█▆▖  ▗▟████▙▖   ▄████▄   ██▄  ▄██  ██  ▗▟█▆▄▄▆█▙▖',
"  \ '██▛▔ ▝██  ██▄▄▄▄██  ██▛▔▔▜██  ▝██  ██▘  ██  ██▛▜██▛▜██',
"  \ '██    ██  ██▀▀▀▀▀▘  ██▖  ▗██   ▜█▙▟█▛   ██  ██  ██  ██',
"  \ '██    ██  ▜█▙▄▄▄▟▊  ▀██▙▟██▀   ▝████▘   ██  ██  ██  ██',
"  \ '▀▀    ▀▀   ▝▀▀▀▀▀     ▀▀▀▀       ▀▀     ▀▀  ▀▀  ▀▀  ▀▀',
"  \]
" }}}


" hi StatusLine_active_normal             guibg=#98C379 guifg=#2C323C gui=bold
" hi StatusLine_active_insert             guibg=#61AFEF guifg=#2C323C gui=bold
" hi StatusLine_active_terminal           guibg=#61AFEF guifg=#2C323C gui=bold
" hi StatusLine_active_visual             guibg=#C678DD guifg=#2C323C gui=bold
" hi StatusLine_active_replace            guibg=#E06C75 guifg=#2C323C gui=bold

" hi StatusLine_active_normal_alt         guibg=#3E4452 guifg=#98C379
" hi StatusLine_active_insert_alt         guibg=#3E4452 guifg=#61AFEF
" hi StatusLine_active_terminal_alt       guibg=#3E4452 guifg=#61AFEF
" hi StatusLine_active_visual_alt         guibg=#3E4452 guifg=#C678DD
" hi StatusLine_active_replace_alt        guibg=#3E4452 guifg=#E06C75

