local ui = require('state').ui
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require('flutter-tools').setup({
  lsp = {
    color = { -- show the derived colours for dart variables
      enabled = true,
      background = false,
      foreground = false,
      virtual_text = true,
      virtual_text_str = '■',
    },
    on_attach = function(client, bufnr)
      require('lsp').on_attach(client, bufnr)
    end,
    capabilities = capabilities,
    settings = {
      showTodos = true,
      completeFunctionCalls = true,
      analysisExcludedFolders = { '' },
      lineLength = 120,
      -- enableSdkFormatter = false,
    },
  },
  ui = {
    border = ui.border.style,
  },
  debugger = {
    enabled = false,
  },
  widget_guides = {
    enabled = true,
  },
})
