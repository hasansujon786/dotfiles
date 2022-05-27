local ui = require('state').ui

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
      -- local opts = { noremap = true, silent = true, buffer = bufnr }
      -- keymap('n', '<F9>', ':silent !explorer C:\\Users\\hasan\\dotfiles\\scripts\\flutter_reload.ahk<CR>', opts)
    end,
    capabilities = require('lsp.util').update_capabilities(),
    -- see the link below for details on each option:
    -- https://github.com/dart-lang/sdk/blob/master/pkg/analysis_server/tool/lsp_spec/README.md#client-workspace-configuration
    settings = {
      showTodos = true,
      completeFunctionCalls = true,
      lineLength = 120,
      enableSnippets = false,
      -- analysisExcludedFolders = { '' },
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
