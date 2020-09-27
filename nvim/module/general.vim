" => General ---------------------------------------------------- {{{
" Set utf8 as standard encoding and en_US as the standard language
set encoding=UTF-8                   " Default encoding
scriptencoding utf-16                " allow emojis in vimrc
set ffs=unix,dos,mac                 " Use Unix as the standard file type
syntax on                            " Enable syntax highlighting
filetype plugin on                   " Enable filetype plugins
filetype indent on

if $COLORTERM == 'gnome-terminal'
  set t_Co=256                       " Enable 256 colors palette in Gnome Terminal
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

" Some general settings
set magic                            " For regular expressions turn magic on
set showcmd                          " show any commands
set noshowmode                       " don't show mode as airline already does
set path+=**                         " usefull while using find in nested folders
set fillchars=""                     " Remove characters in window split (statusline)
set nomodeline
set modelines=0
set shortmess+=c                     " don't give |ins-completion-menu| messages
set lazyredraw                       " Don't redraw while executing macros (good performance config)
set regexpengine=1                   " (good performance config)
set updatetime=100
set timeout ttimeout ttimeoutlen=200 " Quickly time out on keycodes, but never time out on mappings
set mousemodel=popup
set autowrite                        " Automatically :write before running commands
set autoread                         " Set to auto read when a file is changed from the outside
au FocusGained,BufEnter,CursorHold *
      \checktime                     " Update a buffer's contents on focus if it changed outside of Vim.

if has('mouse')
  set mouse=a                        " enable mouse (selection, resizing windows)
endif

let mapleader="\<Space>"             " Map leader (the dedicated user-mapping prefix key) to space
let maplocalleader="\<Space>"

" }}}
" => Files-backup-undo-spelling --------------------------------- {{{
" if filereadable($HOME . '/.vimrc.local')
"   source ~/.vimrc.local
" endif

set nobackup nowb noswapfile         " Turn backup off, since most stuff is in SVN, git etc. anyway...
set backupdir=~/.config/nvim/tmp/backup
set directory=~/.config/nvim/tmp/swap
set undodir=~/.config/nvim/tmp/undo
set viewdir=~/.config/nvim/tmp/view
set viewoptions-=curdir              " see: https://vi.stackexchange.com/questions/11903/working-directory-different-than-current-file-directory

set undofile                         " persistent undo between file reloads
set undolevels=1500                  " Save a lot of back-history.

set spelllang=en_us                  " Speak proper English | en_gb
set complete+=kspell                 " Autocomplete with dictionary words when spell check is on
set spellfile=~/dotfiles/nvim/spell/en.utf-8.add

" }}}
" => VIM-User-Interface ----------------------------------------- {{{

" Avoid garbled characters in Chinese language windows OS
let $LANG='en'
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" Autocompletion
" set wildmode=longest,list,full
set wildmenu                         " Turn on the Wild menu
set pumblend=3                       " set pum background visibility to 20 percent
set pumheight=10                     " Makes popup menu smaller
set wildoptions=pum                  " set file completion in command to use pum

" Ignore the following globs in file completions
set wildignore+=*.o,*~,*.pyc,*.obj,*.pyc,*.so,*.swp
set wildignore+=*.zip,*.jpg,*.gif,*.png,*.pdf
set wildignore+=.git,.hg,.svn,DS_STORE,bower_components,node_modules
if has("win16") || has("win32")
  set wildignore+=.git\*,.hg\*,.svn\*
else
  set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

set hidden                           " enable hidden unsaved buffers
set diffopt+=vertical                " Always use vertical diffs
set ruler                            " Always show current position
set cmdheight=1                      " Height of the command bar
set foldcolumn=0                     " display gutter markings for folds
set cursorline                       " Show a line on current line
set showmatch                        " Show matching brackets when text indicator is over them
set mat=2                            " How many tenths of a second to blink when matching brackets
set backspace=eol,start,indent       " Configure backspace so it acts as it should act
set splitbelow splitright            " Fix splitting

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

let g:sh_fold_enabled=1              " enable folding in bash files

" }}}
" => Text-Tab-and-Indent ---------------------------------------- {{{

" Tabbing
set tabstop=2                        " The number of spaces a tab is
set shiftwidth=2                     " Number of spaces to use in auto(indent)
set softtabstop=2                    " Just to be clear
set expandtab                        " Insert tabs as spaces

" Searching
set wrapscan                         " Wrap searches
set ignorecase                       " Ignore search term case...
set smartcase                        " ... unless term contains an uppercase character
set hlsearch                         " ... as you type

" text appearance
set so=1                             " Set 7 lines to the cursor - when moving vertically using j/k
set iskeyword+=-                     " treat dash separated words as a word text object
set list
set listchars=tab:→\ ,nbsp:␣,trail:•,precedes:«,extends:»   " show hidden characters
set matchpairs+=<:>,«:»,｢:｣          " Match angle brackets...
set ai si                            " Auto indent & Smart indent

" Wrappings
set whichwrap+=<,>,h,l,[,]           " automatically wrap left and right
set textwidth=80                    " Hard-wrap text at nth column
set nowrap                           " No wrap by default
set linebreak                        " Don't break words when wrapping lines
let &showbreak="↳ "                  " Make wrapped lines more obvious
set cpoptions+=n
set breakindent                      " Every wrapped line will continue visually indented

" }}}
