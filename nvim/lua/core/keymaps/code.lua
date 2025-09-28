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
  { "<CR>", ":<up>", mode = { "n", "x" }, desc = "Run last command easily", silent = false },
  { "n", "nzz", mode = { "n", "x" }, remap = true, desc = "Repeat the latest \"/\" or \"?\"" },
  { "N", "Nzz", mode = { "n", "x" }, remap = true, desc = "Repeat the latest \"/\" or \"?\"" },
  { "'", "`", mode = { "n", "x" }, remap = true, desc = "Jump to the mark" },
  { "@", ":norm @", mode = "v", desc = "Run macro on visual selection", silent = false },
  { "p", "pgvy", mode = "v" },
  { "y", "ygv<Esc>", mode = "v", desc = "Keep cursor at place" },
  { "gV", "`[v`]", desc = "Select the last yanked text" },
  { "x", "\"_x", mode = { "n", "x" }, desc = "Prevent x from overriding the clipboard." },
  { "X", "\"_X", mode = { "n", "x" }, desc = "Prevent X from overriding the clipboard." },
  { "<leader>y", "\"+y", mode = "n", desc = "Yank to system" },
  { "<leader>y", "\"+ygv<Esc>", mode = "v", desc = "Yank to system" },
  { "<leader>ip", "\"+p", mode = { "n", "x" }, desc = "Paste from system" },
  { "<leader>iP", "\"+P", mode = { "n", "x" }, desc = "Paste from system" },
  { "$", "g_", mode = { "x" }, desc = "A fix to select end of line" },
  { ">", ">gv", mode = "v", desc = "Keep selection when indenting/outdenting" },
  { "<", "<gv", mode = "v", desc = "Keep selection when indenting/outdenting" },
  { "gcu", M.uncomment_block, mode = "n", desc = "Uncomment block" },
  { "gc/", M.uncomment_block, mode = "n", desc = "Uncomment block" },
  { "a/", "<cmd>lua require(\"vim._comment\").textobject()<CR>", mode = "o", desc = "Comment textobject" },
  { "a/", "<Esc><cmd>lua require(\"vim._comment\").textobject()<CR>", mode = "x", desc = "Comment textobject" },
  { "gcO", M.comment_at('O'), desc = "Add comment above" },
  { "gco", M.comment_at('o'), desc = "Add comment below" },
  { "gcI", M.comment_at('I'), desc = "Add comment start of line" },
  { "gcA", M.comment_at('A '), desc = "Add comment end of line" },
  { "cm", ":%s/<c-r>///g<Left><Left>", silent = false, desc = "Change all matches with prompt" },
  { "dm", ":%s/<c-r>///g<CR>", desc = "Delete all matches" },
  { "dM", ":%g/<c-r>//d<CR>", desc = "Delete all lines with matches" },
  { "<leader>cw", "<cmd>lua require(\"hasan.widgets.inputs\").substitute_word()<CR>", mode = { "n", "x" }, desc = "Substitute word" },
  { "z/", "/\\%><C-r>=line(\"w0\")-1<CR>l\\%<<C-r>=line(\"w$\")+1<CR>l", silent = false, desc = "Search in viewport" },
  { "z/", "<ESC>/\\%V", mode = "x", desc = "Search in visual selection", silent = false },
  { "gB", M._open, desc = "Opens filepath or URI under cursor" },
  { "gB", M._open_v, mode = "x", desc = "Opens filepath or URI under cursor" },
  { "gW", "<cmd>Translate<CR>", mode = { "n", "x" }, desc = "Search on Translate" },
  { "gG", "<cmd>Google<CR>", mode = { "n", "x" }, desc = "Search on google" },
  { "g<BS>", "<c-w><c-p>", mode = { "n", "x" } },
  { "k", "<cmd>call reljump#jump(\"k\")<cr>", desc = "Move cursor up" },
  { "j", "<cmd>call reljump#jump(\"j\")<cr>", desc = "Move cursor down" },
  { "H", "H<cmd>exec \"norm! \".&scrolloff.\"k\"<cr>", desc = "Jump to first line on the window" },
  { "L", "L<cmd>exec \"norm! \".&scrolloff.\"j\"<cr>", desc = "Jump to last line on the window" },
  { "<leader>r", "<cmd>lua require(\"hasan.utils.win\").cycle_numbering()<CR>", mode = "n", desc = "Cycle number" },
  { "<leader>q", "<Cmd>lua require(\"vscode\").action(\"workbench.action.closeActiveEditor\")<CR>", mode = { "n", "x" }, desc = "Close current window" },
  { "<leader>wc", "<Cmd>lua require(\"vscode\").action(\"workbench.action.closeActiveEditor\")<CR>", mode = { "n", "x" }, desc = "Close current window" },
  { "<leader>bd", "<Cmd>lua require(\"vscode\").action(\"workbench.action.closeActiveEditor\")<CR>", mode = { "n", "x" } },
  { "<leader>h", "<Cmd>lua require(\"vscode\").action(\"workbench.action.navigateLeft\")<CR>", mode = { "n", "x" }, desc = "which_key_ignore" },
  { "<leader>j", "<Cmd>lua require(\"vscode\").action(\"workbench.action.navigateDown\")<CR>", mode = { "n", "x" }, desc = "which_key_ignore" },
  { "<leader>k", "<Cmd>lua require(\"vscode\").action(\"workbench.action.navigateUp\")<CR>", mode = { "n", "x" }, desc = "which_key_ignore" },
  { "<leader>l", "<Cmd>lua require(\"vscode\").action(\"workbench.action.navigateRight\")<CR>", mode = { "n", "x" }, desc = "which_key_ignore" },
  { "<leader>wh", "<Cmd>lua require(\"vscode\").action(\"workbench.action.navigateLeft\")<CR>", mode = { "n", "x" }, desc = "Window left" },
  { "<leader>wj", "<Cmd>lua require(\"vscode\").action(\"workbench.action.navigateDown\")<CR>", mode = { "n", "x" }, desc = "Window down" },
  { "<leader>wk", "<Cmd>lua require(\"vscode\").action(\"workbench.action.navigateUp\")<CR>", mode = { "n", "x" }, desc = "Window up" },
  { "<leader>wl", "<Cmd>lua require(\"vscode\").action(\"workbench.action.navigateRight\")<CR>", mode = { "n", "x" }, desc = "Window right" },
  { "<leader>ws", "<Cmd>lua require(\"vscode\").action(\"workbench.action.splitEditorDown\")<CR>", mode = { "n", "x" }, desc = "Window split" },
  { "<leader>wv", "<Cmd>lua require(\"vscode\").action(\"workbench.action.splitEditorRight\")<CR>", mode = { "n", "x" }, desc = "Windwo vsplit" },
  { "<leader>wo", "<Cmd>lua require(\"vscode\").action(\"runCommands\", {args = { commands = { 'workbench.action.closeEditorsInOtherGroups', 'workbench.action.closeOtherEditors', 'workbench.action.focusActiveEditorGroup' }}})<CR>", mode = { "n", "x" }, desc = "Keep only window" },
  { "<leader>wO", "<Cmd>lua require(\"vscode\").action(\"workbench.action.closeOtherEditors\")<CR>", mode = { "n", "x" }, desc = "Keep only tab" },
  { "<Bar>", "<Cmd>lua require(\"vscode\").action(\"workbench.action.evenEditorWidths\")<CR>", mode = { "n", "x" }, desc = "Equalize all windows" },
  { "<leader>wp", "<cmd>lua run_cmd(\"wincmd p\")<CR>", mdoe = { "n", "x" }, desc = "Window previous" },
  { "<leader>ww", "<cmd>lua run_cmd(\"wincmd w\")<CR>", mode = { "n", "x" }, desc = "Window next" },
  { "<leader>wW", "<cmd>lua run_cmd(\"wincmd W\")<CR>", mode = { "n", "x" }, desc = "Window previous" },
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
  { "z.", M.foldWithLevel('editor.foldLevel1'), mode = { "n", "x" }, desc = "Fold all buf" },
  { "z;", M.foldWithLevel('editor.foldLevel2'), mode = { "n", "x" }, desc = "Fold all buf" },
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
  { "<BS>", M.edit_alternate_file, mode = { "n", "x" }, desc = "Edit alternate file" },
  { "<C-j>", "<cmd>lua require(\"vscode\").action(\"workbench.action.navigateForward\")<CR>", mode = { "n", "x" } },
  { "]d", "<cmd>lua require(\"vscode\").action(\"editor.action.marker.nextInFiles\")<CR>", mode = { "n", "x" } },
  { "[d", "<cmd>lua require(\"vscode\").action(\"editor.action.marker.prevInFiles\")<CR>", mode = { "n", "x" } },
  { "[c", "<cmd>lua require(\"vscode\").action(\"workbench.action.editor.previousChange\")<CR>", mode = { "n", "x" } },
  { "]c", "<cmd>lua require(\"vscode\").action(\"workbench.action.editor.nextChange\")<CR>", mode = { "n", "x" } },
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
