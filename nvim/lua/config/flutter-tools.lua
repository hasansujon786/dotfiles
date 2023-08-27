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

      create_command('PubInstall', function(_)
        require('hasan.telescope.custom').pub_install()
      end)
      create_command('FlutterLogOpen', function(_)
        local winFound = require('hasan.utils.win').focusWinIfExists('log')
        if not winFound then
          vim.cmd([[vertical 30new | b __FLUTTER_DEV_LOG__]])
        end
      end)
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
