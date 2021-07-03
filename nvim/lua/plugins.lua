-- C:\Users\hasan\AppData\Local\nvim-data\site\pack\packer

return require("packer").startup({
  function(use)
    use({ 'wbthomason/packer.nvim' })
    --> Visual -------------------------------------
    use({ 'folke/tokyonight.nvim' })
    use({ 'navarasu/onedark.nvim' })
    use({ 'glepnir/dashboard-nvim' })
    use({ 'kyazdani42/nvim-web-devicons' })
    use({ 'junegunn/goyo.vim', opt = true, cmd = 'Goyo', })
    use({ 'Yggdroot/indentLine', opt = true, event = 'BufRead' })
    use({ 'hasansujon786/kissline.nvim' })
    use({ 'hasansujon786/notifier.nvim', opt = true, event = 'BufRead' })

    --> Productiviry -------------------------------
    use({ 'vimwiki/vimwiki', opt = true, cmd = {'VimwikiIndex','VimwikiTabIndex','VimwikiUISelect','VimwikiDiaryIndex','VimwikiMakeDiaryNote','VimwikiTabMakeDiaryNote'} })
    use({ 'kristijanhusak/orgmode.nvim', opt = true, event = 'BufRead',
      config = function()
        require('plugin.orgmode')
      end
    })
    use({ 'mkropat/vim-tt' })

    --> Navigation ---------------------------------
    use({ 'ThePrimeagen/harpoon', opt = true, event = 'VimEnter' })
    use({ 'nvim-telescope/telescope.nvim' })
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
    use({ 'tweekmonster/startuptime.vim' })
    -- " use 'tpope/vim-scriptease'
    use({ 'hasansujon786/vim-rel-jump', opt = true, event = 'BufRead' })
    use({ 'dhruvasagar/vim-open-url', opt = true, event = 'BufRead' })
    use({ 'unblevable/quick-scope', opt = true, event = 'BufRead' })
    use({ 'tpope/vim-commentary', opt = true, event = 'BufRead' })
    use({ 'tpope/vim-surround', opt = true, event = 'BufRead' })
    use({ 'justinmk/vim-sneak', opt = true, event = 'BufRead' })
    use({ 'Konfekt/vim-CtrlXA', opt = true, event = 'BufRead' })
    use({ 'tpope/vim-repeat', opt = true, event = 'BufRead' })

    use({ 'folke/which-key.nvim' })
    use({ 'folke/neoscroll.nvim', opt = true,
      -- event = 'VimEnter',
      event = 'CursorHold',
      config = function()
        require('plugin.neoscroll')
      end,
    })

    --> Git ----------------------------------------
    use({ 'airblade/vim-gitgutter', opt = true, event = 'BufRead' })
    use({ 'tpope/vim-fugitive', opt = true, cmd = 'Git' })
    use({ 'tpope/vim-rhubarb', opt = true, cmd = 'Git'  })
    use({ 'junegunn/gv.vim', opt = true, cmd = 'GV' })
    use({ 'TimUntersberger/neogit', opt = true, cmd = 'Neogit' })

    --> Lsp & completions --------------------------
    use({ 'nvim-treesitter/nvim-treesitter' })
    use({ 'nvim-treesitter/playground', opt = true, cmd = {'TSPlaygroundToggle','TSHighlightCapturesUnderCursor'} })
    use({ 'JoosepAlviste/nvim-ts-context-commentstring' })

    use({ 'neoclide/coc.nvim', opt = true, event = 'BufRead' })
    use({ 'honza/vim-snippets', opt = true, event = 'InsertEnter'})

    use({ 'gu-fan/colorv.vim', opt = true, cmd = 'ColorV' })
    use({ 'mattn/emmet-vim', opt = true, event = 'BufRead' })
    use({ 'norcalli/nvim-colorizer.lua', opt = true, event = 'BufRead',
      config = function ()
        require('colorizer').setup()
      end
    })
  end,
})
