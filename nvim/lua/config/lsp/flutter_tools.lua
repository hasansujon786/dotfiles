return {
  'nvim-flutter/flutter-tools.nvim',
  lazy = true,
  ft = { 'dart' },
  cmd = { 'FlutterRun' },
  event = { 'BufReadPre pubspec.yaml' },
  keys = {
    {
      '<leader>fc',
      function()
        require('config.lsp.servers.dartls.run_commmands').commands()
      end,
      ft = { 'yaml', 'dart', 'log' },
      desc = 'Flutter: Show commands',
    },
  },
  config = function()
    require('flutter-tools').setup({
      ui = { border = require('core.state').ui.border.style },
      widget_guides = { enabled = true },
      fvm = true,
      lsp = {
        capabilities = require('config.lsp.util.setup').update_capabilities('flutter_tools'),
        -- see the link below for details on each option:
        -- https://github.com/dart-lang/sdk/blob/master/pkg/analysis_server/tool/lsp_spec/README.md#client-workspace-configuration
        settings = require('config.lsp.servers.dartls').opts.settings.dart,
      },
      dev_log = {
        enabled = true,
        notify_errors = false,
        -- open_cmd = 'botright 5split',
        open_cmd = '5split',
        focus_on_open = true,
      },
      debugger = {
        enabled = true,
        run_via_dap = true, -- use dap instead of a plenary job to run flutter apps
        register_configurations = function(paths)
          require('dap').adapters.dart = {
            type = 'executable',
            command = 'flutter', -- or full path to your flutter binary
            args = { 'debug-adapter' },
          }

          require('dap').configurations.dart = {
            {
              type = 'dart',
              request = 'launch',
              name = 'Launch Flutter',
              program = '${workspaceFolder}/lib/main.dart',
              cwd = '${workspaceFolder}',
              -- dartSdkPath = paths.dart_sdk,
              -- flutterSdkPath = paths.flutter_sdk,
              -- toolArgs = { '-d', 'Edge' },
              --skipFiles = ["**/node_modules/**", "!**/node_modules/my-module/**"]
            },
          }
        end,
      },
    })

    augroup('MY_FLUTTER_AUGROUP')(function(autocmd)
      autocmd({ 'FileType' }, 'setlocal nonumber norelativenumber signcolumn=no', { pattern = 'log' })
      autocmd({ 'BufWinEnter', 'WinEnter' }, 'normal Gzt', { pattern = '__FLUTTER_DEV_LOG__' })
      autocmd('User', function()
        vim.lsp.semantic_tokens.force_refresh()
      end, { pattern = 'LspProgressUpdate', once = true })
    end)
  end,
  dependencies = {
    {
      'akinsho/pubspec-assist.nvim',
      dependencies = 'nvim-lua/plenary.nvim',
      opts = {},
    },
  },
}
