augroup colorextend
  autocmd!
  autocmd ColorScheme * call onedark#extend_highlight("FoldColumn", { "fg": { "gui": "#4b5263" } })
augroup END

try
  colorscheme onedark
catch
endtry

" let g:one_allow_italics = 1       " support italic fonts
