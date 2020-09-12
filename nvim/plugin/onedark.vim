augroup colorextend
  autocmd!
  autocmd ColorScheme * call onedark#extend_highlight("FoldColumn", { "fg": { "gui": "#4b5263" } })
augroup END

let g:onedark_terminal_italics = 1       " support italic fonts

try
  colorscheme onedark
catch
endtry

" put =execute('echo onedark#GetColors()')

