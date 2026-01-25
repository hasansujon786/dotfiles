return {
  'neovim/nvim-lspconfig',
  lazy = true,
  event = { 'VeryLazy' },
  dependencies = {
    { 'mason-org/mason-lspconfig.nvim', lazy = true, module = 'mason-lspconfig' },
    {
      'mason-org/mason.nvim',
      cmd = { 'Mason', 'MasonInstall', 'MasonUpdate' },
      opts = {
        max_concurrent_installers = 3,
        ui = { border = 'none', height = 0.7, width = 0.6 },
      },
      config = function(_, opts)
        require('mason').setup(opts)
        require('mason-lspconfig').setup({
          ensure_installed = { 'vtsls', 'vue_ls', 'lua_ls' },
          -- handlers = {
          --   function(server_name)
          --     require('lspconfig')[server_name].setup(require('config.lsp.util.setup').get_setup_opts(server_name))
          --   end,
          -- },
        })
        require('config.lsp.util.diagnosgic').setup()
        require('lspconfig.ui.windows').default_options.border = 'rounded'
      end,
      build = ':MasonUpdate',
    },
    { 'b0o/schemastore.nvim', lazy = true, commit = '976b31e' },
  },
}
