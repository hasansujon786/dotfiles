-- C:\Users\hasan\AppData\Local\nvim-data\site\pack\packer
vim.g.disable_lsp = false
vim.g.disable_coc = true

return require('packer').startup({
  function(use)
    use({ 'wbthomason/packer.nvim' })
    --> Visual -------------------------------------
    use({ 'navarasu/onedark.nvim', config = function() require('config.onedark') end })
    use({ 'glepnir/dashboard-nvim', config = function() require('config.dashboard') end })
    use({ 'kyazdani42/nvim-web-devicons' })
    use({ 'hasansujon786/kissline.nvim' })
    use({ 'hasansujon786/notifier.nvim' })
    use({ 'hasansujon786/telescope-yanklist.nvim' })
    use({ 'folke/zen-mode.nvim', opt = true, cmd = 'ZenMode',
      config = function() require('config.zen') end
    })
    use({ 'Yggdroot/indentLine', opt = true, event = 'BufRead',
      config = function() require('config.indentLine') end
    })
    -- use({ 'folke/tokyonight.nvim' })
    -- use({'projekt0n/github-nvim-theme'})

    --> Productiviry -------------------------------
    use({ 'vimwiki/vimwiki', opt = true, cmd = {'VimwikiIndex','VimwikiTabIndex','VimwikiUISelect'} })
    use({ 'kristijanhusak/orgmode.nvim', opt = true, event = 'BufRead', config = function() require('config.orgmode') end })
    use({ 'mkropat/vim-tt', opt = true, event = 'CursorHold',
      config = function ()
        vim.g.tt_loaded = 1
        vim.cmd 'source ~/dotfiles/nvim/autoload/hasan/tt.vim'
      end
    })

    --> Navigation ---------------------------------
    use({ 'ahmedkhalf/project.nvim', opt = true, event = 'VimEnter',
      config = function()
        require('config.project')
      end
    })
    use({ 'ThePrimeagen/harpoon', opt = true, event = 'VimEnter' })
    use({ 'nvim-telescope/telescope.nvim', config = function() require('config.telescope') end })
    use({ 'nvim-telescope/telescope-fzy-native.nvim' })

    use({ 'lambdalisue/fern-renderer-nerdfont.vim' })
    use({ 'hasansujon786/glyph-palette.vim' })
    use({ 'lambdalisue/nerdfont.vim' })
    use({ 'lambdalisue/fern.vim', config = function() require('config.fern') end })

    --> Utils --------------------------------------
    use({ 'nvim-lua/popup.nvim' })
    use({ 'nvim-lua/plenary.nvim' })
    use({ 'tpope/vim-eunuch', opt = true, cmd = {'Delete','Move','Rename','Mkdir','Chmod'} })
    use({ 'voldikss/vim-floaterm', opt = true,
      cmd = {'FloatermNew','FloatermToggle'},
      config = function() require('config.floaterm') end
    })
    use({ 'mg979/vim-visual-multi', opt = true, event = 'BufRead' })
    use({ 'michaeljsmith/vim-indent-object', opt = true, event = 'BufRead' })
    use({ 'tweekmonster/startuptime.vim', opt = true, cmd = 'StartupTime' })
    -- use 'tpope/vim-scriptease'
    use({ 'hasansujon786/vim-rel-jump', opt = true, event = 'BufRead' })
    use({ 'dhruvasagar/vim-open-url', opt = true, event = 'BufRead' })
    use({ 'unblevable/quick-scope', opt = true, event = 'BufReadPost'})
    use({ 'tpope/vim-commentary', opt = true, event = 'BufRead' })
    use({ 'tpope/vim-surround', opt = true, event = 'BufRead',  })
    use({ 'justinmk/vim-sneak', opt = true, event = 'BufRead',
      after = 'vim-surround',
      config = function()
        require('config.sneak')
      end
    })
    use({ 'Konfekt/vim-CtrlXA', opt = true, event = 'BufRead' })
    use({ 'tpope/vim-repeat', opt = true, event = 'BufRead' })
    use({ 'folke/which-key.nvim', config = function() require('config.whichkey') end })
    use({ 'karb94/neoscroll.nvim', opt = true, event = 'BufRead',
      disable = true,
      config = function()
        require('config.neoscroll')
      end
    })

    --> Git ----------------------------------------
    use({ 'tpope/vim-fugitive', opt = true, cmd = {'Git','GBrowse','GV'}})
    use({ 'tpope/vim-rhubarb', opt = true, after = 'vim-fugitive'})
    use({ 'junegunn/gv.vim', opt = true, after = 'vim-fugitive' })
    use({ 'TimUntersberger/neogit', opt = true, cmd = 'Neogit' })
    use({ 'lewis6991/gitsigns.nvim',
      opt = true, event = 'BufRead',
      config = function()
        require('config.gitsigns')
      end
    })
    -- use({'ruifm/gitlinker.nvim'})
    -- ues({'tanvirtin/vgit.nvim'})

    --> Lsp & completions --------------------------
    use({ 'neoclide/coc.nvim',
      opt = true, event = 'BufRead',
      disable = vim.g.disable_coc,
      config = function ()
        vim.cmd 'source ~/dotfiles/nvim/config/coc.vim'
      end
    })
    use({ 'nvim-treesitter/nvim-treesitter', config = function() require('config.treesitter') end })
    use({ 'nvim-treesitter/playground', opt = true, cmd = {'TSPlaygroundToggle','TSHighlightCapturesUnderCursor'} })
    use({ 'JoosepAlviste/nvim-ts-context-commentstring', opt = true, event = 'BufRead'  })
    use({ 'nvim-treesitter/nvim-treesitter-textobjects' })

    use({ 'gu-fan/colorv.vim', opt = true, cmd = 'ColorV' })
    use({ 'mattn/emmet-vim', opt = true, event = 'BufRead',
      config = function()
        require('config.emmet')
      end
    })
    use({ 'norcalli/nvim-colorizer.lua',
      opt = true, event = 'BufRead',
      config = function()
        require('config.colorizer')
      end
    })

    use({ 'neovim/nvim-lspconfig',
      opt = true, event = 'CursorHold',
      disable = vim.g.disable_lsp,
      config = function()
        require('lsp')
        require('lsp.tailwindcss-ls')
        require('lsp.sumneko_lua')
      end
    })
    use({ 'hrsh7th/nvim-compe',
      opt = true, event = 'InsertEnter',
      disable = vim.g.disable_lsp,
      config = function()
        require('config.compe')
      end
    })
    use({ 'windwp/nvim-autopairs',
      opt = true, event = 'InsertEnter',
      disable = vim.g.disable_lsp,
      config = function()
        require('config.autopairs')
      end
    })
    use({ 'windwp/nvim-ts-autotag',
      opt = true, after = 'nvim-autopairs',
      disable = vim.g.disable_lsp,
    })
    use({ 'hrsh7th/vim-vsnip',
      opt = true, event = 'InsertCharPre',
      disable = vim.g.disable_lsp,
    })
    use({ 'rafamadriz/friendly-snippets',
      opt = true, event = 'InsertCharPre'
    })

  end,
})
