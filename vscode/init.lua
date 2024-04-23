-- https://github.com/Axlefublr/dotfiles/blob/main/init.lua
-- https://github.com/microsoft/vscode-docs/blob/main/docs/getstarted/tips-and-tricks.md
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
local noSilent = { silent = false }
local keymap = function(mode, lhs, rhs, opts)
  local def_opts = { silent = true, noremap = true }
  opts = vim.tbl_deep_extend('force', def_opts, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- => Simple mappings -------------------------------
keymap('n', 'Q', 'q') -- Use Q to record macros
keymap({ 'n', 'v' }, 'q', '<ESC>:noh<CR>')
keymap({ 'n', 'v' }, '<CR>', ':<up>', noSilent) -- run last : command easily

keymap('x', '$', 'g_') -- A fix to select end of line
keymap('v', '.', ':norm.<cr>') -- map . in visual mode
keymap('x', '>', '>gv') -- Keep selection when indenting/outdenting.
keymap('x', '<', '<gv')

-- Comment or uncomment lines using Commentary
keymap({ 'n', 'x', 'o' }, 'gc', '<Plug>VSCodeCommentary')
keymap('n', 'gcc', '<Plug>VSCodeCommentaryLine')

-- G command
keymap('n', 'gB', '<Cmd>call VSCodeNotify("editor.action.openLink")<CR>')

-- Folding
keymap('n', '<tab>', '<Cmd>call VSCodeNotify("editor.toggleFold")<CR>') -- Toggle folds
keymap('n', 'za', '<Cmd>call VSCodeNotify("editor.toggleFold")<CR>')
keymap('n', 'zc', '<Cmd>call VSCodeNotify("editor.foldRecursively")<CR>')
keymap('n', 'zo', '<Cmd>call VSCodeNotify("editor.unfoldRecursively")<CR>')
keymap('n', 'zC', '<Cmd>call VSCodeNotify("editor.foldAll")<CR>')
keymap('n', 'zO', '<Cmd>call VSCodeNotify("editor.unfoldAll")<CR>')
keymap('n', 'zR', '<Cmd>call VSCodeNotify("editor.unfoldAll")<CR>')
keymap('n', 'zp', '<Cmd>call VSCodeNotify("editor.gotoParentFold")<CR>')

-- Custom pseudo-text object
keymap('x', 'aa', 'GoggV') -- Make vaa select the entire file
keymap('o', 'aa', ':<C-u>normal vaa<CR>') -- Make vaa select the entire file

-- => Yank and copy ---------------------------------
keymap('v', 'p', 'pgvy') -- Prevent selecting and pasting from overwriting what you originally copied.
keymap('v', 'y', 'ygv<Esc>') -- Keep cursor at the bottom of the visual selection after you yank it.
keymap('n', 'Y', 'y$') -- Ensure Y works similar to D,C.
keymap({ 'n', 'v' }, 'x', '"_x') -- Prevent x from overriding the clipboard.
keymap({ 'n', 'v' }, 'X', '"_X')
keymap('n', 'gV', '`[v`]')
-- Paste from current register/buffer in insert mode
-- imap <C-v> <C-R>*
-- cmap <C-v> <C-R>+
-- keymap({ 'i', 'c' }, '<A-p>', '<C-R>"', noSilent) -- Paste the last item from register

-- Easier system clipboard usage
keymap('v', '<Leader>y', '"+ygv<Esc>')
keymap('v', '<Leader>d', '"+d')
keymap({ 'n', 'v' }, '<Leader>p', '"+p')
keymap({ 'n', 'v' }, '<Leader>P', '"+P')

-- => Search ----------------------------------------
keymap('n', '<A-/>', "<Cmd>call VSCodeNotify('workbench.action.findInFiles', { 'query': expand('<cword>')})<CR>")

-- => LSP -------------------------------------------
keymap({ 'n', 'x' }, 'gd', '<Cmd>call VSCodeNotify("editor.action.revealDefinition")<CR>')
keymap({ 'n', 'x' }, 'gD', '<Cmd>call VSCodeNotify("editor.action.revealDeclaration")<CR>')
keymap({ 'n', 'x' }, 'gr', '<Cmd>call VSCodeNotify("editor.action.referenceSearch.trigger")<CR>')
keymap({ 'n', 'x' }, 'gR', '<Cmd>call VSCodeNotify("references-view.findReferences")<CR>')
keymap({ 'n', 'x' }, 'gp', '<Cmd>call VSCodeNotify("editor.action.peekDefinition")<CR>')
keymap({ 'n', 'x' }, 'gP', '<Cmd>call VSCodeNotify("editor.action.peekDeclaration")<CR>')
keymap({ 'n', 'x' }, 'go', '<Cmd>call VSCodeNotify("workbench.action.gotoSymbol")<CR>')

keymap('n', '<C-space>', '<Cmd>call VSCodeNotify("editor.action.quickFix")<CR>')
keymap('i', '<C-space>', '<Cmd>call VSCodeNotify("editor.action.triggerSuggest")<CR>')

-- => Leader commands -------------------------------
keymap('n', '<leader><leader>', '<Cmd>call VSCodeNotify("workbench.action.quickOpen")<CR>')
keymap('n', '<leader>pp', '<Cmd>call VSCodeNotify("workbench.action.openRecent")<CR>')
-- Save file
keymap('n', '<leader>s', '<Cmd>call VSCodeNotify("workbench.action.files.save")<CR>')
keymap('n', '<leader>fs', '<Cmd>call VSCodeNotify("editor.action.formatDocument")<CR>')
keymap('n', '<leader>fX', '<Cmd>call VSCodeNotify("editor.action.trimTrailingWhitespace")<CR>')
-- open Explorer
keymap('n', '<leader>0', '<Cmd>call VSCodeNotify("editor.action.formatDocument")<CR>')
keymap('n', '<leader>ob', '<Cmd>call VSCodeNotify("workbench.action.toggleSidebarVisibility")<CR>')
keymap('n', '<leader>op', '<Cmd>call VSCodeNotify("workbench.view.explorer")<CR>')
--Toggles
keymap('n', '<leader>tl', '<Cmd>setlocal cursorcolumn!<CR>') --
keymap('n', '<leader>tK', '<Cmd>call VSCodeNotify("workbench.action.toggleStickyScroll")<CR>')
keymap('n', '<leader>u', '<Cmd>call VSCodeNotify("workbench.action.toggleZenMode")<CR>')
-- keymap('n', '<leader>r', ':set relativenumber!<CR>')
-- Git
keymap('n', '<leader>g.', '<Cmd>call VSCodeNotify("git.stageAll")<CR>')
keymap('n', '<leader>gp', '<Cmd>call VSCodeNotify("editor.action.dirtydiff.next")<CR>')
keymap('n', '<leader>gr', '<Cmd>call VSCodeNotify("git.revertSelectedRanges")<CR>')
keymap('n', '<leader>gs', '<Cmd>call VSCodeNotify("git.stageSelectedRanges")<CR>')
-- keymap('n', '<leader>gu', '<Cmd>call VSCodeNotify("git.unstageSelectedRanges")<CR>')

-- => Navigation ------------------------------------
keymap('n', '<A-d>', '<c-d>')
keymap('n', '<A-u>', '<c-u>')

-- keymap('n', '<A-k>', '<Cmd>lua MoveCurrentline("Up")<CR>')
-- keymap('n', '<A-j>', '<Cmd>lua MoveCurrentline("Down")<CR>')
-- keymap('v', '<A-k>', '<Cmd>lua MoveVisualSelection("Up")<CR>')
-- keymap('v', '<A-j>', '<Cmd>lua MoveVisualSelection("Down")<CR>')
keymap('v', '<A-k>', [[:<C-U>exec "'<,'>move '<-" . (1+v:count1)<CR>gv]])
keymap('v', '<A-j>', [[:<C-U>exec "'<,'>move '>+" . (0+v:count1)<CR>gv]])
-- Jump between tabs
keymap('n', 'gl', '<Cmd>call VSCodeNotify("workbench.action.nextEditorInGroup")<CR>')
keymap('n', 'gh', '<Cmd>call VSCodeNotify("workbench.action.previousEditorInGroup")<CR>')
keymap('n', 'gL', '<Cmd>call VSCodeNotify("workbench.action.lastEditorInGroup")<CR>')
keymap('n', 'gH', '<Cmd>call VSCodeNotify("workbench.action.firstEditorInGroup")<CR>')

-- window management
keymap('n', '<leader>j', '<Cmd>call VSCodeNotify("workbench.action.focusBelowGroup")<CR>')
keymap('n', '<leader>k', '<Cmd>call VSCodeNotify("workbench.action.focusAboveGroup")<CR>')
keymap('n', '<leader>h', '<Cmd>call VSCodeNotify("workbench.action.focusLeftGroup")<CR>')
keymap('n', '<leader>l', '<Cmd>call VSCodeNotify("workbench.action.focusRightGroup")<CR>')
keymap('n', '<leader>q', '<Cmd>call VSCodeNotify("workbench.action.closeActiveEditor")<CR>')
keymap('n', '<leader>ws', '<Cmd>call VSCodeNotify("workbench.action.splitEditorDown")<CR>')
keymap('n', '<leader>wv', '<Cmd>call VSCodeNotify("workbench.action.splitEditorRight")<CR>')
keymap('n', '<leader>wo', '<Cmd>call VSCodeNotify("workbench.action.joinAllGroups")<CR>')
keymap('n', '<leader>ww', '<Cmd>call VSCodeNotify("workbench.action.focusNextGroup")<CR>')
keymap('n', '<leader>wW', '<Cmd>call VSCodeNotify("workbench.action.focusPreviousGroup")<CR>')
keymap('n', '\\', '<Cmd>call VSCodeNotify("workbench.action.toggleEditorWidths")<CR>') -- zoom a vim pane
keymap('n', '<Bar>', '<Cmd>call VSCodeNotify("workbench.action.evenEditorWidths")<CR>') -- even all windows

keymap('n', '[c', '<Cmd>call VSCodeNotify("workbench.action.editor.previousChange")<CR>')
keymap('n', ']c', '<Cmd>call VSCodeNotify("workbench.action.editor.nextChange")<CR>')
keymap('n', '<C-j>', '<Cmd>call VSCodeNotify("workbench.action.navigateForward")<CR>')

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
