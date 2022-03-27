-- C:\Users\hasan\AppData\Local\nvim-data\site\pack\packer
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local is_installed = fn.isdirectory(install_path) == 1
if not is_installed then
  print('Installing packer...')
  fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
  vim.cmd('packadd packer.nvim')
  print('Installed packer.nvim.')
end

vim.g.disable_lsp = false
vim.g.disable_coc = true

return require('packer').startup({
  function(use)
    use({ 'wbthomason/packer.nvim' })
    --> Visual -------------------------------------
    use({ 'navarasu/onedark.nvim', config = function() require('config.onedark') end })
    use({ 'hasansujon786/dashboard-nvim', config = function() require('config.dashboard') end })
    use({ 'hasansujon786/kissline.nvim', opt = true, event = 'VimEnter',
      config = function() require('config.kissline') end
    })
    use({ 'nvim-lualine/lualine.nvim', config = function() require('config.lualine-config') end })
    use({ 'kyazdani42/nvim-web-devicons', config = function() require('config.devicons-config') end })
    use({ 'hasansujon786/notifier.nvim' })
    use({ 'folke/zen-mode.nvim', opt = true, cmd = 'ZenMode',
      config = function() require('config.zen') end
    })
    use({ 'Yggdroot/indentLine', opt = true, event = 'BufRead',
      disable = true,
      config = function() require('config.indentLine') end
    })
    use({ "lukas-reineke/indent-blankline.nvim",opt = true,event = 'VimEnter',
      config = function() require('config.indentLine-config') end
    })
    use({ 'norcalli/nvim-colorizer.lua', opt = true, event = 'CursorHold',
      config = function() require('config.colorizer') end
    })
    -- use({ 'folke/tokyonight.nvim' })
    -- use({'projekt0n/github-nvim-theme'})

    --> Productiviry -------------------------------
    -- use({ 'vimwiki/vimwiki', opt = true, cmd = {'VimwikiIndex','VimwikiTabIndex','VimwikiUISelect'} })
    use({ 'nvim-orgmode/orgmode',
      -- commit ='50d1a97b25d77f33d312b4775fbd68217d22c946',
      -- commit ='e287630dad1eceb03292b6283aa73505e539191b', -- working
      opt = true, after = 'nvim-treesitter',
      config = function() require('config.orgmode') end,
      requires = {
        {"akinsho/org-bullets.nvim", config = function() require('config.org-bullets') end }
      }
    })
    use({ 'mkropat/vim-tt', opt = true, event = 'CursorHold',
      config = function ()
        vim.g.tt_loaded = 1
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
    use({ 'nvim-telescope/telescope-file-browser.nvim', opt = true, event = 'CursorHold', })
    use({ 'hasansujon786/telescope-yanklist.nvim', opt = true, event = 'CursorHold', })
    use({ 'kyazdani42/nvim-tree.lua', config = [[require('config.nv_tree')]] })
    use({ 'lambdalisue/fern.vim',
      disable = true,
      config = function() require('config.fern') end,
      opt = true, event = 'CursorHold',
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

    -- use({'tpope/vim-obsession'})
    -- https://github.com/sindrets/winshift.nvim
    --> Utils --------------------------------------
    use({ 'hasansujon786/vim-zoom', opt = true, cmd={'ZoomToggle'}, config='require("config.zoom-config")' })
    use({ 'MunifTanjim/nui.nvim' })
    use({ 'mg979/vim-visual-multi', opt = true, event = 'CursorHold' })
    use({ 'arthurxavierx/vim-caser', opt = true, event = 'CursorHold' })
    use({ 'NTBBloodbath/color-converter.nvim', opt = true, event = 'CursorHold' })
    use({ 'Konfekt/vim-CtrlXA', opt = true, event = 'CursorHold' })
    use({ 'tpope/vim-commentary', opt = true, event = 'BufRead' })
    use({ 'tpope/vim-surround', opt = true, event = 'BufRead',  })
    use({ 'nathom/filetype.nvim', disable = true })
    use({ 'nvim-lua/plenary.nvim' })
    use({ 'voldikss/vim-floaterm', opt = true,
      cmd = {'FloatermNew','FloatermToggle'},
      config = function()
        require('config.floaterm')
      end
    })
    use({ 'chentau/marks.nvim',opt=true,event='CursorHold',config=[[require('config.marks-config')]] })
    use({ 'hasansujon786/vim-rel-jump', opt = true, event = 'BufRead' })
    use({ 'dhruvasagar/vim-open-url', opt = true, event = 'BufRead' })
    use({ 'folke/which-key.nvim', config = function() require('config.whichkey') end })
    use({ 'karb94/neoscroll.nvim', opt = true, event = 'BufRead',
      disable = true,
      config = function()
        require('config.neoscroll')
      end
    })
    use({ 'olimorris/persisted.nvim',
      module = 'persisted', opt = true,
      cmd = {'SessionLoad', 'SessionLoadLast', 'SessionSave'},
      config = function()
        require('config.persisted').setup()
      end,
    })
    use({ 'tweekmonster/startuptime.vim', opt = true, cmd = 'StartupTime' })
    use({ 'tpope/vim-scriptease', opt = true, cmd = {'PP','Messages'} })
    use({ 'tpope/vim-eunuch', opt = true, cmd = {'Delete','Move','Rename','Mkdir','Chmod'} })
    use({ 'tpope/vim-repeat', opt = true, event = 'BufRead' })
    use({ 'simrat39/symbols-outline.nvim',
      opt = true, cmd = { 'SymbolsOutline', 'SymbolsOutlineClose' },
      setup = function()
        require('config.symbol_outline').setup()
      end,
    })
    -- use({ 'sunjon/Shade.nvim', config = function() require('config.shade') end })

    --> Git ----------------------------------------
    -- use({ 'tpope/vim-fugitive', opt = true, cmd = {'Git','GBrowse','GV'},
    --   requires = {
    --     'tpope/vim-rhubarb',
    --     'junegunn/gv.vim'
    --   }
    -- })
    use({ 'TimUntersberger/neogit', opt = true, cmd = 'Neogit' })
    use({'airblade/vim-gitgutter',opt=true,event='CursorHold',config="require('config.gitgutter-config')"})
    use({ 'lewis6991/gitsigns.nvim',
      -- opt = true, event = 'BufRead',
      branch = 'crlf', opt = true, event = 'BufRead',
      disable = true,
      config = function()
        require('config.gitsigns')
      end
    })
    -- use({'ruifm/gitlinker.nvim'})
    -- ues({'tanvirtin/vgit.nvim'})

    --> Lsp & completions --------------------------
    use({ 'neoclide/coc.nvim',
      opt = true, event = 'CursorHold',
      disable = vim.g.disable_coc,
      config = function ()
        vim.cmd 'source ~/dotfiles/nvim/config/coc.vim'
      end
    })
    use({ 'nvim-treesitter/nvim-treesitter',
      opt = true, event = 'CursorHold',
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
      config = function() require('lsp') end,
    })
    use({ 'jose-elias-alvarez/null-ls.nvim',
      opt = true, after = 'nvim-lspconfig',
      config = function() require('lsp.null-ls') end,
    })
    use({ 'williamboman/nvim-lsp-installer',
      opt = true, after = 'nvim-lspconfig',
      disable = vim.g.disable_lsp,
      config = function() require('lsp.installer') end,
    })
    use({ 'hrsh7th/nvim-cmp',
      opt = true, after = 'nvim-lspconfig',
      config = function() require('config.cmp') end,
      requires = {
        'hrsh7th/vim-vsnip',
        'rafamadriz/friendly-snippets',
        -- completion sources
        'f3fora/cmp-spell',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-vsnip',
        {'hrsh7th/cmp-path', commit ='d83839ae510d18530c6d36b662a9e806d4dceb73'}
      },
    })
    use({ 'windwp/nvim-autopairs',
      opt = true, after = 'nvim-cmp',
      config = function() require('config.autopairs') end
    })
    use({ 'mattn/emmet-vim', opt = true, event = 'BufRead',
      config = function() require('config.emmet') end
    })
    use({ 'akinsho/flutter-tools.nvim', opt = true, ft = {'dart'},
      config = function() require('config.flutter-tools') end
    })

    if not is_installed then
      require('packer').sync()
    end
  end,
  config = {
    max_jobs = 5,
  },
})
