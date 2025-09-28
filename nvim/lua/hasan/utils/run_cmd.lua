local M = {}

local wincmds = {
  ['wincmd h'] = 'workbench.action.navigateLeft',
  ['wincmd j'] = 'workbench.action.navigateDown',
  ['wincmd k'] = 'workbench.action.navigateUp',
  ['wincmd l'] = 'workbench.action.navigateRight',

  ['wincmd s'] = 'workbench.action.splitEditorDown',
  ['wincmd v'] = 'workbench.action.splitEditorRight',

  ['wincmd p'] = 'workbench.action.focusLastEditorGroup',
  ['wincmd w'] = 'workbench.action.focusNextGroup',
  ['wincmd W'] = 'workbench.action.focusPreviousGroup',

  Quit = 'workbench.action.closeActiveEditor',
  Bufdelete = 'workbench.action.closeActiveEditor',

  only = {
    'runCommands',
    opts = [[{args = { commands = { 'workbench.action.closeEditorsInOtherGroups', 'workbench.action.closeOtherEditors', 'workbench.action.focusActiveEditorGroup' }}}]],
  },
  ['tabonly'] = 'workbench.action.closeOtherEditors',
  ['wincmd ='] = 'workbench.action.evenEditorWidths',
}

function M.run_cmd(wincmd)
  if vim.g.vscode then
    local cmd = wincmds[wincmd]
    if not cmd then
      return '<Cmd>' .. 'echo "hello"' .. '<CR>'
    end

    if type(cmd) == 'table' then
      local opts = cmd.opts
      cmd = cmd[1]
      local x = '<Cmd>lua require("vscode").action("' .. cmd .. '", ' .. opts .. ')<CR>'
      return x
    end

    return '<Cmd>lua require("vscode").action("' .. cmd .. '")<CR>'
  end

  return '<Cmd>' .. wincmd .. '<CR>'
end

return M
