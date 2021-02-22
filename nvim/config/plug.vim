call plug#begin('~/dotfiles/nvim/plugged')

" => Visual-&-Theme ======================================== {{{
Plug 'junegunn/goyo.vim',{ 'on': 'Goyo' }
Plug 'joshdick/onedark.vim'
Plug 'Yggdroot/indentLine'
" }}}

" => Productivity ========================================== {{{
Plug 'vimwiki/vimwiki',{ 'branch': 'dev', 'on': ['VimwikiIndex', 'VimwikiTabIndex', 'VimwikiUISelect', 'VimwikiDiaryIndex', 'VimwikiMakeDiaryNote','VimwikiTabMakeDiaryNote'] }
Plug 'dhruvasagar/vim-dotoo',{ 'on': 'CocStart' }
Plug 'wsdjeg/vim-todo',{ 'on': 'OpenTodo' }
Plug 'tools-life/taskwiki'
Plug 'mkropat/vim-tt'
" }}}

" => Functionality-&-Helpers =============================== {{{
Plug 'tpope/vim-eunuch',{ 'on': ['Delete','Move','Rename','Mkdir','Chmod'] } "for moving and manipulating files / directories.
Plug 'voldikss/vim-floaterm',{ 'on': [ 'FloatermNew', 'FloatermToggle' ] }
Plug 'mg979/vim-visual-multi',{'branch': 'master', 'on': 'CocStart' }
Plug 'amadeus/vim-convert-color-to',{ 'on': 'ConvertColorTo' }
Plug 'michaeljsmith/vim-indent-object',{ 'on': 'CocStart' }
Plug 'tweekmonster/startuptime.vim',{ 'on': 'StartupTime' }
Plug 'tpope/vim-scriptease',{ 'on': ['Messages', 'PP'] }
Plug 'hasansujon786/vim-rel-jump',{ 'on': 'CocStart' }
Plug 'dhruvasagar/vim-open-url',{ 'on': 'CocStart' }
Plug 'unblevable/quick-scope',{ 'on': 'CocStart' }
Plug 'tpope/vim-commentary',{ 'on': 'CocStart' }
Plug 'tpope/vim-surround',{ 'on': 'CocStart' }
Plug 'justinmk/vim-sneak',{ 'on': 'CocStart' }
Plug 'Konfekt/FastFold',{ 'on': 'CocStart' }
Plug 'tpope/vim-repeat',{ 'on': 'CocStart' }

Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'hasansujon786/notifications.vim'
Plug 'liuchengxu/vim-which-key'
Plug 'Konfekt/vim-CtrlXA'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
Plug 'lambdalisue/fern-git-status.vim'
Plug 'hasansujon786/glyph-palette.vim'
Plug 'lambdalisue/fern.vim'
" Plug 'lambdalisue/glyph-palette.vim'
" Plug 'lambdalisue/fern-bookmark.vim'
Plug 'lambdalisue/vim-manpager',{'on': 'Man'}
" }}}

" => Git =================================================== {{{
Plug 'airblade/vim-gitgutter',{ 'on': 'CocStart' }
Plug 'tpope/vim-fugitive',{ 'on': 'CocStart' }
Plug 'tpope/vim-rhubarb',{ 'on': 'CocStart' }
Plug 'junegunn/gv.vim',{ 'on': 'CocStart' }
" }}}

" => Languae-support ======================================= {{{
" Auto Completion
Plug 'neoclide/coc.nvim',{'branch': 'release', 'on': 'CocStart' }
Plug 'jiangmiao/auto-pairs',{ 'on': 'CocStart' }
Plug 'honza/vim-snippets',{ 'on': 'CocStart' }

" html & css
Plug 'mattn/emmet-vim',{ 'on': 'CocStart' }
Plug 'ap/vim-css-color',{ 'on': 'CocStart' }
" Plug 'norcalli/nvim-colorizer.lua'

" javascript
Plug 'sheerun/vim-polyglot',{ 'on': 'CocStart' }    " Full lang support
" Plug 'jparise/vim-graphql'
Plug 'leafOfTree/vim-vue-plugin',{ 'on': 'CocStart' }
" }}}

" => Not-listed ============================================ {{{
" Plug 'shime/vim-livedown', { 'do': 'npm install -g livedown' } " markdown preview
" Plug 'glts/vim-radical'            " Convert binary, hex, etc..
" Plug 'editorconfig/editorconfig-vim'
" https://github.com/TimUntersberger/neogit

" Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }   " css color
" Plug 'dragvisuals.vim'
" Plug 'vmath.vim'
" }}}
call plug#end()

" Plug 'xolox/vim-session'
" Plug 'romgrk/github-light.vim'
" Plug 'romgrk/doom-one.vim'
" Plug 'https://github.com/arp242/undofile_warn.vim'
" Plug 'https://github.com/guns/xterm-color-table.vim'
" Plug 'https://github.com/luochen1990/indent-detector.vim'
" Plug 'https://github.com/xuxinx/vim-tabline'
" Plug 'https://github.com/pacha/vem-tabline'

" 0.5
" Plug 'https://github.com/ChristianChiarulli/nvcode-color-schemes.vim'
" Plug 'nvim-treesitter/nvim-treesitter'
