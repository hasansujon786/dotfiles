-- C:\Users\hasan\AppData\Local\nvim-data\site\pack\packer
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local is_installed = fn.isdirectory(install_path) == 1
if not is_installed then
  print('Installing packer...')
  fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
  vim.cmd({ cmd = 'packadd', args = { 'packer.nvim' } })
  print('Installed packer.nvim.')
end

return require('packer').startup({
  function(use)
    use({ 'wbthomason/packer.nvim' })
    ------------------------------------------------
    --> Visual -------------------------------------
    ------------------------------------------------
    use({ 'navarasu/onedark.nvim', config = [[require('config.onedark')]] })
    use({ 'goolord/alpha-nvim', config = [[require('config.alpha')]] })
    use({ 'hasansujon786/kissline.nvim', config = [[require('config.kissline')]] })
    use({ 'nvim-lualine/lualine.nvim', config = [[require('config.lualine')]], commit = '8d956c18258bb128ecf42f95411bb26efd3a5d23' })
    use({ 'kyazdani42/nvim-web-devicons', config = [[require('config.devicons-config')]] })
    use({ 'hasansujon786/notifier.nvim', opt = true, module = 'notifier' })
    use({ 'folke/which-key.nvim', config = function() require('config.whichkey') end })
    use({ 'uga-rosa/ccc.nvim', config=[[require('config.color-picker')]], opt=true, cmd='CccPick' })
    use({ 'lukas-reineke/indent-blankline.nvim', opt = true, event = 'BufReadPost', config = [[require('config.indentLine')]],
      requires = {
        { 'karb94/neoscroll.nvim', config = [[require('config.neoscroll')]] },
        { 'NvChad/nvim-colorizer.lua', config = [[require('config.colorizer')]] },
        { 'chentoast/marks.nvim', config=[[require('config.marks-config')]] },
      }
    })

    ------------------------------------------------
    --> Productiviry -------------------------------
    ------------------------------------------------
    use({ 'mkropat/vim-tt', opt = true, event = 'CursorHold', config = function () vim.g.tt_loaded = 1 end })
    use({ 'folke/zen-mode.nvim', opt = true, cmd = 'ZenMode', config = [[require('config.zen')]] })
    use({ 'nvim-orgmode/orgmode',
      opt = true, ft = {'org'},
      config = function() require('config.orgmode') end,
      requires = { {'akinsho/org-bullets.nvim', config = function() require('config.org-bullets') end} }
    })

    ------------------------------------------------
    --> Navigation ---------------------------------
    ------------------------------------------------
    use({ 'ziontee113/neo-minimap', config = 'require("config.neo_minimap")' })
    use({ 'kyazdani42/nvim-tree.lua', config = [[require('config.nv_tree')]] })
    use({ 'kevinhwang91/nvim-bqf', opt = true, ft = {'qf'} })
    use({ 'ThePrimeagen/harpoon', opt = true, module = 'harpoon' })
    use({ 'nvim-telescope/telescope.nvim', config = [[require('config.telescope')]],
      requires = {
        { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      }
    })
    use({ 'ahmedkhalf/project.nvim', config = [[require('config.project')]], event = 'CursorHold', opt = true,
      requires = {
        { 'hasansujon786/telescope-ui-select.nvim', config = [[require('telescope').load_extension('ui-select')]] },
        { 'hasansujon786/telescope-yanklist.nvim', opt = true, event = 'TextYankPost', module = 'yanklist' },
        { 'nvim-telescope/telescope-file-browser.nvim' },
      }
    })

    ------------------------------------------------
    --> Utils --------------------------------------
    ------------------------------------------------
    use({ 'MunifTanjim/nui.nvim' })
    use({ 'nvim-lua/plenary.nvim' })
    use({ 'tpope/vim-commentary', opt = true, event = 'BufReadPost',
      requires = {
        { 'tpope/vim-surround' },
        { 'tpope/vim-repeat' },
        { 'mg979/vim-visual-multi' },
        { 'dhruvasagar/vim-open-url' },
        { 'arthurxavierx/vim-caser' },
        { 'NTBBloodbath/color-converter.nvim' },
        { 'Konfekt/vim-CtrlXA' },
        { 'hasansujon786/vim-rel-jump' },
        { 'justinmk/vim-sneak', config = [[require('config.sneak')]] },
        { 'unblevable/quick-scope' }
      }
    })

    use({ 'tpope/vim-eunuch', opt = true, cmd = {'Delete','Move','Rename','Mkdir','Chmod'} })
    use({ 'voldikss/vim-floaterm', opt = true, cmd={'FloatermNew','FloatermToggle'}, config=[[require('config.floaterm')]] })
    use({ 'olimorris/persisted.nvim',
      cmd = {'SessionLoad', 'SessionLoadLast', 'SessionSave'},
      module = 'persisted', opt = true,
      config = [[require('config.persisted').setup()]],
    })
    use({ 'tpope/vim-scriptease', opt = true, cmd = {'PP','Messages'} })

    ------------------------------------------------
    --> Git ----------------------------------------
    ------------------------------------------------
    use({ 'TimUntersberger/neogit',
      opt = true, cmd = 'Neogit', commit = '64245bb',
      config = [[require('config.neogit')]],
      requires = { 'sindrets/diffview.nvim' },
    })
    use({ 'airblade/vim-gitgutter',
      opt = true, event = 'BufReadPost',
      config="require('config.gitgutter-config')",
      commit='f19b6203191d69de955d91467a5707959572119b'
      -- commit='d5bae104031bb1633cb5c5178dc7d4ac422b422a'
    })

    ------------------------------------------------
    --> Lsp & completions --------------------------
    ------------------------------------------------
    use({ 'nvim-treesitter/playground', opt = true, cmd = {'TSPlaygroundToggle','TSHighlightCapturesUnderCursor'} })
    use({ 'nvim-treesitter/nvim-treesitter',
      opt = true, event = 'CursorHold', -- commit = 'c853370',
      config = [[require('config.treesitter')]],
      requires = {
        'JoosepAlviste/nvim-ts-context-commentstring',
        'nvim-treesitter/nvim-treesitter-textobjects',
        'michaeljsmith/vim-indent-object',
        'windwp/nvim-ts-autotag',
      }
    })
    use({ 'neovim/nvim-lspconfig', opt = true, event = 'BufReadPre', config = function() require('lsp') end,
      requires = {
        { 'williamboman/mason-lspconfig.nvim', opt = true, module = 'mason-lspconfig' },
        { 'jose-elias-alvarez/null-ls.nvim', config = function() require('lsp.null-ls') end },
        { 'williamboman/mason.nvim', config = function() require('lsp.lsp-config') end },
      }
    })
    use({ 'hrsh7th/nvim-cmp', opt = true, event = 'BufReadPost', config = function() require('config.cmp') end,
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
        { 'mattn/emmet-vim', config = [[require('config.emmet')]] },
      },
    })
    use({ 'simrat39/symbols-outline.nvim', opt = true, cmd = 'SymbolsOutline', config = [[require('config.symbol_outline')]] })
    use({ 'akinsho/flutter-tools.nvim', opt = true, ft = {'dart'}, config = [[require('config.flutter-tools')]] })
    use({ 'mfussenegger/nvim-dap', opt = true, module = 'dap', config = "require('config.dap').setup()",
      requires = {
        {'rcarriga/nvim-dap-ui', config = 'require("config.dap").configure_dap_ui()'},
        {'theHamsta/nvim-dap-virtual-text', config = 'require("config.dap").configure_virtual_text()'},
        {'nvim-telescope/telescope-dap.nvim'},
        -- 'jbyuki/one-small-step-for-vimkind',
      },
    })

    if not is_installed then
      require('packer').sync()
    end
  end,
  config = {
    max_jobs = 5,
    snapshot_path = fn.stdpath('config')
  },
})
