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
    use({ 'hasansujon786/notifier.nvim', opt = true, module = 'notifier' })
    use({ 'karb94/neoscroll.nvim', config = function () require('config.neoscroll') end, event = 'BufReadPost', opt = true })

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
    use({ 'ziontee113/color-picker.nvim', config = [[require('config.color-picker')]], opt = true, cmd = 'PickColor' })

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
    use({ 'MunifTanjim/nui.nvim' })
    use({ 'nvim-lua/plenary.nvim' })
    use({ 'tpope/vim-repeat', opt = true, event = 'BufRead' })
    use({ 'dhruvasagar/vim-open-url', opt = true, event = 'BufRead' })
    use({ 'tpope/vim-commentary', opt = true, event = 'BufReadPost' })
    use({ 'tpope/vim-surround', opt = true, event = 'BufReadPost' })
    use({ 'mg979/vim-visual-multi', opt = true, event = 'CursorHold' })
    use({ 'tpope/vim-eunuch', opt = true, cmd = {'Delete','Move','Rename','Mkdir','Chmod'} })
    use({ 'folke/which-key.nvim', config = function() require('config.whichkey') end })
    use({ 'voldikss/vim-floaterm',opt=true,cmd={'FloatermNew','FloatermToggle'},config=[[require('config.floaterm')]] })
    use({ 'olimorris/persisted.nvim',
      cmd = {'SessionLoad', 'SessionLoadLast', 'SessionSave'},
      module = 'persisted', opt = true,
      config = [[require('config.persisted').setup()]],
    })
    use({ 'simrat39/symbols-outline.nvim',
      opt = true, cmd = { 'SymbolsOutline', 'SymbolsOutlineClose' },
      setup = [[require('config.symbol_outline').setup()]],
    })
    use({ 'arthurxavierx/vim-caser', opt = true, event = 'CursorHold' })
    use({ 'NTBBloodbath/color-converter.nvim', opt = true, event = 'CursorHold' })
    use({ 'Konfekt/vim-CtrlXA', opt = true, event = 'CursorHold' })
    use({ 'chentoast/marks.nvim',opt=true,event='CursorHold',config=[[require('config.marks-config')]] })
    use({ 'hasansujon786/vim-rel-jump', opt = true, event = 'BufRead' })
    use({ 'tpope/vim-scriptease', opt = true, cmd = {'PP','Messages'} })

    ------------------------------------------------
    --> Git ----------------------------------------
    ------------------------------------------------
    use({ 'TimUntersberger/neogit', cmd = 'Neogit',
      config = [[require('config.neogit')]], opt = true,
      requires = { 'sindrets/diffview.nvim' }
    })
    use({ 'airblade/vim-gitgutter',
      opt = true, event = 'CursorHold',
      config="require('config.gitgutter-config')",
      commit='d5bae104031bb1633cb5c5178dc7d4ac422b422a'
    })

    ------------------------------------------------
    --> Lsp & completions --------------------------
    ------------------------------------------------
    use({ 'nvim-treesitter/playground', opt = true, cmd = {'TSPlaygroundToggle','TSHighlightCapturesUnderCursor'} })
    use({ 'nvim-treesitter/nvim-treesitter',
      opt = true, event = 'BufReadPost',
      config = [[require('config.treesitter')]],
      requires = {
        'JoosepAlviste/nvim-ts-context-commentstring',
        'nvim-treesitter/nvim-treesitter-textobjects',
        'michaeljsmith/vim-indent-object',
        'windwp/nvim-ts-autotag',
      }
    })
    use({ 'neovim/nvim-lspconfig',
      opt = true, event = 'BufReadPost',
      config = function() require('lsp') end,
      requires = {
        { 'jose-elias-alvarez/null-ls.nvim', config = function() require('lsp.null-ls') end },
        { 'williamboman/nvim-lsp-installer', config = function() require('lsp.installer') end },
      }
    })
    use({ 'hrsh7th/nvim-cmp',
      opt = true, after = 'nvim-lspconfig',
      config = function() require('config.cmp') end,
      requires = {
        'rafamadriz/friendly-snippets',
        {'L3MON4D3/LuaSnip', opt = true, module = 'luasnip', config='require("config.luasnip")'},
        -- completion sources
        'f3fora/cmp-spell',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'saadparwaiz1/cmp_luasnip',
        { 'hrsh7th/cmp-path', commit ='d83839ae510d18530c6d36b662a9e806d4dceb73' },
        { 'windwp/nvim-autopairs', config = [[require('config.autopairs')]] },
      },
    })
    use({ 'akinsho/flutter-tools.nvim', opt = true, ft = {'dart'}, config = [[require('config.flutter-tools')]] })
    use({ 'mattn/emmet-vim', opt = true, event = 'BufReadPost', config = [[require('config.emmet')]] })
    use {
      'mfussenegger/nvim-dap',
      opt = true, module = 'dap',
      config = "require('config.dap').setup()",
      requires = {
        {'rcarriga/nvim-dap-ui', config = 'require("config.dap").configure_dap_ui()'},
        {'theHamsta/nvim-dap-virtual-text', config = 'require("config.dap").configure_virtual_text()'},
        'nvim-telescope/telescope-dap.nvim',
        -- 'jbyuki/one-small-step-for-vimkind',
      },
    }

    if not is_installed then
      require('packer').sync()
    end
  end,
  config = {
    max_jobs = 5,
    snapshot_path = fn.stdpath('config')
  },
})
