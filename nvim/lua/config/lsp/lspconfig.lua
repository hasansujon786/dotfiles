return {
  'neovim/nvim-lspconfig',
  lazy = true,
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    { 'williamboman/mason-lspconfig.nvim', lazy = true, module = 'mason-lspconfig' },
    {
      'williamboman/mason.nvim',
      cmd = { 'Mason', 'MasonInstall', 'MasonUpdate' },
      opts = { max_concurrent_installers = 3, ui = { border = 'none', height = 0.8 } },
      config = function(_, opts)
        require('mason').setup(opts)
        require('mason-lspconfig').setup({
          ensure_installed = { 'lua_ls', 'ts_ls', 'vimls' },
          handlers = {
            function(server_name)
              require('lspconfig')[server_name].setup(require('config.lsp.util.extras').get_lspconfig(server_name))
            end,
          },
        })
        require('config.lsp.util.diagnosgic').setup()
        require('lspconfig.ui.windows').default_options.border = 'rounded'
      end,
      build = ':MasonUpdate',
    },
  },
}
