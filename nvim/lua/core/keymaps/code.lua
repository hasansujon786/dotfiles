local M = {}

function M.set_keymaps(key_specs)
  for _, k in ipairs(key_specs) do
    vim.keymap.set(k.mode or 'n', k[1], k[2], {
      desc = k.desc,
      silent = k.silent,
      remap = k.remap,
      expr = k.expr,
      nowait = k.nowait,
      noremap = k.noremap,
    })
  end
end

function M.disable_keys()
  if vim.fn.has('nvim-0.11') == 1 then
    local keys_to_del = { { 'gra', mode = { 'n', 'x' } }, 'grn', 'grr', 'gri', 'grt' }
    for _, key in ipairs(keys_to_del) do
      if type(key) == 'string' then
        pcall(vim.keymap.del, 'n', key)
      else
        pcall(vim.keymap.del, key.mode or 'n', key[1])
      end
    end
  end
end

function M.set_opts()
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  if not vim.g.vscode then
    require('hasan.pseudo-text-objects')
  end
end

function M.record_macro()
    return require('hasan.widgets.register_editor').start_recording()
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

function M.multi_cursor(cmd)
    return function()
      require('vscode').with_insert(function()
        require('vscode').action(cmd)
      end)
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

function M.foldWithLevel(level)
    return function()
      require('vscode').action('runCommands', { args = { commands = { 'editor.unfoldAll', level } } })
    end
  end

function M.edit_alternate_file()
    require('vscode').action('runCommands', {
      args = { commands = { 'workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup', 'list.select' } },
    })
  end

local maps_common = {
  { "q", "<esc><cmd>noh<CR>", mode = { "n", "x" } },
  { "<CR>", ":<up>", desc = "Run last command easily", silent = false, mode = { "n", "x" } },
  { "n", "nzz", desc = "Repeat the latest \"/\" or \"?\"", remap = true, mode = { "n", "x" } },
  { "N", "Nzz", desc = "Repeat the latest \"/\" or \"?\"", remap = true, mode = { "n", "x" } },
  { "'", "`", desc = "Jump to the mark", remap = true, mode = { "n", "x" } },
  { "@", ":norm @", desc = "Run macro on visual selection", silent = false, mode = "v" },
  { "p", "pgvy", mode = "v" },
  { "y", "ygv<Esc>", desc = "Keep cursor at place", mode = "v" },
  { "gV", "`[v`]", desc = "Select the last yanked text" },
  { "x", "\"_x", desc = "Prevent x from overriding the clipboard.", mode = { "n", "x" } },
  { "X", "\"_X", desc = "Prevent X from overriding the clipboard.", mode = { "n", "x" } },
  { "<leader>y", "\"+y", desc = "Yank to system", mode = "n" },
  { "<leader>y", "\"+ygv<Esc>", desc = "Yank to system", mode = "v" },
  { "<leader>ip", "\"+p", desc = "Paste from system", mode = { "n", "x" } },
  { "<leader>iP", "\"+P", desc = "Paste from system", mode = { "n", "x" } },
  { "$", "g_", desc = "A fix to select end of line", mode = { "x" } },
  { ">", ">gv", desc = "Keep selection when indenting/outdenting", mode = "v" },
  { "<", "<gv", desc = "Keep selection when indenting/outdenting", mode = "v" },
  { "gcu", M.uncomment_block, desc = "Uncomment block", mode = "n" },
  { "gc/", M.uncomment_block, desc = "Uncomment block", mode = "n" },
  { "a/", "<cmd>lua require(\"vim._comment\").textobject()<CR>", desc = "Comment textobject", mode = "o" },
  { "a/", "<Esc><cmd>lua require(\"vim._comment\").textobject()<CR>", desc = "Comment textobject", mode = "x" },
  { "gcO", M.comment_at('O'), desc = "Add comment above" },
  { "gco", M.comment_at('o'), desc = "Add comment below" },
  { "gcI", M.comment_at('I'), desc = "Add comment start of line" },
  { "gcA", M.comment_at('A '), desc = "Add comment end of line" },
  { "cm", ":%s/<c-r>///g<Left><Left>", desc = "Change all matches with prompt", silent = false },
  { "dm", ":%s/<c-r>///g<CR>", desc = "Delete all matches" },
  { "dM", ":%g/<c-r>//d<CR>", desc = "Delete all lines with matches" },
  { "<leader>cw", "<cmd>lua require(\"hasan.widgets.inputs\").substitute_word()<CR>", desc = "Substitute word", mode = { "n", "x" } },
  { "z/", "/\\%><C-r>=line(\"w0\")-1<CR>l\\%<<C-r>=line(\"w$\")+1<CR>l", desc = "Search in viewport", silent = false },
  { "z/", "<ESC>/\\%V", desc = "Search in visual selection", silent = false, mode = "x" },
  { "gB", M._open, desc = "Opens filepath or URI under cursor" },
  { "gB", M._open_v, desc = "Opens filepath or URI under cursor", mode = "x" },
  { "gW", "<cmd>Translate<CR>", desc = "Search on Translate", mode = { "n", "x" } },
  { "gG", "<cmd>Google<CR>", desc = "Search on google", mode = { "n", "x" } },
  { "g<BS>", "<c-w><c-p>", mode = { "n", "x" } },
  { "k", "v:count == 0 ? \"gk\" : \"k\"", desc = "Move cursor up", remap = true, expr = true },
  { "j", "v:count == 0 ? \"gj\" : \"j\"", desc = "Move cursor down", remap = true, expr = true },
  { "<leader>r", "<cmd>lua require(\"hasan.utils.win\").cycle_numbering()<CR>", desc = "Cycle number", mode = "n" },
  { "<leader>q", "<Cmd>lua require(\"vscode\").action(\"workbench.action.closeActiveEditor\")<CR>", desc = "Close current window", mode = { "n", "x" } },
  { "<leader>wc", "<Cmd>lua require(\"vscode\").action(\"workbench.action.closeActiveEditor\")<CR>", desc = "Close current window", mode = { "n", "x" } },
  { "<leader>bd", "<Cmd>lua require(\"vscode\").action(\"workbench.action.closeActiveEditor\")<CR>", mode = { "n", "x" } },
  { "<leader>h", "<Cmd>lua require(\"vscode\").action(\"workbench.action.navigateLeft\")<CR>", desc = "which_key_ignore", mode = { "n", "x" } },
  { "<leader>j", "<Cmd>lua require(\"vscode\").action(\"workbench.action.navigateDown\")<CR>", desc = "which_key_ignore", mode = { "n", "x" } },
  { "<leader>k", "<Cmd>lua require(\"vscode\").action(\"workbench.action.navigateUp\")<CR>", desc = "which_key_ignore", mode = { "n", "x" } },
  { "<leader>l", "<Cmd>lua require(\"vscode\").action(\"workbench.action.navigateRight\")<CR>", desc = "which_key_ignore", mode = { "n", "x" } },
  { "<leader>wh", "<Cmd>lua require(\"vscode\").action(\"workbench.action.navigateLeft\")<CR>", desc = "Window left", mode = { "n", "x" } },
  { "<leader>wj", "<Cmd>lua require(\"vscode\").action(\"workbench.action.navigateDown\")<CR>", desc = "Window down", mode = { "n", "x" } },
  { "<leader>wk", "<Cmd>lua require(\"vscode\").action(\"workbench.action.navigateUp\")<CR>", desc = "Window up", mode = { "n", "x" } },
  { "<leader>wl", "<Cmd>lua require(\"vscode\").action(\"workbench.action.navigateRight\")<CR>", desc = "Window right", mode = { "n", "x" } },
  { "<leader>ws", "<Cmd>lua require(\"vscode\").action(\"workbench.action.splitEditorDown\")<CR>", desc = "Window split", mode = { "n", "x" } },
  { "<leader>wv", "<Cmd>lua require(\"vscode\").action(\"workbench.action.splitEditorRight\")<CR>", desc = "Windwo vsplit", mode = { "n", "x" } },
  { "<leader>wo", "<Cmd>lua require(\"vscode\").action(\"runCommands\", {args = { commands = { 'workbench.action.closeEditorsInOtherGroups', 'workbench.action.closeOtherEditors', 'workbench.action.focusActiveEditorGroup' }}})<CR>", desc = "Keep only window", mode = { "n", "x" } },
  { "<leader>wO", "<Cmd>lua require(\"vscode\").action(\"workbench.action.closeOtherEditors\")<CR>", desc = "Keep only tab", mode = { "n", "x" } },
  { "<Bar>", "<Cmd>lua require(\"vscode\").action(\"workbench.action.evenEditorWidths\")<CR>", desc = "Equalize all windows", mode = { "n", "x" } },
  { "<leader>wp", "<cmd>lua run_cmd(\"wincmd p\")<CR>", desc = "Window previous", mdoe = { "n", "x" } },
  { "<leader>ww", "<cmd>lua run_cmd(\"wincmd w\")<CR>", desc = "Window next", mode = { "n", "x" } },
  { "<leader>wW", "<cmd>lua run_cmd(\"wincmd W\")<CR>", desc = "Window previous", mode = { "n", "x" } },
}
local maps = {
  { "Q", "q", { desc = "Record a macro" } },
  { "<C-l>", M.multi_cursor('editor.action.addSelectionToNextFindMatch'), mode = { "n", "x", "i" } },
  { "<C-S-l>", M.multi_cursor('editor.action.selectHighlights'), mode = { "n", "x", "i" } },
  { "<A-/>", "<cmd>lua require(\"vscode\").action(\"workbench.action.findInFiles\",{args={query=vim.fn.expand(\"<cword>\")}})<CR>" },
  { "<A-/>", "<cmd>lua require(\"vscode\").action(\"workbench.action.findInFiles\")<CR>", mode = "x" },
  { "<leader>//", "<cmd>lua require(\"vscode\").action(\"workbench.action.findInFiles\")<CR>", mode = { "n", "x" } },
  { "<leader><leader>", "<cmd>Tabfind<CR>", mode = { "n", "x" } },
  { "<leader>pp", "<cmd>lua require(\"vscode\").action(\"workbench.action.openRecent\")<CR>", mode = { "n", "x" } },
  { "g.", "<cmd>lua require(\"vscode\").action(\"workbench.action.showAllEditors\")<CR>", mode = { "n", "x" } },
  { "<tab>", "<cmd>lua require(\"vscode\").action(\"editor.toggleFold\")<CR>", desc = "Toggle fold" },
  { "<s-tab>", "<cmd>lua require(\"vscode\").action(\"editor.toggleFoldRecursively\")<CR>", desc = "Fold recursively" },
  { "z.", M.foldWithLevel('editor.foldLevel1'), desc = "Fold all buf", mode = { "n", "x" } },
  { "z;", M.foldWithLevel('editor.foldLevel2'), desc = "Fold all buf", mode = { "n", "x" } },
  { "za", "<cmd>lua require(\"vscode\").action(\"editor.toggleFold\")<CR>", desc = "Toggle fold" },
  { "zc", "<cmd>lua require(\"vscode\").action(\"editor.foldRecursively\")<CR>", desc = "Fold recursively" },
  { "zC", "<cmd>lua require(\"vscode\").action(\"editor.foldAll\")<CR>", desc = "Fold all" },
  { "zM", "<cmd>lua require(\"vscode\").action(\"editor.foldRecursively\")<CR>", desc = "Fold recursively" },
  { "zM", "<cmd>lua require(\"vscode\").action(\"editor.foldAll\")<CR>", desc = "Fold all" },
  { "zo", "<cmd>lua require(\"vscode\").action(\"editor.unfoldRecursively\")<CR>", desc = "Unfold recursively" },
  { "zO", "<cmd>lua require(\"vscode\").action(\"editor.unfoldAll\")<CR>", desc = "Unfold all" },
  { "zr", "<cmd>lua require(\"vscode\").action(\"editor.unfoldRecursively\")<CR>", desc = "Unfold recursively" },
  { "zR", "<cmd>lua require(\"vscode\").action(\"editor.unfoldAll\")<CR>", desc = "Unfold all" },
  { "zp", "<cmd>lua require(\"vscode\").action(\"editor.gotoParentFold\")<CR>", desc = "Go to parent fold" },
  { "<BS>", M.edit_alternate_file, desc = "Edit alternate file", mode = { "n", "x" } },
  { "<C-j>", "<cmd>lua require(\"vscode\").action(\"workbench.action.navigateForward\")<CR>", mode = { "n", "x" } },
  { "]d", "<cmd>lua require(\"vscode\").action(\"editor.action.marker.nextInFiles\")<CR>", mode = { "n", "x" } },
  { "[d", "<cmd>lua require(\"vscode\").action(\"editor.action.marker.prevInFiles\")<CR>", mode = { "n", "x" } },
  { "[c", "<cmd>lua require(\"vscode\").action(\"workbench.action.editor.previousChange\")<CR>", mode = { "n", "x" } },
  { "]c", "<cmd>lua require(\"vscode\").action(\"workbench.action.editor.nextChange\")<CR>", mode = { "n", "x" } },
  { "g[", "<cmd>lua require(\"vscode\").action(\"editor.action.wordHighlight.prev\")<CR>", mode = { "n", "x" } },
  { "g]", "<cmd>lua require(\"vscode\").action(\"editor.action.wordHighlight.next\")<CR>", mode = { "n", "x" } },
  { "<leader>s", "<cmd>lua require(\"vscode\").action(\"workbench.action.files.save\")<CR>", mode = { "n", "x" } },
  { "<leader>fs", "<cmd>lua require(\"vscode\").action(\"editor.action.formatDocument\")<CR>", mode = "n" },
  { "<leader>fs", "<cmd>lua require(\"vscode\").action(\"editor.action.formatSelection\")<CR>", mode = "x" },
  { "<leader>fxx", "<cmd>lua require(\"vscode\").action(\"editor.action.trimTrailingWhitespace\")<cr>" },
  { "<leader>u", "<cmd>lua require(\"vscode\").action(\"workbench.action.toggleZenMode\")<CR>", mode = { "n", "x" } },
  { "<leader>gg", "<cmd>lua require(\"vscode\").action(\"workbench.view.scm\")<CR>" },
  { "<leader>g.", "<cmd>lua require(\"vscode\").action(\"git.stage\")<CR>" },
  { "<leader>gp", "<cmd>lua require(\"vscode\").action(\"editor.action.dirtydiff.next\")<CR>", mode = { "n", "x" } },
  { "<leader>gr", "<cmd>lua require(\"vscode\").action(\"git.revertSelectedRanges\")<CR>", mode = { "n", "x" } },
  { "<leader>gs", "<cmd>lua require(\"vscode\").action(\"git.stageSelectedRanges\")<CR>", mode = { "n", "x" } },
  { "<leader>gd", "<cmd>lua require(\"vscode\").action(\"git.viewChanges\")<CR>", mode = { "n", "x" } },
  { "<leader>dc", "<cmd>lua require(\"vscode\").action(\"workbench.action.debug.continue\")<CR>" },
  { "<leader>ds", "<cmd>lua require(\"vscode\").action(\"workbench.action.debug.continue\")<CR>" },
  { "<leader>da", "<cmd>lua require(\"vscode\").action(\"workbench.action.debug.selectandstart\")<CR>" },
  { "<leader>dq", "<cmd>lua require(\"vscode\").action(\"workbench.action.debug.stop\")<CR>" },
  { "<leader>db", "<cmd>lua require(\"vscode\").action(\"editor.debug.action.toggleBreakpoint\")<CR>" },
  { "<leader>di", "<cmd>lua require(\"vscode\").action(\"workbench.action.debug.stepInto\")<CR>" },
  { "<leader>do", "<cmd>lua require(\"vscode\").action(\"workbench.action.debug.stepOver\")<CR>" },
  { "<leader>dh", "<cmd>lua require(\"vscode\").action(\"editor.debug.action.showDebugHover\")<CR>" },
  { "<leader>vo", "<cmd>lua require(\"vscode\").action(\"notifications.clearAll\")<CR>", mode = { "n", "x" } },
  { "<leader>op", "<cmd>lua require(\"vscode\").action(\"workbench.view.explorer\")<CR>" },
  { "-", "<cmd>lua require(\"vscode\").action(\"workbench.files.action.showActiveFileInExplorer\")<CR>" },
  { "gh", "<cmd>lua require(\"vscode\").action(\"workbench.action.previousEditorInGroup\")<CR>", mode = { "n", "x" } },
  { "gl", "<cmd>lua require(\"vscode\").action(\"workbench.action.nextEditorInGroup\")<CR>", mode = { "n", "x" } },
  { "gH", "<cmd>lua require(\"vscode\").action(\"workbench.action.firstEditorInGroup\")<CR>", mode = { "n", "x" } },
  { "gL", "<cmd>lua require(\"vscode\").action(\"workbench.action.lastEditorInGroup\")<CR>", mode = { "n", "x" } },
  { "gd", "<cmd>lua require(\"vscode\").action(\"editor.action.revealDefinition\")<CR>" },
  { "gr", "<cmd>lua vim.lsp.buf.references()<CR>" },
  { "gR", "<cmd>lua require(\"vscode\").action(\"references-view.findReferences\")<CR>" },
  { "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>" },
  { "gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>" },
  { "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>" },
  { "go", "<cmd>lua vim.lsp.buf.document_symbol()<CR>" },
  { "<leader>ad", "<cmd>lua require(\"vscode\").action(\"workbench.panel.markers.view.focus\")<CR>" },
}
M.set_opts()
M.disable_keys()
M.set_keymaps(maps_common)
M.set_keymaps(maps)

-------------------------------------------------------------------------------
-- Generated from "nvim/lua/hasan/pseudo-text-objects.lua"
-------------------------------------------------------------------------------
local map = vim.keymap.set

-- line pseudo-text objects
-- ------------------------
-- il al
map('x', 'il', 'g_o^', { desc = 'inner line' })
map('o', 'il', '<cmd>normal vil<CR>', { desc = 'inner line' })
map('x', 'al', '$o0', { desc = 'line' })
map('o', 'al', '<cmd>normal val<CR>', { desc = 'line' })

-- number pseudo-text object (integer and float)
-- ---------------------------------------------
-- in
local function visual_number()
  vim.cmd([[normal v]])
  vim.fn.search([[\d\([^0-9\.]\|$\)]], 'cW')
  vim.cmd([[normal v]])
  vim.fn.search([[\(^\|[^0-9\.]\d\)]], 'becW')
end
map('x', 'in', visual_number, { desc = 'inner number' })
map('o', 'in', '<cmd>normal vin<CR>', { desc = 'inner number' })

-- buffer pseudo-text objects
-- --------------------------
-- ie ae
map('x', 'ie', [[0:<C-u>let z = @/|1;/^./kz<CR>G??<CR>:let @/ = z|nohlsearch<CR>V'z]], { desc = 'inner buffer' })
map('o', 'ie', '<cmd>normal vie<CR>', { desc = 'inner buffer' })
map('x', 'ae', 'G$ogg0', { desc = 'buffer' })
map('o', 'ae', '<cmd>normal vae<CR>', { desc = 'buffer' })

-- square brackets pseudo-text objects
-- -----------------------------------
-- ir ar
map('x', 'ir', 'i[', { desc = 'inner square brackets' })
map('o', 'ir', '<cmd>normal vi[<CR>', { desc = 'inner square brackets' })
map('x', 'ar', 'a[', { desc = 'square brackets' })
map('o', 'ar', '<cmd>normal va[<CR>', { desc = 'square brackets' })

-- last change pseudo-text objects
-- -------------------------------
-- ie ae
-- map('x', 'ie', '`]o`[', { desc = 'inner last change' })
-- map('o', 'ie', '<cmd>normal vie<CR>', { desc = 'inner last change' })
-- map('x', 'ae', '`]o`[V', { desc = 'last change' })
-- map('o', 'ae', '<cmd>normal vae<CR>', { desc = 'last change' })

-- block comment pseudo-text objects
-- ---------------------------------
-- i? a?
map('x', 'i?', '[*jo]*k', { desc = 'inner block comment' })
map('o', 'i?', '<cmd>normal vi?V<CR>', { desc = 'inner block comment' })
map('x', 'a?', '[*o]*', { desc = 'block comment' })
map('o', 'a?', '<cmd>normal va?V<CR>', { desc = 'block comment' })

-- 24 simple pseudo-text objects
-- -----------------------------
-- i_ i. i: i, i; i| i/ i\ i* i+ i- i#
-- a_ a. a: a, a; a| a/ a\ a* a+ a- a#
local simple_objects = {
  inner = function(char)
    return function()
      vim.cmd(string.format('normal! T%sot%s', char, char))
    end
  end,
  outer = function(char)
    return function()
      vim.cmd(string.format('normal! F%sof%s', char, char))
    end
  end,
}
for _, char in ipairs({ '_', '.', ':', ',', '<bar>', '/', '<bslash>', '*', '-', '#' }) do
  map('x', 'i' .. char, simple_objects.inner(char), { desc = 'which_key_ignore' })
  map('o', 'i' .. char, string.format('<cmd>normal vi%s<CR>', char), { desc = 'which_key_ignore' })
  map('x', 'a' .. char, simple_objects.outer(char), { desc = 'which_key_ignore' })
  map('o', 'a' .. char, string.format('<cmd>normal va%s<CR>', char), { desc = 'which_key_ignore' })
end

-- hasan/mahmud/sujon
-- hasan_mahmud_sujon
-- hasan-mahmud-sujon
-- hasan.mahmud.sujon
-- hasan#mahmud#sujon
-- hasan,mahmud,sujon
-- hasan*mahmud*sujon
-- hasan:mahmud:sujon

-------------------------------------------------------------------------------
-- Generated from "nvim/lua/core/keymaps/code_autocmds.lua"
-------------------------------------------------------------------------------
local group = vim.api.nvim_create_augroup('CODE_AUTOCMDS', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  group = group,
  callback = function()
    vim.hl.on_yank({ on_visual = true, higroup = 'Search', timeout = 200 })
  end,
})

vim.api.nvim_create_autocmd('InsertEnter', {
  group = group,
  callback = function()
    vim.schedule(function()
      vim.cmd('nohlsearch')
    end)
  end,
})
