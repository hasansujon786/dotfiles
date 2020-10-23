
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

" Ignore WhichKeys --------------------------------------- {{{
" Map 1-9 + <Space> to jump to respective tab
let i = 1
while i < 10
  execute ":nnoremap <silent> <Space>" . i . " :tabn " . i . "<CR>"
  let g:which_key_map[i] = 'which_key_ignore'
  let i += 1
endwhile

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
" }}}

" Single mappings ---------------------------------------- {{{
let g:which_key_map['n'] = [ ':call hasan#fern#open_drawer()'       , 'open-fern' ]
let g:which_key_map['q'] = [ ':Q'                                   , 'close-window' ]
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
nnoremap <silent> <leader>k :wincmd k<CR>
nnoremap <silent> <leader>j :wincmd j<CR>
nnoremap <silent> <leader>l :wincmd l<CR>
nnoremap <silent> <leader>h :wincmd h<CR>
nnoremap <silent> <leader>r :call hasan#utils#cycle_numbering()<CR>
nnoremap <silent> <leader><TAB> :AlternateFile<CR>
" nnoremap <silent> <leader>q :Q<CR>


" }}}

" a is for actions ins language server protocol ---------- {{{
" @todo: fix bindgigs
let g:which_key_map['a'] = {
      \ 'name' : '+lsp-actions' ,
      \ '.' : [':CocConfig'                          , 'config'],
      \ ';' : ['<Plug>(coc-refactor)'                , 'refactor'],
      \ '?' : [':CocList diagnostics'                , 'diagnostics'],
      \ 'a' : ['<Plug>(coc-codeaction)'              , 'line-action'],
      \ 'A' : ['<Plug>(coc-codeaction-selected)'     , 'selected action'],
      \ 'b' : [':CocNext'                            , 'next-action'],
      \ 'B' : [':CocPrev'                            , 'prev-action'],
      \ 'c' : [':CocList commands'                   , 'commands'],
      \ 'd' : ['<Plug>(coc-definition)'              , 'definition'],
      \ 'D' : ['<Plug>(coc-declaration)'             , 'declaration'],
      \ 'e' : [':CocList extensions'                 , 'extensions'],
      \ 'f' : ['<Plug>(coc-format-selected)'         , 'format-selected'],
      \ 'F' : ['<Plug>(coc-format)'                  , 'format'],
      \ 'h' : ['<Plug>(coc-float-hide)'              , 'hide'],
      \ 'i' : ['<Plug>(coc-implementation)'          , 'implementation'],
      \ 'j' : ['<Plug>(coc-float-jump)'              , 'float-jump'],
      \ 'l' : ['<Plug>(coc-codelens-action)'         , 'code-lens'],
      \ 'n' : ['<Plug>(coc-diagnostic-next)'         , 'next-diagnostic'],
      \ 'N' : ['<Plug>(coc-diagnostic-next-error)'   , 'next-error'],
      \ 'o' : [':CocList outline'                    , 'outline'],
      \ 'O' : [':Vista!!'                            , 'outline'],
      \ 'p' : ['<Plug>(coc-diagnostic-prev)'         , 'prev-diagnostic'],
      \ 'P' : ['<Plug>(coc-diagnostic-prev-error)'   , 'prev-error'],
      \ 'q' : ['<Plug>(coc-fix-current)'             , 'quickfix'],
      \ 'r' : ['<Plug>(coc-references)'              , 'references'],
      \ 'R' : ['<Plug>(coc-rename)'                  , 'rename'],
      \ 's' : [':CocList -I symbols'                 , 'references'],
      \ 'S' : [':CocList snippets'                   , 'snippets'],
      \ 't' : ['<Plug>(coc-type-definition)'         , 'type-definition'],
      \ 'T' : [':CocList tasks'                      , 'list-tasks'],
      \ 'u' : [':CocListResume'                      , 'resume-list'],
      \ 'U' : [':CocUpdate'                          , 'update-CoC'],
      \ 'z' : [':CocDisable'                         , 'disable-CoC'],
      \ 'Z' : [':CocEnable'                          , 'enable-CoC'],
      \ }
      " \ 'o' : ['<Plug>(coc-openlink)'                , 'open link'],
" }}}

" b is for buffer ---------------------------------------- {{{
let g:which_key_map['b'] = {
      \ 'name' : '+buffer',
      \ '/' : ['Buffers'                            , 'fzf-buffer'],
      \ 'd' : ['Bclose'                             , 'delete-buffer'],
      \ 'D' : [':call hasan#utils#clear_buffers()'  , 'kill-other-buffers'],
      \ 'f' : ['bfirst'                             , 'first-buffer'],
      \ 'l' : ['blast'                              , 'last-buffer'],
      \ 'n' : ['bnext'                              , 'next-buffer'],
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
      \ 'v' : {
      \ 'name' : '+vim',
      \    '.' : [':e $MYVIMRC'                 , 'open-$MYVIMRC'],
      \  },
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
      \ 'a' : [':Git add %'                        , 'add-current'],
      \ 'b' : [':Git blame'                        , 'blame'],
      \ 'i' : [':Gist -b'                          , 'post-gist'],
      \ 'L' : [':Git log'                          , 'log'],
      \
      \ 'B' : [':GBrowse'                          , 'browse'],
      \ 'd' : [':Gvdiffsplit!'                     , 'diff'],
      \ 'g' : [':Gstatus'                          , 'status'],
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

" w is for wiki-or-window -------------------------------- {{{
let g:which_key_map['w'] = {
      \ 'name' : '+wiki-or-window',
      \ '/' : [':Windows'                                 , 'fzf-windows'],
      \ 'v' : ['<C-w>v'                                   , 'split-right'],
      \ 's' : ['<C-w>s'                                   , 'split-bellow'],
      \ 'o' : ['<C-w>o'                                   , 'only-window'],
      \ 'c' : ['<C-w>c'                                   , 'only-window'],
      \ 'z' : 'auto-zoom-win'                             ,
      \ 'w' : ['<Plug>VimwikiIndex'                       , 'ncdu'],
      \ 'n' : ['<plug>(wiki-open)'                        , 'ncdu'],
      \ 'j' : ['<plug>(wiki-journal)'                     , 'ncdu'],
      \ 'R' : ['<plug>(wiki-reload)'                      , 'ncdu'],
      \ 'C' : ['<plug>(wiki-code-run)'                    , 'ncdu'],
      \ 'b' : ['<plug>(wiki-graph-find-backlinks)'        , 'ncdu'],
      \ 'g' : ['<plug>(wiki-graph-in)'                    , 'ncdu'],
      \ 'G' : ['<plug>(wiki-graph-out)'                   , 'ncdu'],
      \ 'l' : ['<plug>(wiki-link-toggle)'                 , 'ncdu'],
      \ 'd' : ['<plug>(wiki-page-delete)'                 , 'ncdu'],
      \ 'r' : ['<plug>(wiki-page-rename)'                 , 'ncdu'],
      \ 't' : ['<plug>(wiki-page-toc)'                    , 'ncdu'],
      \ 'T' : ['<plug>(wiki-page-toc-local)'              , 'ncdu'],
      \ 'e' : ['<plug>(wiki-export)'                      , 'ncdu'],
      \ 'u' : ['<plug>(wiki-list-uniq)'                   , 'ncdu'],
      \ 'U' : ['<plug>(wiki-list-uniq-local)'             , 'ncdu'],
      \ }
nnoremap <leader>wz :AutoZoomWin<CR>
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
" interactive find replace preview
set inccommand=nosplit

" }}}

" Register which key map
call which_key#register('<Space>', "g:which_key_map")

