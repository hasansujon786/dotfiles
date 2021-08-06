" g:vimwiki_list
" http://thedarnedestthing.com/vimwiki%20cheatsheet

" let g:vimwiki_auto_chdir = 1
let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md', 'auto_toc': 1}]
let g:vimwiki_folding = 'expr'
let g:vimwiki_markdown_link_ext = 1
let g:taskwiki_markup_syntax = 'markdown'
let g:vimwiki_key_mappings =
  \ {
  \   'global': 0,
  \ }
" nnoremap <leader>gt :VimwikiRebuildTags!<cr>:VimwikiGenerateTagLinks<cr><c-l>
" nnoremap <silent><buffer> <leader><bs> :VimwikiBacklinks<cr>
xnoremap <silent> <Plug>VimwikiCreateLinkTag :call hasan#vimwiki#_create_link_tag()<CR>
" gZ

" \ 'w' : ['<Plug>VimwikiIndex'                       , 'ncdu'],
" \ 'j' : ['<plug>(wiki-journal)'                     , 'ncdu'],
" \ 'R' : ['<plug>(wiki-reload)'                      , 'ncdu'],
" \ 'C' : ['<plug>(wiki-code-run)'                    , 'ncdu'],
" \ 'b' : ['<plug>(wiki-graph-find-backlinks)'        , 'ncdu'],
" \ 'g' : ['<plug>(wiki-graph-in)'                    , 'ncdu'],
" \ 'G' : ['<plug>(wiki-graph-out)'                   , 'ncdu'],
" \ 'l' : ['<plug>(wiki-link-toggle)'                 , 'ncdu'],
" \ 'd' : ['<plug>(wiki-page-delete)'                 , 'ncdu'],
" \ 'r' : ['<plug>(wiki-page-rename)'                 , 'ncdu'],
" \ 'T' : ['<plug>(wiki-page-toc)'                    , 'ncdu'],
" \ 'Z' : ['<plug>(wiki-page-toc-local)'              , 'ncdu'],
" \ 'e' : ['<plug>(wiki-export)'                      , 'ncdu'],
" \ 'u' : ['<plug>(wiki-list-uniq)'                   , 'ncdu'],
" \ 'U' : ['<plug>(wiki-list-uniq-local)'             , 'ncdu'],
