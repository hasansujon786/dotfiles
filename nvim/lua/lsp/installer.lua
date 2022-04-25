require('nvim-lsp-installer').on_server_ready(function(server)
  local opts = {
    on_attach = require('lsp').on_attach,
    flags = {
      debounce_text_changes = 500,
    },
    capabilities = require('lsp.util').update_capabilities(),
  }

  if server.name == 'sumneko_lua' then
    opts.settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim', 'jit', 'keymap', 'P' },
        },
      },
    }
  end

  -- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
  server:setup(opts)
  local autocmd = [[ do User LspAttachBuffers ]]
  vim.cmd(autocmd)
end)

vim.api.nvim_create_user_command('LspInstallEssentials', require('lsp.util').install_essential_servers, {})
