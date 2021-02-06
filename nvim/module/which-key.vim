
" WhichKey configs --------------------------------------- {{{
" Map leader to which_key
nnoremap <silent> <leader> :silent WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :silent <c-u> :silent WhichKeyVisual '<Space>'<CR>

" Create map to add keys to
let g:which_key_map =  {}
" Define a separator
let g:which_key_sep = '→'
" Not a fan of floating windows for this
let g:which_key_use_floating_win = 0
" set timeoutlen=100

" Change the colors if you want
highlight default link WhichKey          Operator
highlight default link WhichKeySeperator DiffAdded
highlight default link WhichKeyGroup     Identifier
highlight default link WhichKeyDesc      Function
" Hide status line
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler
" }}}

" Single mappings ---------------------------------------- {{{
let g:which_key_map['m'] = [':call WindowSwap#EasyWindowSwap()'     , 'move-window' ]
let g:which_key_map['n'] = [':FernCurFileDrawer'                    , 'open-fern' ]
let g:which_key_map['l'] = [':JumpToWin l'                          , 'window-right']
let g:which_key_map['h'] = [':JumpToWin h'                          , 'window-left']
let g:which_key_map['j'] = [':JumpToWin j'                          , 'window-bellow']
let g:which_key_map['k'] = [':JumpToWin k'                          , 'window-above']
let g:which_key_map['r'] = [':CycleNumber'                          , 'cycle-number' ]
let g:which_key_map['='] = ['<C-W>='                                , 'balance-windows' ]
let g:which_key_map['x'] = [':bdelete'                              , 'delete-buffer']
let g:which_key_map['z'] = ['za'                                    , 'fold' ]
let g:which_key_map['s'] = 'save-current-file'
let g:which_key_map['q'] = 'close-current-window'
nnoremap <leader>s :w<CR>
vnoremap <leader>s :<C-u>w<CR>gv
nnoremap <silent> <leader>q :Quit<CR>
nnoremap <silent> <leader><TAB> :AlternateFile<CR>
vnoremap <silent> <leader><TAB> :<C-u>AlternateFile<CR>


" }}}

" a is for actions in language server protocol ----------- {{{
let g:which_key_map['a'] = {
      \ 'name' : '+lsp-actions' ,
      \ '$' : 'coc-restart',
      \ '.' : [':CocConfig'                          , 'config'],
      \ '?' : [':CocList diagnostics'                , 'diagnostics'],
      \ ';' : [':CocList'                            , 'coc-lists'],
      \ 'a' : 'coc-action',
      \ 'c' : [':CocList commands'                   , 'commands'],
      \ 'e' : [':CocList extensions'                 , 'extensions'],
      \ 'f' : 'format',
      \ 'h' : ['<Plug>(coc-float-hide)'              , 'hide'],
      \ 'j' : ['<Plug>(coc-float-jump)'              , 'float-jump'],
      \ 'S' : [':CocList snippets'                   , 'snippets'],
      \ 'T' : [':CocList tasks'                      , 'list-tasks'],
      \ 'u' : [':CocListResume'                      , 'resume-list'],
      \ 'U' : [':CocUpdate'                          , 'update-CoC'],
      \ 'z' : [':CocDisable'                         , 'disable-CoC'],
      \ 'Z' : [':CocEnable'                          , 'enable-CoC'],
      \
      \ ',' : ['<Plug>(coc-rename)'                  , 'rename'],
      \ 'd' : ['<Plug>(coc-definition)'              , 'definition'],
      \ 'D' : ['<Plug>(coc-declaration)'             , 'declaration'],
      \ 'i' : ['<Plug>(coc-implementation)'          , 'implementation'],
      \ 'l' : ['<Plug>(coc-codelens-action)'         , 'code-lens'],
      \ 'o' : [':CocList outline'                    , 'outline'],
      \ 'O' : [':Vista!!'                            , 'outline'],
      \ 'q' : ['<Plug>(coc-fix-current)'             , 'quickfix'],
      \ 'r' : ['<Plug>(coc-references)'              , 'references'],
      \ 'R' : ['<Plug>(coc-refactor)'                , 'refactor'],
      \ 's' : [':CocList -I symbols'                 , 'symbol-references'],
      \ 'y' : ['<Plug>(coc-type-definition)'         , 'type-definition'],
      \
      \
      \ 'b' : [':CocNext'                            , 'next-action'],
      \ 'B' : [':CocPrev'                            , 'prev-action'],
      \ 'p' : ['<Plug>(coc-diagnostic-prev)'         , 'prev-diagnostic'],
      \ 'n' : ['<Plug>(coc-diagnostic-next)'         , 'next-diagnostic'],
      \ 'N' : ['<Plug>(coc-diagnostic-next-error)'   , 'next-error'],
      \ 'P' : ['<Plug>(coc-diagnostic-prev-error)'   , 'prev-error'],
      \ }
nnoremap <silent><leader>a$ :CocRestart<CR>
nmap <leader>aa <Plug>(coc-codeaction)
vmap <leader>aa <Plug>(coc-codeaction-selected)
nmap <leader>af <Plug>(coc-format)
vmap <leader>af <Plug>(coc-format-selected)
" }}}

" b is for buffer ---------------------------------------- {{{
let g:which_key_map['b'] = {
      \ 'name' : '+buffer',
      \ '/' : ['Buffers'                            , 'Search-buffers'],
      \ 'f' : ['bfirst'                             , 'first-buffer'],
      \ 'l' : ['blast'                              , 'last-buffer'],
      \ 'n' : ['bnext'                              , 'next-buffer'],
      \ 'p' : ['bprevious'                          , 'previous-buffer'],
      \
      \ 'k' : ['Bclose'                             , 'delete-buffer'],
      \ 'K' : ['Todo'                               , 'kill-all-buffers'],
      \ 'O' : ['KillOtherBuffers'                   , 'kill-other-buffers'],
      \
      \ 's' : [':w'                                 , 'Save-buffer'],
      \ 'S' : [':wa'                                , 'Save-all-buffer'],
      \ }
" }}}

" e is for edit ------------------------------------------ {{{
let g:which_key_map['e'] = {
      \ 'name' : '+edit',
      \ 'e' : 'edit-in-directory'        ,
      \ 'd' : 'create-directory'         ,
      \ 's' : 'edit-in-directory-split'  ,
      \ 't' : 'edit-in-directory-tab'    ,
      \ 'v' : 'edit-in-directory-vsplit' ,
      \ '~' : 'edit-project-root'        ,
      \ }
" Open a file relative to the current file
nnoremap <leader>ed :Mkdir <C-R>=expand('%:h').'/'<cr>
nnoremap <leader>et :tabe <C-R>=expand('%:h').'/'<cr>
nnoremap <leader>ev :vsp <C-R>=expand('%:h').'/'<cr>
nnoremap <leader>es :sp <C-R>=expand('%:h').'/'<cr>
nnoremap <leader>ee :e <C-R>=expand('%:h').'/'<cr>
nnoremap <leader>e~ :cd %:p:h<CR>:pwd<CR>
" }}}

" f is for file ------------------------------------------ {{{
let g:which_key_map['f'] = {
      \ 'name' : '+find' ,
      \ '/' : [':Files'                         , 'fzf-files'],
      \ 'i' : 'file-info'                       ,
      \ 'f' : 'find-and-replace-in-file'                       ,
      \ 'o' : [':FernCurFileDrawer'             , 'find-in-file-tree' ],
      \ 's' : [':update'                        , 'save-current-file'],
      \ 'S' : [':wall'                          , 'save-all-file'],
      \ 'c' : {
      \ 'name' : '+files/convert',
      \    'x' : [':Chmod +x'                   , 'make-executale'],
      \    'X' : [':Chmod -x'                   , 'remove-executale'],
      \    'w' : [':Chmod +w'                   , 'add-write-permission'],
      \    'W' : [':Chmod -w'                   , 'remove-write-permission'],
      \  },
      \ 't' : [':Filetypes'                     , 'fzf-filetypes'],
      \ 'w' : ['<Plug>FixCurrentWord'           , 'fix-current-word'],
      \
      \ 'R' : 'rename-current-file',
      \ 'C' : 'Todo',
      \ 'M' : 'move-current-file',
      \ 'y' : 'copy-current-filename',
      \ 'Y' : 'copy-current-filpath',
      \ }
nnoremap <leader>fi :call hasan#utils#file_info()<CR>
nnoremap <Leader>fM :Move <C-R>=expand("%")<CR>
nnoremap <Leader>fR :Rename <C-R>=expand("%:t")<CR>
nnoremap <leader>fy :CopyFileNameToClipBoard!<CR>
nnoremap <leader>fY :CopyFileNameToClipBoard<CR>
" replace word under cursor, globally, with confirmation
nnoremap <Leader>ff  "zyiw:%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
xnoremap <Leader>ff "zy:%s/<C-r>"//gc<Left><Left><Left>

" }}}

" g is for git ------------------------------------------- {{{
let g:which_key_map['g'] = {
      \ 'name' : '+git',
      \ '/' : [':GFiles?'                         , 'fzf-git-files*'],
      \ '.' : [':Git add %'                        , 'stage-current-file'],
      \ 'g' : [':Gstatus!'                         , 'status'],
      \ 'b' : [':Git blame'                        , 'blame'],
      \ 'L' : [':Git log'                          , 'log'],
      \ 'f' : [':diffget //2'                      , 'diffget ours'],
      \ 'j' : [':diffget //3'                      , 'diffget theirs'],
      \ 'd' : [':Gvdiffsplit!'                     , 'diff'],
      \ 'B' : [':GBrowse'                          , 'browse-repo'],
      \ 'r' : [':GRemove'                          , 'remove'],
      \ 'v' : [':GV'                               , 'view-commits'],
      \ 'V' : [':GV!'                              , 'view-buffer-commits'],
      \ 'i' : [':Gist -b'                          , 'post-gist'],
      \
      \ 's' : ['<Plug>(GitGutterStageHunk)'        , 'stage-hunk'],
      \ 'u' : ['<Plug>(GitGutterUndoHunk)'         , 'undo-hunk'],
      \ 'p' : ['<Plug>(GitGutterPreviewHunk)'      , 'preview-hunk'],
      \ 'U' : [':GitGutter'                        , 'update-gitgutter'],
      \ 'F' : [':GitGutterFold'                    , 'fold-around-hunk'],
      \ 'H' : [':GitGutterLineHighlightsToggle'    , 'highlight-hunks'],
      \ 'T' : [':GitGutterSignsToggle'             , 'toggle-signs'],
      \ }
" }}}

" i is for insert ---------------------------------------- {{{
let g:which_key_map['i'] = {
      \ 'name' : '+insert',
      \ 'd' :['_#Insertion(strftime("%e %B %Y"))'           , 'date'],
      \ 'D' :['_#Insertion(strftime("%H:%M"))'              , 'time'],
      \ 'f' :['_#Insertion(expand("%:t"))'                  , 'current-file-name'],
      \ 'F' :['_#Insertion(expand("%:~"))'                  , 'current-file-path'],
      \
      \ 't' : {
      \ 'name' : '+transfrom',
      \    'c' :['<Plug>(camel_case_operator)'       , 'transfrom-to-camel-case' ],
      \    'C' :['<Plug>(upper_camel_case_operator)' , 'transfrom-to-upper-camel-case' ],
      \    's' :['<Plug>(snake_case_operator)'       , 'transfrom-to-snake-case' ],
      \    'k' :['<Plug>(kebab_case_operator)'       , 'transfrom-to-kebab-case' ],
      \    'S' :['<Plug>(start_case_operator)'       , 'transfrom-to-start-case' ],
      \ 
      \    'h' :['<Plug>(ConvertColorCode-h)'        , 'convert-color-to-hsl' ],
      \    'r' :['<Plug>(ConvertColorCode-r)'        , 'convert-color-to-rgb' ],
      \    'x' :['<Plug>(ConvertColorCode-x)'        , 'convert-color-to-hex' ],
      \    'H' :['<Plug>(ConvertColorCode-H)'        , 'convert-color-to-hsl-alpha' ],
      \    'R' :['<Plug>(ConvertColorCode-R)'        , 'convert-color-to-rgb-alpha' ],
      \    'X' :['<Plug>(ConvertColorCode-X)'        , 'convert-color-to-hex-alpha' ],
      \  },
      \ }

" ConvertColorTo
let s:convertColorTo = [['x', 'hex'],['X', 'hexa'],['r', 'rgb'],['R', 'rgba'],['h', 'hsl'],['H', 'hsla']]
for i in s:convertColorTo
  exe 'nmap <silent><Plug>(ConvertColorCode-'.i[0].') :ConvertColorTo '.i[1].'<CR>:call repeat#set("\<Plug>(ConvertColorCode-'.i[0].')")<CR>'
  " exe 'nmap c'.i[0].' <Plug>(ConvertColorCode-'.i[0].')'
endfor
" }}}

" o is for open ------------------------------------------ {{{
let g:which_key_map['o'] = {
      \ 'name' : '+open',
      \ ';' : [':FloatermNew --wintype=normal --height=6'  , 'terminal'],
      \ 'a' : ['<Plug>(dotoo-agenda)'                      , 'org-agenda'],
      \ 'c' : ['<Plug>(dotoo-capture-custom)'              , 'org-capture'],
      \ 'b' : [':Fern bookmark:///'                        , 'bookmark'],
      \ 't' : [':OpenTodo'                                 , 'todo-manager'],
      \ 'q' : [':QfixToggle'                               , 'quickfix'],
      \ 'y' : [':CocList --normal yank'                    , 'yank-history'],
      \ }

" }}}

" p is for project --------------------------------------- {{{
let g:which_key_map['p'] = {
      \ 'name' : '+project',
      \ 'p' : [':Projects'               , 'swithc-project'],
      \ 'r' : [':ProjectRecentFiles'     , 'project-recent-files'],
      \ }

" }}}

" S is for session --------------------------------------- {{{
" @todo: Add session support.
let g:which_key_map['S'] = {
      \ 'name' : '+Session',
      \ 'c' : [':SClose'          , 'close-session'],
      \ 'd' : [':SDelete'         , 'delete-session'],
      \ 'l' : [':SLoad'           , 'load-session'],
      \ 's' : [':Startify'        , 'start-page'],
      \ 'S' : [':SSave'           , 'save-session'],
      \ }
" }}}

" t is for task ------------------------------------------ {{{
let g:which_key_map['t'] = {
      \ 'name' : '+task',
      \ 'e' : 'TaskWikiAdvancedEdit',
      \}
" }}}

" ` is for toggle ---------------------------------------- {{{
let g:which_key_map['`'] = {
      \ 'name' : '+toggle',
      \ 'c' : [':setlocal cursorcolumn!'                   , 'cursorcolumn'],
      \ 'w' : [':call hasan#utils#toggleWrap()'            , 'toggle-wrap'],
      \
      \ '`' : {
      \ 'name' : '+task-and-timer',
      \    'b' : [':Break'              , 'tt-break'],
      \    'h' : [':HideAndShowTimer'   , 'tt-hide-timer'],
      \    'o' : [':OpenTasks'          , 'tt-open-tasks'],
      \    'p' : [':PauseOrPlayTimer'   , 'tt-pause-or-play'],
      \    'w' : [':Work'               , 'tt-work'],
      \    's' : ['ShowTimer'           , 'tt-status'],
      \    'u' : 'tt-update-timer',
      \    'U' : 'tt-update-status',
      \ }
      \ }
nnoremap <Leader>``u :UpdateCurrentTimer<space>
nnoremap <Leader>``U :UpdateCurrentStatus<space>
" }}}

" v is for vim ------------------------------------------- {{{
let g:which_key_map['v'] = {
      \ 'name' : '+vim',
      \ '.' : [':e $MYVIMRC'                  , 'open-$MYVIMRC'],
      \ '$' : 'source-$MYVIMRC',
      \ 'e' : 'print-to-float',
      \ 'l' : 'logevents-toggle',
      \ 'p' : {
      \ 'name' : '+plug',
      \    'i' : [':PlugInstall'                , 'install-plugins'],
      \    'c' : [':PlugClean'                  , 'clean-plugins'],
      \    's' : [':PlugStatus'                 , 'plug-status'],
      \    'u' : [':PlugUpdate'                 , 'update-all-plugins'],
      \    'U' : 'upgrade-plug-itself',
      \  },
      \ }
nnoremap <leader>v$ :so $MYVIMRC<CR>
nnoremap <leader>vl :call logevents#LogEvents_Toggle()<CR>
nnoremap <leader>vpU :PlugUpgrade<CR>
nnoremap <leader>ve :call _#print_to_float(g:)<left>
" }}}

" w is for wiki-or-window -------------------------------- {{{
let g:which_key_map['w'] = {
      \ 'name' : '+wiki-n-window',
      \ '/' : [':Windows'                                 , 'fzf-windows'],
      \ 'w' : ['<C-w>w'                                   , 'next-window'],
      \ 'W' : ['<C-w>W'                                   , 'previous-window'],
      \ 'h' : ['<C-w>h'                                   , 'window-left'],
      \ 'j' : ['<C-w>j'                                   , 'window-down'],
      \ 'k' : ['<C-w>k'                                   , 'window-up'],
      \ 'l' : ['<C-w>l'                                   , 'window-right'],
      \ 'p' : ['<C-w>p'                                   , 'window-previous'],
      \ 'H' : ['<C-w>H'                                   , 'window-move-left'],
      \ 'J' : ['<C-w>J'                                   , 'window-move-down'],
      \ 'K' : ['<C-w>K'                                   , 'window-move-up'],
      \ 'L' : ['<C-w>L'                                   , 'window-move-right'],
      \ 'r' : ['<C-w>r'                                   , 'window-rotate-downwards'],
      \ 'R' : ['<C-w>R'                                   , 'window-rotate-upwards'],
      \
      \ 'v' : ['<C-w>v'                                   , 'vsplit'],
      \ 's' : ['<C-w>s'                                   , 'split'],
      \ 't' : [':-tab split'                              , 'tab-split'],
      \ 'o' : ['<C-w>o'                                   , 'only-window'],
      \ 'O' : [':tabonly'                                 , 'only-tab'],
      \ 'c' : ['<C-w>c'                                   , 'close-window'],
      \ 'q' : ['<C-w>c'                                   , 'quit-window'],
      \ 'z' : 'auto-zoom-win'                             ,
      \
      \ '.' : 'wiki-index',
      \ 'T' : 'wiki-index-tab',
      \ 'i' : 'diary-index',
      \ 'n' : 'diary-today',
      \ 'N' : 'diary-today-tab',
      \ 'g' : 'diary-generate-links',
      \ '?' : 'wiki-ui-select',
      \ }
nnoremap <leader>wz :AutoZoomWin<CR>
" vimwike mappings
nnoremap <leader>w. :VimwikiIndex<CR>
nnoremap <leader>wT :VimwikiTabIndex<CR>
nnoremap <leader>wi :VimwikiDiaryIndex<CR>
nnoremap <leader>wn :VimwikiMakeDiaryNote<CR>
nnoremap <leader>wN :VimwikiTabMakeDiaryNote<CR>
nnoremap <leader>wg :VimwikiDiaryGenerateLinks<CR>
nnoremap <leader>w? :VimwikiUISelect<CR>
" }}}

" / is for search ---------------------------------------- {{{
let g:which_key_map['/'] = {
      \ 'name' : '+search',
      \ '/' : [':BLines'                , 'fzf-buffer-lines'],
      \ ';' : [':History:'              , 'fzf-commands-history'],
      \ ':' : [':Command!'              , 'fzf-commands-history'],
      \ 'b' : [':Buffers'               , 'fzf-buffer'],
      \ 'C' : [':BCommits'              , 'fzf-buffer-commits'],
      \ 'c' : [':Commits'               , 'fzf-commits'],
      \ 'f' : [':Files'                 , 'fzf-files'],
      \ 'g' : [':GFiles?'               , 'fzf-git-files*'],
      \ 'h' : [':History/'              , 'fzf-search-history'],
      \ 'H' : [':History'               , 'fzf-file-history'],
      \ 'l' : [':Lines'                 , 'fzf-lines'] ,
      \ 'm' : [':Marks'                 , 'fzf-marks'] ,
      \ 'k' : [':Maps!'                 , 'fzf-keymaps'] ,
      \ 'r' : [':ProjectRecentFiles'    , 'fzf-project-recent-files'],
      \ 'p' :                             'fzf-project-search',
      \ 't' : [':Filetypes'             , 'fzf-filetypes'],
      \ 'w' : [':Windows'               , 'fzf-windows'],
      \ }
" Search word in whole project
nnoremap <leader>/p :RG!<CR>
xnoremap <leader>/p "zy:RG! <C-r>z<CR>
" }}}

" [ is for terminal -------------------------------------- {{{
let g:which_key_map['['] = {
      \ 'name' : '+terminal',
      \ '[' : 'SetTerminal',
      \ }
nmap <leader>[[ :SetTerminal<space>
" }}}

" tmux --------------------------------------------------- {{{
if !exists('$TMUX')
  let g:which_key_map.g.l = [ ':FloatermNew --name=lazygit lazygit'                 , 'lazygit' ]
  let g:which_key_map.g.t = [ ':FloatermNew --name=tig tig'                         , 'tig' ]

  let g:which_key_map.f.l = [ ':FloatermNew --name=lf lf %:p'                       , 'file-in-lf' ]
  let g:which_key_map.o.l = [ ':FloatermNew --name=lf lf'                           , 'open-lf' ]
  let g:which_key_map.o.v = [ ':FloatermNew --name=vit vit'                         , 'open-vit' ]
else
  let g:which_key_map.g.l = [ ':silent !tmux new-window "lazygit"'                  , 'lazygit' ]
  let g:which_key_map.g.t = [ ':silent !tmux new-window "tig"'                      , 'tig' ]

  let g:which_key_map.f.l = [ ':silent !tmux new-window "lf" %:p'                   , 'file-in-lf' ]
  let g:which_key_map.o.l = [ ':silent !tmux new-window "lf"'                       , 'open-lf' ]
  let g:which_key_map.o.v = [ ':silent !tmux new-window -n "vit" "vit"'             , 'open-vit' ]
endif
" }}}

" Ignore WhichKeys --------------------------------------- {{{
" Open current file directory into the drawer
nnoremap <silent> <Leader>. :FernCurDirDrawer<CR>
nnoremap <silent> <Leader>0 :Fern . -drawer -toggle<CR><C-w>=
let g:which_key_map['.'] = 'which_key_ignore'
let g:which_key_map['0'] = 'which_key_ignore'

" Easier system clipboard usage
nnoremap <Leader>ip "+p
nnoremap <Leader>y "+y
nnoremap <Leader>d "+d
vnoremap <Leader>ip "+p
vnoremap <Leader>y "+ygv<Esc>
vnoremap <Leader>d "+d
let g:which_key_map['i']['p'] = 'from-system-clipboard'
let g:which_key_map['y'] = 'which_key_ignore'
let g:which_key_map['d'] = 'which_key_ignore'

" Map <Space>  + 1-9 to jump to respective tab
" Map <Space>w + 1-9 to jump to respective window
for tnum in range(1, 9)
  execute ':nnoremap <silent> <Space>'.tnum.' :tabn '.tnum.'<CR>'
  let g:which_key_map[tnum] = 'which_key_ignore'
  execute ':nnoremap <silent> <Space>w'.tnum.' :'.tnum.'wincmd w<CR>'
  let g:which_key_map['w'][tnum] = 'which_key_ignore'
endfor
" }}}

" Register which key map
call which_key#register('<Space>', "g:which_key_map")

