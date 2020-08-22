" Coc Search & refactor
nnoremap <leader>? :CocSearch <C-R>=expand("<cword>")<CR><CR>

" Single mappings
" let g:which_key_map['/'] = [ ':call Comment()'                    , 'comment' ]
nnoremap <silent> <leader>.  :e $MYVIMRC<CR>
" nnoremap <silent> <leader>;  :Commands<CR>
nnoremap <silent> <leader>:  :Commands<CR>
nnoremap <silent> <leader>u  :UndotreeToggle<CR>
nnoremap <silent> <leader>q  :q<CR>
nnoremap <silent> <leader>z  :Goyo<CR>

" let g:which_key_map['='] = [ '<C-W>='                             , 'balance windows' ]
" let g:which_key_map['d'] = [ ':Bdelete'                           , 'delete buffer']
" let g:which_key_map['e'] = [ ':CocCommand explorer'               , 'explorer' ]
" let g:which_key_map['f'] = [ ':Farr'                              , 'find and replace' ]
" let g:which_key_map['h'] = [ '<C-W>s'                             , 'split below']
" let g:which_key_map['m'] = [ ':call WindowSwap#EasyWindowSwap()'  , 'move window' ]
" let g:which_key_map['p'] = [ ':Files'                             , 'search files' ]
" let g:which_key_map['r'] = [ ':RnvimrToggle'                      , 'ranger' ]
" let g:which_key_map['v'] = [ '<C-W>v'                             , 'split right']
" let g:which_key_map['W'] = [ 'w'                                  , 'write' ]


" a is for actions
\ 'm' : [':MarkdownPreview'        , 'markdown preview'],
\ 'M' : [':MarkdownPreviewStop'    , 'markdown preview stop'],
\ 'w' : [':StripWhitespace'        , 'strip whitespace'],
\ 't' : [':FloatermToggle'         , 'terminal'],


\ 'n' : [':set nonumber!'          , 'line-numbers'],
\ 'r' : [':set norelativenumber!'  , 'relative line nums'],

" Group mappings

" f is for find and replace
