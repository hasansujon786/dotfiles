vim.api.nvim_create_user_command('LspInstallEssentials', require('lsp.util').install_essential_servers, {})
require('nvim-lsp-installer').setup({ ensure_installed = { 'sumneko_lua' } })
local lspconfig = require('lspconfig')

local opts = {
  on_attach = require('lsp').on_attach,
  flags = {
    debounce_text_changes = 500,
  },
  capabilities = require('lsp.util').update_capabilities(),
}

for _, server_name in pairs(_G.lsp_installer_essential_servers) do
  if server_name == 'sumneko_lua' then
    lspconfig[server_name].setup(require('hasan.utils').merge(opts, {
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim', 'jit', 'keymap', 'P' },
          },
        },
      },
    }))
  else
    lspconfig[server_name].setup(opts)
  end
end
