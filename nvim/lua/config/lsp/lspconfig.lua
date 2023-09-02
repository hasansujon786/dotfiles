local lspconfig_setup = function()
  local lspconfig = require('lspconfig')
  local settings = require('config.lsp.util.settings')

  require('lspconfig.ui.windows').default_options.border = 'rounded'
  for server_name, server_config in pairs(settings.essential_servers) do
    if server_config[2] == nil then
      lspconfig[server_name].setup(settings.default_opts)
    else
      lspconfig[server_name].setup(require('hasan.utils').merge(settings.default_opts, server_config[2]))
    end
  end
end

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
        lspconfig_setup()
        require('config.lsp.util.diagnosgic').setup()
      end,
      build = ':MasonUpdate',
    },
    { 'hrsh7th/cmp-nvim-lsp', lazy = true, module = 'cmp_nvim_lsp' },
    { 'williamboman/mason-lspconfig.nvim', lazy = true, module = 'mason-lspconfig' },
    { 'jose-elias-alvarez/null-ls.nvim' },
  },
}
