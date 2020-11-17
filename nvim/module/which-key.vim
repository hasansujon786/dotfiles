
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
let g:which_key_map['n'] = [ ':call hasan#fern#open_drawer()'       , 'open-fern' ]
let g:which_key_map['s'] = [ ':update'                              , 'save-file' ]
let g:which_key_map['='] = [ '<C-W>='                               , 'balance-windows' ]
let g:which_key_map['x'] = [ ':bdelete'                             , 'delete-buffer']
let g:which_key_map['m'] = [ ':call WindowSwap#EasyWindowSwap()'    , 'move-window' ]
let g:which_key_map['z'] = [ 'za'                                   , 'fold' ]
let g:which_key_map['r'] = 'cycle-number'
let g:which_key_map['l'] = 'window-right'
let g:which_key_map['h'] = 'window-left'
let g:which_key_map['j'] = 'window-bellow'
let g:which_key_map['k'] = 'window-above'
" let g:which_key_map['q'] = 'close-window'
nnoremap <silent> <leader>q :Q<CR>
nnoremap <silent> <leader>k :call hasan#utils#JumpToWin('k')<CR>
nnoremap <silent> <leader>j :call hasan#utils#JumpToWin('j')<CR>
nnoremap <silent> <leader>l :call hasan#utils#JumpToWin('l')<CR>
nnoremap <silent> <leader>h :call hasan#utils#JumpToWin('h')<CR>
nnoremap <silent> <leader>r :call hasan#utils#cycle_numbering()<CR>
nnoremap <silent> <leader><TAB> :AlternateFile<CR>
" nnoremap <silent> <leader>q :Q<CR>


" }}}

" a is for actions ins language server protocol ---------- {{{
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
      \ '/' : ['Buffers'                            , 'fzf-buffer'],
      \ 'f' : ['bfirst'                             , 'first-buffer'],
      \ 'l' : ['blast'                              , 'last-buffer'],
      \ 'n' : ['bnext'                              , 'next-buffer'],
      \ 'x' : ['Bclose'                             , 'delete-buffer'],
      \ 'X' : [':call hasan#utils#clear_buffers()'  , 'kill-other-buffers'],
      \ 'p' : ['bprevious'                          , 'previous-buffer'],
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
      \ 'o' : [':call hasan#fern#open_drawer()' , 'find-in-file-tree' ],
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
      \ 'R' : 'rename-current-file',
      \ 'M' : 'move-current-file',
      \ 'y' : 'copy-current-filename',
      \ 'Y' : 'copy-current-filename',
      \ }
nnoremap <Leader>fM :Move <C-R>=expand("%")<CR>
nnoremap <Leader>fR :Rename <C-R>=expand("%:t")<CR>
nnoremap <leader>fy :call hasan#utils#CopyFileNameToClipBoard(1)<CR>
nnoremap <leader>fY :call hasan#utils#CopyFileNameToClipBoard()<CR>

" }}}

" g is for git ------------------------------------------- {{{
let g:which_key_map['g'] = {
      \ 'name' : '+git',
      \ '/' : [':GFiles'                           , 'fzf-git-files'],
      \ '?' : [':GFiles!?'                         , 'fzf-git-files*'],
      \
      \ '.' : [':Git add %'                        , 'stage-current-file'],
      \ 'b' : [':Git blame'                        , 'blame'],
      \ 'i' : [':Gist -b'                          , 'post-gist'],
      \ 'L' : [':Git log'                          , 'log'],
      \
      \ 'B' : [':GBrowse'                          , 'browse'],
      \ 'd' : [':Gvdiffsplit!'                     , 'diff'],
      \ 'g' : [':Gstatus!'                          , 'status'],
      \ 'r' : [':GRemove'                          , 'remove'],
      \ 'v' : [':GV'                               , 'view-commits'],
      \ 'V' : [':GV!'                              , 'view-buffer-commits'],
      \
      \ 'U' : [':GitGutter'                        , 'update-gitgutter'],
      \ 'u' : ['<Plug>(GitGutterUndoHunk)'         , 'undo-hunk'],
      \ 's' : ['<Plug>(GitGutterStageHunk)'        , 'stage-hunk'],
      \ 'p' : ['<Plug>(GitGutterPreviewHunk)'      , 'preview-hunk'],
      \ 'M' : [':GitGutterFold'                    , 'fold-around-hunk'],
      \ 'H' : [':GitGutterLineHighlightsToggle'    , 'highlight-hunks'],
      \ 'T' : [':GitGutterSignsToggle'             , 'toggle-signs'],
      \ }
if !exists('$TMUX')
  let g:which_key_map.g.l = [ ':FloatermNew --name=lazygit lazygit'   , 'lazygit' ]
  let g:which_key_map.g.t = [ ':FloatermNew --name=tig tig'           , 'tig' ]
else
  let g:which_key_map.g.l = [ ':silent !tmux new-window "lazygit"'    , 'lazygit' ]
  let g:which_key_map.g.t = [ ':silent !tmux new-window "tig"'        , 'tig' ]
endif
" }}}

" i is for insertion ------------------------------------- {{{
let g:which_key_map['i'] = {
      \ 'name' : '+insertion',
      \ 'd' : {
      \ 'name' : 'date-and-time',
      \    'd' :['_#Insertion(strftime("%e %B %Y"))'           , 'date'],
      \    't' :['_#Insertion( strftime("%H:%M"))'             , 'time'],
      \  },
      \ 't' : {
      \ 'name' : 'text-transfrom',
      \    'c' :['<Plug>(camel_case_operator)'       , 'transfrom-to-camel-case' ],
      \    'C' :['<Plug>(upper_camel_case_operator)' , 'transfrom-to-upper-camel-case' ],
      \    's' :['<Plug>(snake_case_operator)'       , 'transfrom-to-snake-case' ],
      \    'k' :['<Plug>(kebab_case_operator)'       , 'transfrom-to-kebab-case' ],
      \    'S' :['<Plug>(start_case_operator)'       , 'transfrom-to-start-case' ],
      \  },
      \ }
" }}}

" o is for open ------------------------------------------ {{{
let g:which_key_map['o'] = {
      \ 'name' : '+open',
      \ ';' : [':FloatermNew --wintype=normal --height=6'  , 'terminal'],
      \ 'b' : [':Fern bookmark:///'                        , 'bookmark'],
      \ 't' : [':OpenTodo'                                 , 'todo-manager'],
      \ 'q' : [':call hasan#utils#quickFix_toggle()'       , 'quickfix'],
      \ 'y' : [':CocList --normal yank'                    , 'yankc-history'],
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

" t is for terminal -------------------------------------- {{{
let g:which_key_map['t'] = {
      \ 'name' : '+terminal',
      \ 's' : 'SetTerminal',
      \ }
nmap <leader>ts :SetTerminal<space>
" }}}

" T is for tast-timer-&-toggle --------------------------- {{{
let g:which_key_map['T'] = {
      \ 'name' : '+tast-timer-&-toggle',
      \ 'b' : [':Break'              , 'tt-break'],
      \ 'h' : [':HideAndShowTimer'   , 'tt-hide-timer'],
      \ 'o' : [':OpenTasks'          , 'tt-open-tasks'],
      \ 'p' : [':ToggleTimer'        , 'tt-pause'],
      \ 'W' : [':Work'               , 'tt-work'],
      \ 's' : 'tt-status',
      \ 'u' : 'tt-update-timer',
      \ 'U' : 'tt-update-status',
      \
      \ 'c' : [':setlocal cursorcolumn!'                   , 'cursorcolumn'],
      \ 'w' : [':call hasan#utils#toggleWrap()'            , 'wrap'],
      \ }
nnoremap <Leader>Ts :ShowTimer<CR>
nnoremap <Leader>Tu :UpdateCurrentTimer<space>
nnoremap <Leader>TU :UpdateCurrentStatus<space>
" }}}

" v is for vim ------------------------------------------- {{{
let g:which_key_map['v'] = {
      \ 'name' : '+vim',
      \ '.' : [':e $MYVIMRC'                  , 'open-$MYVIMRC'],
      \ '$' : 'source-$MYVIMRC',
      \ 'l' : 'logevents-toggle',
      \ }
nnoremap <leader>v$ :so $MYVIMRC<CR>
nnoremap <leader>vl :call logevents#LogEvents_Toggle()<CR>
" }}}

" w is for wiki-or-window -------------------------------- {{{
let g:which_key_map['w'] = {
      \ 'name' : '+wiki-or-window',
      \ '/' : [':Windows'                                 , 'fzf-windows'],
      \ 'v' : ['<C-w>v'                                   , 'vsplit'],
      \ 's' : ['<C-w>s'                                   , 'split'],
      \ 't' : [':-tab split'                               , 'tab-split'],
      \ 'o' : ['<C-w>o'                                   , 'only-window'],
      \ 'c' : ['<C-w>c'                                   , 'close-window'],
      \ 'z' : 'auto-zoom-win'                             ,
      \
      \ 'w' : 'wiki-index',
      \ 'T' : 'wiki-index-tab',
      \ 'i' : 'diary-index',
      \ 'n' : 'diary-today',
      \ 'N' : 'diary-today-tab',
      \ 'g' : 'diary-today-tab',
      \ 'u' : 'wiki-ui-select',
      \ }
nnoremap <leader>wz :AutoZoomWin<CR>
" vimwike mappings
nnoremap <leader>ww :VimwikiIndex<CR>
nnoremap <leader>wT :VimwikiTabIndex<CR>
nnoremap <leader>wi :VimwikiDiaryIndex<CR>
nnoremap <leader>wn :VimwikiMakeDiaryNote<CR>
nnoremap <leader>wN :VimwikiTabMakeDiaryNote<CR>
nnoremap <leader>wg :VimwikiDiaryGenerateLinks<CR>
nnoremap <leader>wu :VimwikiUISelect<CR>
" }}}

" / is for search ---------------------------------------- {{{
let g:which_key_map['/'] = {
      \ 'name' : '+search',
      \ '/' : [':History:'              , 'commands-history'],
      \ ';' : [':Commands'              , 'commands'],
      \ 'b' : [':Buffers'               , 'fzf-buffer'],
      \ 'C' : [':BCommits'              , 'fzf-buffer-commits'],
      \ 'c' : [':Commits'               , 'fzf-commits'],
      \ 'f' : [':Files'                 , 'fzf-files'],
      \ 'g' : [':GFiles'                , 'fzf-git-files'],
      \ 'G' : [':GFiles!?'              , 'fzf-git-files*'],
      \ 'h' : [':History'               , 'fzf-file-history'],
      \ 'H' : [':History/'              , 'fzf-search-history'],
      \ 'l' : [':Lines'                 , 'fzf-lines'] ,
      \ 'L' : [':BLines'                , 'fzf-buffer-lines'],
      \ 'm' : [':Marks'                 , 'fzf-marks'] ,
      \ 'k' : [':Maps!'                 , 'fzf-keymaps'] ,
      \ 'p' : 'search-word-in-project',
      \ 's' : [':CocList snippets'      , 'snippets'],
      \ 'r' : 'replace-word-in-file'          ,
      \ 't' : [':Filetypes'             , 'fzf-filetypes'],
      \ 'R' : [':RG!'                   , 'text-Rg'],
      \ 'w' : [':Windows'               , 'fzf-windows'],
      \ }
" Search world in whole project
nnoremap <leader>/p :CocSearch <C-R>=expand("<cword>")<CR><CR>
xnoremap <leader>/p y:CocSearch -F <C-r>"<Home><C-right><C-right><C-right>\<C-right>
" replace word under cursor, globally, with confirmation
nnoremap <Leader>/r :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
xnoremap <Leader>/r y :%s/<C-r>"//gc<Left><Left><Left>
" }}}

" Ignore WhichKeys --------------------------------------- {{{
" Open current file directory into the drawer
nnoremap <silent> <Leader>. :FernCurDirDrawer<CR>
nnoremap <silent> <Leader>0 :Fern . -drawer -toggle<CR><C-w>=
let g:which_key_map['.'] = 'which_key_ignore'
let g:which_key_map['0'] = 'which_key_ignore'

" Easier system clipboard usage
nnoremap <Leader>p "+p
vnoremap <Leader>p "+p
nnoremap <Leader>P "+P
nnoremap <Leader>y "+y
vnoremap <Leader>y "+ygv<Esc>
vnoremap <Leader>d "+d
let g:which_key_map['p'] = 'which_key_ignore'
let g:which_key_map['P'] = 'which_key_ignore'
let g:which_key_map['y'] = 'which_key_ignore'

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

