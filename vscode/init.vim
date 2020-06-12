" neovim default commands
" https://github.com/asvetliakov/vscode-neovim/tree/master/vim
" if exists('g:vscode') else " ordinary neovim endif

call plug#begin('~/.config/nvim/plugged')

" ======================================
" => Functionality-&-Helpers
" ======================================
Plug 'michaeljsmith/vim-indent-object'
Plug 'tpope/vim-surround'
" Plug 'terryma/vim-multiple-cursors'
" Plug 'airblade/vim-gitgutter'


call plug#end()


" => Key-Mappings ---------------------------------- {{{
  
" Map leader (the dedicated user-mapping prefix key) to space
let mapleader="\<Space>"
let maplocalleader="\<Space>"

nnoremap <silent> <leader>s :<C-u>call VSCodeNotify('workbench.action.files.save')<CR>
nnoremap <silent> <leader>q :<C-u>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>
nnoremap <silent> <leader>n :<C-u>call VSCodeNotify('workbench.action.toggleSidebarVisibility')<CR>
" nnoremap <silent> ? :<C-u>call VSCodeNotify('workbench.action.findInFiles', { 'query': expand('<cword>')})<CR>

" Use q, qq & jk to return to normal mode
nnoremap <silent> q <ESC>:noh<CR>
vnoremap <silent> q <ESC>:noh<CR>
" inoremap jk <ESC>
" inoremap qq <ESC>
" cnoremap qq <C-c>

" Use Q to record macros
nnoremap Q q

" j/k will move virtual lines (lines that wrap)
" Seamlessly treat visual lines as actual lines when moving around.
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
" Store relative line number jumps in the jumplist if they exceed a threshold.
noremap <expr> k (v:count > 5 ? "m'" . v:count : '') . 'k'
noremap <expr> j (v:count > 5 ? "m'" . v:count : '') . 'j'

" Vertical scrolling => Done in vscode
" nnoremap <A-k> <C-u>
" nnoremap <A-j> <C-d>
" Horizontal scroll => Todo
" nnoremap <A-l> 5zl
" nnoremap <A-h> 5zh

" ======================================
" => Copy-paset
" ======================================
" Prevent selecting and pasting from overwriting what you originally copied.
vnoremap p pgvy
" Keep cursor at the bottom of the visual selection after you yank it.
vnoremap y ygv<Esc>
" Ensure Y works similar to D,C.
nnoremap Y y$
" Prevent x from overriding the clipboard.
noremap x "_x
noremap X "_x
" Paste from current register/buffer in insert mode
imap <C-v> <C-R>*
cmap <C-v> <C-R>+

" ======================================
" => Modify-&-Rearrange-texts
" ======================================

" Make vaa select the entire file...
vnoremap aa VGo1G

" map . in visual mode => Todo . cmd dose't work
vnoremap . :norm.<cr>

" Keep selection when indenting/outdenting.
vnoremap > >gv
vnoremap < <gv

" Commentary
xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine

" Move lines up and down in normal & visual mode => Todo
" nnoremap <silent> <A-k> :move -2<CR>==
" nnoremap <silent> <A-j> :move +1<CR>==
" vnoremap <silent> <A-k> :move '<-2<CR>gv=gv
" vnoremap <silent> <A-j> :move '>+1<CR>gv=gv

" ======================================
" => Moving-around-tabs-and-buffers
" ======================================

" Jump between panes
nnoremap <silent> <leader>j :<C-u>call VSCodeNotify('workbench.action.focusBelowGroup')<CR>
nnoremap <silent> <leader>k :<C-u>call VSCodeNotify('workbench.action.focusAboveGroup')<CR>
nnoremap <silent> <leader>h :<C-u>call VSCodeNotify('workbench.action.focusLeftGroup')<CR>
nnoremap <silent> <leader>l :<C-u>call VSCodeNotify('workbench.action.focusRightGroup')<CR>

" Resize splits => Done in vscode
" nnoremap <silent> <A-=> :resize +3<CR>
" nnoremap <silent> <A--> :resize -3<CR>
" nnoremap <silent> <A-.> :vertical resize +5<CR>
" nnoremap <silent> <A-,> :vertical resize -5<CR>

" zoom a vim pane
nnoremap <silent> \ :<C-u>call VSCodeNotify('workbench.action.toggleEditorWidths')<CR>
nnoremap <silent> <Bar> :<C-u>call VSCodeNotify('workbench.action.evenEditorWidths')<CR>

" Jump between tabs
nnoremap <silent> gl :<C-u>call VSCodeNotify('workbench.action.nextEditorInGroup')<CR>
nnoremap <silent> gh :<C-u>call VSCodeNotify('workbench.action.previousEditorInGroup')<CR>
nnoremap <silent> gL :<C-u>call VSCodeNotify('workbench.action.lastEditorInGroup')<CR>
nnoremap <silent> gH :<C-u>call VSCodeNotify('workbench.action.firstEditorInGroup')<CR>

" }}}
