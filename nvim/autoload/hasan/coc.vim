function hasan#coc#_better_search() abort
 if (index(g:coc_lsp_filetypes, &ft) >= 0)
   exe "CocList outline"
 elseif (&ft == 'vimwiki')
   exe 'VimwikiBacklinks'
 else
   exe "lua require('hasan.telescope.custom').curbuf()"
 endif
endfunction
