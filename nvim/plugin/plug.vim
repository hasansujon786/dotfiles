call plug#begin('~/.config/nvim/plugged')

" => Visual-&-Theme ========================================
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'itchyny/lightline.vim'
Plug 'joshdick/onedark.vim'
Plug 'Yggdroot/indentLine'
Plug 'https://github.com/cocopon/iceberg.vim'

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
Plug 'mhinz/vim-startify'
Plug 'Konfekt/FastFold'
Plug 'tpope/vim-repeat'
Plug 'psliwka/vim-smoothie'          " Smooth scroll
Plug 'hasansujon786/vim-rel-jump'
Plug 'mkropat/vim-tt'

Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'lambdalisue/fern-renderer-devicons.vim' " Icon support
Plug 'lambdalisue/fern-git-status.vim'
Plug 'lambdalisue/glyph-palette.vim'    " Add color to icons
Plug 'lambdalisue/fern-bookmark.vim'
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/vim-manpager'

" Plug 'vim-scripts/YankRing.vim', { 'on': 'YRShow' }
" Plug 'vimwiki/vimwiki'             " my own personal wiki
" Plug 'mhinz/vim-grepper'           " Handle multi-file find and replace.
" Plug 'will133/vim-dirdiff'         " Run a diff on 2 directories.
" Plug 'christoomey/vim-tmux-navigator'
" Plug 'shime/vim-livedown', { 'do': 'npm install -g livedown' } " markdown preview
" Plug 'editorconfig/editorconfig-vim'
" Plug 'moll/vim-node'
" Plug 'glts/vim-radical'            " Convert binary, hex, etc..

" => Auto completion ========================================
Plug 'jiangmiao/auto-pairs'
Plug 'honza/vim-snippets'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" => Git ===================================================
Plug 'tpope/vim-fugitive', { 'on': ['Gstatus','Gvdiffsplit'] }
Plug 'tpope/vim-rhubarb', { 'on': 'Gbrowse' }
Plug 'junegunn/gv.vim', { 'on': 'GV' }
Plug 'airblade/vim-gitgutter'

source ~/dotfiles/nvim/plugin/language-support.vim
call plug#end()

source ~/dotfiles/nvim/plugin/quick-scope.vim
source ~/dotfiles/nvim/plugin/quick-scope.vim
source ~/dotfiles/nvim/plugin/onedark.vim
source ~/dotfiles/nvim/plugin/indentLine.vim
source ~/dotfiles/nvim/plugin/lightline.vim
source ~/dotfiles/nvim/plugin/goyo.vim
source ~/dotfiles/nvim/plugin/auto-pairs.vim
source ~/dotfiles/nvim/plugin/fzf.vim
source ~/dotfiles/nvim/plugin/fern.vim
source ~/dotfiles/nvim/plugin/vim-sneak.vim
source ~/dotfiles/nvim/plugin/vim-gitgutter.vim
source ~/dotfiles/nvim/plugin/vim-fugitive.vim
source ~/dotfiles/nvim/plugin/vim-floaterm.vim
source ~/dotfiles/nvim/plugin/vim-visual-multi.vim
source ~/dotfiles/nvim/plugin/coc.vim
source ~/dotfiles/nvim/plugin/tt.vim
" source ~/dotfiles/nvim/plugin/yank-ring.vim

