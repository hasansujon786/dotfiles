local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true;


-- alternatively you can override the default configs
require('flutter-tools').setup {
  lsp = {
    on_attach = function (client, bufnr)
      local opts = { noremap=true, silent=false }
      local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
      require('lsp').on_attach(client, bufnr)

      buf_set_keymap('n', '<Leader>fr', '<Cmd>lua require("hasan.project_run").open_tab(vim.fn.getcwd(), "adb connect 192.168.31.252 && flutter run")<CR>', opts)
      buf_set_keymap('n', '<Leader>fc', '<Cmd>lua require("telescope").extensions.flutter.commands()<CR>', opts)
      vim.cmd[[
        xnoremap at abob
        onoremap at :normal vat<CR>
        xnoremap it iwl%o
        onoremap it :normal vit<CR>
      ]]
    end,
    capabilities = capabilities,
    settings = {
      showTodos = true,
      completeFunctionCalls = true,
      analysisExcludedFolders = {''},
      lineLength = 120,
      -- enableSdkFormatter = false,
    }
  },
  ui = {
    border = 'rounded',
  },
  debugger = {
    enabled = false,
  },
  widget_guides = {
    enabled = true,
  },
}
