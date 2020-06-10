" " NERDTrees File highlighting
" function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
"  exec 'autocmd FileType nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
"  exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
" endfunction

" call NERDTreeHighlightFile('jade', 'green', 'none', 'green', 'none')
" call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', 'none')
" call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', 'none')
" call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', 'none')
" call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', 'none')
" call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', 'none')
" call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', 'none')
" call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', 'none')
" call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', 'none')
" call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', 'none')
" call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', 'none')
" call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', 'none')
" call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', 'none')
" call NERDTreeHighlightFile('ds_store', 'Gray', 'none', '#686868', 'none')
" call NERDTreeHighlightFile('gitconfig', 'Gray', 'none', '#686868', 'none')
" call NERDTreeHighlightFile('gitignore', 'Gray', 'none', '#686868', 'none')
" call NERDTreeHighlightFile('bashrc', 'Gray', 'none', '#686868', 'none')
" call NERDTreeHighlightFile('bashprofile', 'Gray', 'none', '#686868', 'none')


" " NERDTrees File highlighting only the glyph/icon
" " test highlight just the glyph (icons) in nerdtree:
" autocmd filetype nerdtree highlight haskell_icon ctermbg=none ctermfg=Red guifg=#ffa500
" autocmd filetype nerdtree highlight html_icon ctermbg=none ctermfg=Red guifg=#ffa500
" autocmd filetype nerdtree highlight go_icon ctermbg=none ctermfg=Red guifg=#ffa500
" autocmd filetype nerdtree highlight css_icon ctermbg=none ctermfg=Red guifg=#00a5ff

" " if you are using another syn highlight for a given line (e.g.
" " NERDTreeHighlightFile) need to give that name in the 'containedin' for this
" " other highlight to work with it
" autocmd filetype nerdtree syn match haskell_icon ## containedin=NERDTreeFile
" autocmd filetype nerdtree syn match html_icon ## containedin=NERDTreeFile,html
" autocmd filetype nerdtree syn match go_icon ## containedin=NERDTreeFile
" autocmd filetype nerdtree syn match css_icon ## containedin=NERDTreeFile

" if exists("g:loaded_webdevicons")
"   call webdevicons#refresh()
" endif


" set confirm
" vmap <C-c><C-c> <Plug>SendSelectionToTmux
" nmap <C-c><C-c> <Plug>NormalModeSendToTmux
" nmap <C-c>r <Plug>SetTmuxVars
" set wildchar=<Tab> wildmenu wildmode=full
" set wildcharm=<C-Z>
" set wildignore=*.o,*.obj,*~                                                     "stuff to ignore when tab completing
" set wildignore+=*vim/backups*
" set wildignore+=*logs*
" set wildignore+=*node_modules/**
" set wildignore+=*DS_Store*
" set wildignore+=*.gem
" set wildignore+=log/**
" set wildignore+=tmp/**
" set wildignore+=*.png,*.jpg,*.gif

