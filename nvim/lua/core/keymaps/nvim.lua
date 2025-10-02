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
  { "<CR>", ":<up>", mode = { "n", "x" }, silent = false, desc = "Run last command easily" },
  { "n", "nzz", mode = { "n", "x" }, remap = true, desc = "Repeat the latest \"/\" or \"?\"" },
  { "N", "Nzz", mode = { "n", "x" }, remap = true, desc = "Repeat the latest \"/\" or \"?\"" },
  { "'", "`", mode = { "n", "x" }, remap = true, desc = "Jump to the mark" },
  { "@", ":norm @", mode = "v", silent = false, desc = "Run macro on visual selection" },
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
  { ">", ">gv", mode = "v", desc = "Keep selection when indenting/outdenting" },
  { "<", "<gv", mode = "v", desc = "Keep selection when indenting/outdenting" },
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
  { "z/", "/\\%><C-r>=line(\"w0\")-1<CR>l\\%<<C-r>=line(\"w$\")+1<CR>l", silent = false, desc = "Search in viewport" },
  { "z/", "<ESC>/\\%V", mode = "x", silent = false, desc = "Search in visual selection" },
  { "gB", M._open, desc = "Opens filepath or URI under cursor" },
  { "gB", M._open_v, desc = "Opens filepath or URI under cursor", mode = "x" },
  { "gW", "<cmd>Translate<CR>", desc = "Search on Translate", mode = { "n", "x" } },
  { "gG", "<cmd>Google<CR>", desc = "Search on google", mode = { "n", "x" } },
  { "g<BS>", "<c-w><c-p>", mode = { "n", "x" } },
  { "<leader>r", "<cmd>lua require(\"hasan.utils.win\").cycle_numbering()<CR>", desc = "Cycle number", mode = "n" },
  { "<leader>q", "<Cmd>Quit<CR>", desc = "Close current window", mode = { "n", "x" } },
  { "<leader>wc", "<Cmd>Quit<CR>", desc = "Close current window", mode = { "n", "x" } },
  { "<leader>bd", "<Cmd>Bufdelete<CR>", mode = { "n", "x" } },
  { "<leader>h", "<Cmd>wincmd h<CR>", desc = "which_key_ignore", mode = { "n", "x" } },
  { "<leader>j", "<Cmd>wincmd j<CR>", desc = "which_key_ignore", mode = { "n", "x" } },
  { "<leader>k", "<Cmd>wincmd k<CR>", desc = "which_key_ignore", mode = { "n", "x" } },
  { "<leader>l", "<Cmd>wincmd l<CR>", desc = "which_key_ignore", mode = { "n", "x" } },
  { "<leader>wh", "<Cmd>wincmd h<CR>", desc = "Window left", mode = { "n", "x" } },
  { "<leader>wj", "<Cmd>wincmd j<CR>", desc = "Window down", mode = { "n", "x" } },
  { "<leader>wk", "<Cmd>wincmd k<CR>", desc = "Window up", mode = { "n", "x" } },
  { "<leader>wl", "<Cmd>wincmd l<CR>", desc = "Window right", mode = { "n", "x" } },
  { "<leader>ws", "<Cmd>wincmd s<CR>", desc = "Window split", mode = { "n", "x" } },
  { "<leader>wv", "<Cmd>wincmd v<CR>", desc = "Windwo vsplit", mode = { "n", "x" } },
  { "<leader>wo", "<Cmd>only<CR>", desc = "Keep only window", mode = { "n", "x" } },
  { "<leader>wO", "<Cmd>tabonly<CR>", desc = "Keep only tab", mode = { "n", "x" } },
  { "<Bar>", "<Cmd>wincmd =<CR>", desc = "Equalize all windows", mode = { "n", "x" } },
  { "<leader>wp", "<cmd>lua run_cmd(\"wincmd p\")<CR>", desc = "Window previous", mdoe = { "n", "x" } },
  { "<leader>ww", "<cmd>lua run_cmd(\"wincmd w\")<CR>", desc = "Window next", mode = { "n", "x" } },
  { "<leader>wW", "<cmd>lua run_cmd(\"wincmd W\")<CR>", desc = "Window previous", mode = { "n", "x" } },
}
local maps = {
  { "Q", M.record_macro, mode = { "n", "x" }, desc = "Record a macro", expr = true },
  { "<C-v>", "<C-R>+", mode = { "i", "c" }, silent = false, desc = "Paste from system clipboard" },
  { "<C-g><C-v>", "<C-v>", mode = { "i", "c" }, silent = false, desc = "Paste from system clipboard" },
  { "<A-p>", "<C-R>\"", mode = { "i", "c" }, silent = false, desc = "Paste the last item from register" },
  { "<A-k>", "<esc><cmd>m .-2<cr>==gi", desc = "Move Up", mode = "i" },
  { "<A-j>", "<esc><cmd>m .+1<cr>==gi", desc = "Move Down", mode = "i" },
  { "<C-_>", "mz_gcc`z", mode = "n", remap = true, desc = "Toggle comment line" },
  { "<C-_>", "<ESC>_gccgi", mode = "i", remap = true, desc = "Toggle comment line" },
  { "<C-_>", "mz_gcgv`z", mode = "v", remap = true, desc = "Toggle comment line" },
  { "zuu", "0vai:foldclose!<CR>zazt", mode = { "n", "x" }, remap = true, desc = "Fold current context" },
  { "zu", ":foldclose!<CR>zazt", mode = { "n", "x" }, remap = true, desc = "Fold current context" },
  { "<tab>", "za", desc = "Toggle fold", mode = { "n", "x" } },
  { "<s-tab>", "zA", desc = "Toggle fold recursively", mode = { "n", "x" } },
  { "z.", "<cmd>%foldclose<CR>zb", desc = "Fold all buf", mode = { "n", "x" } },
  { "z;", "<cmd>setl foldlevel=1<CR>zb", desc = "Fold all buf", mode = { "n", "x" } },
  { "<BS>", "<c-^>", desc = "Edit alternate file", mode = { "n", "x" } },
  { "<C-j>", "<c-i>", mode = { "n", "x" }, remap = false },
  { "k", "v:count == 0 ? \"gk\" : \"k\"", expr = true, remap = false, desc = "Move cursor up" },
  { "j", "v:count == 0 ? \"gj\" : \"j\"", expr = true, remap = false, desc = "Move cursor down" },
  { "<A-u>", "<C-u>", mode = { "n", "x" }, remap = true, desc = "Scroll window" },
  { "<A-d>", "<C-d>", mode = { "n", "x" }, remap = true, desc = "Scroll window" },
  { "<A-o>", "<C-d>", mode = { "n", "x" }, remap = true, desc = "Scroll window" },
  { "<PageUp>", "<C-u>", mode = { "n", "x" }, remap = true, desc = "Scroll window" },
  { "<PageDown>", "<C-d>", mode = { "n", "x" }, remap = true, desc = "Scroll window" },
  { "<A-f>", "<C-f>", mode = { "n", "x" }, remap = true, desc = "Scroll window" },
  { "<A-b>", "<C-b>", mode = { "n", "x" }, remap = true, desc = "Scroll window" },
  { "<A-y>", "<C-y>", mode = { "n", "x" }, remap = true, desc = "Scroll window" },
  { "<A-e>", "<C-e>", mode = { "n", "x" }, remap = true, desc = "Scroll window" },
  { "<A-h>", "20zh", mode = { "n", "x" } },
  { "<A-l>", "20zl", mode = { "n", "x" } },
  { "<C-o>", "<C-\\><C-n>", desc = "Exit Term mode", mode = "t" },
  { "<M-m>", "<cmd>close<cr>", desc = "Hide Terminal", mode = "t" },
  { ",", ",<c-g>u", mode = "i" },
  { ".", ".<c-g>u", mode = "i" },
  { ";", ";<c-g>u", mode = "i" },
  { "<A-h>", "<left>", mode = { "i", "c" } },
  { "<A-l>", "<right>", mode = { "i", "c" } },
  { "<C-n>", "<down>", mode = { "i", "c" } },
  { "<C-p>", "<up>", mode = { "i", "c" } },
  { "<A-f>", "<S-right>", mode = { "i", "c" } },
  { "<A-b>", "<S-left>", mode = { "i", "c" } },
  { "<C-a>", "<C-o>^<C-g>u", mode = "i" },
  { "<C-a>", "<Home>", mode = "c" },
  { "<C-e>", "<End>", mode = { "i", "c" } },
  { "<C-d>", "<Delete>", mode = { "i", "c" } },
  { "<A-d>", "<C-O>dw", mode = "i" },
  { "<A-d>", "<S-Right><C-W><Delete>", mode = "c" },
  { "<C-u>", "<C-G>u<C-U>", mode = "i" },
  { "<C-CR>", "<C-o>o", desc = "Move & insert a newline under cursor", mode = "i" },
  { "<A-CR>", "<C-o>o", desc = "Move & insert a newline under cursor", mode = "i" },
  { "<A-o>", "<CR><C-o>O", desc = "Open HTML tags", mode = "i" },
  { "<C-g><C-e>", "<c-g>u<Esc>bgUiwgi", desc = "Uppercase current word", mode = "i" },
  { "<C-g><C-g>", "<c-g>u<Esc>[s1z=`]a<c-g>u", desc = "Fix previous misspelled world", mode = "i" },
  { "<C-s>", "<cmd>w<cr>", desc = "Save File", mode = { "i", "x", "n" } },
  { "<leader>s", "<cmd>w<cr>", desc = "Save File", mode = { "n", "x" } },
  { "ZZ", "<cmd>Quit!<CR>", desc = "close the current window", mode = { "n", "x" } },
  { "<A-=>", "<cmd>resize +3<CR>", mode = { "n", "x" } },
  { "<A-->", "<cmd>resize -3<CR>", mode = { "n", "x" } },
  { "<A-.>", "<cmd>vertical resize +5<CR>", mode = { "n", "x" } },
  { "<A-,>", "<cmd>vertical resize -5<CR>", mode = { "n", "x" } },
  { "gh", "gT", desc = "Jump to left tab", mode = { "n", "x" } },
  { "gl", "gt", desc = "Jump to right tab", mode = { "n", "x" } },
  { "gH", "<cmd>tabmove-<CR>", desc = "Move tab to left" },
  { "gL", "<cmd>tabmove+<CR>", desc = "Move tab to right" },
  { "<leader>fC", ":w <C-R>=expand(\"%\")<CR>", desc = "Copy this file", silent = false },
  { "<leader>fe", ":edit <C-R>=expand('%:p:h') . '\\'<CR>", desc = "Edit in current dir", silent = false },
  { "<leader>fM", ":Move <C-R>=expand(\"%\")<CR>", desc = "Move/rename file", silent = false },
  { "<leader>fi", "<cmd>lua require(\"hasan.widgets.file_info\").show_file_info()<CR>", desc = "Show file info" },
  { "<c-g>", "<cmd>lua require(\"hasan.widgets.file_info\").show_file_info()<CR>", desc = "Show file info" },
}
M.set_opts()
M.disable_keys()
M.set_keymaps(maps_common)
M.set_keymaps(maps)
