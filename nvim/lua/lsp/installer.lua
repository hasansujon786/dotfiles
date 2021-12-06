local lsp_installer = require("nvim-lsp-installer")
-- if using cmp.nvim
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
local cmp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if cmp_ok then capabilities = cmp_nvim_lsp.update_capabilities(capabilities) end

lsp_installer.on_server_ready(function(server)
  local opts = {
    on_attach = require('lsp').on_attach,
    flags = {
      debounce_text_changes = 500,
    },
    capabilities = capabilities,
  }


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
