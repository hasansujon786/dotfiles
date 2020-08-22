" => Single mappings ======================================
nnoremap <silent> <leader>; :Commands<CR>
nnoremap <silent> <leader>q :close<CR>
" Switch between the last two files
nnoremap <silent> <leader><tab> <c-^>
nnoremap <silent> <leader>z za
vnoremap <silent> <leader>z za
" Easier system clipboard usage
vnoremap <Leader>y "+ygv<Esc>
vnoremap <Leader>d "+d
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P
vnoremap <Leader>p "+p
vnoremap <Leader>P "+P
" Save file Quickly
nnoremap <leader>s :write<CR>
nnoremap <C-s> :write<CR>
inoremap <C-s> <Esc>:write<CR><Esc>a
" Open nerd tree at the current file or close nerd tree if pressed again.
nnoremap <silent> <expr> <Leader>n g:NERDTree.IsOpen() ? "\:NERDTreeClose<CR>" : bufexists(expand('%')) ? "\:NERDTreeFind<CR>" : "\:NERDTree<CR>"
nnoremap <silent> <Leader>0 :NERDTreeToggle<CR>
" Map 1-9 + <Space> to jump to respective tab
let i = 1
while i < 10
  execute ":nmap <silent> <Space>" . i . " :tabn " . i . "<CR>"
  let i += 1
endwhile

" Group mappings

" => e is for Edit ========================================
" Open a file relative to the current file
" Synonyms: e: edit,
" e: window, s: split, v: vertical split, t: tab, d: directory
nnoremap <Leader>er :Move <C-R>=expand("%")<CR>
nnoremap <leader>ed :Mkdir <C-R>=expand('%:h').'/'<cr>
nnoremap <leader>et :tabe <C-R>=expand('%:h').'/'<cr>
nnoremap <leader>ev :vsp <C-R>=expand('%:h').'/'<cr>
nnoremap <leader>es :sp <C-R>=expand('%:h').'/'<cr>
nnoremap <leader>ee :e <C-R>=expand('%:h').'/'<cr>

" => f & r is for find & replace ==========================
" Search world in whole project
nmap <leader>ff :CocSearch <C-R>=expand("<cword>")<CR><CR>
xmap <leader>ff y :CocSearch -F <C-r>"<C-a><C-right><C-right><C-right>\
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
" interactive find replace preview
set inccommand=nosplit
" replace word under cursor, globally, with confirmation
nmap <Leader>rr :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
xmap <Leader>rr y :%s/<C-r>"//gc<Left><Left><Left>

" => g is for git =========================================
nmap <silent> <leader>gg :Gstatus<CR>
nmap <silent> <leader>gp <Plug>(GitGutterPreviewHunk)
nmap <silent> <leader>gs <Plug>(GitGutterStageHunk)
vmap <silent> <leader>gs <Plug>(GitGutterStageHunk)
nmap <silent> <leader>gu <Plug>(GitGutterUndoHunk)
nmap <silent> <leader>gl :FloatermNew --height=0.99 --width=0.98 --name=lazygit lazygit<CR>

" => t is for toggle ======================================
" Toggle highlighting of current line and column
nnoremap <silent> <leader>tc :setlocal cursorcolumn!<CR>
" Toggle quickfix window {{{
function! QuickFix_toggle()
  for i in range(1, winnr('$'))
    let bnum = winbufnr(i)
    if getbufvar(bnum, '&buftype') == 'quickfix'
      cclose
      return
    endif
  endfor
  copen
endfunction
" }}}
nnoremap <silent> <Leader>tq :call QuickFix_toggle()<CR>
" Toggle relative line numbers and regular line numbers.
nnoremap <silent> <leader>tr :set invrelativenumber<CR>
nnoremap <silent> <leader>tn :set number!<CR>
" Toggle wrap {{{
" Allow j and k to work on visual lines (when wrapping)
function! ToggleWrap()
  if &wrap
    echo 'Wrap OFF'
    setlocal nowrap
    set virtualedit=all
    silent! nunmap <buffer> j
    silent! nunmap <buffer> k
  else
    " TODO: fix jk mapping while wrap toggle
    echo 'Wrap ON'
    setlocal wrap linebreak nolist
    set virtualedit=
    setlocal display+=lastline
    noremap  <buffer> <silent> k gk
    noremap  <buffer> <silent> j gj
    inoremap <buffer> <silent> <Up> <C-o>gk
    inoremap <buffer> <silent> <Down> <C-o>gj
  endif
endfunction
" }}}
noremap <silent> <leader>tw :call ToggleWrap()<CR>

" => v is for vim =========================================
nnoremap <leader>v. :e $MYVIMRC<CR>
nnoremap <leader>v, :e ~/dotfiles/nvim/mod.dorin.vim<CR>
nnoremap <leader>vs :source $MYVIMRC<CR>

" => Others ===============================================
" compile & run c Code
autocmd FileType c nmap <leader>bb :w<CR>:!gcc % -o .lastbuild && ./.lastbuild<cr>
autocmd FileType c nmap <leader>bl :w<CR>:!./.lastbuild<cr>
" Run js Code on node
autocmd FileType javascript nmap <leader>bb :!node %<CR>

" Change dir to current file's dir
nnoremap <leader>CD :cd %:p:h<CR>:pwd<CR>

" Pasting support
" set pastetoggle=<F3>  " Press F3 in insert mode to preserve tabs when
" map <leader>pp :setlocal paste!<cr>

