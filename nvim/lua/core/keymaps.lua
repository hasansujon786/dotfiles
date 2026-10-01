vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local n, nx = { 'n' }, { 'n', 'x' }
local is_vscode = vim.g.vscode ~= nil

if not is_vscode then
  require('hasan.pseudo-text-objects')
end

local M = {}

function M.disable_keys()
  if vim.fn.has('nvim-0.11') == 1 then
    local keys_to_del = {
      -- { 'gra', mode = nx },
      -- 'grn',
      -- 'grr',
      -- 'gri',
      -- 'grt',
    }
    for _, key in ipairs(keys_to_del) do
      if type(key) == 'string' then
        pcall(vim.keymap.del, 'n', key)
      else
        pcall(vim.keymap.del, key.mode or 'n', key[1])
      end
    end
  end
end

function M.edit_alternate_file()
  require('vscode').action('runCommands', {
    args = { commands = { 'workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup', 'list.select' } },
  })
end

function M.uncomment_block()
  require('vim._comment').textobject()
  feedkeys('gc')
end

function M.comment_at(move)
  return function()
    local lhs, rhs = require('hasan.utils.buffer').current_commentstring():match('^(.-)%%s(.*)$')
    local shiftstr = string.rep(vim.keycode('<Left>'), #rhs)
    vim.fn.feedkeys(move .. lhs .. rhs .. shiftstr)
  end
end

function M.foldWithLevel(level)
  return function()
    require('vscode').action('runCommands', { args = { commands = { 'editor.unfoldAll', level } } })
  end
end

function M.do_open(uri)
  local cmd, err = vim.ui.open(uri)
  local rv = cmd and cmd:wait(1000) or nil
  if cmd and rv and rv.code ~= 0 then
    err = ('vim.ui.open: command %s (%d): %s'):format(
      (rv.code == 124 and 'timeout' or 'failed'),
      rv.code,
      vim.inspect(cmd.cmd)
    )
  end

  if err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end

function M._open()
  M.do_open(vim.fn.expand('<cfile>'))
end

function M._open_v()
  local lines = vim.fn.getregion(vim.fn.getpos('.'), vim.fn.getpos('v'), { type = vim.fn.mode() })
  M.do_open(table.concat(vim.iter(lines):map(vim.trim):totable())) -- Trim whitespace on each line and concatenate.
end

function M.multi_cursor(cmd)
  return function()
    require('vscode').with_insert(function()
      require('vscode').action(cmd)
    end)
  end
end

-- stylua: ignore
maps({
  -----------------------------------------------------------------------------
  -- Basic Editing
  -----------------------------------------------------------------------------
  { 'q', '<esc><cmd>noh<CR>', mode = nx },
  { '<CR>', ':<up>', mode = nx, desc = 'Run last command easily', silent = false },
  { 'n', 'nzz', mode = nx, remap = true, desc = 'Repeat search forward' }, -- n
  { 'N', 'Nzz', mode = nx, remap = true, desc = 'Repeat search backward' }, -- n
  { "'", '`', mode = nx, remap = true, desc = 'Jump to mark' },
  { 'p', 'pgvy', mode = 'v' },
  { 'y', 'ygv<Esc>', mode = 'v', desc = 'Keep cursor position' },
  { 'gV', '`[v`]', desc = 'Select last yanked text' },
  { 'x', '"_x', mode = nx, desc = 'Delete without yanking' },
  { 'X', '"_X', mode = nx, desc = 'Delete without yanking' },
  { '$', 'g_', mode = 'x', desc = 'Select to end of line' },
  { '>', '>gv', mode = 'v', desc = 'Keep selection after indent' },
  { '<', '<gv', mode = 'v', desc = 'Keep selection after outdent' },

  -----------------------------------------------------------------------------
  -- Clipboard & Registers
  -----------------------------------------------------------------------------
  { '<leader>y', '"+y', mode = 'n', desc = 'Yank to system clipboard' },
  { '<leader>y', '"+ygv<Esc>', mode = 'v', desc = 'Yank to system clipboard' },
  { '<leader>ip', '"+p', mode = nx, desc = 'Paste from system clipboard' },
  { '<leader>iP', '"+P', mode = nx, desc = 'Paste from system clipboard' },

  -- n
  { '<C-v>', '<C-R>+', mode = { 'i', 'c' }, desc = 'Paste from system clipboard', silent = false },
  { '<C-g><C-v>', '<C-v>', mode = { 'i', 'c' }, desc = 'Literal paste', silent = false },
  { '<A-p>', '<C-R>"', mode = { 'i' }, desc = 'last deleted, changed or yanked content' },
  { '<c-r><c-r>', '<C-R>"', mode = { 'i', 'c' }, desc = 'last deleted, changed or yanked content' },

  -----------------------------------------------------------------------------
  -- Comments
  -----------------------------------------------------------------------------
  { 'gcu', M.uncomment_block, desc = 'Uncomment block' },
  { 'gc/', M.uncomment_block, desc = 'Uncomment block' },
  { 'gcO', M.comment_at('O'), desc = 'Comment above' },
  { 'gco', M.comment_at('o'), desc = 'Comment below' },
  { 'gcI', M.comment_at('I'), desc = 'Comment at line start' },
  { 'gcA', M.comment_at('A '), desc = 'Comment at line end' },

  { 'a/', '<cmd>lua require("vim._comment").textobject()<CR>', mode = 'o', desc = 'Comment textobject' },
  { 'a/', '<Esc><cmd>lua require("vim._comment").textobject()<CR>', mode = 'x', desc = 'Comment textobject' },

  -- TODO: not working but working in vscode
  { '<C-_>', 'mz_gcc`z', mode = 'n', remap = true, desc = 'Toggle comment' },
  { '<C-_>', '<Esc>_gccgi', mode = 'i', remap = true, desc = 'Toggle comment' },
  { '<C-_>', 'mz_gcgv`z', mode = 'v', remap = true, desc = 'Toggle comment' },

  -----------------------------------------------------------------------------
  -- Search & Replace
  -----------------------------------------------------------------------------
  { 'cm', ':%s/<C-r>///g<Left><Left>', desc = 'Substitute with prompt', silent = false },
  { 'dm', ':%s/<C-r>///g<CR>', desc = 'Delete matches' },
  { 'dM', ':%g/<C-r>//d<CR>', desc = 'Delete matching lines' },
  { '<leader>cw', '<cmd>lua require("hasan.widgets.inputs").substitute_word()<CR>', mode = nx, desc = 'Substitute word' },

  { 'z/', '/\\%><C-r>=line("w0")-1<CR>l\\%<<C-r>=line("w$")+1<CR>l', desc = 'Search in viewport', silent = false },
  { 'z/', '<Esc>/\\%V', mode = 'x', desc = 'Search in selection', silent = false },

  { 'gB', M._open, desc = 'Open URI under cursor' },
  { 'gB', M._open_v, mode = 'x', desc = 'Open URI under selection' },
  { 'gG', '<cmd>Google<CR>', mode = nx, desc = 'Search Google' }, -- n
  { 'gW', '<cmd>Translate<CR>', mode = nx, desc = 'Translate' }, -- n

  -----------------------------------------------------------------------------
  -- Folding
  -----------------------------------------------------------------------------
  { 'zuu', '0vai:foldclose!<CR>zazt', mode = nx, remap = true, desc = 'Fold context' },
  { 'zu', ':foldclose!<CR>zazt', mode = nx, remap = true, desc = 'Fold context' },
  { '<Tab>', 'za', mode = nx, desc = 'Toggle fold', code = '<cmd>lua require("vscode").action("editor.toggleFold")<CR>' },
  { '<S-Tab>', 'zA', mode = nx, desc = 'Toggle recursive fold', code = '<cmd>lua require("vscode").action("editor.toggleFoldRecursively")<CR>' },
  { 'z.', '<cmd>%foldclose<CR>zb', mode = nx, desc = 'Fold all', code = M.foldWithLevel('editor.foldLevel1') },
  { 'z;', '<cmd>lua require("hasan.utils.fold").close_level(2)<CR>zb', mode = nx, desc = 'Fold level 1', code = M.foldWithLevel('editor.foldLevel2') },

  { 'za', '<cmd>lua require("vscode").action("editor.toggleFold")<CR>', desc = 'Toggle fold', code = true },
  { 'zc', '<cmd>lua require("vscode").action("editor.foldRecursively")<CR>', desc = 'Fold recursively', code = true },
  { 'zC', '<cmd>lua require("vscode").action("editor.foldAll")<CR>', desc = 'Fold all' },
  { 'zM', '<cmd>lua require("vscode").action("editor.foldRecursively")<CR>', desc = 'Fold recursively', code = true },
  { 'zM', '<cmd>lua require("vscode").action("editor.foldAll")<CR>', desc = 'Fold all', code = true },
  { 'zo', '<cmd>lua require("vscode").action("editor.unfoldRecursively")<CR>', desc = 'Unfold recursively', code = true },
  { 'zO', '<cmd>lua require("vscode").action("editor.unfoldAll")<CR>', desc = 'Unfold all', code = true },
  { 'zr', '<cmd>lua require("vscode").action("editor.unfoldRecursively")<CR>', desc = 'Unfold recursively', code = true },
  { 'zR', '<cmd>lua require("vscode").action("editor.unfoldAll")<CR>', desc = 'Unfold all', code = true },
  { 'zp', '<cmd>lua require("vscode").action("editor.gotoParentFold")<CR>', desc = 'Go to parent fold', code = true },

  -----------------------------------------------------------------------------
  -- Navigation & Scrolling
  -----------------------------------------------------------------------------
  { 'j', 'v:count == 0 ? "gj" : "j"', expr = true, remap = false, desc = 'Move cursor down' },
  { 'k', 'v:count == 0 ? "gk" : "k"', expr = true, remap = false, desc = 'Move cursor up' },
  { '<BS>', '<C-^>', desc = 'Edit alternate file', mode = nx, code = M.edit_alternate_file, },
  { '<C-j>', '<C-i>', mode = nx, remap = false, code = '<cmd>lua require("vscode").action("workbench.action.navigateForward")<CR>' },
  { 'g<BS>', '<C-w><C-p>', mode = nx },

  { '<A-u>', '<C-u>', mode = nx, remap = true, desc = 'Scroll up' }, -- n
  { '<A-d>', '<C-d>', mode = nx, remap = true, desc = 'Scroll down' },
  { '<A-o>', '<C-d>', remap = true, desc = 'Scroll window', mode = nx },
  { '<PageUp>', '<C-u>', mode = nx, remap = true },
  { '<PageDown>', '<C-d>', mode = nx, remap = true },
  { '<A-f>', '<C-f>', mode = nx, remap = true },
  { '<A-b>', '<C-b>', mode = nx, remap = true },
  { '<A-y>', '<C-y>', mode = nx, remap = true },
  { '<A-e>', '<C-e>', mode = nx, remap = true },
  { '<A-h>', '20zh', mode = nx },
  { '<A-l>', '20zl', mode = nx },

  -----------------------------------------------------------------------------
  -- Explorer
  -----------------------------------------------------------------------------
  { '<leader>op', '<cmd>lua require("vscode").action("workbench.view.explorer")<CR>', code = true },
  { '-', '<cmd>lua require("vscode").action("workbench.files.action.showActiveFileInExplorer")<CR>', code = true },

  -----------------------------------------------------------------------------
  -- Git
  -----------------------------------------------------------------------------
  { '<leader>gg', '<cmd>lua require("vscode").action("workbench.view.scm")<CR>', code = true },
  { '<leader>g.', '<cmd>lua require("vscode").action("git.stage")<CR>', code = true },
  { '<leader>gp', '<cmd>lua require("vscode").action("editor.action.dirtydiff.next")<CR>', mode = nx, code = true },
  { '<leader>gr', '<cmd>lua require("vscode").action("git.revertSelectedRanges")<CR>', mode = nx, code = true },
  { '<leader>gs', '<cmd>lua require("vscode").action("git.stageSelectedRanges")<CR>', mode = nx, code = true },
  { '<leader>gd', '<cmd>lua require("vscode").action("git.viewChanges")<CR>', mode = nx, code = true },

  -----------------------------------------------------------------------------
  -- Windows
  -----------------------------------------------------------------------------
  { '<leader>q', '<Cmd>Quit<CR>', mode = nx, desc = 'Close window', code = '<cmd>lua require("vscode").action("workbench.action.closeActiveEditor")<CR>' },
  { '<leader>wc', '<Cmd>Quit<CR>', mode = nx, desc = 'Close window', code = '<cmd>lua require("vscode").action("workbench.action.closeActiveEditor")<CR>' },


  { '<leader>h', '<Cmd>wincmd h<CR>', mode = nx, desc = 'which_key_ignore', code = '<cmd>lua require("vscode").action("workbench.action.focusLeftGroup")<CR>' },
  { '<leader>j', '<Cmd>wincmd j<CR>', mode = nx, desc = 'which_key_ignore', code = '<cmd>lua require("vscode").action("workbench.action.focusBelowGroup")<CR>' },
  { '<leader>k', '<Cmd>wincmd k<CR>', mode = nx, desc = 'which_key_ignore', code = '<cmd>lua require("vscode").action("workbench.action.focusAboveGroup")<CR>' },
  { '<leader>l', '<Cmd>wincmd l<CR>', mode = nx, desc = 'which_key_ignore', code = '<cmd>lua require("vscode").action("workbench.action.focusRightGroup")<CR>' },
  { '<leader>wh', '<Cmd>wincmd h<CR>', mode = nx, desc = 'Window left', code = '<cmd>lua require("vscode").action("workbench.action.focusLeftGroup")<CR>' },
  { '<leader>wj', '<Cmd>wincmd j<CR>', mode = nx, desc = 'Window down', code = '<cmd>lua require("vscode").action("workbench.action.focusBelowGroup")<CR>' },
  { '<leader>wk', '<Cmd>wincmd k<CR>', mode = nx, desc = 'Window up', code = '<cmd>lua require("vscode").action("workbench.action.focusAboveGroup")<CR>' },
  { '<leader>wl', '<Cmd>wincmd l<CR>', mode = nx, desc = 'Window right', code = '<cmd>lua require("vscode").action("workbench.action.focusRightGroup")<CR>' },


  { '<leader>ws', '<Cmd>wincmd s<CR>', mode = nx, desc = 'Horizontal split', code = '<cmd>lua require("vscode").action("workbench.action.splitEditorDown")<CR>' },
  { '<leader>wv', '<Cmd>wincmd v<CR>', mode = nx, desc = 'Vertical split', code = '<cmd>lua require("vscode").action("workbench.action.splitEditorRight")<CR>' },
  { '<leader>ww', '<cmd>wincmd w<CR>', mode = nx, desc = 'Next window', code = '<cmd>lua require("vscode").action("workbench.action.focusNextGroup")<CR>' },
  { '<leader>wW', '<cmd>"wincmd W"<CR>', mode = nx, desc = 'Previous window', code = '<cmd>lua require("vscode").action("workbench.action.focusPreviousGroup")<CR>' },

  { '<leader>wo', '<Cmd>only<CR>', mode = nx, desc = 'Only window', code = '<cmd>lua require("vscode").action("workbench.action.joinAllGroups")<CR>' },
  { '<leader>wO', '<Cmd>tabonly<CR>', mode = nx, desc = 'Only tab', code = '<cmd>lua require("vscode").action("workbench.action.closeOtherEditors")<CR>' },
  { '<leader>wt', '<cmd>-tab split<CR>', mode = nx, desc = 'Edit to new tab', code = '<cmd>lua require("vscode").action("workbench.action.moveEditorToNewWindow")<CR>' },
  { '<leader>wH', '<cmd>wincmd H<CR>', mode = nx, desc = 'Move window far left', code = '<cmd>lua require("vscode").action("workbench.action.moveActiveEditorGroupLeft")<CR>' },
  { '<leader>wJ', '<cmd>wincmd J<CR>', mode = nx, desc = 'Move window far bottom', code = '<cmd>lua require("vscode").action("workbench.action.moveActiveEditorGroupDown")<CR>' },
  { '<leader>wK', '<cmd>wincmd K<CR>', mode = nx, desc = 'Move window far top', code = '<cmd>lua require("vscode").action("workbench.action.moveActiveEditorGroupUp")<CR>' },
  { '<leader>wL', '<cmd>wincmd L<CR>', mode = nx, desc = 'Move window far right', code = '<cmd>lua require("vscode").action("workbench.action.moveActiveEditorGroupRight")<CR>' },
  { '<leader>wr', '<cmd>wincmd r<CR>', mode = nx, desc = 'Rotate window cw', code = '<cmd>lua require("vscode").action("workbench.action.moveEditorToNextGroup")<CR>' },
  { '<leader>wR', '<cmd>wincmd R<CR>', mode = nx, desc = 'Rotate window ccw', code = '<cmd>lua require("vscode").action("workbench.action.moveEditorToPreviousGroup")<CR>' },
  { '<leader>wp', '<cmd>wincmd p<CR>', mode = nx, desc = 'Previous window' },

  { '<Bar>', '<Cmd>wincmd =<CR>', mode = nx, desc = 'Equalize windows', code = '<cmd>lua require("vscode").action("workbench.action.evenEditorWidths")<CR>' },
  { '<leader>u', '<cmd>lua require("vscode").action("workbench.action.toggleZenMode")<CR>', mode = nx, code = true },
  { '<leader>z', '<cmd>lua require("vscode").action("workbench.action.toggleZenMode")<CR>', mode = nx, code = true },
-- keymap('n', '\\', '<cmd>lua require("vscode").action("workbench.action.toggleEditorWidths")<CR>') -- zoom a vim pane

  -----------------------------------------------------------------------------
  -- Buffers & Tabs
  -----------------------------------------------------------------------------
  { '<leader>bK', '<cmd>call hasan#utils#buffer#_clear_all()<CR>', desc = 'Kill all buffers' },

  { 'gh', 'gT', mode = nx, desc = 'Previous tab', code = '<cmd>lua require("vscode").action("workbench.action.previousEditorInGroup")<CR>' },
  { 'gl', 'gt', mode = nx, desc = 'Next tab', code = '<cmd>lua require("vscode").action("workbench.action.nextEditorInGroup")<CR>' },
  { 'gH', '<Cmd>tabmove -1<CR>', desc = 'Move tab left', code = '<cmd>lua require("vscode").action("workbench.action.firstEditorInGroup")<CR>' },
  { 'gL', '<Cmd>tabmove +1<CR>', desc = 'Move tab right', code = '<cmd>lua require("vscode").action("workbench.action.lastEditorInGroup")<CR>' },

  -----------------------------------------------------------------------------
  -- File Management
  -----------------------------------------------------------------------------
  { '<leader>fC', ':w <C-R>=expand("%")<CR>', desc = 'Copy file', silent = false },
  { '<leader>fe', ":edit <C-R>=expand('%:p:h') . '\\'<CR>", desc = 'Edit current directory', silent = false },
  { '<leader>fM', ':Move <C-R>=expand("%")<CR>', desc = 'Move file', silent = false },
  { '<leader>fi', '<Cmd>lua require("hasan.widgets.file_info").open()<CR>', desc = 'File info' },
  { '<C-g>', '<Cmd>lua require("hasan.widgets.file_info").open()<CR>', desc = 'File info' },

  -----------------------------------------------------------------------------
  -- Macros
  -----------------------------------------------------------------------------
  { 'Q', function() return require('hasan.widgets.register_editor').start_recording() end, mode = nx, expr = true, desc = 'Record macro' },
  { '@', ':norm @', mode = 'v', desc = 'Run macro', silent = false },

  -----------------------------------------------------------------------------
  -- Terminal
  -----------------------------------------------------------------------------
  { '<C-o>', '<C-\\><C-n>', mode = 't', desc = 'Exit terminal mode' },
  { '<M-m>', '<Cmd>close<CR>', mode = 't', desc = 'Hide terminal' },

  -----------------------------------------------------------------------------
  -- Insert & Command-line
  -----------------------------------------------------------------------------
  -- Movement
  { '<A-k>', '<Esc><Cmd>m .-2<CR>==gi', mode = 'i', desc = 'Move line up' },
  { '<A-j>', '<Esc><Cmd>m .+1<CR>==gi', mode = 'i', desc = 'Move line down' },

  { ',', ',<C-g>u', mode = 'i' },
  { '.', '.<C-g>u', mode = 'i' },
  { ';', ';<C-g>u', mode = 'i' },

  { '<C-n>', '<Down>', mode = { 'i', 'c' } },
  { '<C-p>', '<Up>', mode = { 'i', 'c' } },
  { '<A-h>', '<Left>', mode = { 'i', 'c' } },
  { '<A-l>', '<Right>', mode = { 'i', 'c' } },
  { '<A-f>', '<S-Right>', mode = { 'i', 'c' } },
  { '<A-b>', '<S-Left>', mode = { 'i', 'c' } },

  { '<C-a>', '<C-o>^<C-g>u', mode = 'i' },
  { '<C-a>', '<Home>', mode = 'c' },
  { '<C-e>', '<End>', mode = { 'i', 'c' } },
  { '<C-d>', '<Delete>', mode = { 'i', 'c' } },
  { '<A-d>', '<C-o>dw', mode = 'i' },
  { '<A-d>', '<S-Right><C-W><Delete>', mode = 'c' },
  { '<C-u>', '<C-g>u<C-u>', mode = 'i' },

  { '<C-CR>', '<C-o>o', mode = 'i', desc = 'New line below' },
  { '<A-CR>', '<C-o>o', mode = 'i', desc = 'New line below' },
  { '<A-o>', '<CR><C-o>O', mode = 'i', desc = 'Open HTML tag' },

  { '<C-g><C-e>', '<C-g>u<Esc>bgUiwgi', mode = 'i', desc = 'Uppercase word' },
  { '<C-g><C-g>', '<C-g>u<Esc>[s1z=`]a<C-g>u', mode = 'i', desc = 'Fix spelling' },

  -----------------------------------------------------------------------------
  -- Saving
  -----------------------------------------------------------------------------
  { '<C-s>', '<Cmd>w<CR>', mode = { 'n', 'i', 'x' }, desc = 'Save file' },
  { '<leader>s', '<Cmd>w<CR>', mode = nx, desc = 'Save file' },
  { 'ZZ', '<Cmd>Quit!<CR>', mode = nx, desc = 'Quit window' },
  { '<leader>fs', '<cmd>lua require("vscode").action("editor.action.formatDocument")<CR>', mode = 'n', code = true },
  { '<leader>fs', '<cmd>lua require("vscode").action("editor.action.formatSelection")<CR>', mode = 'x', code = true },
  { '<leader>fxx', '<cmd>call hasan#autocmd#trimWhitespace()<CR>', desc = 'Remove white space', code = '<cmd>lua require("vscode").action("editor.action.trimTrailingWhitespace")<cr>' },

  -----------------------------------------------------------------------------
  -- Window Resizing
  -----------------------------------------------------------------------------
  { '<A-=>', '<Cmd>resize +3<CR>', mode = nx },
  { '<A-->', '<Cmd>resize -3<CR>', mode = nx },
  { '<A-.>', '<Cmd>vertical resize +5<CR>', mode = nx },
  { '<A-,>', '<Cmd>vertical resize -5<CR>', mode = nx },

  -----------------------------------------------------------------------------
  -- Utilities
  -----------------------------------------------------------------------------
  { '<leader>r', '<cmd>lua require("hasan.utils.win").cycle_numbering()<CR>', desc = 'Cycle numbers' },
  { 'g<space>', '<cmd>lua require("music.actions").ytm_toggle()<CR>', desc = 'Toggle YouTube Music' },
  { '<leader>vh', '<cmd>lua Snacks.notifier.hide()<CR>', desc = 'Dismiss All Notifications', mode = nx, code = '<cmd>lua require("vscode").action("notifications.clearAll")<CR>' },

  -----------------------------------------------------------------------------
  -- Pickers
  -----------------------------------------------------------------------------
  { '<leader><space>', function() require('config.navigation.snacks.custom').project_files() end, desc = 'Find project files', code = '<cmd>Tabfind<CR>', mode = nx },
  { '<leader>m', function() require('config.navigation.snacks.custom').buffers_with_symbols() end, code = '<cmd>lua require("vscode").action("workbench.action.showAllEditors")<CR>' },
  { '<leader>pp', function() require('config.navigation.snacks.persisted').persisted() end, desc = 'Switch project', mode = nx, code = '<cmd>lua require("vscode").action("workbench.action.openRecent")<CR>' },
  {
    '<A-/>',
    '<cmd>lua require("vscode").action("workbench.action.findInFiles",{args={query=vim.fn.expand("<cword>")}})<CR>',
  },
  { '<A-/>', '<cmd>lua require("vscode").action("workbench.action.findInFiles")<CR>', mode = 'x' },
  { '<leader>//', '<cmd>lua require("vscode").action("workbench.action.findInFiles")<CR>', mode = nx },
})

---@type lsp.AttachCb
function M.lsp_buffer_keymaps(client, bufnr)
  local b = { buffer = bufnr }

  -- if is_vscode then
  --   maps({
  --   })
  -- end

  -- stylua: ignore
  local maps_list = {
    { 'gd', '<cmd>Glance definitions<CR>', desc = 'Lsp: Go to definition', unpack(b), code = '<cmd>lua require("vscode").action("editor.action.revealDefinition")<CR>' },
    { 'gr', '<cmd>Glance references<CR>', desc = 'Lsp: Go to references', nowait = true, unpack(b), code = '<cmd>lua vim.lsp.buf.references()<CR>' },
    { 'gI', '<cmd>Glance implementations<CR>', desc = 'Lsp: Type implementation', unpack(b), code = '<cmd>lua vim.lsp.buf.implementation()<CR>' },
    { 'gy', '<cmd>Glance type_definitions<CR>', desc = 'Lsp: Type definition', unpack(b), code = '<cmd>lua vim.lsp.buf.type_definition()<CR>' },
    { 'gR', '<cmd>Glance resume<CR>', desc = 'Lsp: Glance resume', unpack(b) },
    { 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', desc = 'Lsp: Go to declaration', unpack(b) },
    { 'go', function () require('config.navigation.snacks.custom').lsp_symbols() end, desc = 'LSP Symbols', code = '<cmd>lua vim.lsp.buf.document_symbol()<CR>' },
    { '<leader>a.', run_code_action({ 'source.fixAll' }), desc = 'Lsp: Fix all', unpack(b) },
      -- { 'gR', '<cmd>lua require("vscode").action("references-view.findReferences")<CR>' },

    -- Peek
    { 'gpd', '<cmd>lua require("config.lsp.util.peek").PeekDefinition()<CR>', desc = 'Peek definition', unpack(b), code = false },
    { 'gpI', '<cmd>lua require("config.lsp.util.peek").PeekImplementation()<CR>', desc = 'Peek implementation', unpack(b), code = false  },
    { 'gpy', '<cmd>lua require("config.lsp.util.peek").PeekTypeDefinition()<CR>', desc = 'Peek type definition', unpack(b), code = false  },

    -- Action, Prompt, Search
    { 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', desc = 'Lsp: Hover under cursor', unpack(b) },
    { '<F2>', '<cmd>lua require("config.lsp.util.extras").lsp_rename()<CR>', desc = 'Lsp: Rename under cursor', unpack(b) },
    { '<C-q>', '<cmd>lua vim.lsp.buf.code_action()<CR>', mode = nx, desc = 'Lsp: Code action', unpack(b) },
    { '<C-space>', '<cmd>lua vim.lsp.buf.code_action()<CR>', mode = nx, desc = 'Lsp: Code action', unpack(b) },
    { '<A-space>', '<cmd>lua vim.lsp.buf.code_action()<CR>', mode = nx, desc = 'Lsp: Code action', unpack(b) },
    { 'g.', '<cmd>lua vim.lsp.buf.code_action()<CR>', mode = nx, desc = 'Lsp: Code action', unpack(b) },

    -- Diagnostics
    { '<leader>ad', '<cmd>lua vim.diagnostic.setloclist()<CR>', desc = 'Lsp: Show local diagnostics', unpack(b), code = '<cmd>lua require("vscode").action("workbench.panel.markers.view.focus")<CR>' },
    { '<leader>aD', '<cmd>lua vim.diagnostic.setqflist()<CR>', desc = 'Lsp: Show global diagnostics', unpack(b), code = '<cmd>lua require("vscode").action("workbench.panel.markers.view.focus")<CR>' },
    { '<leader>al', '<cmd>lua vim.diagnostic.open_float()<CR>', desc = 'Lsp: Show line diagnostics', unpack(b) },
    { '<C-c><C-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', mode = { 'n', 'i' }, desc = 'Lsp: show signature help', unpack(b) },
    { '<leader>a+', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', desc = 'Lsp: Add workspace folder', unpack(b) },
    { '<leader>a-', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', desc = 'Lsp: Remove workspace folder', unpack(b) },
    { '<leader>aw', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, desc = 'Lsp: list workspace folders', unpack(b) },
  }

  -- stylua: ignore
  if client.name == 'vtsls' then
    table.insert(maps_list, { 'gR', '<cmd>VtsExec file_references<CR>', desc = 'Lsp: File references', unpack(b) })
    table.insert(maps_list, { '<leader>ai', '<cmd>VtsExec organize_imports<CR>', desc = 'Lsp: Organize imports', unpack(b) })
    table.insert(maps_list, { '<leader>am', '<cmd>VtsExec add_missing_imports<CR>', desc = 'Lsp: Add Missing Imports', unpack(b) })
  else
    table.insert(maps_list, { '<leader>ai', run_code_action({ 'source.organizeImports' }), desc = 'Lsp: Organize imports', unpack(b) })
  end

  maps(maps_list)
end

if vim.g.vscode then
  maps({
    -- { '<C-l>', M.multi_cursor('editor.action.addSelectionToNextFindMatch'), mode = { 'n', 'x', 'i' } },
    -- { '<C-S-l>', M.multi_cursor('editor.action.selectHighlights'), mode = { 'n', 'x', 'i' } },
    -- { '<leader>dc', '<cmd>lua require("vscode").action("workbench.action.debug.continue")<CR>' },
    -- { '<leader>ds', '<cmd>lua require("vscode").action("workbench.action.debug.continue")<CR>' },
    -- { '<leader>da', '<cmd>lua require("vscode").action("workbench.action.debug.selectandstart")<CR>' },
    -- { '<leader>dq', '<cmd>lua require("vscode").action("workbench.action.debug.stop")<CR>' },
    -- { '<leader>db', '<cmd>lua require("vscode").action("editor.debug.action.toggleBreakpoint")<CR>' },
    -- { '<leader>di', '<cmd>lua require("vscode").action("workbench.action.debug.stepInto")<CR>' },
    -- { '<leader>do', '<cmd>lua require("vscode").action("workbench.action.debug.stepOver")<CR>' },
    -- { '<leader>dh', '<cmd>lua require("vscode").action("editor.debug.action.showDebugHover")<CR>' },
  })
end

if is_vscode then
  M.lsp_buffer_keymaps({}, 0)
end

M.disable_keys()

return M
