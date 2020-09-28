call plug#begin('~/.config/plug')

" => Visual-&-Theme ========================================
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'itchyny/lightline.vim'
Plug 'joshdick/onedark.vim'
Plug 'Yggdroot/indentLine'

" => Functionality-&-Helpers ===============================
Plug 'tpope/vim-eunuch', { 'on': ['Delete', 'Move', 'Rename', 'Mkdir'] }  "for moving and manipulating files / directories.
Plug 'voldikss/vim-floaterm', { 'on': [ 'FloatermNew', 'FloatermToggle' ] }
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'michaeljsmith/vim-indent-object'
Plug 'dhruvasagar/vim-open-url'
Plug 'unblevable/quick-scope'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'justinmk/vim-sneak'
Plug 'Konfekt/FastFold'
Plug 'tpope/vim-repeat'
Plug 'psliwka/vim-smoothie'          " Smooth scroll
Plug 'hasansujon786/vim-rel-jump'
Plug 'mkropat/vim-tt'
" Plug 'vimwiki/vimwiki'             " my own personal wiki

Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'lambdalisue/fern-renderer-devicons.vim' " Icon support
Plug 'lambdalisue/fern-git-status.vim'
Plug 'lambdalisue/glyph-palette.vim'    " Add color to icons
Plug 'lambdalisue/fern-bookmark.vim'
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/vim-manpager', {'on': 'Man'}

" => Auto completion ========================================
Plug 'jiangmiao/auto-pairs'
Plug 'honza/vim-snippets'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" => Git ===================================================
Plug 'tpope/vim-fugitive', { 'on': ['Gstatus','Gvdiffsplit'] }
Plug 'tpope/vim-rhubarb', { 'on': 'Gbrowse' }
Plug 'junegunn/gv.vim', { 'on': 'GV' }
Plug 'airblade/vim-gitgutter'

" => Languae-support =======================================
" html & css
Plug 'mattn/emmet-vim'
Plug 'ap/vim-css-color'
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

