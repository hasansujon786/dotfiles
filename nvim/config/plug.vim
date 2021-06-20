call plug#begin('~/dotfiles/nvim/plugged')

" => Visual-&-Theme ======================================== {{{
" Plug 'joshdick/onedark.vim'
" Plug 'christianchiarulli/nvcode-color-schemes.vim'
Plug 'navarasu/onedark.nvim'
Plug 'glepnir/dashboard-nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'junegunn/goyo.vim',{ 'on': 'Goyo' }
Plug 'Yggdroot/indentLine',{ 'on': 'CocStart' }
Plug 'hasansujon786/kissline.nvim', { 'dir': '~/kissline.nvim' }
" }}}

" => Productivity ========================================== {{{
Plug 'vimwiki/vimwiki',{ 'branch': 'dev', 'on': ['VimwikiIndex', 'VimwikiTabIndex', 'VimwikiUISelect', 'VimwikiDiaryIndex', 'VimwikiMakeDiaryNote','VimwikiTabMakeDiaryNote'] }
Plug 'dhruvasagar/vim-dotoo',{ 'on': 'CocStart' }
Plug 'tools-life/taskwiki'
Plug 'mkropat/vim-tt'
" }}}

" => Navigation ============================================ {{{
Plug 'ThePrimeagen/harpoon'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-project.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
" }}}

" => Functionality-&-Helpers =============================== {{{
Plug 'tpope/vim-eunuch',{ 'on': ['Delete','Move','Rename','Mkdir','Chmod'] } "for moving and manipulating files / directories.
Plug 'voldikss/vim-floaterm',{ 'on': [ 'FloatermNew', 'FloatermToggle' ] }
Plug 'mg979/vim-visual-multi',{'branch': 'master', 'on': 'CocStart' }
Plug 'michaeljsmith/vim-indent-object',{ 'on': 'CocStart' }
Plug 'tweekmonster/startuptime.vim',{ 'on': 'StartupTime' }
Plug 'tpope/vim-scriptease',{ 'on': ['Messages', 'PP'] }
Plug 'hasansujon786/vim-rel-jump',{ 'on': 'CocStart' }
Plug 'dhruvasagar/vim-open-url',{ 'on': 'CocStart' }
Plug 'unblevable/quick-scope',{ 'on': 'CocStart' }
Plug 'tpope/vim-commentary',{ 'on': 'CocStart' }
Plug 'tpope/vim-surround',{ 'on': 'CocStart' }
Plug 'justinmk/vim-sneak',{ 'on': 'CocStart' }
Plug 'Konfekt/vim-CtrlXA',{ 'on': 'CocStart' }
Plug 'Konfekt/FastFold',{ 'on': 'CocStart' }
Plug 'tpope/vim-repeat',{ 'on': 'CocStart' }

Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'hasansujon786/notifications.vim'
Plug 'liuchengxu/vim-which-key'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

" Plug 'lambdalisue/fern-git-status.vim',{ 'on': ['Fern']}
Plug 'lambdalisue/fern-renderer-nerdfont.vim',{ 'on': ['Fern']}
Plug 'hasansujon786/glyph-palette.vim',{ 'on': ['Fern']}
Plug 'lambdalisue/nerdfont.vim',{ 'on': ['Fern']}
Plug 'lambdalisue/fern.vim',{ 'on': ['Fern']}
" Plug 'lambdalisue/glyph-palette.vim'
" Plug 'lambdalisue/fern-bookmark.vim'
" Plug 'lambdalisue/vim-manpager',{'on': 'Man'}

" }}}

" => Git =================================================== {{{
Plug 'airblade/vim-gitgutter',{ 'on': 'CocStart' }
Plug 'tpope/vim-fugitive',{ 'on': 'CocStart' }
Plug 'tpope/vim-rhubarb',{ 'on': 'CocStart' }
Plug 'junegunn/gv.vim',{ 'on': 'CocStart' }
" }}}

" => Languae-support ======================================= {{{
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/playground', { 'on': ['TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor']}

" Auto Completion
Plug 'neoclide/coc.nvim',{'branch': 'release', 'on': 'CocStart' }
Plug 'honza/vim-snippets',{ 'on': 'CocStart' }

" html & css
Plug 'gu-fan/colorv.vim',{ 'on': ['ColorV','ColorVEditTo','ColorVEdit','ColorVPreviewLine','ColorVPreview'] }
Plug 'mattn/emmet-vim',{ 'on': 'CocStart' }
Plug 'ap/vim-css-color',{ 'on': 'CocStart' }
" Plug 'norcalli/nvim-colorizer.lua'

" javascript
" Plug 'sheerun/vim-polyglot',{ 'on': 'CocStart' }    " Full lang support
" Plug 'jparise/vim-graphql'
Plug 'leafOfTree/vim-vue-plugin',{ 'on': 'CocStart' }
" }}}

" Plug 'https://github.com/winston0410/mark-radar.nvim'
" Plug 'folke/which-key.nvim'
" Plug 'https://github.com/McAuleyPenney/mark-radar.nvim'
Plug 'TimUntersberger/neogit', { 'on': 'Neogit' }
call plug#end()

