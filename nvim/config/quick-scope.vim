let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
" let qs_max_chars=80
augroup qs_colors
  autocmd!
  autocmd ColorScheme * highlight QuickScopePrimary guifg='tomato' gui=underline ctermfg=155 cterm=underline
  autocmd ColorScheme * highlight QuickScopeSecondary guifg='#d78787' gui=underline ctermfg=81 cterm=underline
augroup END


