return {
  setup = function(client, bufnr)
    require('config.lsp.util.setup').on_attach(client, bufnr)

    -- Custom keymap
    keymap(
      'n',
      '<leader>fc',
      '<Cmd>lua require("telescope").extensions.flutter.commands()<CR>',
      { desc = 'Flutter: Show commands', buffer = bufnr }
    )
    keymap('n', '<leader>fr', '<Cmd>FlutterRestart<CR>', { desc = 'Flutter: Lsp restart', buffer = bufnr })
    -- lua require('project_run.utils').open_tab(vim.fn.getcwd(), 'adb connect 192.168.31.252 && flutter run')

    command('FlutterLogOpen', function(_)
      local winFound = require('hasan.utils.win').focusWinIfExists('log')
      if not winFound then
        vim.cmd([[vertical 30new | b __FLUTTER_DEV_LOG__]])
      end
    end)

    require('config.lsp.servers.flutter.pub').setup()
  end,
}
