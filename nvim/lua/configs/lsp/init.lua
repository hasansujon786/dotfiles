return {
  {
    'neovim/nvim-lspconfig',
    lazy = true,
    event = 'BufReadPre',
    dependencies = {
      {
        'williamboman/mason.nvim',
        config = function()
          require('config.module.lspconfig')
        end,
        build = ':MasonUpdate',
      },
      { 'hrsh7th/cmp-nvim-lsp', lazy = true, module = 'cmp_nvim_lsp' },
      { 'williamboman/mason-lspconfig.nvim', lazy = true, module = 'mason-lspconfig' },
      { 'jose-elias-alvarez/null-ls.nvim', lazy = true, module = 'null-ls' },
    },
  },
  {
    'mfussenegger/nvim-dap',
    lazy = true,
    module = 'dap',
    config = function()
      require('configs.module.dap').setup()
    end,
    dependencies = {
      'nvim-telescope/telescope-dap.nvim',
      'mxsdev/nvim-dap-vscode-js',
      {
        'rcarriga/nvim-dap-ui',
        config = function()
          require('configs.module.dap').configure_dap_ui()
        end,
      },
      {
        'theHamsta/nvim-dap-virtual-text',
        config = function()
          require('configs.module.dap').configure_virtual_text()
        end,
      },
      -- 'jbyuki/one-small-step-for-vimkind',
    },
  },
}
