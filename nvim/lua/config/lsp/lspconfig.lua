local function init_lspconfig()
  local lspconfig = require('lspconfig')
  require('lspconfig.ui.windows').default_options.border = 'rounded'

  -- default lsp configs
  local lsp_extras = require('config.lsp.util.extras')
  local g_conf = lsp_extras.get_global_conf()

  for server_name, _ in pairs(g_conf.essential_servers) do
    local local_conf = lsp_extras.get_server_conf(server_name)
    if local_conf == nil or local_conf.settings == nil then
      lspconfig[server_name].setup(g_conf.default_opts)
    else
      local opts = require('hasan.utils').merge(g_conf.default_opts, local_conf.settings)
      lspconfig[server_name].setup(opts)
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
        init_lspconfig()
        require('config.lsp.util.diagnosgic').setup()
      end,
      build = ':MasonUpdate',
    },
    { 'hrsh7th/cmp-nvim-lsp', lazy = true, module = 'cmp_nvim_lsp' },
    { 'williamboman/mason-lspconfig.nvim', lazy = true, module = 'mason-lspconfig' },
    { 'jose-elias-alvarez/null-ls.nvim' },
  },
}
