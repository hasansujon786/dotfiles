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
  { "<CR>", ":<up>", silent = false, mode = { "n", "x" }, desc = "Run last command easily" },
  { "n", "nzz", remap = true, mode = { "n", "x" }, desc = "Repeat the latest \"/\" or \"?\"" },
  { "N", "Nzz", remap = true, mode = { "n", "x" }, desc = "Repeat the latest \"/\" or \"?\"" },
  { "'", "`", remap = true, mode = { "n", "x" }, desc = "Jump to the mark" },
  { "@", ":norm @", silent = false, mode = "v", desc = "Run macro on visual selection" },
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
  { "z/", "<ESC>/\\%V", silent = false, mode = "x", desc = "Search in visual selection" },
  { "gB", M._open, desc = "Opens filepath or URI under cursor" },
  { "gB", M._open_v, mode = "x", desc = "Opens filepath or URI under cursor" },
  { "gW", "<cmd>Translate<CR>", mode = { "n", "x" }, desc = "Search on Translate" },
  { "gG", "<cmd>Google<CR>", mode = { "n", "x" }, desc = "Search on google" },
  { "g<BS>", "<c-w><c-p>", mode = { "n", "x" } },
  { "<leader>r", "<cmd>lua require(\"hasan.utils.win\").cycle_numbering()<CR>", mode = "n", desc = "Cycle number" },
  { "<leader>q", "<Cmd>Quit<CR>", mode = { "n", "x" }, desc = "Close current window" },
  { "<leader>wc", "<Cmd>Quit<CR>", mode = { "n", "x" }, desc = "Close current window" },
  { "<leader>bd", "<Cmd>Bufdelete<CR>", mode = { "n", "x" } },
  { "<leader>h", "<Cmd>wincmd h<CR>", mode = { "n", "x" }, desc = "which_key_ignore" },
  { "<leader>j", "<Cmd>wincmd j<CR>", mode = { "n", "x" }, desc = "which_key_ignore" },
  { "<leader>k", "<Cmd>wincmd k<CR>", mode = { "n", "x" }, desc = "which_key_ignore" },
  { "<leader>l", "<Cmd>wincmd l<CR>", mode = { "n", "x" }, desc = "which_key_ignore" },
  { "<leader>wh", "<Cmd>wincmd h<CR>", mode = { "n", "x" }, desc = "Window left" },
  { "<leader>wj", "<Cmd>wincmd j<CR>", mode = { "n", "x" }, desc = "Window down" },
  { "<leader>wk", "<Cmd>wincmd k<CR>", mode = { "n", "x" }, desc = "Window up" },
  { "<leader>wl", "<Cmd>wincmd l<CR>", mode = { "n", "x" }, desc = "Window right" },
  { "<leader>ws", "<Cmd>wincmd s<CR>", mode = { "n", "x" }, desc = "Window split" },
  { "<leader>wv", "<Cmd>wincmd v<CR>", mode = { "n", "x" }, desc = "Windwo vsplit" },
  { "<leader>wo", "<Cmd>only<CR>", mode = { "n", "x" }, desc = "Keep only window" },
  { "<leader>wO", "<Cmd>tabonly<CR>", mode = { "n", "x" }, desc = "Keep only tab" },
  { "<Bar>", "<Cmd>wincmd =<CR>", mode = { "n", "x" }, desc = "Equalize all windows" },
  { "<leader>wp", "<cmd>lua run_cmd(\"wincmd p\")<CR>", mdoe = { "n", "x" }, desc = "Window previous" },
  { "<leader>ww", "<cmd>lua run_cmd(\"wincmd w\")<CR>", mode = { "n", "x" }, desc = "Window next" },
  { "<leader>wW", "<cmd>lua run_cmd(\"wincmd W\")<CR>", mode = { "n", "x" }, desc = "Window previous" },
}
local maps = {
  { "Q", M.record_macro, expr = true, mode = { "n", "x" }, desc = "Record a macro" },
  { "<C-v>", "<C-R>+", silent = false, mode = { "i", "c" }, desc = "Paste from system clipboard" },
  { "<C-g><C-v>", "<C-v>", silent = false, mode = { "i", "c" }, desc = "Paste from system clipboard" },
  { "<A-p>", "<C-R>\"", silent = false, mode = { "i", "c" }, desc = "Paste the last item from register" },
  { "<A-k>", "<esc><cmd>m .-2<cr>==gi", mode = "i", desc = "Move Up" },
  { "<A-j>", "<esc><cmd>m .+1<cr>==gi", mode = "i", desc = "Move Down" },
  { "<C-_>", "mz_gcc`z", remap = true, mode = "n", desc = "Toggle comment line" },
  { "<C-_>", "<ESC>_gccgi", remap = true, mode = "i", desc = "Toggle comment line" },
  { "<C-_>", "mz_gcgv`z", remap = true, mode = "v", desc = "Toggle comment line" },
  { "zuu", "0vai:foldclose!<CR>zazt", remap = true, mode = { "n", "x" }, desc = "Fold current context" },
  { "zu", ":foldclose!<CR>zazt", remap = true, mode = { "n", "x" }, desc = "Fold current context" },
  { "<tab>", "za", mode = { "n", "x" }, desc = "Toggle fold" },
  { "<s-tab>", "zA", mode = { "n", "x" }, desc = "Toggle fold recursively" },
  { "z.", "<cmd>%foldclose<CR>zb", mode = { "n", "x" }, desc = "Fold all buf" },
  { "z;", "<cmd>setl foldlevel=1<CR>zb", mode = { "n", "x" }, desc = "Fold all buf" },
  { "<BS>", "<c-^>", mode = { "n", "x" }, desc = "Edit alternate file" },
  { "<C-j>", "<c-i>", mode = { "n", "x" }, remap = false },
  { "k", "v:count == 0 ? \"gk\" : \"k\"", expr = true, remap = false, desc = "Move cursor up" },
  { "j", "v:count == 0 ? \"gj\" : \"j\"", expr = true, remap = false, desc = "Move cursor down" },
  { "<A-u>", "<C-u>", remap = true, mode = { "n", "x" }, desc = "Scroll window" },
  { "<A-d>", "<C-d>", remap = true, mode = { "n", "x" }, desc = "Scroll window" },
  { "<A-o>", "<C-d>", remap = true, mode = { "n", "x" }, desc = "Scroll window" },
  { "<PageUp>", "<C-u>", remap = true, mode = { "n", "x" }, desc = "Scroll window" },
  { "<PageDown>", "<C-d>", remap = true, mode = { "n", "x" }, desc = "Scroll window" },
  { "<A-f>", "<C-f>", remap = true, mode = { "n", "x" }, desc = "Scroll window" },
  { "<A-b>", "<C-b>", remap = true, mode = { "n", "x" }, desc = "Scroll window" },
  { "<A-y>", "<C-y>", remap = true, mode = { "n", "x" }, desc = "Scroll window" },
  { "<A-e>", "<C-e>", remap = true, mode = { "n", "x" }, desc = "Scroll window" },
  { "<A-h>", "20zh", mode = { "n", "x" } },
  { "<A-l>", "20zl", mode = { "n", "x" } },
  { "<C-o>", "<C-\\><C-n>", mode = "t", desc = "Exit Term mode" },
  { "<M-m>", "<cmd>close<cr>", mode = "t", desc = "Hide Terminal" },
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
  { "<C-CR>", "<C-o>o", mode = "i", desc = "Move & insert a newline under cursor" },
  { "<A-CR>", "<C-o>o", mode = "i", desc = "Move & insert a newline under cursor" },
  { "<A-o>", "<CR><C-o>O", mode = "i", desc = "Open HTML tags" },
  { "<C-g><C-e>", "<c-g>u<Esc>bgUiwgi", mode = "i", desc = "Uppercase current word" },
  { "<C-g><C-g>", "<c-g>u<Esc>[s1z=`]a<c-g>u", mode = "i", desc = "Fix previous misspelled world" },
  { "<C-s>", "<cmd>w<cr>", mode = { "i", "x", "n" }, desc = "Save File" },
  { "<leader>s", "<cmd>w<cr>", mode = { "n", "x" }, desc = "Save File" },
  { "ZZ", "<cmd>Quit!<CR>", mode = { "n", "x" }, desc = "close the current window" },
  { "<A-=>", "<cmd>resize +3<CR>", mode = { "n", "x" } },
  { "<A-->", "<cmd>resize -3<CR>", mode = { "n", "x" } },
  { "<A-.>", "<cmd>vertical resize +5<CR>", mode = { "n", "x" } },
  { "<A-,>", "<cmd>vertical resize -5<CR>", mode = { "n", "x" } },
  { "gh", "gT", mode = { "n", "x" }, desc = "Jump to left tab" },
  { "gl", "gt", mode = { "n", "x" }, desc = "Jump to right tab" },
  { "gH", "<cmd>tabmove-<CR>", desc = "Move tab to left" },
  { "gL", "<cmd>tabmove+<CR>", desc = "Move tab to right" },
  { "<leader>fC", ":w <C-R>=expand(\"%\")<CR>", silent = false, desc = "Copy this file" },
  { "<leader>fe", ":edit <C-R>=expand('%:p:h') . '\\'<CR>", silent = false, desc = "Edit in current dir" },
  { "<leader>fM", ":Move <C-R>=expand(\"%\")<CR>", silent = false, desc = "Move/rename file" },
  { "<leader>fi", "<cmd>lua require(\"hasan.widgets.file_info\").show_file_info()<CR>", desc = "Show file info" },
  { "<c-g>", "<cmd>lua require(\"hasan.widgets.file_info\").show_file_info()<CR>", desc = "Show file info" },
}
M.set_opts()
M.disable_keys()
M.set_keymaps(maps_common)
M.set_keymaps(maps)
