"
"  ███▄    █ ▓█████  ▒█████   ██▒   █▓ ██▓ ███▄ ▄███▓
"  ██ ▀█   █ ▓█   ▀ ▒██▒  ██▒▓██░   █▒▓██▒▓██▒▀█▀ ██▒
" ▓██  ▀█ ██▒▒███   ▒██░  ██▒ ▓██  █▒░▒██▒▓██    ▓██░
" ▓██▒  ▐▌██▒▒▓█  ▄ ▒██   ██░  ▒██ █░░░██░▒██    ▒██
" ▒██░   ▓██░░▒████▒░ ████▓▒░   ▒▀█░  ░██░▒██▒   ░██▒
" ░ ▒░   ▒ ▒ ░░ ▒░ ░░ ▒░▒░▒░    ░ ▐░  ░▓  ░ ▒░   ░  ░
" ░ ░░   ░ ▒░ ░ ░  ░  ░ ▒ ▒░    ░ ░░   ▒ ░░  ░      ░
"    ░   ░ ░    ░   ░ ░ ░ ▒       ░░   ▒ ░░      ░
"          ░    ░  ░    ░ ░        ░   ░         ░
"                                 ░
"
" => General --------------------------------------- {{{
" Set utf8 as standard encoding and en_US as the standard language
set encoding=UTF-8    " Default encoding
scriptencoding utf-16 " allow emojis in vimrc
set ffs=unix,dos,mac  " Use Unix as the standard file type
syntax on             " Enable syntax highlighting

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
  set t_Co=256
endif
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"copy next line to .tmux.conf for support true color within tmux
"set-option -ga terminal-overrides ",xterm-256color:Tc"
if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
if (has("termguicolors"))
  set termguicolors
endif
if has("gui_running")
  set guioptions-=T
  set guioptions-=e
  set t_Co=256
  set guitablabel=%M\ %t
endif

" Enable filetype plugins
filetype plugin on
filetype indent on

" Some general settings
set magic             " For regular expressions turn magic on
set showcmd           " show any commands
set noshowmode        " don't show mode as airline already does
set path+=**          " usefull while using find in nested folders
set fillchars=""      " Remove characters in window split
set fillchars=stlnc:=
set nomodeline
set modelines=0
set shortmess+=c      " don't give |ins-completion-menu| messages
set lazyredraw        " Don't redraw while executing macros (good performance config)
set regexpengine=1    " (good performance config)
set updatetime=100
" Quickly time out on keycodes, but never time out on mappings
set timeout ttimeout ttimeoutlen=200
set mousemodel=popup
set autowrite         " Automatically :write before running commands
set autoread          " Set to auto read when a file is changed from the outside
" Update a buffer's contents on focus if it changed outside of Vim.
au FocusGained,BufEnter,CursorHold * checktime

if has('mouse')
  set mouse=a           " enable mouse (selection, resizing windows)
endif

" Map leader (the dedicated user-mapping prefix key) to space
let mapleader="\<Space>"
let maplocalleader="\<Space>"

" }}}
" => Files-backup-undo-spelling -------------------- {{{
" Variables
let $NVIM = '~/dotfiles/nvim'
let $SPELLFILE = $NVIM.'/spell/en.utf-8.add'

" if filereadable($HOME . '/.vimrc.local')
"   source ~/.vimrc.local
" endif

" Turn backup off, since most stuff is in SVN, git etc. anyway...
set nobackup nowb noswapfile
" set backupdir=~/.config/nvim/tmp/backup,.
" set directory=~/.config/nvim/tmp/swap,.

" persistent undo between file reloads
" set undolevels=5000   " Save a lot of back-history...
set undodir=~/.config/nvim/tmp/undo,.
set undofile

set spelllang=en_gb   " Speak proper English
set complete+=kspell  " Autocomplete with dictionary words when spell check is on
" Set spellfile to location that is guaranteed to exist
set spellfile=$SPELLFILE
" Toggle spelling and show it's status
nmap <F7> :setlocal spell! spell?<CR>
"Open spell file
nnoremap <leader>fw :normal! 1z=<CR>
nnoremap <leader>fp :normal! mz[s1z=`z<CR>
nnoremap <leader>fn :normal! mz]s1z=`z<CR>
" Spell commands
" Next wrong spell      ]s
" Previous wrong spell  [s
" Add to spell file     zg
" Prompt spell fixes    z=

" }}}
" => Plugin-Settings ------------------------------- {{{
call plug#begin('~/.config/nvim/plugged')

" => Visual-&-Theme ========================================
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'itchyny/lightline.vim'
Plug 'joshdick/onedark.vim'
Plug 'Yggdroot/indentLine'

" => Functionality-&-Helpers ===============================
Plug 'tpope/vim-eunuch', { 'on': ['Delete', 'Move', 'Rename'] }  "for moving and manipulating files / directories.
Plug 'voldikss/vim-floaterm', { 'on': 'FloatermNew' }
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'michaeljsmith/vim-indent-object'
Plug 'dhruvasagar/vim-open-url'
Plug 'unblevable/quick-scope'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'justinmk/vim-sneak'
Plug 'mhinz/vim-startify'
Plug 'Konfekt/FastFold'
Plug 'tpope/vim-repeat'
Plug 'psliwka/vim-smoothie' " Smooth scroll

Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'


" Plug 'vim-scripts/YankRing.vim', { 'on': 'YRShow' }
" Plug 'vimwiki/vimwiki'      " my own personal wiki
" Plug 'mhinz/vim-grepper'    " Handle multi-file find and replace.
" Plug 'will133/vim-dirdiff'  " Run a diff on 2 directories.
" Plug 'christoomey/vim-tmux-navigator'
" Plug 'shime/vim-livedown', { 'do': 'npm install -g livedown' } " markdown preview
" Plug 'editorconfig/editorconfig-vim'
" Plug 'moll/vim-node'
" Plug 'glts/vim-radical' " Convert binary, hex, etc..

" => Auto completion ========================================
Plug 'jiangmiao/auto-pairs'
Plug 'honza/vim-snippets'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'branch': 'release/1.x',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html']
  \ }

" => Git ===================================================
Plug 'tpope/vim-fugitive', { 'on': ['Gstatus', 'Gbrowse', 'GV'] }
Plug 'tpope/vim-rhubarb', { 'on': 'Gbrowse' }
Plug 'junegunn/gv.vim', { 'on': 'GV' }
Plug 'airblade/vim-gitgutter'

source ~/dotfiles/nvim/plugin/language-support.vim
call plug#end()

source ~/dotfiles/nvim/plugin/quick-scope.vim
source ~/dotfiles/nvim/plugin/onedark.vim
source ~/dotfiles/nvim/plugin/indentLine.vim
source ~/dotfiles/nvim/plugin/lightline.vim
source ~/dotfiles/nvim/plugin/goyo.vim
source ~/dotfiles/nvim/plugin/auto-pairs.vim
source ~/dotfiles/nvim/plugin/coc.vim
source ~/dotfiles/nvim/plugin/fzf.vim
source ~/dotfiles/nvim/plugin/nerdtree.vim
source ~/dotfiles/nvim/plugin/vim-sneak.vim
source ~/dotfiles/nvim/plugin/vim-prettier.vim
source ~/dotfiles/nvim/plugin/vim-gitgutter.vim
source ~/dotfiles/nvim/plugin/vim-fugitive.vim
source ~/dotfiles/nvim/plugin/vim-floaterm.vim
source ~/dotfiles/nvim/plugin/vim-smoothie.vim
" source ~/dotfiles/nvim/plugin/yank-ring.vim

" Local Configurations
source ~/dotfiles/nvim/plugin/fold.vim
source ~/dotfiles/nvim/plugin/filetypes.vim
" }}}
" => VIM-User-Interface ---------------------------- {{{

" Set 7 lines to the cursor - when moving vertically using j/k
set so=1

" Avoid garbled characters in Chinese language windows OS
let $LANG='en'
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" Autocompletion
" set wildmode=longest,list,full
set wildmenu          " Turn on the Wild menu
set pumblend=3        " set pum background visibility to 20 percent
set wildoptions=pum   " set file completion in command to use pum

" Ignore the following globs in file completions
set wildignore+=*.o,*~,*.pyc,*.obj,*.pyc,*.so,*.swp
set wildignore+=*.zip,*.jpg,*.gif,*.png,*.pdf
set wildignore+=.git,.hg,.svn,DS_STORE,bower_components,node_modules
if has("win16") || has("win32")
  set wildignore+=.git\*,.hg\*,.svn\*
else
  set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

set hidden                        " enable hidden unsaved buffers
set diffopt+=vertical             " Always use vertical diffs
set ruler                         " Always show current position
set cmdheight=1                   " Height of the command bar
set foldcolumn=1                  " display gutter markings for folds
set cursorline                    " Show a line on current line
set showmatch                     " Show matching brackets when text indicator is over them
set mat=2                         " How many tenths of a second to blink when matching brackets
set backspace=eol,start,indent    " Configure backspace so it acts as it should act
set whichwrap+=<,>,h,l,[,]        " automatically wrap left and right
set splitbelow splitright         " Fix splitting

" Guicursor Setting
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
      \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
      \,sm:block-blinkwait175-blinkoff150-blinkon175

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Numbers
set number relativenumber
set numberwidth=1

" Specify the behavior when switching between buffers
set switchbuf=useopen,usetab,newtab
set showtabline=2

" enable folding in bash files
let g:sh_fold_enabled=1

" Highlight the characters on column 81
highlight CocHighlightText ctermbg=gray guibg=#3B4048
highlight ColorColumn guibg=#3B4048 ctermbg=gray
call matchadd('ColorColumn', '\%81v', '100')
augroup fzf
  autocmd  FileType fzf call clearmatches()
        \| autocmd BufLeave <buffer> call matchadd('ColorColumn', '\%81v', '100')
augroup END

" }}}
" => Text-Tab-and-Indent --------------------------- {{{

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

" text appearance
set iskeyword+=-                    " treat dash separated words as a word text object
set textwidth=80                    " Hard-wrap text at nth column
set nowrap                          " nowrap by default
set list
set listchars=tab:→\ ,space:·,nbsp:␣,trail:•,precedes:«,extends:»   " show hidden characters
" set listchars=tab:»·,trail:·,nbsp:· " Display extra whitespace
set matchpairs+=<:>,«:»,｢:｣         " Match angle brackets...
set ai "Auto indent
set si "Smart indent
set linebreak                       " Don't break words when wrapping lines
let &showbreak="↳ "                 " Make wrapped lines more obvious
set cpoptions+=n

" }}}
" => Key-Mappings ---------------------------------- {{{

" Use q, qq & jk to return to normal mode
nnoremap <silent> q <ESC>:noh<CR>
vnoremap <silent> q <ESC>:noh<CR>
inoremap jk <ESC>
inoremap qq <ESC>
cnoremap qq <C-c>

" Use Q to record macros
nnoremap Q q

" j/k will move virtual lines (lines that wrap)
" Seamlessly treat visual lines as actual lines when moving around.
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
" Store relative line number jumps in the jumplist if they exceed a threshold.
noremap <expr> k (v:count > 5 ? "m'" . v:count : '') . 'k'
noremap <expr> j (v:count > 5 ? "m'" . v:count : '') . 'j'

" Vertical scrolling
" nnoremap <A-k> <C-u>
" nnoremap <A-j> <C-d>
nnoremap <A-u> <C-u>
nnoremap <A-d> <C-d>
nnoremap <A-y> <C-y>
nnoremap <A-e> <C-e>
" Horizontal scroll
nnoremap <A-l> 5zl
nnoremap <A-h> 5zh

" => Copy-paset ============================================
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

" => Modify-&-Rearrange-texts ==============================

" Make vaa select the entire file...
vnoremap aa VGo1G
" select a block {} of code
vnoremap <silent> ao <Esc>/}<CR>:noh<CR>V%
" map . in visual mode
vnoremap . :norm.<cr>
" Keep selection when indenting/outdenting.
vnoremap > >gv
vnoremap < <gv

" Comment or uncomment lines
nmap <C-_> mz_gcc`z
imap <C-_> <ESC>_gccgi
vmap <C-_> _gcgv

" Move lines up and down in normal & visual mode
nnoremap <silent> <A-k> :move -2<CR>==
nnoremap <silent> <A-j> :move +1<CR>==
vnoremap <silent> <A-k> :move '<-2<CR>gv=gv
vnoremap <silent> <A-j> :move '>+1<CR>gv=gv

" " Format paragraph (selected or not) to 80 character lines.
" nnoremap <Leader>g gqap
" xnoremap <Leader>g gqa

" => Moving-around-tabs-and-buffers ========================
" Jump between panes
nnoremap <silent> <leader>j :wincmd j<CR>
nnoremap <silent> <leader>k :wincmd k<CR>
nnoremap <silent> <leader>h :wincmd h<CR>
nnoremap <silent> <leader>l :wincmd l<CR>
nnoremap <silent> <leader>l :wincmd l<CR>
nnoremap <silent> <leader>\ :wincmd p<CR>

" Resize splits
nnoremap <silent> <A-=> :resize +3<CR>
nnoremap <silent> <A--> :resize -3<CR>
nnoremap <silent> <A-.> :vertical resize +5<CR>
nnoremap <silent> <A-,> :vertical resize -5<CR>
" zoom a vim pane
nnoremap <silent> \ :wincmd _<cr>:wincmd \|<cr>:vertical resize -5<CR>
nnoremap <silent> <leader><leader> :wincmd _<cr>:wincmd \|<cr>:vertical resize -5<CR>
nnoremap <silent> <Bar> :wincmd =<cr>

" Jump between tabs
nnoremap <silent> gl :tabnext<CR>
nnoremap <silent> gh :tabprevious<CR>
nnoremap <silent> m<TAB> :tabmove+<CR>
nnoremap <silent> m<S-TAB> :tabmove-<CR>
" Map 1-9 + <Space> to jump to respective tab
let i = 1
while i < 10
  execute ":nmap <silent> <Space>" . i . " :tabn " . i . "<CR>"
  let i += 1
endwhile

" => Search-functionalities ================================
" auto center on matched string
noremap n nzz
noremap N Nzz

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>
" vnoremap * "xy/<C-R>x<CR>

" Type a replacement term and press . to repeat the replacement again. Useful
" for replacing a few instances of the term (comparable to multiple cursors).
nnoremap <silent> C :let @/='\<'.expand('<cword>').'\>'<CR>cgn
xnoremap <silent> C "sy:let @/=@s<CR>cgn
" Alias replace all to S
" nnoremap S :%s//gI<Left><Left><Left>

" interactive find replace preview
set inccommand=nosplit
" replace word under cursor, globally, with confirmation
nnoremap <Leader>ff :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
vnoremap <Leader>ff y :%s/<C-r>"//gc<Left><Left><Left>

" => Insert-Mode-key-mapping ===============================
" Move cursor by character
inoremap <A-h> <left>
inoremap <A-l> <right>
inoremap <A-j> <down>
inoremap <A-k> <up>
" Move cursor by words
inoremap <A-f> <S-right>
inoremap <A-b> <S-left>
" Jump cursor to start & end of a line
inoremap <C-a> <C-O>^
inoremap <C-e> <C-O>$
" Delete by characters & words
inoremap <C-d> <Delete>
inoremap <A-d> <C-O>dw
inoremap <A-BS> <C-W>
" Make a new line under the cursor
inoremap <silent> <A-CR> <C-o>o
inoremap <silent> <A-o> <C-o>mq<CR><C-o>`q<CR>
inoremap <silent> <A-O> <Esc>mqA<CR><Esc>`qa
" " CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" " so that you can undo CTRL-U after inserting a line break.
inoremap <C-u> <C-G>u<C-U>

" => Command-mode ==========================================
" Bash like keys for the command line
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

" => Leader-commands =======================================
" Save file Quickly
nnoremap <C-s> :write<CR>
inoremap <C-s> <Esc>:write<CR><Esc>a
nnoremap <leader>s :write<CR>
nnoremap <silent> <leader>q :close<CR>

" Switch between the last two files
nnoremap <leader><tab> <c-^>

" Open vimrc in a new tab & source
nmap <leader>vid :tabedit $MYVIMRC<CR>
nmap <leader>vim :tabedit ~/mydotfiles/nvim/init.vim<CR>
nmap <leader>vis :source $MYVIMRC<CR>

" Toggle highlighting of current line and column
nnoremap <silent> <leader>c :setlocal cursorcolumn!<CR>

" => Organize-files-&-folders ==============================
" Open a file relative to the current file
" Synonyms: e: edit,
" e: window, s: split, v: vertical split, t: tab, d: directory
nnoremap <Leader>er :Move <C-R>=expand("%")<CR>
nnoremap <leader>ed :Mkdir <C-R>=expand('%:h').'/'<cr>
nnoremap <leader>et :tabe <C-R>=expand('%:h').'/'<cr>
nnoremap <leader>ev :vsp <C-R>=expand('%:h').'/'<cr>
nnoremap <leader>es :sp <C-R>=expand('%:h').'/'<cr>
nnoremap <leader>ee :e <C-R>=expand('%:h').'/'<cr>

" Change dir to current file's dir
nnoremap <leader>CD :cd %:p:h<CR>:pwd<CR>

" Find & open file on current window
"map <C-p> :tabfind *

" => Function-key-mappings =================================
" Pasting support
" set pastetoggle=<F3>  " Press F3 in insert mode to preserve tabs when
" map <leader>pp :setlocal paste!<cr>

" Toggle relative line numbers and regular line numbers.
nmap <F6> :set invrelativenumber<CR>

" }}}
" => Disabled-keys --------------------------------- {{{
" disable arrow keys in normal mode
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" }}}
" => Nvim-terminal --------------------------------- {{{

" Default settings
au BufEnter * if &buftype == 'terminal' | :startinsert | endif
autocmd BufEnter term://* startinsert
autocmd TermOpen * set bufhidden=hide

" Terminal mappings -------------------------------

" Open terminal
nmap <silent> <C-t>s <C-w>s<C-w>j:terminal<CR>a
nmap <silent> <C-t>v <C-w>v<C-w>l:terminal<CR>a
" Silently open a shell in the directory of the current file
if has("win32") || has("win64")
 " map <C-t><C-t> :silent !start cmd /k cd %:p:h <CR>
  nmap <silent> <C-t><C-t> :tc %:h<CR>:silent !start bash<CR>:tc -<CR>
endif

" }}}
" => Abbreviations --------------------------------- {{{

iab xdate <C-r>=strftime("%d/%m/%y %H:%M:%S")<cr>
iab reutrn return
iab re return
iab td TODO:
iab meta-vp <meta name="viewport" content="width=device-width, initial-scale=1" />

" }}}
" => Auto-commands --------------------------------- {{{
" Vertically center document when entering insert mode
autocmd InsertEnter * norm zz

augroup vimrcEx
  autocmd!
  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif

  " Vim/tmux layout rebalancing
  " automatically rebalance windows on vim resize
  autocmd VimResized * :wincmd =
augroup END

" Only show the cursor line in the active buffer.
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

source ~/dotfiles/nvim/plugin/vim-devicons.vim
" }}}
" => Helper-functions ------------------------------ {{{

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

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
" Allow j and k to work on visual lines (when wrapping)
noremap <silent> <A-z> :call ToggleWrap()<CR>

fun! ToggleBackground()
  if (&background ==? 'dark')
    set background=light
  else
    set background=dark
  endif
endfun
nnoremap <silent> <F10> :call ToggleBackground()<CR>

function! TrimWhitespace()
  let l:save = winsaveview()
  %s/\\\@<!\s\+$//e
  call winrestview(l:save)
endfunction
autocmd BufWritePre *.vim :call TrimWhitespace()

" PlaceholderImgTag 300x200
function! s:PlaceholderImgTag(size)
  let url = 'http://dummyimage.com/' . a:size . '/000000/555555'
  let [width,height] = split(a:size, 'x')
  execute "normal a<img src=\"".url."\" width=\"".width."\" height=\"".height."\" />"
endfunction
command! -nargs=1 PlaceholderImgTag call s:PlaceholderImgTag(<f-args>)

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
  let l:currentBufNum = bufnr("%")
  let l:alternateBufNum = bufnr("#")

  if buflisted(l:alternateBufNum)
    buffer #
  else
    bnext
  endif

  if bufnr("%") == l:currentBufNum
    new
  endif

  if buflisted(l:currentBufNum)
    execute("bdelete! ".l:currentBufNum)
  endif
endfunction

" Toggle quickfix window.
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
nnoremap <silent> <Leader>c :call QuickFix_toggle()<CR>

" }}}
" => Temporary ------------------------------------- {{{

" vmap gs :sort<CR>

" }}}
" => Section name ---------------------------------- {{{
" ======================================
" => Title
" ======================================
" }}}


  """""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Author: Hasan Mahmud                                   "
"  Repo:   https://github.com/hasansujon786/dotfiles/     "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  """""""""""""""""""""""""""""""""""""""""""""""""""""""

