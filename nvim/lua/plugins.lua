-- C:\Users\hasan\AppData\Local\nvim-data\site\pack\packer
vim.g.disable_lsp = false
vim.g.disable_coc = true

return require('packer').startup({
  function(use)
    use({ 'wbthomason/packer.nvim' })
    --> Visual -------------------------------------
    use({ 'navarasu/onedark.nvim' })
    use({ 'glepnir/dashboard-nvim', config = function() require('config.dashboard') end })
    use({ 'kyazdani42/nvim-web-devicons' })
    use({ 'Yggdroot/indentLine', opt = true, event = 'BufRead' })
    use({ 'hasansujon786/kissline.nvim' })
    use({ 'hasansujon786/notifier.nvim' })
    use({ 'hasansujon786/telescope-yanklist.nvim' })
    use({ 'folke/zen-mode.nvim', opt = true, cmd = 'ZenMode',
      config = function()
        require('config.zen')
      end
    })
    -- use({ 'folke/tokyonight.nvim' })

    --> Productiviry -------------------------------
    use({ 'vimwiki/vimwiki', opt = true, cmd = {'VimwikiIndex','VimwikiTabIndex','VimwikiUISelect'} })
    use({ 'kristijanhusak/orgmode.nvim', opt = true, event = 'BufRead', config = function() require('config.orgmode') end })
    use({ 'mkropat/vim-tt', opt = true, event = 'VimEnter', config = function () vim.g.tt_loaded = 1 end })

    --> Navigation ---------------------------------
    use({ 'ThePrimeagen/harpoon', opt = true, event = 'VimEnter' })
    use({ 'nvim-telescope/telescope.nvim', config = function() require('config.telescope') end })
    use({ 'nvim-telescope/telescope-fzy-native.nvim' })
    use({ 'nvim-telescope/telescope-project.nvim', opt = true, cmd = {'SwitchProjects'}, config = function ()
      vim.cmd[[command! SwitchProjects lua require('telescope').extensions.project.project{}]]
    end })

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
    -- use 'tpope/vim-scriptease'
    use({ 'hasansujon786/vim-rel-jump', opt = true, event = 'BufRead' })
    use({ 'dhruvasagar/vim-open-url', opt = true, event = 'BufRead' })
    use({ 'unblevable/quick-scope', opt = true, event = 'BufRead' })
    use({ 'tpope/vim-commentary', opt = true, event = 'BufRead' })
    use({ 'tpope/vim-surround', opt = true, event = 'BufRead' })
    use({ 'justinmk/vim-sneak', opt = true, event = 'BufRead' })
    use({ 'Konfekt/vim-CtrlXA', opt = true, event = 'BufRead' })
    use({ 'tpope/vim-repeat', opt = true, event = 'BufRead' })
    use({ 'folke/which-key.nvim', config = function() require('config.whichkey') end })
    use({ 'folke/neoscroll.nvim', opt = true, event = 'WinScrolled',
      config = function()
        require('config.neoscroll')
      end
    })

    --> Git ----------------------------------------
    use({ 'airblade/vim-gitgutter', opt = true, event = 'BufRead' })
    use({ 'tpope/vim-fugitive', opt = true, cmd = {'Git','GBrowse','GV'}})
    use({ 'tpope/vim-rhubarb', opt = true, after = 'vim-fugitive'})
    use({ 'junegunn/gv.vim', opt = true, after = 'vim-fugitive' })
    use({ 'TimUntersberger/neogit', opt = true, cmd = 'Neogit' })
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

    use({ 'neoclide/coc.nvim',
      config = function ()
        vim.cmd 'source ~/dotfiles/nvim/config/coc.vim'
      end,
      disable = vim.g.disable_coc,
      opt = true,
      event = 'BufRead'
    })

    use({ 'gu-fan/colorv.vim', opt = true, cmd = 'ColorV' })
    use({ 'mattn/emmet-vim', opt = true, event = 'BufRead' })
    use({ 'norcalli/nvim-colorizer.lua',
      opt = true, event = 'BufRead',
      config = function()
        require('config.colorizer')
      end
    })

    use({ 'neovim/nvim-lspconfig',
      disable = vim.g.disable_lsp,
      config = function()
        require('lsp')
        require('lsp.tailwindcss-ls')
        require('lsp.sumneko_lua')
      end
    })
    use({ 'airblade/vim-rooter',
      opt = true, event = 'VimEnter',
      disable = vim.g.disable_lsp,
      config = function() vim.g.rooter_silent_chdir = 1 end
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
    use({ 'hrsh7th/vim-vsnip',
      opt = true, event = 'InsertCharPre',
      disable = vim.g.disable_lsp,
    })
    use({ 'rafamadriz/friendly-snippets',
      opt = true, event = 'InsertCharPre'
    })

  end,
})
