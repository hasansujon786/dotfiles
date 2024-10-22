local vscode = require('vscode')
local noSilent = { silent = false }

-- => Simple mappings -------------------------------
-- G command
keymap('n', 'go', '<cmd>lua require("vscode").action("editor.action.openLink")<CR>')

-- Folding
keymap('n', '<tab>', '<cmd>lua require("vscode").action("editor.toggleFold")<CR>') -- Toggle folds
keymap('n', 'za', '<cmd>lua require("vscode").action("editor.toggleFold")<CR>')
keymap('n', 'zc', '<cmd>lua require("vscode").action("editor.foldRecursively")<CR>')
keymap('n', 'zo', '<cmd>lua require("vscode").action("editor.unfoldRecursively")<CR>')
keymap('n', 'zC', '<cmd>lua require("vscode").action("editor.foldAll")<CR>')
keymap('n', 'zO', '<cmd>lua require("vscode").action("editor.unfoldAll")<CR>')
keymap('n', 'zR', '<cmd>lua require("vscode").action("editor.unfoldAll")<CR>')
keymap('n', 'zp', '<cmd>lua require("vscode").action("editor.gotoParentFold")<CR>')

-- => Navigation ------------------------------------
keymap({ 'n', 'x' }, ']d', '<cmd>lua require("vscode").action("editor.action.marker.next")<CR>')
keymap({ 'n', 'x' }, '[d', '<cmd>lua require("vscode").action("editor.action.marker.prev")<CR>')
keymap({ 'n', 'x' }, '[c', '<cmd>lua require("vscode").action("workbench.action.editor.previousChange")<CR>')
keymap({ 'n', 'x' }, ']c', '<cmd>lua require("vscode").action("workbench.action.editor.nextChange")<CR>')
keymap({ 'n', 'x' }, '<C-j>', '<cmd>lua require("vscode").action("workbench.action.navigateForward")<CR>')
keymap(
  'n',
  '<backspace>',
  '<cmd>lua require("vscode").action("workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup")<CR>'
)
-- Scroll
keymap('n', '<A-d>', '<c-d>')
keymap('n', '<A-u>', '<c-u>')
keymap('n', 'zh', '<cmd>lua require("vscode").action("scrollLeft")<CR>')
keymap('n', 'zl', '<cmd>lua require("vscode").action("scrollRight")<CR>')

-- => Search ----------------------------------------
-- stylua: ignore
keymap('n', '<A-/>', '<cmd>lua require("vscode").action("workbench.action.findInFiles",{args={query=vim.fn.expand("<cword>")}})<CR>')
keymap('x', '<A-/>', '<cmd>lua require("vscode").action("workbench.action.findInFiles")<CR>')

keymap({ 'n', 'x' }, '<C-l>', function()
  vscode.with_insert(function()
    vscode.action('editor.action.addSelectionToNextFindMatch')
  end)
end)

-- => LSP -------------------------------------------
keymap({ 'n', 'x' }, 'gd', '<cmd>lua require("vscode").action("editor.action.revealDefinition")<CR>')
keymap({ 'n', 'x' }, 'gr', '<cmd>lua require("vscode").action("editor.action.referenceSearch.trigger")<CR>')
keymap({ 'n', 'x' }, 'gm', '<cmd>lua require("vscode").action("editor.action.goToImplementation")<CR>')
keymap({ 'n', 'x' }, 'gy', '<cmd>lua require("vscode").action("editor.action.goToTypeDefinition")<CR>')
keymap({ 'n', 'x' }, 'gD', '<cmd>lua require("vscode").action("editor.action.revealDeclaration")<CR>')
keymap({ 'n', 'x' }, 'gR', '<cmd>lua require("vscode").action("references-view.findReferences")<CR>')

keymap({ 'n', 'x' }, 'gpd', '<cmd>lua require("vscode").action("editor.action.peekDefinition")<CR>')
keymap({ 'n', 'x' }, 'gpm', '<cmd>lua require("vscode").action("editor.action.peekImplementation")<CR>')
keymap({ 'n', 'x' }, 'gpy', '<cmd>lua require("vscode").action("editor.action.peekTypeDefinition")<CR>')
keymap({ 'n', 'x' }, 'gpD', '<cmd>lua require("vscode").action("editor.action.peekDeclaration")<CR>')

keymap({ 'n', 'x' }, 'g.', '<cmd>lua require("vscode").action("workbench.action.gotoSymbol")<CR>')

keymap('n', '<C-space>', '<cmd>lua require("vscode").action("editor.action.quickFix")<CR>')
keymap('i', '<C-space>', '<cmd>lua require("vscode").action("editor.action.triggerSuggest")<CR>')
keymap({ 'n', 'x' }, '<leader>ad', '<cmd>lua require("vscode").action("workbench.actions.view.problems")<CR>')
keymap({ 'n', 'x' }, '<leader>aa', '<cmd>lua require("vscode").action("editor.action.sourceAction")<CR>')

keymap('n', 'g<tab>', '<cmd>lua require("vscode").action("editor.action.smartSelect.expand")<CR>')
keymap('v', '<tab>', '<cmd>lua require("vscode").action("editor.action.smartSelect.expand")<CR>')
keymap('v', '<S-tab>', '<cmd>lua require("vscode").action("editor.action.smartSelect.shrink")<CR>')

-- => Leader commands -------------------------------
keymap('n', '<leader><leader>', '<cmd>lua require("vscode").action("workbench.action.quickOpen")<CR>')
keymap('n', '<leader>pp', '<cmd>lua require("vscode").action("workbench.action.openRecent")<CR>')
-- Save file
keymap({ 'n', 'x' }, '<leader>s', '<cmd>lua require("vscode").action("workbench.action.files.save")<CR>')
keymap({ 'n', 'x' }, '<leader>fxx', '<cmd>lua require("vscode").action("editor.action.trimTrailingWhitespace")<cr>')
keymap('n', '<leader>fs', '<cmd>lua require("vscode").action("editor.action.formatDocument")<CR>')
keymap('x', '<leader>fs', '<cmd>lua require("vscode").action("editor.action.formatSelection")<CR>')
-- open explorer
keymap('n', '<leader>ob', '<cmd>lua require("vscode").action("workbench.action.toggleSidebarVisibility")<CR>')
keymap('n', '<leader>op', '<cmd>lua require("vscode").action("workbench.view.explorer")<CR>')
keymap('n', '-', '<cmd>lua require("vscode").action("workbench.files.action.showActiveFileInExplorer")<CR>')
-- keymap('n', '<leader>oi', '<cmd>lua require("vscode").action("workbench.files.action.focusFilesExplorer")<CR>')
-- Toggles
keymap('n', '<leader>u', '<cmd>lua require("vscode").action("workbench.action.toggleZenMode")<CR>')
-- keymap('n', '<leader>tl', '<Cmd>setlocal cursorcolumn!<CR>') --
-- keymap('n', '<leader>tK', '<cmd>lua require("vscode").action("workbench.action.toggleStickyScroll")<CR>')
-- keymap('n', '<leader>r', ':set relativenumber!<CR>')
-- Git
keymap('n', '<leader>gg', '<cmd>lua require("vscode").action("workbench.view.scm")<CR>')
keymap('n', '<leader>g.', '<cmd>lua require("vscode").action("git.stage")<CR>')
keymap({ 'n', 'x' }, '<leader>gp', '<cmd>lua require("vscode").action("editor.action.dirtydiff.next")<CR>')
keymap({ 'n', 'x' }, '<leader>gr', '<cmd>lua require("vscode").action("git.revertSelectedRanges")<CR>')
keymap({ 'n', 'x' }, '<leader>gs', '<cmd>lua require("vscode").action("git.stageSelectedRanges")<CR>')
keymap({ 'n', 'x' }, '<leader>gd', '<cmd>lua require("vscode").action("git.viewChanges")<CR>')
-- keymap({ 'n', 'x' }, '<leader>gu', '<cmd>lua require("vscode").action("git.unstageSelectedRanges")<CR>')
-- Debugger
keymap({ 'n', 'x' }, '<leader>db', '<cmd>lua require("vscode").action("editor.debug.action.toggleBreakpoint")<CR>')
-- Editor commands
keymap({ 'n', 'v' }, '<leader>vc', '<cmd>lua require("vscode").action("notifications.clearAll")<CR>')

-- keymap('n', '<A-k>', '<Cmd>lua MoveCurrentline("Up")<CR>')
-- keymap('n', '<A-j>', '<Cmd>lua MoveCurrentline("Down")<CR>')
-- keymap('v', '<A-k>', '<Cmd>lua MoveVisualSelection("Up")<CR>')
-- keymap('v', '<A-j>', '<Cmd>lua MoveVisualSelection("Down")<CR>')
keymap('x', '<A-k>', [[:<C-U>exec "'<,'>move '<-" . (1+v:count1)<CR>gv]])
keymap('x', '<A-j>', [[:<C-U>exec "'<,'>move '>+" . (0+v:count1)<CR>gv]])
-- Jump between tabs
keymap('n', 'gl', '<cmd>lua require("vscode").action("workbench.action.nextEditorInGroup")<CR>')
keymap('n', 'gh', '<cmd>lua require("vscode").action("workbench.action.previousEditorInGroup")<CR>')
keymap('n', 'gL', '<cmd>lua require("vscode").action("workbench.action.lastEditorInGroup")<CR>')
keymap('n', 'gH', '<cmd>lua require("vscode").action("workbench.action.firstEditorInGroup")<CR>')

-- window management
keymap('n', '<leader>j', '<cmd>lua require("vscode").action("workbench.action.focusBelowGroup")<CR>')
keymap('n', '<leader>k', '<cmd>lua require("vscode").action("workbench.action.focusAboveGroup")<CR>')
keymap('n', '<leader>h', '<cmd>lua require("vscode").action("workbench.action.focusLeftGroup")<CR>')
keymap('n', '<leader>l', '<cmd>lua require("vscode").action("workbench.action.focusRightGroup")<CR>')
keymap('n', '<leader>q', '<cmd>lua require("vscode").action("workbench.action.closeActiveEditor")<CR>')
keymap('n', '<leader>ws', '<cmd>lua require("vscode").action("workbench.action.splitEditorDown")<CR>')
keymap('n', '<leader>wv', '<cmd>lua require("vscode").action("workbench.action.splitEditorRight")<CR>')
keymap('n', '<leader>wo', '<cmd>lua require("vscode").action("workbench.action.joinAllGroups")<CR>')
keymap('n', '<leader>ww', '<cmd>lua require("vscode").action("workbench.action.focusNextGroup")<CR>')
keymap('n', '<leader>wW', '<cmd>lua require("vscode").action("workbench.action.focusPreviousGroup")<CR>')
keymap('n', '\\', '<cmd>lua require("vscode").action("workbench.action.toggleEditorWidths")<CR>') -- zoom a vim pane
keymap('n', '<Bar>', '<cmd>lua require("vscode").action("workbench.action.evenEditorWidths")<CR>') -- even all windows

-- editor.action.goToReferences
-- editor.action.triggerSuggest

function MoveCurrentline(direction)
  local line = vim.fn.line('.')
  vim.fn.cursor(direction == 'Up' and line - 1 or line + 1, 0)
  vim.fn.VSCodeNotify('editor.action.moveLines' .. direction .. 'Action')
end
function MoveVisualSelection(direction)
  local cursorLine = vim.fn.line('v')
  local cursorStartLine = vim.fn.line('.')

  local startLine = cursorLine
  local endLine = cursorStartLine

  if direction == 'Up' then
    if startLine < endLine then
      local tmp = startLine
      startLine = endLine
      endLine = tmp
    end
  else -- == "Down"
    if startLine > endLine then
      local tmp = startLine
      startLine = endLine
      endLine = tmp
    end
  end

  -- move lines
  vim.fn.VSCodeCallRange('editor.action.moveLines' .. direction .. 'Action', startLine, endLine, 1)

  -- move visual selection
  if direction == 'Up' then
    if endLine > 1 then
      startLine = startLine - 1
      endLine = endLine - 1

      -- exit visual mode
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<esc>', true, false, true), 'x', true)

      -- select range
      vim.cmd('normal!' .. startLine .. 'GV' .. endLine .. 'G')
      -- vim.api.nvim_command(tostring(endLine)) -- move cursor
      -- vim.api.nvim_feedkeys("V", 'n', false) -- enter visual line mode
      -- vim.api.nvim_command(tostring(startLine)) -- move cursor
    end
  else -- == "Down"
    if endLine < vim.api.nvim_buf_line_count(0) then
      startLine = startLine + 1
      endLine = endLine + 1
    end

    -- exit visual mode
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<esc>', true, false, true), 'x', true)

    -- select range
    vim.cmd('normal!' .. startLine .. 'GV' .. endLine .. 'G')
  end
end
