" => Environment ----------------------------------- {{{

" Local config
if filereadable($HOME . '/.vimrc.local')
  source ~/.vimrc.local
endif

" }}}
" => General --------------------------------------- {{{

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * checktime

" Automatically :write before running commands
set autowrite

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
set updatetime=100
" Quickly time out on keycodes, but never time out on mappings
set timeout ttimeout ttimeoutlen=200
set mousemodel=popup
" snippets
" set clipboard=unnamed
" set clipboard+=unnamedplus

" Mouse Settings
if has('mouse')
  set mouse=a           " enable mouse (selection, resizing windows)
endif

" Map leader (the dedicated user-mapping prefix key) to space
let mapleader="\<Space>"
let maplocalleader="\<Space>"

" }}}
" => Plugin-Settings ------------------------------- {{{

call plug#begin('~/.config/nvim/plugged')

" ======================================
" => Visual-&-Theme
" ======================================
Plug 'itchyny/lightline.vim'
Plug 'Yggdroot/indentLine'
Plug 'junegunn/goyo.vim'
Plug 'rakr/vim-one'
" Plug 'rafi/awesome-vim-colorschemes'
" Plug 'whatyouhide/vim-gotham'

" ======================================
" => Functionality-&-Helpers
" ======================================
Plug 'michaeljsmith/vim-indent-object'
Plug 'terryma/vim-multiple-cursors'
Plug 'unblevable/quick-scope'
Plug 'easymotion/vim-easymotion'
Plug 'vim-scripts/YankRing.vim', { 'on':  'YRShow' }
Plug 'tpope/vim-commentary'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-eunuch'   "for moving and manipulating files / directories.

" ======================================
" => Intrigration
" ======================================
"Plug 'christoomey/vim-tmux-navigator'
Plug 'mhinz/vim-startify'
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'yuki-ycino/fzf-preview.vim'

Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'

" ======================================
" => Syntax
" ======================================
Plug 'sheerun/vim-polyglot'     " Full lang support
Plug 'ap/vim-css-color'

" ======================================
" => Git
" ======================================
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'

" ======================================
" => Languae-support
" ======================================
" javascript {{{
"   Plug 'nvim-typescript'
"   Plug 'othree/yajs.vim'
"   Plug 'mxw/vim-jsx'
"   Plug 'heavenshell/vim-jsdoc'
"   Plug 'elzr/vim-json'
"   Plug 'HerringtonDarkholme/yats.vim'
"   Plug 'Quramy/vison'
"   Plug 'jxnblk/vim-mdx-js'
"   Plug 'meain/vim-package-info', {'build': 'npm install'}
"   Plug 'yardnsm/vim-import-cost', {'build': 'npm install'}
" }}}

" html {{{
"   Plug 'othree/html5.vim'
  Plug 'mattn/emmet-vim'
"   Plug 'valloric/MatchTagAlways', {'on_ft': 'html'}
"   Plug 'posva/vim-vue'
"   Plug 'skwp/vim-html-escape'
"   Plug 'kana/vim-textobj-user'
"   Plug 'whatyouhide/vim-textobj-xmlattr'
"   Plug 'pedrohdz/vim-yaml-folds'
" }}}

" css {{{
"   Plug 'hail2u/vim-css3-syntax'
"   Plug 'ap/vim-css-color'
"   Plug 'norcalli/nvim-colorizer.lua'
"   Plug 'ncm2/ncm2-cssomni'
" }}}

Plug 'neoclide/coc.nvim', {'branch': 'release'}
" https://thoughtbot.com/blog/modern-typescript-and-react-development-in-vim
" coc extension {{{
" https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions
" let g:coc_global_extensions = [
"   \ 'coc-tsserver'
"   \ ]
" => JavaScript
" coc-tsserver coc-json coc-vetur

" => HTML
" coc-html coc-css coc-emmet coc-tailwindcss

" => Ediort Support
" coc-bookmark coc-actions coc-lists coc-snippets coc-spell-checker coc-vimlsp coc-yank

" => CLang
" coc-clangd

" }}}

" ======================================
" => Not-listed
" ======================================
" Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
" Plug 'terryma/vim-expand-region'
" Plug 'voldikss/vim-floaterm'
" Plug 'alvan/vim-closetag'
" Plug 'dragvisuals.vim'
" Plug 'vmath.vim'
" Plug 'vis.vim'

call plug#end()

" ======================================
" => yuki-ycino/fzf-preview.vim
" ======================================
" let g:fzf_preview_use_dev_icons = 1
" let g:fzf_preview_layout = '12split new'
" let g:fzf_preview_use_floating_window = 0
" let g:fzf_preview_command = 'head -100 {-1}'

" let g:fzf_preview_custom_default_processors = {
"     \  '':      function('fzf_preview#resource_processor#edit'),
"     \ 'ctrl-s': function('fzf_preview#resource_processor#split'),
"     \ 'ctrl-v': function('fzf_preview#resource_processor#vsplit'),
"     \ 'ctrl-t': function('fzf_preview#resource_processor#tabedit'),
"     \ 'ctrl-q': function('fzf_preview#resource_processor#export_quickfix') }

" let $FZF_PREVIEW_PREVIEW_BAT_THEME = 'TwoDark'

" let g:fzf_pco = '--multi --ansi --bind=ctrl-d:preview-page-down,ctrl-u:preview-page-up,?:toggle-preview'
" nnoremap <silent> <Leader>fb :<C-u>FzfPreviewBuffers -overwrite-fzf-args=g:fzf_pco<CR>
" nnoremap <silent> <Leader>fh :<C-u>FzfPreviewOldFiles -overwrite-fzf-args=g:fzf_pco<CR>
" nnoremap <silent> <Leader>fd :<C-u>FzfPreviewDirectoryFiles -overwrite-fzf-args=g:fzf_pco<CR>
" nnoremap <silent> <Leader>fw :<C-u>Windows<CR>
" nnoremap <silent> <Leader>fp :<C-u>FzfPreviewProjectFiles -overwrite-fzf-args=g:fzf_pco<CR>

" nnoremap <silent> <C-p> :<C-u>FzfPreviewProjectOldFiles -overwrite-fzf-args=g:fzf_pco<CR>
" nnoremap <silent> <C-p> :<C-u>FzfPreviewProjectMruFiles -overwrite-fzf-args=g:fzf_pco<CR>

" ======================================
" => junegunn/fzf
" ======================================
nnoremap <silent> - :Files <C-R>=expand('%:h')<CR><CR>
nnoremap <silent> <C-p> :History<CR>
nnoremap <silent> <C-k>p :Files<CR>
nnoremap <silent> <C-k><C-p> :GFile<CR>
nnoremap <silent> <C-k>w :Windows<CR>
nnoremap <silent> <C-k>m :Filetypes<CR>
nnoremap <silent> <C-k>? :GFile?<CR>
nnoremap <silent> <C-k>/ :History/<CR>
nnoremap <silent> <C-k>: :History:<CR>

let g:fzf_layout = { 'window': '30new' }
" let g:fzf_files_options = '--reverse --preview "(cat {})"'

let $FZF_DEFAULT_OPTS =' --color=dark,
      \fg:-1,bg:-1,hl:#55B6C2,
      \fg+:#E5C07B,bg+:-1,hl+:#55B6C2,pointer:#E5C07B,
      \info:#ABB2BF,prompt:#E06C75,
      \marker:#E06C75,spinner:#61afef,header:#c678dd,gutter:-1
      \ --bind ctrl-a:select-all'

let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit',
      \ 'q': 'normal <C-c>'}

" ======================================
" => Yggdroot/indentLine
" ======================================
let g:indentLine_color_gui = '#444444'
let g:indentLine_char = '▏'

" ======================================
" => jiangmiao/auto-pairs
" ======================================
let g:AutoPairsShortcutJump = '<M-n>'
let g:AutoPairsShortcutToggle = '<M-q>'
let g:AutoPairsShortcutBackInsert = '<Nul>'

" ======================================
" => scrooloose/nerdtree
" ======================================
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

" autocmd BufEnter NERD_tree_* nmap  d<CR> <CR> :NERDTreeToggle <CR>
" autocmd BufLeave NERD_tree_* unmap d<CR>
" Open nerd tree at the current file or close nerd tree if pressed again.
nnoremap <silent> <expr> <Leader>n g:NERDTree.IsOpen() ? "\:NERDTreeClose<CR>" : bufexists(expand('%')) ? "\:NERDTreeFind<CR>" : "\:NERDTree<CR>"
nnoremap <silent> <Leader>0 :NERDTreeToggle<CR>

" ======================================
" => ryanoasis/vim-devicons
" ======================================
let g:webdevicons_enable_nerdtree = 1
let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1
" enable open and close folder/directory glyph flags (disabled by default with 0)
let g:DevIconsEnableFoldersOpenClose = 1

" Fix Vue Icon - ﵂
" change the default dictionary mappings for file extension matches
" let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {} " needed
" let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['vue'] = 'V'

" ======================================
" => itchyny/lightline.vim
" ======================================
" let s:p.tabline.left   = [ [ s:gray1, s:bg ] ]
" let s:p.tabline.tabsel = [ [ s:fg, s:gray3, 'bold' ] ]
" nmap <leader>le :e ~/.config/nvim/plugged/lightline.vim/autoload/lightline/colorscheme/one.vim

" let g:lightline.separator.right = ''
" let g:lightline.separator.left =  ''

let g:lightline = {
      \ 'colorscheme': 'one',
      \ 'mode_map': { 'c': 'NORMAL' },
      \ 'active': {
      \   'left': [[ 'mode', 'paste', 'readonly'],
      \            [ 'fugitive', 'filename',],
      \            [ 'cocstatus' ]],
      \
      \ 'right':  [[ 'lineinfo' ],
      \            [ 'percent'  ],
      \            [ 'filetype' ]],
      \ },
      \   'component': {
      \   'readonly': '%{&readonly?"":""}',
      \ },
      \ 'component_function': {
      \   'fugitive': 'LightlineFugitive',
      \   'filename': 'MyFilename',
      \   'filetype': 'MyFiletype',
      \   'mode': 'MyMode',
	    \   'cocstatus': 'coc#status'
      \ },
      \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
      \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" }
      \ }

" Use auocmd to force lightline update.
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

function! LightlineFugitive()
  if exists('*FugitiveHead')
    let branch = FugitiveHead()
    return winwidth(0) > 60 ? branch !=# '' ? ' '.branch : '' : ''
  endif
  return ''
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
  " return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! MyMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! MyModified()
  return &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyFilename()
  return (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

" ======================================
" => mhinz/vim-startify
" ======================================
let g:startify_files_number = 5

" ======================================
" => junegunn/goyo.vim
" ======================================
" Toggle Goyo
nnoremap <silent> gz :Goyo<CR>
nnoremap <silent> <C-k>z :Goyo<CR>

let g:background_before_goyo = &background
function! s:goyo_enter()
  let g:background_before_goyo = &background
  if has('gui_running')
    set linespace=7
  elseif exists('$TMUX')
    silent !tmux set status off
  endif
endfunction

function! s:goyo_leave()
  if has('gui_running')
    set linespace=0
  elseif exists('$TMUX')
    silent !tmux set status on
  endif
  execute 'set background=' . g:background_before_goyo
endfunction

augroup GOYO
  autocmd! User GoyoEnter nested call <SID>goyo_enter()
  autocmd! User GoyoLeave nested call <SID>goyo_leave()
augroup END

" ======================================
" => christoomey/vim-tmux-navigator
" ======================================
" let g:tmux_navigator_no_mappings = 1
" nnoremap <silent> <A-h> :TmuxNavigateLeft<cr>
" nnoremap <silent> <A-j> :TmuxNavigateDown<cr>
" nnoremap <silent> <A-k> :TmuxNavigateUp<cr>
" nnoremap <silent> <A-l> :TmuxNavigateRight<cr>
" nnoremap <silent> <A-\> :TmuxNavigatePrevious<cr>
" nnoremap <silent> <S-tab> :TmuxNavigatePrevious<cr>

" ======================================
" => unblevable/quick-scope
" ======================================
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
" let qs_max_chars=80
augroup qs_colors
  autocmd!
  autocmd ColorScheme * highlight QuickScopePrimary guifg='tomato' gui=underline ctermfg=155 cterm=underline
  autocmd ColorScheme * highlight QuickScopeSecondary guifg='#d78787' gui=underline ctermfg=81 cterm=underline
augroup END

" ======================================
" => vim-scripts/YankRing.vim
" ======================================
nnoremap <silent> <leader>y :YRShow<CR>
vnoremap <silent> <leader>y y:YRShow<CR>:close<CR>
let g:yankring_replace_n_pkey = '<M-S-y>'
let g:yankring_replace_n_nkey = '<M-y>'

function! YRRunAfterMaps()
  nnoremap <silent> Y :<C-U>YRYankCount 'y$'<CR>
  vnoremap p pgvy
  vnoremap y ygv<Esc>
endfunction

" ======================================
" => terryma/vim-multiple-cursors
" ======================================
" Default mappings
let g:multi_cursor_start_word_key      = 'gb'
let g:multi_cursor_select_all_word_key = '<C-F2>'
let g:multi_cursor_next_key            = 'gb'
let g:multi_cursor_prev_key            = 'gp'
let g:multi_cursor_quit_key            = 'q'
" let g:multi_cursor_start_key           = 'g<C-n>'
" let g:multi_cursor_select_all_key      = 'g<A-n>'
" let g:multi_cursor_skip_key            = '<C-x>'

" ======================================
" => mbbill/undotree
" ======================================
let g:undotree_WindowLayout = 2
let g:undotree_DiffAutoOpen = 0
" let g:undotree_DiffpanelHeight = 10
nnoremap <silent> <C-F5> :UndotreeToggle<cr>

" ======================================
" => airblade/vim-gitgutter"
" ======================================
let g:gitgutter_map_keys = 0
nmap <leader>gp <Plug>(GitGutterPreviewHunk)
nmap <leader>gs <Plug>(GitGutterStageHunk)
nmap <leader>gu <Plug>(GitGutterUndoHunk)

nmap [c <Plug>(GitGutterPrevHunk)
nmap ]c <Plug>(GitGutterNextHunk)

" ======================================
" => tpope/vim-fugitive
" ======================================
nmap <leader>gg :Gstatus<CR>

source ~/dot-windows/nvim/plugin/config.vim
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
set pumblend=15       " set pum background visibility to 20 percent
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

set hidden            " enable hidden unsaved buffers
set diffopt+=vertical " Always use vertical diffs
set ruler             " Always show current position
set cmdheight=1       " Height of the command bar
set foldcolumn=1      " display gutter markings for folds
set cursorline        " Show a line on current line

" Fix splitting
set splitbelow splitright

" Guicursor Setting
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
      \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
      \,sm:block-blinkwait175-blinkoff150-blinkon175

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500
" Properly disable sound on errors on MacVim
if has("gui_macvim")
  autocmd GUIEnter * set vb t_vb=
endif

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" Numbers
set number
set numberwidth=1
set relativenumber

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set showtabline=2
catch
endtry

" }}}
" => Colors-and-Fonts ------------------------------ {{{

" Enable syntax highlighting
syntax on

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

try
  colorscheme one
catch
endtry

if has("gui_running")
  set guioptions-=T
  set guioptions-=e
  set t_Co=256
  set guitablabel=%M\ %t
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=UTF-8    " Default encoding
scriptencoding utf-16 " allow emojis in vimrc

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Some default settings
" let g:one_allow_italics = 1       " support italic fonts
let g:sh_fold_enabled=1           " enable folding in bash files

" }}}
" => Files-backup-undo ----------------------------- {{{
"
" Turn backup off, since most stuff is in SVN, git etc. anyway...
set nobackup
set nowb
set noswapfile

" set where swap file and undo/backup files are saved
" set backupdir=~/.config/nvim/tmp/backup,.
" set directory=~/.config/nvim/tmp/swap,.

" persistent undo between file reloads
if has('persistent_undo')
  " set undolevels=5000   " Save a lot of back-history...
  set undodir=~/.config/nvim/tmp/undo,.
  set undofile
endif

" File Browsing ----------------------------------
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=&spr       " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

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
set listchars=tab:»·,trail:·,nbsp:· " Display extra whitespace
set list                            " show invisible characters
set matchpairs+=<:>,«:»,｢:｣         " Match angle brackets...
set ai "Auto indent
set si "Smart indent
set linebreak                       " Don't break words when wrapping lines
let &showbreak="↳ "                 " Make wrapped lines more obvious
set cpoptions+=n

" Highlight the characters on column 81
highlight ColorColumn guibg=magenta
call matchadd('ColorColumn', '\%81v', '100')
augroup fzf
  autocmd  FileType fzf call clearmatches()
        \| autocmd BufLeave <buffer> call matchadd('ColorColumn', '\%81v', '100')
augroup END


" }}}
" => Spell-checking -------------------------------- {{{

set spelllang=en_gb   " Speak proper English
set complete+=kspell  " Autocomplete with dictionary words when spell check is on

" Set spellfile to location that is guaranteed to exist
set spellfile=~/.config/nvim/spell/en.utf-8.add

" Toggle spelling and show it's status
nmap <F7> :setlocal spell! spell?<CR>

"Open spell file
map <leader>dic :tabnew ~/.config/nvim/spell/en.utf-8.add<Cr>

" Spell commands
" Next wrong spell      ]s
" Previous wrong spell  [s
" Add to spell file     zg
" Prompt spell fixes    z=

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
nnoremap <A-k> <C-u>
nnoremap <A-j> <C-d>
" Horizontal scroll
nnoremap <A-l> 5zl
nnoremap <A-h> 5zh

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

" map . in visual mode
vnoremap . :norm.<cr>

" Keep selection when indenting/outdenting.
vnoremap > >gv
vnoremap < <gv

" Comment or uncomment lines
nmap <C-_> mzgcc`z
imap <C-_> <ESC>gccgi
vmap <C-_> mzgc`zgv

" Move lines up and down in normal & visual mode
" nnoremap <silent> <A-k> :move -2<CR>==
" nnoremap <silent> <A-j> :move +1<CR>==
vnoremap <silent> <A-k> :move '<-2<CR>gv=gv
vnoremap <silent> <A-j> :move '>+1<CR>gv=gv

" ======================================
" => Moving-around-tabs-and-buffers
" ======================================

" Jump between panes
nnoremap <silent> <leader>j :wincmd j<CR>
nnoremap <silent> <leader>k :wincmd k<CR>
nnoremap <silent> <leader>h :wincmd h<CR>
nnoremap <silent> <leader>l :wincmd l<CR>
nnoremap <silent> <leader>l :wincmd l<CR>
nnoremap <silent> <leader>\ :wincmd p<CR>

" Resize splits
nnoremap <silent> <A->> :resize +3<CR>
nnoremap <silent> <A-<> :resize -3<CR>
nnoremap <silent> <A-.> :vertical resize +5<CR>
nnoremap <silent> <A-,> :vertical resize -5<CR>
" zoom a vim pane
nnoremap <silent> \ :wincmd _<cr>:resize -2<CR>:wincmd \|<cr>:vertical resize -10<CR>
nnoremap <silent> <Bar> :wincmd =<cr>

" Jump between tabs
nnoremap <silent> gl :tabnext<CR>
nnoremap <silent> gh :tabprevious<CR>
nnoremap <silent> gL :tablast<CR>
nnoremap <silent> gH :tabfirst<CR>

" ======================================
" => Search-functionalities
" ======================================

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>
" vnoremap * "xy/<C-R>x<CR>

" Alias replace all to S
nnoremap S :%s//gI<Left><Left><Left>

" interactive find replace preview
set inccommand=nosplit
" replace word under cursor, globally, with confirmation
nnoremap <Leader>ff :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
vnoremap <Leader>ff y :%s/<C-r>"//gc<Left><Left><Left>

" ======================================
" => Special-key-'g'-commands
" ======================================
" sort selected lines
vmap gs :sort<CR>

" ======================================
" => Insert-Mode-key-mapping
" ======================================

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

" ======================================
" => Command-mode-related
" ======================================

" Bash like keys for the command line
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

" ======================================
" => Leader-commands
" ======================================

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

" compile & run c Code
nnoremap <leader>bb :w<CR>:!gcc % -o .lastbuild && ./.lastbuild<cr>
nnoremap <leader>bl :w<CR>:!./.lastbuild<cr>

" Toggle highlighting of current line and column
nnoremap <silent> <leader>c :setlocal cursorcolumn!<CR>

" Toggle relative line numbers and regular line numbers.
nnoremap <silent> <leader>mm :set nu! invrelativenumber<CR>
nnoremap <silent> <leader>mu :set invrelativenumber<CR>

" Allow j and k to work on visual lines (when wrapping)
noremap <silent> <leader>wp :call ToggleWrap()<CR>
noremap <silent> <A-z> :call ToggleWrap()<CR>

" ======================================
" => Organize-files-&-folders
" ======================================

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

" ======================================
" => Function-key-mappings
" ======================================
" Pasting support
set pastetoggle=<F3>  " Press F3 in insert mode to preserve tabs when
" pasting from clipboard into terminal

" toggle background light / dark
nnoremap <silent> <F10> :call ToggleBackground()<CR>

" }}}
" => Disabled-keys --------------------------------- {{{

" disable arrow keys in normal mode
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" Disable help key
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" }}}
" => Fold-related ---------------------------------- {{{

" Space to toggle folds.
nnoremap <leader>z za
vnoremap <leader>z za

autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
autocmd InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif

" autocmd FileType vim setlocal fdc=1
set foldlevel=99

autocmd FileType vim setlocal foldmethod=marker
autocmd FileType vim setlocal foldlevel=0

autocmd FileType javascript,html,css,scss,typescript setlocal foldlevel=99

autocmd FileType css,scss,json setlocal foldmethod=marker
autocmd FileType css,scss,json setlocal foldmarker={,}

autocmd FileType coffee setl foldmethod=indent
let g:xml_syntax_folding = 1
autocmd FileType xml setl foldmethod=syntax

autocmd FileType html setl foldmethod=expr
autocmd FileType html setl foldexpr=HTMLFolds()

" autocmd FileType javascript,typescript,json setl foldmethod=syntax
autocmd FileType javascript,typescript,typescript.tsx,typescriptreact,json setl foldmethod=syntax

function! MyFoldText() " {{{
  let line = getline(v:foldstart)
  let nucolwidth = &fdc + &number * &numberwidth
  let windowwidth = winwidth(0) - nucolwidth - 3
  let foldedlinecount = v:foldend - v:foldstart

  " expand tabs into spaces
  let onetab = strpart('          ', 0, &tabstop)
  let line = substitute(line, '\t', onetab, 'g')

  let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
  " let fillcharcount = windowwidth - len(line) - len(foldedlinecount) - len('lines')
  " let fillcharcount = windowwidth - len(line) - len(foldedlinecount) - len('lines   ')
  let fillcharcount = windowwidth - len(line)
  " return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . ' Lines'
  return line . ''. repeat(" ",fillcharcount)
endfunction " }}}
set foldtext=MyFoldText()


" }}}
" => Nvim-terminal --------------------------------- {{{

" Default settings
au BufEnter * if &buftype == 'terminal' | :startinsert | endif
autocmd BufEnter term://* startinsert
autocmd TermOpen * set bufhidden=hide

" Terminal mappings -------------------------------

tmap jk <C-\><C-n>
tmap <Esc> <C-\><C-n>
tmap <silent> <C-d> <Esc>:q<CR>

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
iab mt-vp <meta name="viewport" content="width=device-width, initial-scale=1" />

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

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile Appraisals,*.rabl set filetype=ruby
  autocmd BufRead,BufNewFile .babelrc set filetype=json
  autocmd BufRead,BufNewFile *.yrl set filetype=erlang
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile .eslintrc,.prettierrc set filetype=json

  " Enable spellchecking for Markdown
  autocmd FileType markdown setlocal spell

  " Automatically wrap at 72 characters and spell check git commit messages
  autocmd FileType gitcommit setlocal textwidth=72
  autocmd FileType gitcommit setlocal spell

  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass setlocal iskeyword+=-

  " Vim/tmux layout rebalancing
  " automatically rebalance windows on vim resize
  autocmd VimResized * :wincmd =

  " add support for comments in json (jsonc format used as configuration for
  " many utilities)
  autocmd FileType json syntax match Comment +\/\/.\+$+

augroup END

" Only show the cursor line in the active buffer.
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

" Pretty font icons like Seti-UI {{{
" Create a dictionary of the colors for later use
let g:sol = {
      \"gui": {
      \"base03": "#002b36",
      \"base02": "#073642",
      \"base01": "#586e75",
      \"base00": "#657b83",
      \"base0": "#839496",
      \"base1": "#93a1a1",
      \"base2": "#eee8d5",
      \"base3": "#fdf6e3",
      \"yellow": "#b58900",
      \"orange": "#cb4b16",
      \"red": "#dc322f",
      \"magenta": "#d33682",
      \"violet": "#6c71c4",
      \"blue": "#268bd2",
      \"cyan": "#2aa198",
      \"green": "#719e07"
      \},
      \"cterm": {
      \"base03": 8,
      \"base02": 0,
      \"base01": 10,
      \"base00": 11,
      \"base0": 12,
      \"base1": 14,
      \"base2": 7,
      \"base3": 15,
      \"yellow": 3,
      \"orange": 9,
      \"red": 1,
      \"magenta": 5,
      \"violet": 13,
      \"blue": 4,
      \"cyan": 6,
      \"green": 2
      \}
      \}

" Needs to be near the end because it changes the way some of the
" other plugins like ctrl-p, startify, NERDTree, etc. work.
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1
if exists("g:loaded_webdevicons")
  call webdevicons#refresh()
endif

augroup devicons
  autocmd!
  autocmd FileType nerdtree setlocal nolist
  autocmd FileType nerdtree syntax match hideBracketsInNerdTree "\]" contained conceal containedin=ALL
  autocmd FileType nerdtree syntax match hideBracketsInNerdTree "\[" contained conceal containedin=ALL
  autocmd FileType nerdtree setlocal conceallevel=3
  autocmd FileType nerdtree setlocal concealcursor=nvic
augroup END

function! DeviconsColors(config)
  let colors = keys(a:config)
  augroup devicons_colors
    autocmd!
    for color in colors
      if color == 'normal'
        exec 'autocmd FileType nerdtree,startify if &background == ''dark'' | '.
              \ 'highlight devicons_'.color.' guifg='.g:sol.gui.base01.' ctermfg='.g:sol.cterm.base01.' | '.
              \ 'else | '.
              \ 'highlight devicons_'.color.' guifg='.g:sol.gui.base1.' ctermfg='.g:sol.cterm.base1.' | '.
              \ 'endif'
      elseif color == 'emphasize'
        exec 'autocmd FileType nerdtree,startify if &background == ''dark'' | '.
              \ 'highlight devicons_'.color.' guifg='.g:sol.gui.base1.' ctermfg='.g:sol.cterm.base1.' | '.
              \ 'else | '.
              \ 'highlight devicons_'.color.' guifg='.g:sol.gui.base01.' ctermfg='.g:sol.cterm.base01.' | '.
              \ 'endif'
      else
        exec 'autocmd FileType nerdtree,startify highlight devicons_'.color.' guifg='.g:sol.gui[color].' ctermfg='.g:sol.cterm[color]
      endif
      exec 'autocmd FileType nerdtree,startify syntax match devicons_'.color.' /\v'.join(a:config[color], '|').'/ containedin=ALL'
    endfor
  augroup END
endfunction

let g:devicons_colors = {
      \'normal': [' ', ' ', ' ', ' ', ' '],
      \'emphasize': [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
      \'yellow': [' ', ' ', ' '],
      \'orange': [' ', ' ', ' ', 'λ ', ' ', ' '],
      \'red': [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
      \'magenta': [' '],
      \'violet': [' ', ' ', ' ', ' '],
      \'blue': [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
      \'cyan': [' ', ' ', ' ', ' '],
      \'green': [' ', ' ', ' ', ' ', 'V ', '﵂']
      \}
call DeviconsColors(g:devicons_colors)
" }}}

" }}}
" => Helper-functions ------------------------------ {{{

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

fun! ToggleBackground()
  if (&background ==? 'dark')
    set background=light
  else
    set background=dark
  endif
endfun

function! TrimWhitespace()
  let l:save = winsaveview()
  %s/\\\@<!\s\+$//e
  call winrestview(l:save)
endfunction
autocmd BufWritePre * :call TrimWhitespace()

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

function! CmdLine(str)
  call feedkeys(":" . a:str)
endfunction

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

" }}}
" => Temporary ------------------------------------- {{{

" if !exists('g:vscode') endif

" if !empty(glob("~/mydotfiles/nvim/init.vim"))
"   source ~/mydotfiles/nvim/init.vim
"   echo 'Welcom to Neovim'
" endif

" clear search
" nnoremap <silent> <leader>sdf :let @/ = ''<cr>

" map markdown preview
" nmap <leader>m :!open -a "Marked 2" "%"<cr><cr>

" map git commands
" nmap <leader>b :Gblame<cr>
" nmap <leader>l :split \| terminal git log -p %<cr>
" nmap <leader>d :split \| terminal git diff %<cr>

" Jump to adjacent files
" nmap <leader>ip :e %:r.pug<CR>
" nmap <leader>is :e %:r.sass<CR>
" nmap <leader>it :e %:r.ts<CR>
" nmap <leader>ih :e %:r.html<CR>

" au FileType javascript imap <C-t> $log();<esc>hi
" au FileType javascript imap <C-a> alert();<esc>hi

" C++
" au BufRead,BufNewFile,BufEnter *.c nmap <leader>ih :e %:h/../inc/%:t:r.h<CR>
" au BufRead,BufNewFile,BufEnter *.c nmap <leader>ic :e %:h/../src/%:t:r.c<CR>
" au BufRead,BufNewFile,BufEnter *.c nmap <leader>gh :e %:h/../inc/%:t:r.h<CR>
" au BufRead,BufNewFile,BufEnter *.h nmap <leader>gh :e %:h/../src/%:t:r.c<CR>
" au BufRead,BufNewFile,BufEnter *.c nmap <leader>ii :e %:h/../inc/%:t:r.h<CR>
" au BufRead,BufNewFile,BufEnter *.h nmap <leader>ii :e %:h/../src/%:t:r.c<CR>

" au BufRead,BufNewFile,BufEnter *.cpp nmap <leader>ih :e %:h/../inc/%:t:r.hpp<CR>
" au BufRead,BufNewFile,BufEnter *.cpp nmap <leader>ic :e %:h/../src/%:t:r.cpp<CR>
" au BufRead,BufNewFile,BufEnter *.cpp nmap <leader>gh :e %:h/../inc/%:t:r.hpp<CR>
" au BufRead,BufNewFile,BufEnter *.hpp nmap <leader>gh :e %:h/../src/%:t:r.cpp<CR>
" au BufRead,BufNewFile,BufEnter *.cpp nmap <leader>ii :e %:h/../inc/%:t:r.hpp<CR>
" au BufRead,BufNewFile,BufEnter *.hpp nmap <leader>ii :e %:h/../src/%:t:r.cpp<CR>

" }}}
" => Misc ------------------------------------------ {{{

" ======================================
" => Omni complete functions
" ======================================
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

" Remove the Windows ^M - when the encodings gets messed up
" noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scribble
" map <leader>q :e ~/buffer<cr>

" Quickly open a markdown buffer for scribble
" map <leader>x :e ~/buffer.md<cr>

" Toggle paste mode on and off
" map <leader>pp :setlocal paste!<cr>

" }}}
" => Section name ---------------------------------- {{{
" ======================================
" => Title
" ======================================
" }}}


" Plug 'godlygeek/tabular' " align stuff... like these vim comments
" Plug 'janko/vim-test'    " run tests inside vim
" Plug 'tpope/vim-rhubarb'    " git(hub) wrapper - open on GitHub
" Plug 'mattn/webapi-vim'
" Plug 'vimwiki/vimwiki'      " my own personal wiki


  """""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Author: Hasan Mahmud                                   "
"  Repo  : https://github.com/hasansujon786/dot-windows/  "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  """"""""""""""""""""""""""""""""""""""""""""""""""""""
