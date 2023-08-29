-- use({ 'hasansujon786/2048.nvim' })
return {
  ------------------------------------------------
  --> Visual -------------------------------------
  ------------------------------------------------
  { 'navarasu/onedark.nvim', lazy = true },
  { 'goolord/alpha-nvim', config = function() require('config.alpha') end },
  { 'kyazdani42/nvim-web-devicons', lazy = true, config = function() require('config.devicons-config') end },
  -- { 'hasansujon786/notifier.nvim', opt = true, module = 'notifier' },
  { 'uga-rosa/ccc.nvim', lazy = true, config = function() require('config.color-picker') end, cmd = 'CccPick' },
  { 'folke/noice.nvim', lazy = true, event = 'VeryLazy', module = 'noice',
    config = function() require('config.noice') end,
    dependencies = {
      { 'folke/which-key.nvim', config = function() require('config.whichkey') end },
      { 'freddiehaddad/feline.nvim', config = function() require('config.feline') end },
    }
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    lazy = true,
    event = 'BufReadPost',
    config = function() require('config.indentLine') end,
    dependencies = {
      -- { 'kevinhwang91/nvim-hlslens', config = function() require('config.hlslens') end },
      { 'karb94/neoscroll.nvim', config = function() require('config.neoscroll') end },
      { 'chentoast/marks.nvim', config = function() require('config.marks-config') end },
    },
  },
  { 'folke/edgy.nvim', event = 'VeryLazy', config = function() require('config.edgy') end },

  ------------------------------------------------
  --> Navigation ---------------------------------
  ------------------------------------------------
  {
    'kyazdani42/nvim-tree.lua',
    lazy = true,
    event = 'CursorHold',
    config = function() require('config.nv_tree') end,
  },
  { 'hasansujon786/harpoon', lazy = true, module = 'harpoon' },
  { 'kevinhwang91/nvim-bqf', lazy = true, module = 'bqf' },
  { 'stefandtw/quickfix-reflector.vim',
    lazy = true, ft = { 'qf' },
    config = function()
      vim.defer_fn(function()
        require('config.bqf')
      end, 50)
    end
  },
  {
    'nvim-telescope/telescope.nvim',
    lazy = true, event = 'VeryLazy',
    config = function() require('config.telescope') end,
    dependencies = {
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      { 'hasansujon786/telescope-yanklist.nvim' },
      { 'nvim-telescope/telescope-file-browser.nvim' },
      { 'ahmedkhalf/project.nvim', config = function() require('config.project') end },
      { 'hasansujon786/telescope-ui-select.nvim' },
    },
  },

  ------------------------------------------------
  --> Productiviry -------------------------------
  ------------------------------------------------
  { 'mkropat/vim-tt', lazy = true, event = 'CursorHold', config = function() vim.g.tt_loaded = 1 end },
  -- { 'folke/zen-mode.nvim', lazy = true, cmd = 'ZenMode', config = function() require('config.zen') end },
  { 'hasansujon786/zen-mode.nvim', lazy = true, cmd = 'ZenMode', config = function() require('config.zen') end, branch = 'win-border' },
  {
    'nvim-orgmode/orgmode',
    lazy = true,
    ft = { 'org' },
    config = function() require('config.orgmode') end,
    dependencies = { { 'akinsho/org-bullets.nvim', config = function() require('config.org-bullets') end } },
  },
  -- { 'epwalsh/obsidian.nvim', config = function() require('config.obsidian') end },

  ------------------------------------------------
  --> Utils --------------------------------------
  ------------------------------------------------
  { 'nvim-lua/plenary.nvim', lazy = true, module = 'plenary' },
  { 'MunifTanjim/nui.nvim', lazy = true, module = 'nui' },
  {
    'tpope/vim-commentary',
    lazy = true,
    event = 'BufReadPost',
    dependencies = {
      'mg979/vim-visual-multi',
      'tpope/vim-surround',
      'tpope/vim-repeat',
      'mg979/vim-visual-multi',
      'arthurxavierx/vim-caser',
      'NTBBloodbath/color-converter.nvim',
      'unblevable/quick-scope',
      { 'dhruvasagar/vim-open-url', cmd = 'OpenURL' },
      { 'Konfekt/vim-CtrlXA', config = function() vim.fn['hasan#CtrlXA#update']() end },
      { 'justinmk/vim-sneak', config = function() require('config.sneak') end },
    },
  },
  { 'tpope/vim-eunuch', lazy = true, cmd = { 'Delete', 'Move', 'Rename', 'Mkdir', 'Chmod' } },
  {
    'voldikss/vim-floaterm',
    commit = 'bcaeabf', lazy = true, cmd = { 'FloatermNew', 'FloatermToggle' },
    config = function() require('config.floaterm') end,
  },
  {
    'olimorris/persisted.nvim',
    lazy = true,
    module = 'persisted',
    cmd = { 'SessionLoad', 'SessionLoadLast', 'SessionSave' },
    config = function() require('config.persisted').setup() end,
  },
  {
    'Wansmer/treesj',
    config = function() require('config.treeSJ') end,
    keys = {
      { '<leader>fm', '<cmd>TSJToggle<CR>', desc = 'TreeSJ: Toggle' },
      { '<leader>fj', '<cmd>TSJSplit<CR>', desc = 'TreeSJ: Split' },
      { '<leader>fJ', '<cmd>TSJJoin<CR>', desc = 'TreeSJ: Join' },
    },
  },
  ------------------------------------------------
  --> Git ----------------------------------------
  ------------------------------------------------
  {
    'NeogitOrg/neogit',
    lazy = true,
    cmd = 'Neogit',
    config = function() require('config.neogit') end,
    dependencies = {
      { 'sindrets/diffview.nvim', config = function() require('config.diffview') end }
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    lazy = true,
    event = 'BufReadPost',
    config = function() require('config.gitsigns') end,
  },
  ------------------------------------------------
  --> Lsp & completions --------------------------
  ------------------------------------------------
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = true,
    event = 'BufReadPre',
    config = function() require('config.treesitter') end,
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
      'nvim-treesitter/nvim-treesitter-textobjects',
      'michaeljsmith/vim-indent-object',
      'windwp/nvim-ts-autotag',
      { 'ziontee113/neo-minimap', config = function() require('config.neo_minimap') end },
      { 'NvChad/nvim-colorizer.lua', config = function() require('config.colorizer') end },
    },
  },
  { 'nvim-treesitter/playground', lazy = true, cmd = { 'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor' } },

  {
    'neovim/nvim-lspconfig',
    lazy = true,
    event = 'BufReadPre',
    dependencies = {
      { 'williamboman/mason.nvim', config = function() require('config.lsp') end, build = ':MasonUpdate' },
      { 'hrsh7th/cmp-nvim-lsp', lazy = true, module = 'cmp_nvim_lsp' },
      { 'williamboman/mason-lspconfig.nvim', lazy = true, module = 'mason-lspconfig' },
      { 'jose-elias-alvarez/null-ls.nvim', lazy = true, module = 'null-ls' },
    },
  },
  {
    'hrsh7th/nvim-cmp',
    lazy = true,
    event = 'BufReadPost',
    config = function() require('config.cmp_setup') end,
    dependencies = {
      'rafamadriz/friendly-snippets',
      { 'L3MON4D3/LuaSnip', lazy = true, module = 'luasnip', config = function() require('config.luasnip') end },
      -- completion sources
      'f3fora/cmp-spell',
      'hrsh7th/cmp-buffer',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-path',
      { 'windwp/nvim-autopairs', config = function() require('config.autopairs') end },
      { 'mattn/emmet-vim', config = function() require('config.emmet') end },
    },
  },
  {
    'simrat39/symbols-outline.nvim',
    lazy = true,
    cmd = { 'SymbolsOutline', 'SymbolsOutlineOpen' },
    config = function() require('config.symbol_outline') end,
  },
  {
    'akinsho/flutter-tools.nvim',
    lazy = true,
    ft = { 'dart' },
    config = function() require('config.flutter-tools') end,
  },
  {
    'mfussenegger/nvim-dap',
    lazy = true,
    module = 'dap',
    config = function() require('config.dap').setup() end,
    dependencies = {
      'nvim-telescope/telescope-dap.nvim',
      'mxsdev/nvim-dap-vscode-js',
      { 'rcarriga/nvim-dap-ui', config = function() require('config.dap').configure_dap_ui() end },
      { 'theHamsta/nvim-dap-virtual-text', config = function() require('config.dap').configure_virtual_text() end },
      -- 'jbyuki/one-small-step-for-vimkind',
    },
  },
}
