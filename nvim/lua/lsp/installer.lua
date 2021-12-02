local lsp_installer = require("nvim-lsp-installer")
lsp_installer.on_server_ready(function(server)
  local opts = {
    on_attach = require('lsp').on_attach,
    flags = {
      debounce_text_changes = 500,
    },
  }

  -- if using cmp.nvm
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  local status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  if status_ok then
    opts.capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
  else
    opts.capabilities = capabilities
  end

  -- (optional) Customize the options passed to the server
  -- if server.name == "tsserver" then
  --     opts.root_dir = function() ... end
  -- end

  if server.name == "sumneko_lua" then
    opts.settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim' }
        }
      }
    }
  end

  -- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
  server:setup(opts)
  vim.cmd [[ do User LspAttachBuffers ]]
end)
vim.cmd[[command! LspInstallEssentials lua require("lsp.util").install_essential_servers()]]
