-- C:\Users\hasan\AppData\Local\nvim-data\site\pack\packer

return require("packer").startup({
  function(use)
    use({ 'wbthomason/packer.nvim' })
    --> Visual -------------------------------------
    use({ 'navarasu/onedark.nvim' })
    use({ 'glepnir/dashboard-nvim' })
    use({ 'kyazdani42/nvim-web-devicons' })
    use({ 'junegunn/goyo.vim', opt = true, cmd = 'Goyo', })
    use({ 'Yggdroot/indentLine', opt = true, event = 'BufRead' })
    use({ 'hasansujon786/kissline.nvim' })
    use({ 'hasansujon786/notifier.nvim', opt = true, event = 'BufRead' })
    -- use({ 'folke/tokyonight.nvim' })

    --> Productiviry -------------------------------
    use({ 'vimwiki/vimwiki', opt = true, cmd = {'VimwikiIndex','VimwikiTabIndex','VimwikiUISelect'} })
    use({ 'kristijanhusak/orgmode.nvim', opt = true, event = 'BufRead', config = function() require('config.orgmode') end })
    use({ 'mkropat/vim-tt', opt = true, event = 'BufRead' })

    --> Navigation ---------------------------------
    use({ 'ThePrimeagen/harpoon', opt = true, event = 'VimEnter' })
    use({ 'nvim-telescope/telescope.nvim', config = function() require('config.telescope') end })
    use({ 'nvim-telescope/telescope-fzy-native.nvim' })
    use({ 'junegunn/fzf.vim' })

    use({ 'lambdalisue/fern-renderer-nerdfont.vim' })
    use({ 'hasansujon786/glyph-palette.vim' })
    use({ 'lambdalisue/nerdfont.vim' })
    use({ 'lambdalisue/fern.vim' })

    --> Utils --------------------------------------
    use({ 'nvim-lua/popup.nvim' })
    use({ 'nvim-lua/plenary.nvim' })
    use({ 'tpope/vim-eunuch', opt = true, cmd = {'Delete','Move','Rename','Mkdir','Chmod'} })
    use({ 'voldikss/vim-floaterm', opt = true, cmd = {'FloatermNew','FloatermToggle'} })
    use({ 'mg979/vim-visual-multi', opt = true, event = 'BufRead' })
    use({ 'michaeljsmith/vim-indent-object', opt = true, event = 'BufRead' })
    use({ 'tweekmonster/startuptime.vim', opt = true, cmd = 'StartupTime' })
    -- " use 'tpope/vim-scriptease'
    use({ 'hasansujon786/vim-rel-jump', opt = true, event = 'BufRead' })
    use({ 'dhruvasagar/vim-open-url', opt = true, event = 'BufRead' })
    use({ 'unblevable/quick-scope', opt = true, event = 'BufRead' })
    use({ 'tpope/vim-commentary', opt = true, event = 'BufRead' })
    use({ 'tpope/vim-surround', opt = true, event = 'BufRead' })
    use({ 'justinmk/vim-sneak', opt = true, event = 'BufRead' })
    use({ 'tpope/vim-repeat', opt = true, event = 'BufRead' })
    use({ 'monaqa/dial.nvim', opt = true, event = 'BufRead', config = function() require('dial').config() end })
    use({ 'folke/which-key.nvim', config = function() require('config.whichkey') end })
    use({ 'folke/neoscroll.nvim', opt = true, event = 'VimEnter', config = function() require('config.neoscroll') end })

    --> Git ----------------------------------------
    use({ 'airblade/vim-gitgutter', opt = true, event = 'BufRead' })
    use({ 'tpope/vim-fugitive', opt = true, cmd = 'Git' })
    use({ 'tpope/vim-rhubarb', opt = true, cmd = 'Git'  })
    use({ 'junegunn/gv.vim', opt = true, cmd = 'GV' })
    use({ 'TimUntersberger/neogit', opt = true, cmd = 'Neogit' })

    --> Lsp & completions --------------------------
    use({ 'nvim-treesitter/nvim-treesitter', config = function() require('config.treesitter') end })
    use({ 'nvim-treesitter/playground', opt = true, cmd = {'TSPlaygroundToggle','TSHighlightCapturesUnderCursor'} })
    use({ 'JoosepAlviste/nvim-ts-context-commentstring', opt = true, event = 'BufRead'  })

    use({ 'neoclide/coc.nvim', opt = true, event = 'BufRead' })
    use({ 'honza/vim-snippets', opt = true, event = 'InsertEnter'})

    use({ 'gu-fan/colorv.vim', opt = true, cmd = 'ColorV' })
    use({ 'mattn/emmet-vim', opt = true, event = 'BufRead' })
    use({ 'norcalli/nvim-colorizer.lua', opt = true, event = 'BufRead',
      config = function ()
        require('colorizer').setup()
        vim.cmd('ColorizerReloadAllBuffers')
      end
    })
  end,
})
