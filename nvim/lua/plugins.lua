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
    use({ 'norcalli/nvim-colorizer.lua', opt = true, event = 'CursorHold',
      config = function() require('config.colorizer') end
    })
    -- use({ 'folke/tokyonight.nvim' })
    -- use({'projekt0n/github-nvim-theme'})

    --> Productiviry -------------------------------
    use({ 'vimwiki/vimwiki', opt = true, cmd = {'VimwikiIndex','VimwikiTabIndex','VimwikiUISelect'} })
    use({ 'kristijanhusak/orgmode.nvim', opt = true, ft = {'org'},
      config = function() require('config.orgmode') end
    })
    use({ 'mkropat/vim-tt', opt = true, event = 'CursorHold',
      config = function ()
        vim.g.tt_loaded = 1
        vim.cmd 'source ~/dotfiles/nvim/autoload/hasan/tt.vim'
      end
    })

    --> Navigation ---------------------------------
    use({'kevinhwang91/nvim-bqf', opt = true, ft = {'qf'}})
    use({ 'ahmedkhalf/project.nvim', opt = true, event = 'VimEnter',
      config = function()
        require('config.project')
      end
    })
    use({ 'ThePrimeagen/harpoon', opt = true, event = 'VimEnter' })
    use({ 'nvim-telescope/telescope.nvim', config = function() require('config.telescope') end })
    use({ 'nvim-telescope/telescope-fzy-native.nvim' })

    use({ 'lambdalisue/fern.vim',
      config = function() require('config.fern') end,
      requires = {
        'lambdalisue/fern-renderer-nerdfont.vim',
        'hasansujon786/glyph-palette.vim',
        'lambdalisue/nerdfont.vim'
      }
    })

    use({ 'unblevable/quick-scope', opt = true, event = 'CursorHold'})
    use({ 'justinmk/vim-sneak', opt = true, event = 'CursorHold',
      after = 'vim-surround',
      config = function()
        require('config.sneak')
      end
    })

    --> Utils --------------------------------------
    use({ 'mg979/vim-visual-multi', opt = true, event = 'CursorHold' })
    use({ 'arthurxavierx/vim-caser', opt = true, event = 'CursorHold' })
    use({ 'NTBBloodbath/color-converter.nvim', opt = true, event = 'CursorHold' })
    use({ 'Konfekt/vim-CtrlXA', opt = true, event = 'CursorHold' })
    use({ 'tpope/vim-commentary', opt = true, event = 'BufRead' })
    use({ 'tpope/vim-surround', opt = true, event = 'BufRead',  })

    use({ 'nvim-lua/popup.nvim' })
    use({ 'nvim-lua/plenary.nvim' })
    use({ 'voldikss/vim-floaterm', opt = true,
      cmd = {'FloatermNew','FloatermToggle'},
      config = function() require('config.floaterm') end
    })
    use({ 'hasansujon786/vim-rel-jump', opt = true, event = 'BufRead' })
    use({ 'dhruvasagar/vim-open-url', opt = true, event = 'BufRead' })
    use({ 'folke/which-key.nvim', config = function() require('config.whichkey') end })
    use({ 'karb94/neoscroll.nvim', opt = true, event = 'BufRead',
      disable = true,
      config = function()
        require('config.neoscroll')
      end
    })
    use({ 'tweekmonster/startuptime.vim', opt = true, cmd = 'StartupTime' })
    use({ 'tpope/vim-scriptease', opt = true, cmd = {'PP','Messages'} })
    use({ 'tpope/vim-eunuch', opt = true, cmd = {'Delete','Move','Rename','Mkdir','Chmod'} })
    use({ 'tpope/vim-repeat', opt = true, event = 'BufRead' })

    --> Git ----------------------------------------
    use({ 'tpope/vim-fugitive', opt = true, cmd = {'Git','GBrowse','GV'},
      requires = {
        'tpope/vim-rhubarb',
        'junegunn/gv.vim'
      }
    })
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
    use({ 'nvim-treesitter/nvim-treesitter',
      opt = true, event = 'BufRead',
      config = function() require('config.treesitter') end,
      requires = {
        'JoosepAlviste/nvim-ts-context-commentstring',
        'nvim-treesitter/nvim-treesitter-textobjects',
        'michaeljsmith/vim-indent-object',
        'windwp/nvim-ts-autotag',
      }
    })
    use({ 'nvim-treesitter/playground', opt = true,
      cmd = {'TSPlaygroundToggle','TSHighlightCapturesUnderCursor'}
    })

    use({ 'neovim/nvim-lspconfig',
      opt = true, event = 'CursorHold',
      disable = vim.g.disable_lsp,
      config = function()
        require('lsp')
        require('lsp.setup.tsserver')
        require('lsp.setup.tailwindcss-ls')
        require('lsp.setup.sumneko_lua')
      end
    })
    use {
      'hrsh7th/nvim-cmp',
      opt = true, event = 'InsertEnter',
      config = function() require('config.cmp') end,
      requires = {
        'hrsh7th/vim-vsnip',
        'rafamadriz/friendly-snippets',
        -- completion sources
        'f3fora/cmp-spell',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-vsnip'
      },
    }
    use({ 'mattn/emmet-vim', opt = true, event = 'BufRead',
      config = function() require('config.emmet') end
    })
    use({ 'windwp/nvim-autopairs',
      opt = true, after = 'nvim-cmp',
      config = function() require('config.autopairs') end
    })
  end,
})
