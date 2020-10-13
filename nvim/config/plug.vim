call plug#begin('~/dotfiles/nvim/plugged')

" => Visual-&-Theme ========================================
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'itchyny/lightline.vim'
Plug 'joshdick/onedark.vim'
Plug 'Yggdroot/indentLine',{ 'on': 'CocStart' }

" => Functionality-&-Helpers ===============================
Plug 'tpope/vim-eunuch', { 'on': ['Delete', 'Move', 'Rename', 'Mkdir'] }  "for moving and manipulating files / directories.
Plug 'voldikss/vim-floaterm', { 'on': [ 'FloatermNew', 'FloatermToggle' ] }
Plug 'mg979/vim-visual-multi', {'branch': 'master', 'on': 'CocStart' }
Plug 'michaeljsmith/vim-indent-object',{ 'on': 'CocStart' }
Plug 'dhruvasagar/vim-open-url',{ 'on': 'CocStart' }
Plug 'unblevable/quick-scope',{ 'on': 'CocStart' }
Plug 'tpope/vim-commentary',{ 'on': 'CocStart' }
Plug 'tpope/vim-surround',{ 'on': 'CocStart' }
Plug 'justinmk/vim-sneak',{ 'on': 'CocStart' }
Plug 'Konfekt/FastFold',{ 'on': 'CocStart' }
Plug 'tpope/vim-repeat',{ 'on': 'CocStart' }
Plug 'psliwka/vim-smoothie',{ 'on': 'CocStart' }          " Smooth scroll
Plug 'hasansujon786/vim-rel-jump',{ 'on': 'CocStart' }
Plug 'mkropat/vim-tt'
Plug 'liuchengxu/vim-which-key'
Plug 'vimwiki/vimwiki',{ 'on': ['VimwikiIndex', 'VimwikiTabIndex', 'VimwikiDiaryIndex'] }

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/fern-bookmark.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
Plug 'lambdalisue/fern-git-status.vim'
Plug 'lambdalisue/glyph-palette.vim'
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/vim-manpager', {'on': 'Man'}

" => Auto completion ========================================
Plug 'jiangmiao/auto-pairs',{ 'on': 'CocStart' }
Plug 'honza/vim-snippets',{ 'on': 'CocStart' }
Plug 'neoclide/coc.nvim', {'branch': 'release', 'on': 'CocStart' }

" => Git ===================================================
Plug 'tpope/vim-fugitive', { 'on': ['Gstatus','Gvdiffsplit'] }
Plug 'tpope/vim-rhubarb', { 'on': 'Gbrowse' }
Plug 'junegunn/gv.vim', { 'on': 'GV' }
Plug 'airblade/vim-gitgutter',{ 'on': 'CocStart' }

" => Languae-support =======================================
" html & css
Plug 'mattn/emmet-vim',{ 'on': 'CocStart' }
Plug 'ap/vim-css-color',{ 'on': 'CocStart' }
" Plug 'norcalli/nvim-colorizer.lua'

" javascript
Plug 'sheerun/vim-polyglot'     " Full lang support
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

