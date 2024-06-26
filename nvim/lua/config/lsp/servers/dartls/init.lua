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

local function lsp_command(buffer, cmd)
  return function()
    local arg1 = { path = vim.api.nvim_buf_get_name(buffer) }
    local action = { command = cmd, arguments = { arg1 } }
    require('config.lsp.util.extras').execute(action, buffer, function(err)
      if err then
        require('hasan.utils.logger').Logger:error(err)
      end
    end)
  end
end
keymap('n', '<Plug>FlutterPkgToRelative', function()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = {
        'refactor.convert.packageToRelativeImport',
        'quickfix.convert.toRelativeImport.multi',
        -- 'quickfix.convert.toRelativeImport',
      },
      diagnostics = {},
    },
  })
  vim.fn['repeat#set'](t('<Plug>FlutterPkgToRelative'))
end)
local fix_all = function()
  vim.lsp.buf.code_action({
    apply = true,
    context = { only = { 'source.fixAll' }, diagnostics = {} },
  })
end

---@type ServerConfig
return {
  setup = function(_, buffer)
    local function desc(d)
      return { desc = d, buffer = buffer }
    end
    -- lua require('project_run.utils').open_tab(vim.fn.getcwd(), 'adb connect 192.168.31.252 && flutter run')

    -- Custom code actions
    keymap('n', '<leader>a.', fix_all, desc('Lsp: fix all'))
    keymap('n', '<leader>ai', lsp_command(buffer, 'edit.organizeImports'), desc('Lsp: organize imports'))
    keymap('n', '<leader>am', '<Plug>FlutterPkgToRelative', desc('Lsp: organize imports'))
  end,
}
