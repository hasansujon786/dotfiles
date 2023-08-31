return {
  {
    'neovim/nvim-lspconfig',
    lazy = true,
    event = 'BufReadPre',
    dependencies = {
      {
        'williamboman/mason.nvim',
        config = function()
          require('mason').setup({ max_concurrent_installers = 3, ui = { border = 'none', height = 0.8 } })
          -- local modles
          require('config.lsp.lspconfig').setup()
          require('config.lsp.util.diagnosgic').setup()
        end,
        build = ':MasonUpdate',
      },
      { 'hrsh7th/cmp-nvim-lsp', lazy = true, module = 'cmp_nvim_lsp' },
      { 'williamboman/mason-lspconfig.nvim', lazy = true, module = 'mason-lspconfig' },
      {
        'jose-elias-alvarez/null-ls.nvim',
        module = 'null-ls',
        config = function()
          require('config.lsp.null-ls').setup()
        end,
      },
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
