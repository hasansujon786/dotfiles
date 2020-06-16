" neovim default commands
" https://github.com/asvetliakov/vscode-neovim/tree/master/vim
" if exists('g:vscode') else " ordinary neovim endif

call plug#begin('~/.config/nvim/plugged')

" ======================================
" => Functionality-&-Helpers
" ======================================
Plug 'michaeljsmith/vim-indent-object'
Plug 'tpope/vim-surround'
Plug 'asvetliakov/vim-easymotion'
" Plug 'terryma/vim-multiple-cursors'
" Plug 'unblevable/quick-scope'


call plug#end()

" => Key-Mappings ---------------------------------- {{{

" Map leader (the dedicated user-mapping prefix key) to space
let mapleader="\<Space>"
let maplocalleader="\<Space>"

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
" Seamlessly treat visual lines as actual lines when moving around. => Todo
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
" Store relative line number jumps in the jumplist if they exceed a threshold.
noremap <expr> k (v:count > 5 ? "m'" . v:count : '') . 'k'
noremap <expr> j (v:count > 5 ? "m'" . v:count : '') . 'j'

" Horizontal scroll => Todo
" nnoremap <A-l> 5zl
" nnoremap <A-h> 5zh

" Plug 'airblade/vim-gitgutter'
nnoremap <silent> [c :<C-u>call VSCodeNotify('workbench.action.editor.previousChange')<CR>
nnoremap <silent> ]c :<C-u>call VSCodeNotify('workbench.action.editor.nextChange')<CR>

nnoremap <leader>gp :<C-u>call VSCodeNotify('editor.action.dirtydiff.next')<CR>
nnoremap <leader>gs :<C-u>call VSCodeNotifyRange('git.stageSelectedRanges')<CR>
vnoremap <leader>gs :<C-u>call VSCodeNotifyRange('git.stageSelectedRanges')<CR>
nnoremap <leader>gu :<C-u>call VSCodeNotify('git.unstageSelectedRanges')<CR>
vnoremap <leader>gu :<C-u>call VSCodeNotify('git.unstageSelectedRanges')<CR>

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

" Easier system clipboard usage
vnoremap <Leader>y "+ygv<Esc>
vnoremap <Leader>d "+d
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P
vnoremap <Leader>p "+p
vnoremap <Leader>P "+P

" ======================================
" => Modify-&-Rearrange-texts
" ======================================

" Make vaa select the entire file...
vnoremap aa VGo1G

" select a block {} of code
nmap <silent> vaf /}<CR>V%
vmap <silent> vaf <Esc>/}<CR>V%

" map . in visual mode => Todo . cmd dose't work
vnoremap . :norm.<cr>

" Keep selection when indenting/outdenting.
vnoremap > >gv
vnoremap < <gv

" Comment or uncomment lines using Commentary
xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine

" Move lines up and down in normal & visual mode => Todo (need to done in vscode)
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
" nnoremap <silent> <A-.> :vertical resize +5<CR>
" nnoremap <silent> <A-,> :vertical resize -5<CR>
" nnoremap <silent> <A-=> :resize +3<CR> (X) => Todo
" nnoremap <silent> <A--> :resize -3<CR> (X)

" zoom a vim pane
nnoremap <silent> \ :<C-u>call VSCodeNotify('workbench.action.toggleEditorWidths')<CR>
nnoremap <silent> <Bar> :<C-u>call VSCodeNotify('workbench.action.evenEditorWidths')<CR>

" Jump between tabs
nnoremap <silent> gl :<C-u>call VSCodeNotify('workbench.action.nextEditorInGroup')<CR>
nnoremap <silent> gh :<C-u>call VSCodeNotify('workbench.action.previousEditorInGroup')<CR>
nnoremap <silent> gL :<C-u>call VSCodeNotify('workbench.action.lastEditorInGroup')<CR>
nnoremap <silent> gH :<C-u>call VSCodeNotify('workbench.action.firstEditorInGroup')<CR>

" ======================================
" => Search-functionalities
" ======================================
" (Maybe dose't support)
" " Alias replace all to S
" nnoremap S :%s//gI<Left><Left><Left>
" " interactive find replace preview
" set inccommand=nosplit
" " replace word under cursor, globally, with confirmation
" nnoremap <Leader>ff :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
" vnoremap <Leader>ff y :%s/<C-r>"//gc<Left><Left><Left>

" ======================================
" => Leader-commands
" ======================================
" Save & quit file Quickly
nnoremap <silent> <leader>s :<C-u>call VSCodeNotify('workbench.action.files.save')<CR>
nnoremap <silent> <leader>q :<C-u>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>

" open Explorer
nnoremap <silent> <leader>n :<C-u>call VSCodeNotify('workbench.action.toggleSidebarVisibility')<CR>

" " Switch between the last two files
" nnoremap <leader><tab> <c-^>

" " Open vimrc in a new tab & source
" nmap <leader>vid :tabedit $MYVIMRC<CR>
" nmap <leader>vim :tabedit ~/mydotfiles/nvim/init.vim<CR>
" nmap <leader>vis :source $MYVIMRC<CR>

" " compile & run c Code
" nnoremap <leader>bb :w<CR>:!gcc % -o .lastbuild && ./.lastbuild<cr>
" nnoremap <leader>bl :w<CR>:!./.lastbuild<cr>

" " Toggle highlighting of current line and column
" nnoremap <silent> <leader>c :setlocal cursorcolumn!<CR>

" " Toggle relative line numbers and regular line numbers.
" nnoremap <silent> <leader>mm :set nu! invrelativenumber<CR>
" nnoremap <silent> <leader>mu :set invrelativenumber<CR>

" ======================================
" => Organize-files-&-folders
" ======================================

" " Open a file relative to the current file
" " Synonyms: e: edit,
" " e: window, s: split, v: vertical split, t: tab, d: directory
" nnoremap <Leader>er :Move <C-R>=expand("%")<CR>
" nnoremap <leader>ed :Mkdir <C-R>=expand('%:h').'/'<cr>
" nnoremap <leader>et :tabe <C-R>=expand('%:h').'/'<cr>
" nnoremap <leader>ev :vsp <C-R>=expand('%:h').'/'<cr>
" nnoremap <leader>es :sp <C-R>=expand('%:h').'/'<cr>
" nnoremap <leader>ee :e <C-R>=expand('%:h').'/'<cr>

" " Change dir to current file's dir
" nnoremap <leader>CD :cd %:p:h<CR>:pwd<CR>

" Toggle folds.
nnoremap <silent> <leader>z :<C-u>call VSCodeNotify('editor.toggleFold')<CR>
vnoremap <silent> <leader>z :<C-u>call VSCodeNotify('editor.toggleFold')<CR>

" ======================================
" => Function-key-mappings
" ======================================
" Pasting support
" set pastetoggle=<F3>  " Press F3 in insert mode to preserve tabs when
" pasting from clipboard into terminal

" toggle background light / dark
" nnoremap <silent> <F10> :call ToggleBackground()<CR>

" }}}

" => Disabled-keys --------------------------------- {{{

" disable arrow keys in normal mode
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" }}}

" " PlaceholderImgTag 300x200
" function! s:PlaceholderImgTag(size)
"   let url = 'http://dummyimage.com/' . a:size . '/000000/555555'
"   let [width,height] = split(a:size, 'x')
"   execute "normal a<img src=\"".url."\" width=\"".width."\" height=\"".height."\" />"
" endfunction
" command! -nargs=1 PlaceholderImgTag call s:PlaceholderImgTag(<f-args>)
