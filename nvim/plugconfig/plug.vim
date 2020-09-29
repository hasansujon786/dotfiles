call plug#begin('~/.config/plug')

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
" Plug 'vimwiki/vimwiki'             " my own personal wiki

Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'lambdalisue/fern-renderer-devicons.vim',{ 'on': 'Fern' } " Icon support
Plug 'lambdalisue/fern-git-status.vim',{ 'on': 'Fern' }
Plug 'lambdalisue/glyph-palette.vim',{ 'on': 'Fern' }     " Add color to icons
Plug 'lambdalisue/fern-bookmark.vim',{ 'on': 'Fern' }
Plug 'lambdalisue/fern.vim',{ 'on': 'Fern' }
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

source ~/dotfiles/nvim/plugconfig/quick-scope.vim
source ~/dotfiles/nvim/plugconfig/onedark.vim
source ~/dotfiles/nvim/plugconfig/indentLine.vim
source ~/dotfiles/nvim/plugconfig/lightline.vim
source ~/dotfiles/nvim/plugconfig/goyo.vim
source ~/dotfiles/nvim/plugconfig/auto-pairs.vim
source ~/dotfiles/nvim/plugconfig/fzf.vim
source ~/dotfiles/nvim/plugconfig/fern.vim
source ~/dotfiles/nvim/plugconfig/vim-sneak.vim
source ~/dotfiles/nvim/plugconfig/vim-gitgutter.vim
source ~/dotfiles/nvim/plugconfig/vim-fugitive.vim
source ~/dotfiles/nvim/plugconfig/vim-floaterm.vim
source ~/dotfiles/nvim/plugconfig/vim-visual-multi.vim
source ~/dotfiles/nvim/plugconfig/coc.vim
source ~/dotfiles/nvim/plugconfig/tt.vim
source ~/dotfiles/nvim/plugconfig/hlnext.vim

