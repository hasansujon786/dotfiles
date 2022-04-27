-- C:\Users\hasan\AppData\Local\nvim-data\site\pack\packer
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local is_installed = fn.isdirectory(install_path) == 1
if not is_installed then
  print('Installing packer...')
  fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
  local pac_cmd = 'packadd packer.nvim'
  vim.cmd(pac_cmd)
  print('Installed packer.nvim.')
end

vim.g.disable_lsp = false
vim.g.disable_coc = true

return require('packer').startup({
  function(use)
    use({ 'wbthomason/packer.nvim' })
    ------------------------------------------------
    --> Visual -------------------------------------
    ------------------------------------------------
    use({ 'navarasu/onedark.nvim', config = function() require('config.onedark') end })
    use({ 'hasansujon786/dashboard-nvim', config = function() require('config.dashboard') end })
    use({ 'hasansujon786/kissline.nvim', config = function() require('config.kissline') end })
    use({ 'nvim-lualine/lualine.nvim', config = function() require('config.lualine') end })
    use({ 'kyazdani42/nvim-web-devicons', config = function() require('config.devicons-config') end })
    use({ 'lukas-reineke/indent-blankline.nvim', opt = true, event = 'VimEnter', config = [[require('config.indentLine')]] })
    use({ 'norcalli/nvim-colorizer.lua', opt = true, event = 'CursorHold', config = [[require('config.colorizer')]] })
    use({ 'folke/zen-mode.nvim', opt = true, cmd = 'ZenMode', config = function() require('config.zen') end })
    use({ 'hasansujon786/notifier.nvim' })

    ------------------------------------------------
    --> Productiviry -------------------------------
    ------------------------------------------------
    use({ 'nvim-orgmode/orgmode',
      -- commit ='50d1a97b25d77f33d312b4775fbd68217d22c946',
      -- commit ='e287630dad1eceb03292b6283aa73505e539191b', -- working
      opt = true, after = 'nvim-treesitter',
      config = function() require('config.orgmode') end,
      requires = {
        {"akinsho/org-bullets.nvim", config = function() require('config.org-bullets') end }
      }
    })
    use({ 'mkropat/vim-tt', opt = true, event = 'CursorHold', config = function () vim.g.tt_loaded = 1 end })

    ------------------------------------------------
    --> Navigation ---------------------------------
    ------------------------------------------------
    use({ 'kyazdani42/nvim-tree.lua', config = [[require('config.nv_tree')]] })
    use({ 'kevinhwang91/nvim-bqf', opt = true, ft = {'qf'} })
    use({ 'ThePrimeagen/harpoon', opt = true, module = 'harpoon' })
    use({ 'nvim-telescope/telescope.nvim',
      config = function() require('config.telescope') end,
      cmd = 'Telescope', module = 'telescope', event = 'BufReadPost', opt = true,
      requires = {
        { 'hasansujon786/telescope-ui-select.nvim', config = [[require('telescope').load_extension('ui-select')]] },
        { 'nvim-telescope/telescope-fzy-native.nvim', config = [[require('telescope').load_extension('fzy_native')]]  },
        { 'ahmedkhalf/project.nvim', config = [[require('config.project')]] },
        { 'nvim-telescope/telescope-file-browser.nvim' },
        { 'hasansujon786/telescope-yanklist.nvim', opt = true, event = 'TextYankPost', module = 'yanklist' },
      }
    })

    use({ 'unblevable/quick-scope', opt = true, event = 'CursorHold'})
    use({ 'justinmk/vim-sneak', opt = true, event = 'CursorHold', config = [[require('config.sneak')]] })

    ------------------------------------------------
    --> Utils --------------------------------------
    ------------------------------------------------
    use({ 'tpope/vim-eunuch', opt = true, cmd = {'Delete','Move','Rename','Mkdir','Chmod'} })
    use({ 'tpope/vim-commentary', opt = true, event = 'BufReadPost' })
    use({ 'tpope/vim-surround', opt = true, event = 'BufReadPost',  })
    use({ 'MunifTanjim/nui.nvim' })
    use({ 'mg979/vim-visual-multi', opt = true, event = 'CursorHold' })
    use({ 'arthurxavierx/vim-caser', opt = true, event = 'CursorHold' })
    use({ 'NTBBloodbath/color-converter.nvim', opt = true, event = 'CursorHold' })
    use({ 'Konfekt/vim-CtrlXA', opt = true, event = 'CursorHold' })
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
    use({ 'olimorris/persisted.nvim',
      module = 'persisted', opt = true,
      cmd = {'SessionLoad', 'SessionLoadLast', 'SessionSave'},
      config = function()
        require('config.persisted').setup()
      end,
    })
    use({ 'tpope/vim-scriptease', opt = true, cmd = {'PP','Messages'} })
    use({ 'tpope/vim-repeat', opt = true, event = 'BufRead' })
    use({ 'simrat39/symbols-outline.nvim',
      opt = true, cmd = { 'SymbolsOutline', 'SymbolsOutlineClose' },
      setup = function()
        require('config.symbol_outline').setup()
      end,
    })

    ------------------------------------------------
    --> Git ----------------------------------------
    ------------------------------------------------
    use({ 'TimUntersberger/neogit', opt = true, cmd = 'Neogit',
      config = function()
        require('config.neogit')
      end,
      requires = { 'sindrets/diffview.nvim', after = 'neogit' }
    })
    use({'airblade/vim-gitgutter',
      -- disable = true,
      opt=true,event='CursorHold',
      config="require('config.gitgutter-config')",
      commit='d5bae104031bb1633cb5c5178dc7d4ac422b422a'
    })

    ------------------------------------------------
    --> Lsp & completions --------------------------
    ------------------------------------------------
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
