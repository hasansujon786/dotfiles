return {
  setup = function(client, bufnr)
    require('config.lsp.util.setup').on_attach(client, bufnr)

    local function desc(d)
      return { desc = d, buffer = bufnr }
    end
    -- lua require('project_run.utils').open_tab(vim.fn.getcwd(), 'adb connect 192.168.31.252 && flutter run')

    -- Custom code actions
    -- stylua: ignore start
    keymap('n', '<leader>ai', "<cmd>lua require('config.lsp.servers.flutter.code_action').organize_imports_async()<CR>", desc('Lsp: organize imports'))
    keymap('n', '<Plug>FlutterPkgToRelative', "<cmd>lua require('config.lsp.servers.flutter.code_action').package_to_relative_import()<CR>")
    keymap('n', '<leader>am', '<Plug>FlutterPkgToRelative', desc('Lsp: relative import'))
    -- stylua: ignore end
  end,
}
