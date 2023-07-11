local lspconfig = require('lspconfig')
require('lspconfig.ui.windows').default_options.border = 'rounded'
require('mason').setup({ max_concurrent_installers = 3, ui = { border = 'none', height = 0.8 } })
require('mason-lspconfig').setup()
require('config.lsp.diagnosgic').setup()
require('config.lsp.null-ls')

local my_config = require('config.lsp.lsp-config')
for server_name, server_config in pairs(my_config.essential_servers) do
  if server_config[2] == nil then
    lspconfig[server_name].setup(my_config.default_opts)
  else
    lspconfig[server_name].setup(require('hasan.utils').merge(my_config.default_opts, server_config[2]))
  end
end
