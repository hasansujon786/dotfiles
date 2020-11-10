call plug#begin('~/dotfiles/nvim/plugged')

" => Visual-&-Theme ========================================
Plug 'junegunn/goyo.vim',{ 'on': 'Goyo' }
Plug 'itchyny/lightline.vim'
Plug 'joshdick/onedark.vim'
Plug 'Yggdroot/indentLine'

" => Functionality-&-Helpers ===============================
Plug 'vimwiki/vimwiki',{ 'on': ['VimwikiIndex', 'VimwikiTabIndex', 'VimwikiUISelect', 'VimwikiDiaryIndex', 'VimwikiMakeDiaryNote','VimwikiTabMakeDiaryNote'] }
Plug 'tpope/vim-eunuch',{ 'on': ['Delete','Move','Rename','Mkdir','Chmod'] } "for moving and manipulating files / directories.
Plug 'voldikss/vim-floaterm',{ 'on': [ 'FloatermNew', 'FloatermToggle' ] }
Plug 'mg979/vim-visual-multi',{'branch': 'master', 'on': 'CocStart' }
Plug 'amadeus/vim-convert-color-to',{ 'on': 'ConvertColorTo' }
Plug 'michaeljsmith/vim-indent-object',{ 'on': 'CocStart' }
Plug 'hasansujon786/vim-rel-jump',{ 'on': 'CocStart' }
Plug 'dhruvasagar/vim-open-url',{ 'on': 'CocStart' }
Plug 'unblevable/quick-scope',{ 'on': 'CocStart' }
Plug 'psliwka/vim-smoothie',{ 'on': 'CocStart' }          " Smooth scroll
Plug 'tpope/vim-commentary',{ 'on': 'CocStart' }
Plug 'tpope/vim-surround',{ 'on': 'CocStart' }
Plug 'justinmk/vim-sneak',{ 'on': 'CocStart' }
Plug 'Konfekt/FastFold',{ 'on': 'CocStart' }
Plug 'tpope/vim-repeat',{ 'on': 'CocStart' }
Plug 'wsdjeg/vim-todo',{ 'on': 'OpenTodo' }

Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'liuchengxu/vim-which-key'
Plug 'Konfekt/vim-CtrlXA'
Plug 'mkropat/vim-tt'

Plug 'junegunn/fzf',{ 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/fern-bookmark.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
Plug 'lambdalisue/fern-git-status.vim'
" Plug 'lambdalisue/glyph-palette.vim'
Plug 'hasansujon786/glyph-palette.vim'
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/vim-manpager',{'on': 'Man'}

" => Auto completion ========================================
Plug 'neoclide/coc.nvim',{'branch': 'release', 'on': 'CocStart' }
Plug 'jiangmiao/auto-pairs',{ 'on': 'CocStart' }
Plug 'honza/vim-snippets',{ 'on': 'CocStart' }

" => Git ===================================================
Plug 'airblade/vim-gitgutter',{ 'on': 'CocStart' }
Plug 'tpope/vim-fugitive',{ 'on': 'CocStart' }
Plug 'tpope/vim-rhubarb',{ 'on': 'CocStart' }
Plug 'junegunn/gv.vim',{ 'on': 'CocStart' }

" => Languae-support =======================================
" html & css
Plug 'mattn/emmet-vim',{ 'on': 'CocStart' }
Plug 'ap/vim-css-color',{ 'on': 'CocStart' }
" Plug 'norcalli/nvim-colorizer.lua'

" javascript
Plug 'sheerun/vim-polyglot',{ 'on': 'CocStart' }    " Full lang support
" Plug 'jparise/vim-graphql'


" => Not-listed ============================================
" Plug 'shime/vim-livedown', { 'do': 'npm install -g livedown' } " markdown preview
" Plug 'glts/vim-radical'            " Convert binary, hex, etc..
" Plug 'editorconfig/editorconfig-vim'

" Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }   " css color
" Plug 'dragvisuals.vim'
" Plug 'vmath.vim'
call plug#end()

source ~/dotfiles/nvim/config/quick-scope.vim
source ~/dotfiles/nvim/config/onedark.vim
source ~/dotfiles/nvim/config/indentLine.vim
source ~/dotfiles/nvim/config/lightline.vim
source ~/dotfiles/nvim/config/goyo.vim
source ~/dotfiles/nvim/config/auto-pairs.vim
source ~/dotfiles/nvim/config/fzf.vim
source ~/dotfiles/nvim/config/fern.vim
source ~/dotfiles/nvim/config/vim-sneak.vim
source ~/dotfiles/nvim/config/vim-gitgutter.vim
source ~/dotfiles/nvim/config/vim-fugitive.vim
source ~/dotfiles/nvim/config/vim-floaterm.vim
source ~/dotfiles/nvim/config/vim-visual-multi.vim
source ~/dotfiles/nvim/config/coc.vim
source ~/dotfiles/nvim/config/tt.vim
source ~/dotfiles/nvim/config/hlnext.vim
source ~/dotfiles/nvim/config/vim-wiki.vim
source ~/dotfiles/nvim/config/vimuxline.vim

" Plug 'xolox/vim-session'
" https://github.com/fannheyward/coc-react-refactor
" https://github.com/romgrk/todoist.nvim
" https://github.com/luochen1990/indent-detector.vim
" Plug 'romgrk/github-light.vim'
" Plug 'romgrk/doom-one.vim'
" Plug 'https://github.com/vim-scripts/PickAColor.vim'
" Plug 'https://github.com/tpope/vim-scriptease'
" Plug 'https://github.com/arp242/undofile_warn.vim'
" Plug 'https://github.com/guns/xterm-color-table.vim'
" https://vimawesome.com/plugin/vim-colors-solarized-ours
