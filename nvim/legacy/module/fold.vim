" => Fold-related ----------------------------------
autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
autocmd InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif

set foldlevel=99

autocmd FileType vim setlocal foldmethod=marker
autocmd FileType vim setlocal foldlevel=0

autocmd FileType css,scss,json setlocal foldmethod=marker
autocmd FileType css,scss,json setlocal foldmarker={,}

" autocmd FileType javascript,typescript,json setl foldmethod=syntax
" autocmd FileType javascript,typescript,typescript.tsx,typescriptreact,json setl foldmethod=syntax
autocmd FileType javascript,typescript,typescript.tsx,typescriptreact,json,lua,vue setl foldmethod=expr
autocmd FileType javascript,typescript,typescript.tsx,typescriptreact,json,lua,vue call timer_start(10, function('s:set_fold'))
function s:set_fold(...) "{{{
  setl foldexpr=nvim_treesitter#foldexpr()
endfunction
"}}}

function! MyFoldText() " {{{
  let line = getline(v:foldstart)
  let nucolwidth = &fdc + &number * &numberwidth
  let windowwidth = winwidth(0) - nucolwidth - 3
  let foldedlinecount = (v:foldend-v:foldstart+1)

  " expand tabs into spaces
  let onetab = strpart('          ', 0, &tabstop)
  let line = substitute(line, '\t', onetab, 'g')

  let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
  let fillcharcount = windowwidth - len(line)

  return line .' ['.foldedlinecount.'ℓ]'. repeat(" ",fillcharcount)
endfunction " }}}
set foldtext=MyFoldText()

" augroup remember_folds
"   autocmd!
"   au BufWritePost ?*.js,*.ts,*.json,*.jsonc,*.css,*.html,*.vue mkview 1
"   au BufReadPost ?*.js,*.ts,*.json,*.jsonc,*.css,*.html,*.vue silent! loadview 1
" augroup END
" let g:session_dir = '$HOME/.nvim/sessions/'
