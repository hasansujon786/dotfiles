" => Single mappings ======================================
" Switch between the alternate files
nnoremap <BS> <c-^>
" Jump between windows
nnoremap <leader>w <C-w>
nnoremap <silent> <leader>j :wincmd j<CR>
nnoremap <silent> <leader>k :wincmd k<CR>
nnoremap <silent> <leader>h :wincmd h<CR>
nnoremap <silent> <leader>l :wincmd l<CR>
nnoremap <silent> <S-TAB> :wincmd p<CR>
" Easy fold
nnoremap <leader>z za
vnoremap <leader>z za
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
" exit file quickly
nnoremap <silent> <leader>q :close<CR>

" Map 1-9 + <Space> to jump to respective tab
let i = 1
while i < 10
  execute ":nmap <silent> <Space>" . i . " :tabn " . i . "<CR>"
  let i += 1
endwhile

" Group mappings

" => c is for coc ========================================
" Remap keys for applying codeAction to the current line.
nmap <silent> <leader>ca <Plug>(coc-codeaction)
" Applying codeAction to the selected region.
xmap <silent> <leader>ca <Plug>(coc-codeaction-selected)
" Apply AutoFix to problem on the current line.
nmap <silent> <leader>cq <Plug>(coc-fix-current)

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>c? :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>ce :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>cc :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>co :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>c@ :<C-u>CocList -I symbols<cr>
" Open yank list
" nnoremap <silent> <leader>cy :<C-u>CocList -A --normal yank<cr>
nnoremap <silent> <leader>cy :<C-u>CocList --normal yank<cr>

" Do default action for next item.
nnoremap <silent> <space>cj :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>ck :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>cp :<C-u>CocListResume<CR>

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
" TODO: need to fix which change part of world
nmap <Leader>rr :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
xmap <Leader>rr y :%s/<C-r>"//gc<Left><Left><Left>
" Alias replace all to S
" nnoremap S :%s//gI<Left><Left><Left>

" => g is for git =========================================
nmap <silent> <leader>gg :Gstatus<CR>:wincmd _<CR>
nmap <silent> <leader>gdf :Gvdiffsplit!<CR>:vertical resize +15<CR>
nmap <silent> <leader>gl :FloatermNew --name=lazygit lazygit<CR>
nmap <silent> <leader>gt :FloatermNew --name=tig tig<CR>
" GitGutter
nmap <silent> <leader>gp <Plug>(GitGutterPreviewHunk)
nmap <silent> <leader>gu <Plug>(GitGutterUndoHunk)
nmap <silent> <leader>gs <Plug>(GitGutterStageHunk)
vmap <silent> <leader>gs <Plug>(GitGutterStageHunk)

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
" Toggle relative line numbers and regular line numbers {{{
function! ToggleNumber()
  if &number
    echo 'Number OFF'
    set nonumber norelativenumber
  else
    echo 'Number ON'
    set number relativenumber
  endif
endfunction
" }}}
nnoremap <silent> <leader>tN :set invrelativenumber<CR>
nnoremap <silent> <leader>tn :call ToggleNumber()<CR>
" Toggle wrap {{{
" Allow j and k to work on visual lines (when wrapping)
function! ToggleWrap()
  if &wrap
    echo 'Wrap OFF'
    setlocal nowrap
    set virtualedit=all
  else
    echo 'Wrap ON'
    setlocal wrap linebreak nolist
    set virtualedit=
    setlocal display+=lastline
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

