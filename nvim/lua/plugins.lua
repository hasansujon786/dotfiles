-- C:\Users\hasan\AppData\Local\nvim-data\site\pack\packer

return require("packer").startup({
  function(use)
    use 'wbthomason/packer.nvim'
    --> Visual -------------------------------------
    use 'folke/tokyonight.nvim'
    use 'navarasu/onedark.nvim'
    use 'glepnir/dashboard-nvim'
    use 'kyazdani42/nvim-web-devicons'
    use 'junegunn/goyo.vim'
    use 'Yggdroot/indentLine'
    use 'hasansujon786/kissline.nvim'
    use 'hasansujon786/notifier.nvim'

    --> Productiviry -------------------------------
    use 'vimwiki/vimwiki'
    use 'kristijanhusak/orgmode.nvim'
    use 'mkropat/vim-tt'

    --> Navigation ---------------------------------
    use 'ThePrimeagen/harpoon'
    use 'nvim-telescope/telescope.nvim'
    use 'nvim-telescope/telescope-fzy-native.nvim'
    use 'junegunn/fzf.vim'

    use 'lambdalisue/fern-renderer-nerdfont.vim'
    use 'hasansujon786/glyph-palette.vim'
    use 'lambdalisue/nerdfont.vim'
    use 'lambdalisue/fern.vim'

    --> Utils --------------------------------------
    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'tpope/vim-eunuch'
    use 'voldikss/vim-floaterm'
    use 'mg979/vim-visual-multi'
    use 'michaeljsmith/vim-indent-object'
    use 'tweekmonster/startuptime.vim'
    -- " use 'tpope/vim-scriptease'
    use 'hasansujon786/vim-rel-jump'
    use 'dhruvasagar/vim-open-url'
    use 'unblevable/quick-scope'
    use 'tpope/vim-commentary'
    use 'tpope/vim-surround'
    use 'justinmk/vim-sneak'
    use 'Konfekt/vim-CtrlXA'
    use 'tpope/vim-repeat'

    use 'hasansujon786/notifications.vim'
    use 'folke/which-key.nvim'
    use 'folke/neoscroll.nvim'

    --> Git ----------------------------------------
    use 'airblade/vim-gitgutter'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-rhubarb'
    use 'junegunn/gv.vim'
    use 'TimUntersberger/neogit'

    --> Lsp & completions --------------------------
    use 'nvim-treesitter/nvim-treesitter'
    use 'nvim-treesitter/playground'
    use 'JoosepAlviste/nvim-ts-context-commentstring'

    use 'neoclide/coc.nvim'
    use 'honza/vim-snippets'

    use 'gu-fan/colorv.vim'
    use 'mattn/emmet-vim'
    use 'norcalli/nvim-colorizer.lua'
  end,
})
