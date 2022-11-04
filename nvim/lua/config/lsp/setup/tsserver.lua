local lspconfig = require('lspconfig')

lspconfig.tsserver.setup {
  on_attach = require('config.lsp.setup').on_attach,
  flags = {
    debounce_text_changes = 150,
  }
}
