
" WhichKey configs --------------------------------------- {{{
" Map leader to which_key
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<c-u> :WhichKeyVisual '<Space>'<CR>
let g:which_key_hspace = 4
let g:which_key_centered = 0
" Create map to add keys to
let g:which_key_map =  {}
" Define a separator
let g:which_key_sep = '→'
" Not a fan of floating windows for this
let g:which_key_use_floating_win = 0
" set timeoutlen=100
" let g:which_key_display_names = {
"       \' ': 'SPC',
"       \'<C-H>': 'BS',
"       \'<C-I>': 'TAB',
"       \'<TAB>': 'TAB',
"       \'.': '●'
"       \}

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
let g:which_key_map[' '] = [':ProjectRecentFiles'                   , 'Find project file']
let g:which_key_map['.'] = [':Files'                                , 'Find file']
let g:which_key_map[':'] = [':Commands'                             , 'Search commands']
let g:which_key_map[';'] = [':History:'                             , 'Search recent cmd']
let g:which_key_map['q'] = [':Quit'                                 , 'Close window']
let g:which_key_map['r'] = [':CycleNumber'                          , 'Cycle number' ]
let g:which_key_map['s'] = [':write'                                , 'Save file' ]
let g:which_key_map['x'] = [':bdelete'                              , 'Delete buffer']
let g:which_key_map['z'] = ['za'                                    , 'Fold/Unfold' ]
let g:which_key_map['`'] = ['<c-^>'                                 , 'Switch last buffer' ]

" }}}

" a is for actions in language server protocol ----------- {{{
let g:which_key_map['a'] = {
      \ 'name' : '+lsp-actions' ,
      \ '$' : 'coc-restart',
      \ 'a' : 'coc-action',
      \ 'f' : 'format',
      \ ',' : [':CocConfig'                          , 'config'],
      \ 'U' : [':CocUpdate'                          , 'update-CoC'],
      \
      \ ';' : [':CocList'                            , 'coc-lists'],
      \ 'c' : [':CocList commands'                   , 'commands'],
      \ 'e' : [':CocList extensions'                 , 'extensions'],
      \ 'o' : [':CocList outline'                    , 'outline'],
      \ 'S' : [':CocList snippets'                   , 'snippets'],
      \ 'T' : [':CocList tasks'                      , 'list-tasks'],
      \ 's' : [':CocList -I symbols'                 , 'symbol-references'],
      \ '?' : [':CocList diagnostics'                , 'diagnostics'],
      \ '.' : [':CocListResume'                      , 'resume-list'],
      \
      \ 'h' : ['<Plug>(coc-float-hide)'              , 'float-hide'],
      \ 'j' : ['<Plug>(coc-float-jump)'              , 'float-jump'],
      \ 'l' : ['<Plug>(coc-codelens-action)'         , 'code-lens'],
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
      \ '/' : [':Buffers'                                     , 'Search buffers'],
      \ 'f' : [':bfirst'                                      , 'First buffer'],
      \ 'l' : [':blast'                                       , 'Last buffer'],
      \ 'n' : [':bnext'                                       , 'Next buffer'],
      \ 'p' : [':bprevious'                                   , 'Previous buffer'],
      \
      \ 'k' : [':Bclose'                                      , 'Kill this buffer'],
      \ 'K' : [':call hasan#utils#clear_all_buffers()'       , 'Kill all buffers'],
      \ 'o' : [':call hasan#utils#clear_other_buffers()'     , 'Kill other buffers'],
      \
      \ 's' : [':w'                                          , 'Save buffer'],
      \ 'S' : [':wa'                                         , 'Save all buffer'],
      \
      \ 'm' : [':call hasan#fzf#set_bookmark()'              , 'Set bookmark'],
      \ 'M' : [':call hasan#fzf#edit_bookmark()'             , 'Delete bookmark'],
      \ }
" }}}

" c is for color ----------------------------------------- {{{

let g:which_key_map['c'] = {
      \ 'name' : '+colorv',
      \ 'e' : [':ColorVEdit'                    , 'ColorVEdit'],
      \ 'E' : [':ColorVEditAll'                 , 'ColorVEditAll'],
      \ 'v' : [':ColorV'                        , 'ColorV'],
      \ 'i' : {
      \ 'name' : '+colorv-insert',
      \    'i' : [':ColorVInsert'               , 'ColorVInsert'],
      \  },
      \ 'c' : {
      \ 'name' : '+colorV-convert-to',
      \    'h' : [':call _colorVConvertTo("HSL")'                , 'Convert to HSL'],
      \    'H' : [':call _colorVConvertTo("HSLA")'               , 'Convert to HSLA'],
      \    'r' : [':call _colorVConvertTo("RGB")'                , 'Convert to RGB'],
      \    'R' : [':call _colorVConvertTo("RGBA")'               , 'Convert to RGBA'],
      \    'x' : [':call _colorVConvertTo("HEX#")'               , 'Convert to HEX#'],
      \    'X' : [':call _colorVConvertTo("HEXA")'               , 'Convert to HEXA'],
      \  },
      \ 'p' : {
      \ 'name' : '+preview',
      \    'l' : [':ColorVPreviewLine'          , 'ColorVPreviewLine'],
      \    'p' : [':ColorVPreview'              , 'ColorVPreview'],
      \  },
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
      \ 'name' : '+file' ,
      \ 'e' : [':Files ~/dotfiles/nvim/'        , 'Find file in nvim'],
      \ 'f' : [':Files'                         , 'Find file'],
      \ 'F' : [':FilesCurDir'                   , 'Find file from here'],
      \ 'd' : [':FilesCurDir'                   , 'Find directory'],
      \ 'r' : [':History'                       , 'Recent files'],
      \ 't' : [':Filetypes'                     , 'Change filetypes'],
      \
      \ 'i' : [':call hasan#utils#file_info()'  , 'Show file info'],
      \ 's' : [':write'                         , 'Save file'],
      \ 'S' : 'Save file as...',
      \ 'R' : 'Rename file',
      \ 'C' : 'Copy this file',
      \ 'M' : 'Move/rename file',
      \ 'y' : ['CopyFileNameToClipBoard'       , 'Yank filename' ],
      \
      \ 'u' : {
      \ 'name' : '+update-permission',
      \    'x' : [':Chmod +x'                   , 'Make this file executable'],
      \    'X' : [':Chmod -x'                   , 'Remove executable'],
      \    'w' : [':Chmod +w'                   , 'Add write permission'],
      \    'W' : [':Chmod -w'                   , 'Remove write permission'],
      \  },
      \ 'w' : ['<Plug>FixCurrentWord'           , 'Fix current world'],
      \ '.' : 'Replace world in buf'
      \ }
nnoremap <Leader>fS :w <C-R>=expand("%")<CR>
nnoremap <Leader>fC :w <C-R>=expand("%")<CR>
nnoremap <Leader>fM :Move <C-R>=expand("%")<CR>
nnoremap <Leader>fR :Rename <C-R>=expand("%:t")<CR>
" replace word under cursor, globally, with confirmation
nnoremap <Leader>f.  "zyiw:%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
xnoremap <Leader>f. "zy:%s/<C-r>"//gc<Left><Left><Left>

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
      \  },
      \ }
" }}}

" o is for open ------------------------------------------ {{{
let g:which_key_map['o'] = {
      \ 'name' : '+open',
      \ '-' : [':FernCurDir'                               , 'Fern'],
      \ 'a' : ['<Plug>(dotoo-agenda)'                      , '+org-agenda'],
      \ 'c' : ['<Plug>(dotoo-capture-custom)'              , '+org-capture'],
      \ 't' : [':FloatermToggle'                           , 'Toggle terminal popup'],
      \ 'T' : [':FloatermNew --wintype=normal --height=10' , 'Open terminal split'],
      \ 'q' : [':QfixToggle'                               , 'Quickfix'],
      \ 'y' : [':CocList --normal yank'                    , 'Yank list'],
      \ 'p' : [':FernDrawerToggle!'                        , 'Project sidebar' ],
      \ 'P' : [':call hasan#fern#reveal()'                 , 'Find file in PSB' ],
      \ }
" }}}

" p is for project --------------------------------------- {{{
let g:which_key_map['p'] = {
      \ 'name' : '+project',
      \ 'p' : [':Projects'               , 'Switch project'],
      \ 'r' : [':ProjectRecentFiles'     , 'Find recent project files'],
      \ }
" }}}

" S is for session --------------------------------------- {{{
" @todo: Add session support.
let g:which_key_map['S'] = {
      \ 'name' : '+Session',
      \ 'd' : [':Dashboard'        , 'Open dashboard'],
      \ 'l' : [':SessionLoad'      , 'Load session'],
      \ 'S' : [':SessionSave'      , 'Save session'],
      \ }
" }}}

" t is for task ------------------------------------------ {{{
let g:which_key_map['t'] = {
      \ 'name' : '+task',
      \ 'e' : 'TaskWikiAdvancedEdit',
      \}
" }}}

" ` is for toggle ---------------------------------------- {{{
" let g:which_key_map['`'] = {
"       \ 'name' : '+toggle',
"       \ 'c' : [':setlocal cursorcolumn!'                   , 'cursorcolumn'],
"       \ 'w' : [':call hasan#utils#toggleWrap()'            , 'toggle-wrap'],
"       \
"       \ '`' : {
"       \ 'name' : '+task-and-timer',
"       \    'b' : [':Break'              , 'tt-break'],
"       \    'h' : [':HideAndShowTimer'   , 'tt-hide-timer'],
"       \    'o' : [':OpenTasks'          , 'tt-open-tasks'],
"       \    'p' : [':PauseOrPlayTimer'   , 'tt-pause-or-play'],
"       \    'w' : [':Work'               , 'tt-work'],
"       \    's' : ['ShowTimer'           , 'tt-status'],
"       \    'u' : 'tt-update-timer',
"       \    'U' : 'tt-update-status',
"       \ }
"       \ }
" nnoremap <Leader>``u :UpdateCurrentTimer<space>
" nnoremap <Leader>``U :UpdateCurrentStatus<space>
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
      \ '/' : [':BetterSearch'          , 'Better search'],
      \ 'd' : [':RGCurDir'              , 'Search current directory'],
      \ 'D' :                             'Search other directory',
      \ 'p' :                             'Search in project',
      \
      \ 'f' : [':Files'                 , 'Find file'],
      \ 'F' : [':FilesCurDir'           , 'Find file from here'],
      \ 'b' : [':Buffers'               , 'Find buffers'],
      \ 'g' : [':GFiles?'               , 'Find git files*'],
      \ 'r' : [':History'               , 'Recent files'],
      \ 'w' : [':Windows'               , 'Find windows'],
      \
      \ 'c' : [':BCommits'              , 'Look up buffer commits'],
      \ 'C' : [':Commits'               , 'Look up commits'],
      \ 'h' : [':History/'              , 'Look up search history'],
      \ 'k' : [':Maps!'                 , 'Look up keymaps'] ,
      \ 'm' : [':Bookmarks'             , 'Jump to bookmark'] ,
      \ 'M' : [':Marks'                 , 'Jump to marks'] ,
      \ 't' : [':Filetypes'             , 'Change filetypes'],
      \ }
" Search word in whole project
nnoremap <leader>/p :RG!<CR>
xnoremap <leader>/p "zy:RG! <C-r>z<CR>
nnoremap <leader>/D :RGDir<space>
" }}}

" tmux --------------------------------------------------- {{{
if !exists('$TMUX')
  let g:which_key_map.g.l = [ ':FloatermNew --name=lazygit lazygit'                 , 'Lazygit' ]
  let g:which_key_map.g.t = [ ':FloatermNew --name=lazygittig tig'                  , 'Tig' ]

  let g:which_key_map.o.l = [ ':FloatermNew --name=lf lf'                           , 'Lf' ]
  let g:which_key_map.o.L = [ ':FloatermNew --name=lf lf %:p'                       , 'File in Lf' ]
  let g:which_key_map.o.v = [ ':FloatermNew --name=vit vit'                         , 'Vit' ]
else
  let g:which_key_map.g.l = [ ':silent !tmux new-window "lazygit"'                  , 'Lazygit' ]
  let g:which_key_map.g.t = [ ':silent !tmux new-window "tig"'                      , 'Tig' ]

  let g:which_key_map.o.l = [ ':silent !tmux new-window "lf"'                       , 'Lf' ]
  let g:which_key_map.o.L = [ ':silent !tmux new-window "lf" %:p'                   , 'File in Lf' ]
  let g:which_key_map.o.v = [ ':silent !tmux new-window -n "vit" "vit"'             , 'Vit' ]
endif
" }}}

" Ignore WhichKeys --------------------------------------- {{{
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
let g:which_key_map['h'] = [':JumpToWin h'     , 'which_key_ignore']
let g:which_key_map['j'] = [':JumpToWin j'     , 'which_key_ignore']
let g:which_key_map['k'] = [':JumpToWin k'     , 'which_key_ignore']
let g:which_key_map['l'] = [':JumpToWin l'     , 'which_key_ignore']

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

