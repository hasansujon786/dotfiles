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
    args = {
      commands = {
        'workbench.action.closeEditorsInOtherGroups',
        'workbench.action.closeOtherEditors',
        'workbench.action.focusActiveEditorGroup',
      },
    },
  },
  ['tabonly'] = 'workbench.action.closeOtherEditors',
  ['wincmd ='] = 'workbench.action.evenEditorWidths',
}

function M.run_cmd(wincmd)
  if vim.g.vscode then
    local cmd, args = wincmds[wincmd], nil
    if not cmd then
      return
    end

    if type(cmd) == 'table' then
      args = cmd.args
      cmd = cmd[1]
    end

    return require('vscode').action(cmd, { args = args })
  end

  vim.cmd(wincmd)
end

return M
