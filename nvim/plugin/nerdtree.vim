" => scrooloose/nerdtree ===================================
let g:NERDTreeIgnore = ['^node_modules$','^.git$']
let g:NERDTreeAutoDeleteBuffer=1
let g:NERDTreeShowHidden=1
let NERDTreeQuitOnOpen = 1
let NERDTreeMinimalUI = 1
let NERDTreeCascadeSingleChildDir=0
" Would be useful mappings, but they interfere with my default window movement
" unmap (<C-j> and <C-k>).
let g:NERDTreeMapJumpPrevSibling='<Nop>'
let g:NERDTreeMapJumpNextSibling='<Nop>'
let NERDTreeMapOpenSplit='s'
let NERDTreeMapOpenVSplit='v'

let NERDTreeDirArrowExpandable=""
let NERDTreeDirArrowCollapsible=""

" icon source: https://www.nerdfonts.com/cheat-sheet
let g:NERDTreeIndicatorMapCustom = {
            \ 'Modified'  : 'M',
            \ 'Staged'    : 'S',
            \ 'Untracked' : 'U',
            \ 'Renamed'   : 'R',
            \ 'Deleted'   : 'D',
            \ 'Unmerged'  : '',
            \ 'Dirty'     : '*',
            \ 'Clean'     : '',
            \ 'Ignored'   : '',
            \ 'Unknown'   : '?'
            \ }

" Open nerd tree at the current file or close nerd tree if pressed again.
nnoremap <silent> <expr> <Leader>n g:NERDTree.IsOpen() ? "\:NERDTreeClose<CR>" : bufexists(expand('%')) ? "\:NERDTreeFind<CR>" : "\:NERDTree<CR>"
nnoremap <silent> <Leader>0 :NERDTreeToggle<CR>

" " let NERDTreeCreatePrefix='silent keepalt keepjumps'
" function! Before_Try_To_select_last_file() abort
"   let s:NERDTreePreFile=expand('%:t')
" endfunction
" function! Try_To_select_last_file() abort
"   if s:NERDTreePreFile !=# ''
"     call search('\v<' . s:NERDTreePreFile . '>')
"   endif
" endfunction
" let NERDTreeMapUpdir='-'
" nnoremap <silent> - :call Before_Try_To_select_last_file()<CR>
"       \:silent keepalt keepjumps edit <C-R>=empty(expand('%')) ? '.' : expand('%:p:h')<CR><CR>
"       \:call Try_To_select_last_file()<CR>
