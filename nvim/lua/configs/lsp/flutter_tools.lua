return {
  'akinsho/flutter-tools.nvim',
  lazy = true,
  ft = { 'dart' },
  opts = {
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
      on_attach = function(client, bufnr)
        require('config.lsp.setup').on_attach(client, bufnr)

        -- Custom keymap
        keymap(
          'n',
          '<leader>fc',
          '<Cmd>lua require("telescope").extensions.flutter.commands()<CR>',
          { desc = 'Flutter: Show commands', buffer = bufnr }
        )
        keymap('n', '<leader>fr', '<Cmd>FlutterRestart<CR>', { desc = 'Flutter: Lsp restart', buffer = bufnr })
        -- lua require('project_run.utils').open_tab(vim.fn.getcwd(), 'adb connect 192.168.31.252 && flutter run')

        -- Commands
        command('PubInstall', function(_)
          require('hasan.telescope.custom').pub_install()
        end)
        command('FlutterLogOpen', function(_)
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
  },
}
