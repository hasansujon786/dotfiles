" => Single mappings ======================================
" Easy fold
nnoremap <leader>z za
vnoremap <leader>z za
" Easier system clipboard usage
nnoremap <Leader>p "+p
vnoremap <Leader>p "+p
nnoremap <Leader>P "+P
nnoremap <Leader>y "+y
vnoremap <Leader>y "+ygv<Esc>
vnoremap <Leader>d "+d
" Save file Quickly
nnoremap <leader>s :write<CR>
nnoremap <C-s> :write<CR>
inoremap <C-s> <Esc>:write<CR><Esc>a
" exit file quickly
nnoremap <silent> <leader>q :close<CR>
" Cycle through relativenumber + number, number (only), and no numbering
nnoremap <silent> <Leader>r :call hasan#utils#cycle_numbering()<CR>

" Map 1-9 + <Space> to jump to respective tab
let i = 1
while i < 10
  execute ":nnoremap <silent> <Space>" . i . " :tabn " . i . "<CR>"
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
" Search world in whole project
nnoremap <leader>cs :CocSearch <C-R>=expand("<cword>")<CR><CR>
xnoremap <leader>cs y:CocSearch -F <C-r>"<Home><C-right><C-right><C-right>\<C-right>

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
" interactive find replace preview
set inccommand=nosplit
" replace word under cursor, globally, with confirmation
nnoremap <Leader>ff :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
xnoremap <Leader>ff y :%s/<C-r>"//gc<Left><Left><Left>
" Alias replace all to S
" nnoremap S :%s//gI<Left><Left><Left>

" => g is for git =========================================
" GitGutter
nmap <silent> <leader>gp <Plug>(GitGutterPreviewHunk)
nmap <silent> <leader>gu <Plug>(GitGutterUndoHunk)
nmap <silent> <leader>gs <Plug>(GitGutterStageHunk)
vmap <silent> <leader>gs <Plug>(GitGutterStageHunk)

nnoremap <silent> <leader>gg :Gstatus<CR>:wincmd _<CR>
if !exists('$TMUX')
  nnoremap <silent> <leader>gl :FloatermNew --name=lazygit lazygit<CR>
  nnoremap <silent> <leader>gt :FloatermNew --name=tig tig<CR>
else
  nnoremap <silent> <leader>gl :silent !tmux new-window "lazygit"<CR>
  nnoremap <silent> <leader>gt :silent !tmux new-window "tig"<CR>
endif

" => d is for diff =========================================
" <LocalLeader>d... -- Diff mode bindings:
" - <LocalLeader>dd: show diff view (mnemonic: [d]iff)
" - <LocalLeader>dh: choose hunk from left (mnemonic: [h] = left)
" - <LocalLeader>dl choose hunk from right (mnemonic: [l] = right)
nnoremap <silent> <leader>dd :Gvdiffsplit!<CR>
nnoremap <silent> <leader>dh :diffget //2<CR>
nnoremap <silent> <leader>dl :diffget //3<CR>

" => t is for toggle ======================================
" Toggle highlighting of current line and column
nnoremap <silent> <leader>tc :setlocal cursorcolumn!<CR>
nnoremap <silent> <Leader>tq :call hasan#utils#quickFix_toggle()<CR>
nnoremap <silent> <leader>tw :call hasan#utils#toggleWrap()<CR>

" => w is for window ======================================
" Switch between the alternate files
nnoremap <BS> <c-^>
" Jump between windows
nnoremap <leader>w <C-w>
nnoremap <silent> <leader>wz :AutoZoomWin<CR>
nnoremap <silent> <leader>j :wincmd j<CR>
nnoremap <silent> <leader>k :wincmd k<CR>
nnoremap <silent> <leader>h :wincmd h<CR>
nnoremap <silent> <leader>l :wincmd l<CR>

" => v is for vim =========================================
nnoremap <leader>v. :e $MYVIMRC<CR>
nnoremap <leader>vs :source $MYVIMRC<CR>

" => Others ===============================================

" Change dir to current file's dir
nnoremap <leader>CD :cd %:p:h<CR>:pwd<CR>

" Pasting support
" set pastetoggle=<F3>  " Press F3 in insert mode to preserve tabs when
" nnoremap <leader>pp :setlocal paste!<cr>

