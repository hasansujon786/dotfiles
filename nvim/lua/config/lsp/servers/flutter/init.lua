return {
  setup = function(client, bufnr)
    require('config.lsp.util.setup').on_attach(client, bufnr)

    local function desc(d)
      return { desc = d, buffer = bufnr }
    end

    -- stylua: ignore
    keymap('n', '<leader>fc', '<Cmd>lua require("telescope").extensions.flutter.commands()<CR>', desc('Flutter: Show commands'))
    keymap('n', '<leader>fr', '<Cmd>FlutterRestart<CR>', desc('Flutter: Lsp restart'))
    keymap('n', '<leader>dd', '<Cmd>FlutterLogOpen<CR>', desc('Flutter: Open log'))
    -- lua require('project_run.utils').open_tab(vim.fn.getcwd(), 'adb connect 192.168.31.252 && flutter run')

    command('FlutterLogOpen', function(_)
      require('hasan.nebulous').mark_as_alternate_win()
      local winFound = require('hasan.utils.win').focusWinIfExists('log')
      if not winFound then
        vim.cmd([[split 26new | b __FLUTTER_DEV_LOG__]])
      end
    end)

    require('config.lsp.servers.flutter.pub').setup()
  end,
}
