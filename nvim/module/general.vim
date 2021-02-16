" => General ---------------------------------------------------- {{{
" filetype plugin indent on                              " Enable filetype plugins
" Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
" copy next line to .tmux.conf for support true color within tmux
" set-option -ga terminal-overrides ",xterm-256color:Tc"
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
 " enable mouse (selection, resizing windows)
if has('mouse')
  set mouse=a
endif

" Some general settings
set path+=**                                           " usefull while using find in nested folders
set backspace=eol,start,indent                         " Configure backspace so it acts as it should act

set lazyredraw                                         " Don't redraw while executing macros (good performance config)
set updatetime=100
set timeout ttimeout ttimeoutlen=200 timeoutlen=500    " Quickly time out on keycodes, but never time out on mappings
set autowrite                                          " Automatically :write before running commands
set autoread                                           " Set to auto read when a file is changed from the outside

let mapleader="\<Space>"                               " Map leader (the dedicated user-mapping prefix key) to space
let maplocalleader="\<Space>"

" }}}
" => Files-backup-undo-spelling --------------------------------- {{{
" if filereadable($HOME . '/.vimrc.local')
"   source ~/.vimrc.local
" endif

if !has('win32')
  if !exists('$XDG_CACHE_HOME')
    let $XDG_CACHE_HOME = $HOME . '/.cache'
  end
  set undodir=$XDG_CACHE_HOME/vim_undo
  set viewdir=$XDG_CACHE_HOME/vim_views
else
  set undodir=$HOME/AppData/Local/nvim-data/undo
  set viewdir=$HOME/AppData/Local/nvim-data/views
end

set nobackup nowb noswapfile                           " Turn backup off, since most stuff is in SVN, git etc. anyway...
set viewoptions-=curdir                                " see: https://vi.stackexchange.com/questions/11903/working-directory-different-than-current-file-directory
set undofile undolevels=1500                           " persistent undo between file reloads

set spelllang=en_us                                    " Speak proper English | en_gb
set complete+=kspell                                   " Autocomplete with dictionary words when spell check is on
set spellfile=~/dotfiles/nvim/spell/en.utf-8.add
" }}}
" => VIM-User-Interface ----------------------------------------- {{{

" Avoid garbled characters in Chinese language windows OS
" set langmenu=en_US
" let $LANG = 'en_US'
" source $VIMRUNTIME/delmenu.vim
" source $VIMRUNTIME/menu.vim

" Autocompletion
set wildmenu wildignorecase                            " Turn on the Wild menu
set pumblend=3                                         " set pum background visibility to 20 percent
set pumheight=10                                       " Makes popup menu smaller
set wildoptions=pum                                    " set file completion in command to use pum
set shortmess+=c                                       " don't give |ins-completion-menu| messages
set mousemodel=popup

" Ignore the following globs in file completions
set wildignore+=*.o,*~,*.pyc,*.obj,*.pyc,*.so,*.swp
set wildignore+=*.zip,*.jpg,*.gif,*.png,*.pdf
set wildignore+=.git,.hg,.svn,DS_STORE,bower_components,node_modules
if has("win16") || has("win32")
  set wildignore+=.git\*,.hg\*,.svn\*
else
  set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

set ruler                                              " Always show current position
set showmatch                                          " Show matching brackets when text indicator is over them
set cursorline                                         " Show a line on current line
set showcmd                                            " show any commands
set noshowmode                                         " don't show mode as lightline already does
set nomodeline
set modelines=0

" Guicursor Setting
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
      \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
      \,sm:block-blinkwait175-blinkoff150-blinkon175

" No annoying sound on errors
set noerrorbells novisualbell
set t_vb=

" Numbers
set number relativenumber
set numberwidth=4
set foldcolumn=0                                       " display gutter markings for folds
set signcolumn=yes                                     " Always show the signcolumn,

" Tabline
set showtabline=2

" Windwo & buffer
set cmdheight=1                                        " Height of the command bar
set splitbelow splitright                              " Fix splitting
set hidden switchbuf=useopen                           " Specify the behavior when switching between buffers (enable hidden unsaved buffers)
set diffopt+=vertical                                  " Always use vertical diffs

let g:sh_fold_enabled=1                                " enable folding in bash files

" }}}
" => Text-Tab-and-Indent ---------------------------------------- {{{

" Tabbing
set expandtab                                          " Insert tabs as spaces.
set tabstop=2 shiftwidth=2 softtabstop=2               " The number of spaces a tab is.
set autoindent smartindent                             " Auto indent & Smart indent

" Searching
set magic                                              " For regular expressions turn magic on
set regexpengine=1                                     " (good performance config)
set wrapscan                                           " Wrap searches.
set ignorecase smartcase                               " Ignore search term case, unless term contains an uppercase character.
set infercase
set hlsearch incsearch                                 " Show where the pattern, as it was typed.
set gdefault                                           " The ':substitute' flag 'g' is default on.
set inccommand=nosplit                                 " interactive find replace preview

" Scroll-aside
set sidescroll=1
set scrolloff=1                                        " Set 1 lines to the cursor - when moving vertically using j/k
set sidescrolloff=5

" Text appearance
set iskeyword+=-                                       " treat dash separated words as a word text object
set iskeyword-=#                                       " Remove # from part of word
set list
set listchars+=tab:→\ ,nbsp:␣,trail:•                  " show hidden characters
" set listchars+=precedes:«,extends:»
set listchars+=precedes:,extends:
set matchpairs+=<:>,«:»,｢:｣                            " Match angle brackets...

" Wrappings
set textwidth=120                                      " Hard-wrap text at nth column
set whichwrap+=<,>,h,l,[,]                             " Allow left/right & h/l key to move to the previous/next line
set nowrap                                             " No wrap by default
set linebreak                                          " Don't break words when wrapping lines
let &showbreak="↳ "                                    " Make wrapped lines more obvious
set cpoptions+=n
set breakindent                                        " Every wrapped line will continue visually indented
" }}}

