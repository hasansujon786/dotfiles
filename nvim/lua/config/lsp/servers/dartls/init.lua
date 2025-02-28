-- https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/buf.lua#L809
-- client.commands = {
-- "edit.sortMembers",
-- "edit.organizeImports",
-- "edit.fixAll",
-- "edit.sendWorkspaceEdit",
-- "refactor.perform",
-- "refactor.validate",
-- "dart.logAction",
-- "dart.refactor.convert_all_formal_parameters_to_named",
-- "dart.refactor.convert_selected_formal_parameters_to_named",
-- "dart.refactor.move_selected_formal_parameters_left",
-- "dart.refactor.move_top_level_to_file"
-- },

local run_code_action = function(cmds)
  return function()
    vim.lsp.buf.code_action({
      apply = true,
      context = { only = cmds, diagnostics = {} },
    })
  end
end
keymap('n', '<Plug>FlutterPkgToRelative', function()
  run_code_action({
    'refactor.convert.packageToRelativeImport',
    'refactor.convert.relativeToPackageImport',
  })()
  vim.fn['repeat#set'](t('<Plug>FlutterPkgToRelative'))
end)

---@class lsp.ServerConfig
local M = {
  lsp_attach = function(_, buffer)
    local function desc(d)
      return { desc = d, buffer = buffer }
    end
    -- lua require('project_run.utils').open_tab(vim.fn.getcwd(), 'adb connect 192.168.31.252 && flutter run')

    -- Custom code actions
    keymap('n', '<leader>a.', run_code_action({ 'source.fixAll' }), desc('Lsp: Fix all'))
    keymap('n', '<leader>ai', run_code_action({ 'source.organizeImports' }), desc('Lsp: Organize imports'))
    keymap('n', '<leader>am', '<Plug>FlutterPkgToRelative', desc('Lsp: Convert to a relative import'))
  end,
  opts = {
    settings = {
      dart = {
        showTodos = true,
        completeFunctionCalls = true,
        -- lineLength = 120,
        enableSnippets = false,
        -- analysisExcludedFolders = { '' },
        -- enableSdkFormatter = false,
      },
    },
  },
}

return M
