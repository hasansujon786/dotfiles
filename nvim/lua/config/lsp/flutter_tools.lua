return {
  'akinsho/flutter-tools.nvim',
  lazy = true,
  ft = { 'dart' },
  config = function()
    require('flutter-tools').setup({
      ui = { border = require('hasan.core.state').ui.border.style },
      widget_guides = { enabled = true },
      lsp = {
        color = { -- show the derived colours for dart variables
          enabled = true,
          background = false,
          foreground = false,
          virtual_text = true,
          virtual_text_str = '■',
        },
        on_attach = require('config.lsp.util.servers.flutter').setup,
        capabilities = require('config.lsp.util.setup').update_capabilities('flutter_tools'),
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
      debugger = {
        enabled = false,
        run_via_dap = true, -- use dap instead of a plenary job to run flutter apps
        register_configurations = function(paths)
          local dap = require('dap')

          dap.adapters.dart = {
            type = 'executable',
            command = 'node',
            args = { path_mason .. '/packages/dart-debug-adapter/extension/out/dist/debug.js', 'flutter' },
            -- args = { dap_adapter_path .. '/Dart-Code/out/dist/debug.js', 'flutter' },
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
    })
  end,
}
