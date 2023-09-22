return {
  'neovim/nvim-lspconfig',
  lazy = true,
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    {
      'williamboman/mason.nvim',
      opts = { max_concurrent_installers = 3, ui = { border = 'none', height = 0.8 } },
      config = function(_, opts)
        require('mason').setup(opts)
        -- local modles
        require('config.lsp.util.setup').init_lspconfig()
        require('config.lsp.util.diagnosgic').setup()
      end,
      build = ':MasonUpdate',
    },
    { 'hrsh7th/cmp-nvim-lsp', lazy = true, module = 'cmp_nvim_lsp' },
    { 'williamboman/mason-lspconfig.nvim', lazy = true, module = 'mason-lspconfig' },
    { 'jose-elias-alvarez/null-ls.nvim' },
  },
}
