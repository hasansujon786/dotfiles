return {
  {
    'neovim/nvim-lspconfig',
    lazy = true,
    event = 'BufReadPre',
    dependencies = {
      {
        'williamboman/mason.nvim',
        config = function()
          local lspconfig = require('lspconfig')
          require('lspconfig.ui.windows').default_options.border = 'rounded'
          require('mason').setup({ max_concurrent_installers = 3, ui = { border = 'none', height = 0.8 } })
          require('mason-lspconfig').setup()
          require('config.lsp.lspconfig.diagnosgic').setup()
          require('config.lsp.lspconfig.null-ls')

          local my_config = require('config.lsp.lspconfig.lsp-config')
          for server_name, server_config in pairs(my_config.essential_servers) do
            if server_config[2] == nil then
              lspconfig[server_name].setup(my_config.default_opts)
            else
              lspconfig[server_name].setup(require('hasan.utils').merge(my_config.default_opts, server_config[2]))
            end
          end
        end,
        build = ':MasonUpdate',
      },
      { 'hrsh7th/cmp-nvim-lsp', lazy = true, module = 'cmp_nvim_lsp' },
      { 'williamboman/mason-lspconfig.nvim', lazy = true, module = 'mason-lspconfig' },
      { 'jose-elias-alvarez/null-ls.nvim', lazy = true, module = 'null-ls' },
    },
  },
  {
    'akinsho/flutter-tools.nvim',
    lazy = true,
    ft = { 'dart' },
    config = function()
      require('config.lsp.flutter_tools').config()
    end,
  },
  {
    'simrat39/symbols-outline.nvim',
    lazy = true,
    cmd = { 'SymbolsOutline', 'SymbolsOutlineOpen' },
    config = function()
      require('config.lsp.outline')
    end,
  },
}
