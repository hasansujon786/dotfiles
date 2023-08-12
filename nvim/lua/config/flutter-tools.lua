local ui = require('core.state').ui

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
      require('config.lsp.setup').on_attach(client, bufnr)

      vim.cmd([[command! PubInstall lua require('hasan.telescope.custom').pub_install()]])
      -- local opts = { noremap = true, silent = true, buffer = bufnr }
      -- keymap('n', '<F9>', ':silent !explorer C:\\Users\\hasan\\dotfiles\\scripts\\flutter_reload.ahk<CR>', opts)
    end,
    capabilities = require('config.lsp.setup').update_capabilities(),
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
    run_via_dap = true, -- use dap instead of a plenary job to run flutter apps
    register_configurations = function(paths)
      local dap = require('dap')

      dap.adapters.dart = {
        type = 'executable',
        command = 'node',
        args = { dap_adapter_path .. '/Dart-Code/out/dist/debug.js', 'flutter' },
      }
      dap.configurations.dart = {
        {
          type = 'dart',
          request = 'launch',
          name = 'Launch flutter',
          dartSdkPath = paths.dart_sdk,
          flutterSdkPath = paths.flutter_sdk,
          program = '${workspaceFolder}/lib/main.dart',
          cwd = '${workspaceFolder}',
        },
      }
    end,
  },
  widget_guides = {
    enabled = true,
  },
})
