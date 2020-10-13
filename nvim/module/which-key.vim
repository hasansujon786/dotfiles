
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
" let g:which_key_map['d'] = 'which_key_ignore'

" Coc Search & refactor
" Search world in whole project
" Change dir to current file's dir
nnoremap <leader>CD :cd %:p:h<CR>:pwd<CR>
nnoremap <leader>cs :CocSearch <C-R>=expand("<cword>")<CR><CR>
xnoremap <leader>cs y:CocSearch -F <C-r>"<Home><C-right><C-right><C-right>\<C-right>
nnoremap <leader>? :CocSearch <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader><TAB> <c-^>
" Open yank list
" nnoremap <silent> <leader>cy :<C-u>CocList -A --normal yank<cr>
nnoremap <silent> <leader>cy :<C-u>CocList --normal yank<cr>
" }}}

" Single mappings ---------------------------------------- {{{
let g:which_key_map['l'] = [ ':wincmd l'       , 'window right' ]
let g:which_key_map['h'] = [ ':wincmd h'       , 'window left' ]
let g:which_key_map['j'] = [ ':wincmd j'       , 'window bellow' ]
let g:which_key_map['k'] = [ ':wincmd k'       , 'window above' ]

let g:which_key_map['?'] = 'search word'
let g:which_key_map['n'] = [ ':call hasan#fern#open_drawer()'       , 'open fern' ]
let g:which_key_map['s'] = [ ':update'                              , 'save file' ]
let g:which_key_map['q'] = [ ':call hasan#utils#confirmQuit(0)'     , 'close window' ]
let g:which_key_map['r'] = [ ':call hasan#utils#cycle_numbering()'  , 'cycle number' ]
let g:which_key_map['='] = [ '<C-W>='                               , 'balance windows' ]
let g:which_key_map['x'] = [ ':bdelete'                             , 'delete buffer']
let g:which_key_map['m'] = [ ':call WindowSwap#EasyWindowSwap()'    , 'move window' ]
let g:which_key_map['z'] = [ 'za'                                   , 'fold' ]
" let g:which_key_map['z'] = [ 'Goyo'                                 , 'zen' ]
" let g:which_key_map[';'] = [ ':Commands'                            , 'commands' ]
" }}}

" a is for actions ins language server protocol ---------- {{{
let g:which_key_map['a'] = {
      \ 'name' : '+lsp-actions' ,
      \ '.' : [':CocConfig'                          , 'config'],
      \ ';' : ['<Plug>(coc-refactor)'                , 'refactor'],
      \ '?' : [':CocList diagnostics'                , 'diagnostics'],
      \ 'a' : ['<Plug>(coc-codeaction)'              , 'line action'],
      \ 'A' : ['<Plug>(coc-codeaction-selected)'     , 'selected action'],
      \ 'b' : [':CocNext'                            , 'next action'],
      \ 'B' : [':CocPrev'                            , 'prev action'],
      \ 'c' : [':CocList commands'                   , 'commands'],
      \ 'd' : ['<Plug>(coc-definition)'              , 'definition'],
      \ 'D' : ['<Plug>(coc-declaration)'             , 'declaration'],
      \ 'e' : [':CocList extensions'                 , 'extensions'],
      \ 'f' : ['<Plug>(coc-format-selected)'         , 'format selected'],
      \ 'F' : ['<Plug>(coc-format)'                  , 'format'],
      \ 'h' : ['<Plug>(coc-float-hide)'              , 'hide'],
      \ 'i' : ['<Plug>(coc-implementation)'          , 'implementation'],
      \ 'j' : ['<Plug>(coc-float-jump)'              , 'float jump'],
      \ 'l' : ['<Plug>(coc-codelens-action)'         , 'code lens'],
      \ 'n' : ['<Plug>(coc-diagnostic-next)'         , 'next diagnostic'],
      \ 'N' : ['<Plug>(coc-diagnostic-next-error)'   , 'next error'],
      \ 'o' : [':CocList outline'                    , 'outline'],
      \ 'O' : [':Vista!!'                            , 'outline'],
      \ 'p' : ['<Plug>(coc-diagnostic-prev)'         , 'prev diagnostic'],
      \ 'P' : ['<Plug>(coc-diagnostic-prev-error)'   , 'prev error'],
      \ 'q' : ['<Plug>(coc-fix-current)'             , 'quickfix'],
      \ 'r' : ['<Plug>(coc-references)'              , 'references'],
      \ 'R' : ['<Plug>(coc-rename)'                  , 'rename'],
      \ 's' : [':CocList -I symbols'                 , 'references'],
      \ 'S' : [':CocList snippets'                   , 'snippets'],
      \ 't' : ['<Plug>(coc-type-definition)'         , 'type definition'],
      \ 'T' : [':CocList tasks'                      , 'list tasks'],
      \ 'u' : [':CocListResume'                      , 'resume list'],
      \ 'U' : [':CocUpdate'                          , 'update CoC'],
      \ 'z' : [':CocDisable'                         , 'disable CoC'],
      \ 'Z' : [':CocEnable'                          , 'enable CoC'],
      \ }
      " \ 'o' : ['<Plug>(coc-openlink)'                , 'open link'],
" }}}

" b is for buffer ---------------------------------------- {{{
let g:which_key_map['b'] = {
      \ 'name' : '+buffer' ,
      \ '1' : ['b1'        , 'buffer 1'],
      \ '2' : ['b2'        , 'buffer 2'],
      \ 'd' : [':Bclose'   , 'delete-buffer'],
      \ 'f' : ['bfirst'    , 'first-buffer'],
      \ 'l' : ['blast'     , 'last-buffer'],
      \ 'n' : ['bnext'     , 'next-buffer'],
      \ 'p' : ['bprevious' , 'previous-buffer'],
      \ 'b' : ['Buffers'   , 'fzf-buffer'],
      \ }
" }}}

" e is for edit ------------------------------------------ {{{
let g:which_key_map['e'] = {
      \ 'name' : '+edit',
      \ '.' : [':e $MYVIMRC'        , 'open $MYVIMRC'],
      \ 'b' : [':Fern bookmark:///' , 'history'],
      \ 'e' : 'edit directory'      ,
      \ 'd' : 'create directory'    ,
      \ 'r' : 'rename cur file'     ,
      \ 't' : 'edit in tab'         ,
      \ 's' : 'edit in split'       ,
      \ 'v' : 'edit in vsplit'      ,
      \ '%' : 'source current file' ,
      \ }
" Open a file relative to the current file
nnoremap <Leader>er :Move <C-R>=expand("%")<CR>
nnoremap <leader>ed :Mkdir <C-R>=expand('%:h').'/'<cr>
nnoremap <leader>et :tabe <C-R>=expand('%:h').'/'<cr>
nnoremap <leader>ev :vsp <C-R>=expand('%:h').'/'<cr>
nnoremap <leader>es :sp <C-R>=expand('%:h').'/'<cr>
nnoremap <leader>ee :e <C-R>=expand('%:h').'/'<cr>
nnoremap <leader>e% :write<CR>:so %<CR>
" }}}

" f is for find ------------------------------------------ {{{
" TODO: fix mappings
let g:which_key_map['f'] = {
      \ 'name' : '+find' ,
      \ '/' : [':History/'     , 'history'],
      \ ';' : [':Commands'     , 'commands'],
      \ 'b' : [':BLines'       , 'current buffer'],
      \ 'B' : [':Buffers'      , 'open buffers'],
      \ 'c' : [':Commits'      , 'commits'],
      \ 'C' : [':BCommits'     , 'buffer commits'],
      \ 'f' : 'find & replace',
      \ 'g' : [':GFiles'       , 'git files'],
      \ 'G' : [':GFiles?'      , 'modified git files'],
      \ 'h' : [':History'      , 'file history'],
      \ 'H' : [':History:'     , 'command history'],
      \ 'l' : [':Lines'        , 'lines'] ,
      \ 'm' : [':Marks'        , 'marks'] ,
      \ 'M' : [':Maps'         , 'normal maps'] ,
      \ 'p' : [':Helptags'     , 'help tags'] ,
      \ 'P' : [':Tags'         , 'project tags'],
      \ 'R' : [':RG!'          , 'text RG'],
      \ 's' : [':Snippets'     , 'snippets'],
      \ 'S' : [':Colors'       , 'color schemes'],
      \ 'T' : [':BTags'        , 'buffer tags'],
      \ 'w' : [':Windows'      , 'search windows'],
      \ 'y' : [':Filetypes'    , 'file types'],
      \ 'z' : [':FZF'          , 'FZF'],
      \ }
" replace word under cursor, globally, with confirmation
nnoremap <Leader>ff :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
xnoremap <Leader>ff y :%s/<C-r>"//gc<Left><Left><Left>
" interactive find replace preview
set inccommand=nosplit
" }}}

" g is for git ------------------------------------------- {{{
let g:which_key_map['g'] = {
      \ 'name' : '+git',
      \ 'a' : [':Git add %'                        , 'add current'],
      \ 'A' : [':Git add .'                        , 'add all'],
      \ 'b' : [':Git blame'                        , 'blame'],
      \ 'B' : [':GBrowse'                          , 'browse'],
      \ 'd' : [':Gvdiffsplit!'                     , 'diff split'],
      \ 'D' : [':Git diff'                         , 'diff'],
      \ 'g' : [':Gstatus'                          , 'status'],
      \ 'h' : [':GitGutterLineHighlightsToggle'    , 'highlight hunks'],
      \ 'H' : ['<Plug>(GitGutterPreviewHunk)'      , 'preview hunk'],
      \ 'i' : [':Gist -b'                          , 'post gist'],
      \ 'j' : ['<Plug>(GitGutterNextHunk)'         , 'next hunk'],
      \ 'k' : ['<Plug>(GitGutterPrevHunk)'         , 'prev hunk'],
      \ 'L' : [':Git log'                          , 'log'],
      \ 'm' : ['<Plug>(git-messenger)'             , 'message'],
      \ 'p' : [':Git pull'                         , 'pull'],
      \ 'P' : [':Git push'                         , 'push'],
      \ 'r' : [':GRemove'                          , 'remove'],
      \ 's' : ['<Plug>(GitGutterStageHunk)'        , 'stage hunk'],
      \ 'S' : [':!git status'                      , 'status'],
      \ 'T' : [':GitGutterSignsToggle'             , 'toggle signs'],
      \ 'u' : ['<Plug>(GitGutterUndoHunk)'         , 'undo hunk'],
      \ 'v' : [':GV'                               , 'view commits'],
      \ 'V' : [':GV!'                              , 'view buffer commits'],
      \ }
if !exists('$TMUX')
  let g:which_key_map.g.l = [ ':FloatermNew --name=lazygit lazygit'   , 'lazygit' ]
  let g:which_key_map.g.t = [ ':FloatermNew --name=tig tig'           , 'tig' ]
else
  let g:which_key_map.g.l = [ ':silent !tmux new-window "lazygit"'    , 'lazygit' ]
  let g:which_key_map.g.t = [ ':silent !tmux new-window "tig"'        , 'tig' ]
endif
" }}}

" S is for session --------------------------------------- {{{
let g:which_key_map['S'] = {
      \ 'name' : '+Session',
      \ 'c' : [':SClose'          , 'Close Session'],
      \ 'd' : [':SDelete'         , 'Delete Session'],
      \ 'l' : [':SLoad'           , 'Load Session'],
      \ 's' : [':Startify'        , 'Start Page'],
      \ 'S' : [':SSave'           , 'Save Session'],
      \ }
" }}}

" t is for toggle ---------------------------------------- {{{
let g:which_key_map['t'] = {
      \ 'name' : '+toggle',
      \ ';' : [':FloatermNew --wintype=normal --height=6'  , 'terminal'],
      \ 'c' : [':setlocal cursorcolumn!'                    , 'cursorcolumn'],
      \ 'q' : [':call hasan#utils#quickFix_toggle()'       , 'quickfix'],
      \ 'w' : [':call hasan#utils#toggleWrap()'            , 'wrap'],
      \ }
" }}}

" w is for wiki-or-window -------------------------------- {{{
let g:which_key_map['w'] = {
      \ 'name' : '+wiki-or-window',
      \ 'v' : ['<C-w>v'                                   , 'split right'],
      \ 's' : ['<C-w>s'                                   , 'split bellow'],
      \ 'o' : ['<C-w>o'                                   , 'only window'],
      \ 'z' : [':AutoZoomWin'                             , 'AutoZoomWin'],
      \ 'w' : ['<Plug>VimwikiIndex'                       , 'ncdu'],
      \ 'n' : ['<plug>(wiki-open)'                        , 'ncdu'],
      \ 'j' : ['<plug>(wiki-journal)'                     , 'ncdu'],
      \ 'R' : ['<plug>(wiki-reload)'                      , 'ncdu'],
      \ 'c' : ['<plug>(wiki-code-run)'                    , 'ncdu'],
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
" }}}

" / is for search ---------------------------------------- {{{
" TODO: fix mappings
let g:which_key_map['/'] = {
      \ 'name' : '+search',
      \ '/' : [':History/'              , 'history'],
      \ ';' : [':Commands'              , 'commands'],
      \ 'b' : [':BLines'                , 'current buffer'],
      \ 'B' : [':Buffers'               , 'open buffers'],
      \ 'c' : [':Commits'               , 'commits'],
      \ 'C' : [':BCommits'              , 'buffer commits'],
      \ 'f' : [':Files'                 , 'files'],
      \ 'g' : [':GFiles'                , 'git files'],
      \ 'G' : [':GFiles?'               , 'modified git files'],
      \ 'h' : [':History'               , 'file history'],
      \ 'H' : [':History:'              , 'command history'],
      \ 'l' : [':Lines'                 , 'lines'] ,
      \ 'm' : [':Marks'                 , 'marks'] ,
      \ 'M' : [':Maps'                  , 'normal maps'] ,
      \ 'p' : [':Helptags'              , 'help tags'] ,
      \ 'P' : [':Tags'                  , 'project tags'],
      \ 's' : [':CocList snippets'      , 'snippets'],
      \ 'S' : [':Colors'                , 'color schemes'],
      \ 'r' : [':RG!'                    , 'text Rg'],
      \ 'T' : [':BTags'                 , 'buffer tags'],
      \ 'w' : [':Windows'               , 'search windows'],
      \ 'y' : [':Filetypes'             , 'file types'],
      \ 'z' : [':FZF'                   , 'FZF'],
      \ }
      " \ 's' : [':Snippets'     , 'snippets'],
" }}}

" Register which key map
call which_key#register('<Space>', "g:which_key_map")
