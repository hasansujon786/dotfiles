local function init_lspconfig()
  local lspconfig = require('lspconfig')
  require('lspconfig.ui.windows').default_options.border = 'rounded'

  -- default lsp configs
  local lsp_extras = require('config.lsp.util.extras')
  local global_conf = lsp_extras.get_global_conf()

  for key_server_name, _ in pairs(global_conf.essential_servers) do
    local local_conf = lsp_extras.get_server_conf(key_server_name)
    local opts = nil

    if local_conf == nil or local_conf.opts == nil then
      opts = global_conf.default_opts
    else
      opts = require('hasan.utils').merge(global_conf.default_opts, local_conf.opts)
    end

    lspconfig[key_server_name].setup(opts)
  end
end

return {
  'neovim/nvim-lspconfig',
  lazy = true,
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    { 'folke/neodev.nvim', lazy = true },
    { 'hrsh7th/cmp-nvim-lsp', lazy = true, module = 'cmp_nvim_lsp' },
    { 'williamboman/mason-lspconfig.nvim', lazy = true, module = 'mason-lspconfig' },
    { 'nvimtools/none-ls.nvim' },
    {
      'williamboman/mason.nvim',
      cmd = { 'Mason', 'MasonInstall', 'MasonUpdate' },
      opts = { max_concurrent_installers = 3, ui = { border = 'none', height = 0.8 } },
      config = function(_, opts)
        require('mason').setup(opts)
        init_lspconfig()
        require('config.lsp.util.diagnosgic').setup()
      end,
      build = ':MasonUpdate',
    },
  },
}
