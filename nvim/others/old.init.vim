" vimrc: a monolithic vim setup. {{{1
"
" © 2009-2013 Tom Vincent <http://tlvince.com/contact>
" vim: set fdm=marker:

" Environment {{{1
" A consistent runtime environment.

" Forget about vi and set it first as it modifies future behaviour
set nocompatible

" Manually load vim-sensible so we can override its settings later
runtime bundle/vim-sensible/plugin/sensible.vim

set spellfile=$XDG_CONFIG_HOME/nvim/spell/en.utf-8.add
set backupdir=$XDG_CONFIG_HOME/nvim/tmp,.
set directory=$XDG_CONFIG_HOME/nvim/tmp,.
" }}}

" General preferences {{{1
"
" Learn about these using vim help.
set foldenable

" System
set path+=**
set wildmenu

" Number
set relativenumber number

" Tabbing
set tabstop=2           " The number of spaces a tab is
set shiftwidth=2        " Number of spaces to use in auto(indent)
set softtabstop=2       " Just to be clear
set expandtab           " Insert tabs as spaces

" Searching
set wrapscan            " Wrap searches
set ignorecase          " Ignore search term case...
set smartcase           " ... unless term contains an uppercase character
set hlsearch            " ... as you type

" Wrapping
set textwidth=80        " Hard-wrap text at nth column
set nowrap              " Don't wrap long lines (good for vsplits)

" General
set showmode            " Persistent notice of current mode
set spelllang=en_gb     " Speak proper English
set fillchars=""        " Remove characters in window split
set encoding=utf-8      " Default encoding
set noshowcmd
set clipboard=unnamed
set nomodeline
set modelines=0
set ttimeoutlen=0
set shortmess+=c        " don't give |ins-completion-menu| messages
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
  \,sm:block-blinkwait175-blinkoff150-blinkon175

" Ignore the following globs in file completions
set wildignore+=*.o,*.obj,*.pyc,*.so,*.swp,*.zip,*.jpg,*.gif,*.png,*.pdf
set wildignore+=.git,.hg,.svn,DS_STORE,bower_components,node_modules
" }}}

" Visuals {{{1
set termguicolors
set background=dark
let g:one_allow_italics = 1
" }}}

" Mappings {{{1
"
" vim does funny things with inline comments here, so don't use them.

" Silently open a shell in the directory of the current file
if has("win32") || has("win64")
  map ,s :silent !start cmd /k cd %:p:h <CR>
endif

" Return to normal mode
inoremap jk <ESC>
inoremap jj <ESC>

" Always move between wrapped lines
nnoremap j gj
nnoremap k gk

" Move text on visual mode
vmap > >gv
vmap < <gv

" Cycle tab with recent buffer list
nmap <Tab> :bnext<CR>
nmap <S-Tab> :bprevious<CR>

" Open a empty tab
nmap go :tabnew<CR>
" Open a file
map <C-p> :find *

" Move between splits with CTRL+[hjkl]
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" }}}

" Leader keys {{{1

" Map leader (the dedicated user-mapping prefix key) to space
let mapleader="\<Space>"
let maplocalleader = "\<Space>"

map <leader>w <C-w>

" Open vimrc in a new tab
nmap <leader>vid :tabedit $MYVIMRC<CR>
nmap <leader>vim :tabedit ~/mydotfiles/nvim/init.vim<CR>
nmap <leader>vis :source $MYVIMRC<CR>

" Disable search highlighting
nmap <silent> <leader><leader> :noh<CR>

" Neovim :Terminal
autocmd BufWinEnter,WinEnter term://* startinsert
"autocmd BufLeave term://* stopinsert
tmap <Esc> <C-\><C-n>
tmap <C-w> <Esc><C-w>
"tmap <C-d> <Esc>:q<CR>
" Open terminal
nmap <leader>ts <C-w>s<C-w>j:terminal<CR>
nmap <leader>vs <C-w>v<C-w>l:terminal<CR>

" Open a file (relative to the current file)
" See: http://vimcasts.org/episodes/the-edit-command/
" Synonyms: {e: edit, where: {w: window, s: split, v: vertical split, t: tab}}
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%

" Create a directory relative to the current file
map <leader>d :!mkdir -p %%

" Write and build the current file
map <leader>m :write<CR> :make %<CR>

" Run the binary of the current file
map <leader>r :!./%:r<CR>

" UTC date
nmap <leader>pd a<C-R>=strftime("%Y-%m-%d")<CR>
"imap <leader>t <C-R>=strftime("%Y-%m-%d")<CR>


" pwgen
nmap <leader>pg :read !pwgen -sy1 32<CR>

" Toggle highlighting of current line and column
nnoremap <leader>c :setlocal cursorline! cursorcolumn!<CR>

" Toggle spelling and show it's status
nmap <silent><leader>s :setlocal spell! spell?<CR>

nmap <leader>q gqip

" Toggle number
nmap  <leader>n :set relativenumber! number!<CR>

" }}}

" Function keys {{{!

" Toggle paste mode (particularly useful to temporarily disable autoindent)
set pastetoggle=<F3>
" }}}

" Disabled keys {{{2

" Disable arrow keys (force good habits)
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
vnoremap <up> <nop>
vnoremap <down> <nop>
vnoremap <left> <nop>
vnoremap <right> <nop>

" Disable help key
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" Disable Ex mode
nnoremap Q <nop>
" }}}

"if !empty(glob("~/mydotfiles/nvim/init.vim"))
  "source ~/mydotfiles/nvim/init.vim
  "echo 'Welcom to Neovim'
"endif
