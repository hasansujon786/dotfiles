local n, nx, ic, nxo, nxi = { 'n' }, { 'n', 'x' }, { 'i', 'c' }, { 'n', 'x', 'o' }, { 'n', 'x', 'i' }

---@class MyKeySpecs
---@field [1] string lhs
---@field [2]? string|fun():string?|false|table
---@field desc? string
---@field noremap? boolean
---@field remap? boolean
---@field expr? boolean
---@field nowait? boolean
---@field ft? string|string[]
---@field mode? string|string[]
---@field silent? boolean

---@class MyKeymaps
---@field all MyKeySpecs[]
---@field vscode MyKeySpecs[]
---@field nvim MyKeySpecs[]
local M = { all = {}, vscode = {}, nvim = {} }

---Set keymap for nvim & vscode
---@param k MyKeySpecs
local function amap(k)
  table.insert(M.all, k)
end

---Set keymap only for nvim
---@param k MyKeySpecs
local function nmap(k)
  table.insert(M.nvim, k)
end

---Set keymap for vscode
---@param k MyKeySpecs
local function vmap(k)
  table.insert(M.vscode, k)
end

---Setup keymaps
---@param key_specs MyKeySpecs[]
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

local function setup()
  amap({ 'q', '<esc><cmd>noh<CR>', mode = nx })
  amap({ '<CR>', ':<up>', silent = false, desc = 'Run last command easily', mode = nx })
  amap({ 'n', 'nzz', desc = 'Repeat the latest "/" or "?"', remap = true, mode = nx })
  amap({ 'N', 'Nzz', desc = 'Repeat the latest "/" or "?"', remap = true, mode = nx })
  amap({ "'", '`', desc = 'Jump to the mark', remap = true, mode = nx })

  -- Custom record keymaps
  function M.record_macro()
    return require('hasan.widgets.register_editor').start_recording()
  end

  nmap({ 'Q', { __code = 'M.record_macro' }, mode = nx, expr = true, desc = 'Record a macro' })
  vmap({ 'Q', 'q', { desc = 'Record a macro' } })
  amap({ '@', ':norm @', mode = 'v', silent = false, desc = 'Run macro on visual selection' })

  -- Center window on insert
  -- require('hasan.center_cursor').attach_mappings()

  -- Copy Paste -----------------------------------
  amap({ 'p', 'pgvy', mode = 'v' }) -- Prevent selecting and pasting from overwriting what you originally copied.
  amap({ 'y', 'ygv<Esc>', desc = 'Keep cursor at place', mode = 'v' })
  amap({ 'gV', '`[v`]', desc = 'Select the last yanked text' })
  amap({ 'x', '"_x', desc = 'Prevent x from overriding the clipboard.', mode = nx })
  amap({ 'X', '"_X', desc = 'Prevent X from overriding the clipboard.', mode = nx })

  -- TODO: vscode-neovim.send
  nmap({ '<C-v>', '<C-R>+', mode = ic, silent = false, desc = 'Paste from system clipboard' })
  nmap({ '<C-g><C-v>', '<C-v>', mode = ic, silent = false, desc = 'Paste from system clipboard' })
  nmap({ '<A-p>', '<C-R>"', mode = ic, silent = false, desc = 'Paste the last item from register' })

  -- Easier system clipboard usage
  amap({ '<leader>y', '"+y', desc = 'Yank to system', mode = 'n' })
  amap({ '<leader>y', '"+ygv<Esc>', desc = 'Yank to system', mode = 'v' })
  amap({ '<leader>ip', '"+p', desc = 'Paste from system', mode = nx })
  amap({ '<leader>iP', '"+P', desc = 'Paste from system', mode = nx })

  -- Search & Modify texts ------------------------
  amap({ '$', 'g_', desc = 'A fix to select end of line', mode = { 'x' } })
  amap({ '>', '>gv', mode = 'v', desc = 'Keep selection when indenting/outdenting' })
  amap({ '<', '<gv', mode = 'v', desc = 'Keep selection when indenting/outdenting' })
  for _, keys in ipairs({ { '<A-k>', '<A-j>' } }) do
    nmap({ keys[1], '<esc><cmd>m .-2<cr>==gi', desc = 'Move Up', mode = 'i' })
    nmap({ keys[2], '<esc><cmd>m .+1<cr>==gi', desc = 'Move Down', mode = 'i' })
  end

  function M.uncomment_block()
    require('vim._comment').textobject()
    feedkeys('gc')
  end

  amap({ 'gcu', { __code = 'M.uncomment_block' }, desc = 'Uncomment block', mode = 'n' })
  amap({ 'gc/', { __code = 'M.uncomment_block' }, desc = 'Uncomment block', mode = 'n' })
  amap({ 'a/', '<cmd>lua require("vim._comment").textobject()<CR>', desc = 'Comment textobject', mode = 'o' })
  amap({ 'a/', '<Esc><cmd>lua require("vim._comment").textobject()<CR>', desc = 'Comment textobject', mode = 'x' })

  -- Toggle comment lines & persist cursor position
  nmap({ '<C-_>', 'mz_gcc`z', desc = 'Toggle comment line', mode = 'n', remap = true })
  nmap({ '<C-_>', '<ESC>_gccgi', desc = 'Toggle comment line', mode = 'i', remap = true })
  nmap({ '<C-_>', 'mz_gcgv`z', desc = 'Toggle comment line', mode = 'v', remap = true })

  -- Comment below/above/at the end of current line
  function M.comment_at(move)
    return function()
      local lhs, rhs = require('hasan.utils.buffer').current_commentstring():match('^(.-)%%s(.*)$')
      local shiftstr = string.rep(vim.keycode('<Left>'), #rhs)
      vim.fn.feedkeys(move .. lhs .. rhs .. shiftstr)
    end
  end

  amap({ 'gcO', { __code = "M.comment_at('O')" }, desc = 'Add comment above' })
  amap({ 'gco', { __code = "M.comment_at('o')" }, desc = 'Add comment below' })
  amap({ 'gcI', { __code = "M.comment_at('I')" }, desc = 'Add comment start of line' })
  amap({ 'gcA', { __code = "M.comment_at('A ')" }, desc = 'Add comment end of line' })

  -- nvim_set_keymap('v', '<C-g>', '*<C-O>:%s///gn<CR>', noSilent) -- Print the number of occurrences of the current word under the cursor

  function M.multi_cursor(cmd)
    return function()
      require('vscode').with_insert(function()
        require('vscode').action(cmd)
      end)
    end
  end

  vmap({ '<C-l>', { __code = "M.multi_cursor('editor.action.addSelectionToNextFindMatch')" }, mode = nxi })
  vmap({ '<C-S-l>', { __code = "M.multi_cursor('editor.action.selectHighlights')" }, mode = nxi })

  amap({ 'cm', ':%s/<c-r>///g<Left><Left>', desc = 'Change all matches with prompt', silent = false })
  amap({ 'dm', ':%s/<c-r>///g<CR>', desc = 'Delete all matches' })
  amap({ 'dM', ':%g/<c-r>//d<CR>', desc = 'Delete all lines with matches' })
  amap({
    '<leader>cw',
    '<cmd>lua require("hasan.widgets.inputs").substitute_word()<CR>',
    desc = 'Substitute word',
    mode = nx,
  })

  local search_viewport = '/\\%><C-r>=line("w0")-1<CR>l\\%<<C-r>=line("w$")+1<CR>l'
  amap({ 'z/', search_viewport, silent = false, desc = 'Search in viewport' })
  amap({ 'z/', '<ESC>/\\%V', silent = false, desc = 'Search in visual selection', mode = 'x' })

  -- Search visual selection or word
  vmap({
    '<A-/>',
    '<cmd>lua require("vscode").action("workbench.action.findInFiles",{args={query=vim.fn.expand("<cword>")}})<CR>',
  })
  vmap({ '<A-/>', '<cmd>lua require("vscode").action("workbench.action.findInFiles")<CR>', mode = 'x' })
  vmap({ '<leader>//', '<cmd>lua require("vscode").action("workbench.action.findInFiles")<CR>', mode = nx })

  -- Picker keymaps
  vmap({ '<leader><leader>', '<cmd>Tabfind<CR>', mode = nx })
  vmap({ '<leader>pp', '<cmd>lua require("vscode").action("workbench.action.openRecent")<CR>', mode = nx })
  vmap({ 'g.', '<cmd>lua require("vscode").action("workbench.action.showAllEditors")<CR>', mode = nx })

  -- Open ----------------------------------------
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

  amap({ 'gB', { __code = 'M._open' }, desc = 'Opens filepath or URI under cursor' })
  amap({ 'gB', { __code = 'M._open_v' }, desc = 'Opens filepath or URI under cursor', mode = 'x' })
  amap({ 'gW', '<cmd>Translate<CR>', desc = 'Search on Translate', mode = nx })
  amap({ 'gG', '<cmd>Google<CR>', desc = 'Search on google', mode = nx })

  -- TODO: fix or remove image preview or make it a command
  -- keymap('n', 'gpp', '<cmd>lua require("config.lsp.util.extras").hover()<cr>', { desc = 'Preview image under cursor' })

  -- Fold
  nmap({ 'zuu', '0vai:foldclose!<CR>zazt', desc = 'Fold current context', remap = true, mode = nx })
  nmap({ 'zu', ':foldclose!<CR>zazt', desc = 'Fold current context', remap = true, mode = nx })

  nmap({ '<tab>', 'za', desc = 'Toggle fold', mode = nx })
  nmap({ '<s-tab>', 'zA', desc = 'Toggle fold recursively', mode = nx })
  vmap({ '<tab>', '<cmd>lua require("vscode").action("editor.toggleFold")<CR>', desc = 'Toggle fold' })
  vmap({ '<s-tab>', '<cmd>lua require("vscode").action("editor.toggleFoldRecursively")<CR>', desc = 'Fold recursively' })

  function M.foldWithLevel(level)
    return function()
      require('vscode').action('runCommands', { args = { commands = { 'editor.unfoldAll', level } } })
    end
  end

  nmap({ 'z.', '<cmd>%foldclose<CR>zb', desc = 'Fold all buf', mode = nx })
  nmap({ 'z;', '<cmd>setl foldlevel=1<CR>zb', desc = 'Fold all buf', mode = nx })
  vmap({ 'z.', { __code = "M.foldWithLevel('editor.foldLevel1')" }, desc = 'Fold all buf', mode = nx })
  vmap({ 'z;', { __code = "M.foldWithLevel('editor.foldLevel2')" }, desc = 'Fold all buf', mode = nx })

  vmap({ 'za', '<cmd>lua require("vscode").action("editor.toggleFold")<CR>', desc = 'Toggle fold' })
  vmap({ 'zc', '<cmd>lua require("vscode").action("editor.foldRecursively")<CR>', desc = 'Fold recursively' })
  vmap({ 'zC', '<cmd>lua require("vscode").action("editor.foldAll")<CR>', desc = 'Fold all' })
  vmap({ 'zM', '<cmd>lua require("vscode").action("editor.foldRecursively")<CR>', desc = 'Fold recursively' })
  vmap({ 'zM', '<cmd>lua require("vscode").action("editor.foldAll")<CR>', desc = 'Fold all' })
  vmap({ 'zo', '<cmd>lua require("vscode").action("editor.unfoldRecursively")<CR>', desc = 'Unfold recursively' })
  vmap({ 'zO', '<cmd>lua require("vscode").action("editor.unfoldAll")<CR>', desc = 'Unfold all' })
  vmap({ 'zr', '<cmd>lua require("vscode").action("editor.unfoldRecursively")<CR>', desc = 'Unfold recursively' })
  vmap({ 'zR', '<cmd>lua require("vscode").action("editor.unfoldAll")<CR>', desc = 'Unfold all' })
  vmap({ 'zp', '<cmd>lua require("vscode").action("editor.gotoParentFold")<CR>', desc = 'Go to parent fold' })

  -- Navigation -----------------------------------
  function M.edit_alternate_file()
    require('vscode').action('runCommands', {
      args = { commands = { 'workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup', 'list.select' } },
    })
  end

  nmap({ '<BS>', '<c-^>', desc = 'Edit alternate file', mode = nx })
  vmap({ '<BS>', { __code = 'M.edit_alternate_file' }, desc = 'Edit alternate file', mode = nx })
  amap({ 'g<BS>', '<c-w><c-p>', mode = nx })
  nmap({ '<C-j>', '<c-i>', mode = nx, remap = false })
  vmap({ '<C-j>', '<cmd>lua require("vscode").action("workbench.action.navigateForward")<CR>', mode = nx })

  vmap({ ']d', '<cmd>lua require("vscode").action("editor.action.marker.nextInFiles")<CR>', mode = nx })
  vmap({ '[d', '<cmd>lua require("vscode").action("editor.action.marker.prevInFiles")<CR>', mode = nx })
  vmap({ '[c', '<cmd>lua require("vscode").action("workbench.action.editor.previousChange")<CR>', mode = nx })
  vmap({ ']c', '<cmd>lua require("vscode").action("workbench.action.editor.nextChange")<CR>', mode = nx })
  vmap({ '[x', '<cmd>lua require("vscode").action("editor.action.dirtydiff.prev")<CR>', mode = nx })
  vmap({ ']x', '<cmd>lua require("vscode").action("editor.action.dirtydiff.next")<CR>', mode = nx })
  vmap({ 'g[', '<cmd>lua require("vscode").action("editor.action.wordHighlight.prev")<CR>', mode = nx })
  vmap({ 'g]', '<cmd>lua require("vscode").action("editor.action.wordHighlight.next")<CR>', mode = nx })

  nmap({ 'k', 'v:count == 0 ? "gk" : "k"', desc = 'Move cursor up', expr = true, remap = false })
  nmap({ 'j', 'v:count == 0 ? "gj" : "j"', desc = 'Move cursor down', expr = true, remap = false })
  vmap({ 'k', 'v:count == 0 ? "gk" : "k"', desc = 'Move cursor up', expr = true, remap = true })
  vmap({ 'j', 'v:count == 0 ? "gj" : "j"', desc = 'Move cursor down', expr = true, remap = true })

  -- Vertical scrolling
  local scroll_maps = {
    { '<A-u>',      '<C-u>' },
    { '<A-d>',      '<C-d>' },
    { '<A-o>',      '<C-d>' },
    { '<PageUp>',   '<C-u>' },
    { '<PageDown>', '<C-d>' },
    { '<A-f>',      '<C-f>' },
    { '<A-b>',      '<C-b>' },
    { '<A-y>',      '<C-y>' },
    { '<A-e>',      '<C-e>' },
  }
  for _, k in pairs(scroll_maps) do
    nmap({ k[1], k[2], desc = 'Scroll window', mode = nx, remap = true })
  end
  -- Horizontal scroll
  nmap({ '<A-h>', '20zh', mode = nx })
  nmap({ '<A-l>', '20zl', mode = nx })

  -- Insert & Term mode -------------------------
  nmap({ '<C-o>', '<C-\\><C-n>', desc = 'Exit Term mode', mode = 't' })
  nmap({ '<M-m>', '<cmd>close<cr>', desc = 'Hide Terminal', mode = 't' })

  -- Add undo break-points
  nmap({ ',', ',<c-g>u', mode = 'i' })
  nmap({ '.', '.<c-g>u', mode = 'i' })
  nmap({ ';', ';<c-g>u', mode = 'i' })

  -- Move cursor by character
  nmap({ '<A-h>', '<left>', mode = ic })
  nmap({ '<A-l>', '<right>', mode = ic })
  nmap({ '<C-n>', '<down>', mode = ic })
  nmap({ '<C-p>', '<up>', mode = ic })
  -- Move cursor by words
  nmap({ '<A-f>', '<S-right>', mode = ic })
  nmap({ '<A-b>', '<S-left>', mode = ic })
  -- Jump cursor to start & end of a line
  nmap({ '<C-a>', '<C-o>^<C-g>u', mode = 'i' })
  nmap({ '<C-a>', '<Home>', mode = 'c' })
  nmap({ '<C-e>', '<End>', mode = ic })
  nmap({ '<C-d>', '<Delete>', mode = ic })
  -- Delete by characters & words
  nmap({ '<A-d>', '<C-O>dw', mode = 'i' })
  nmap({ '<A-d>', '<S-Right><C-W><Delete>', mode = 'c' })

  -- CTRL-U in insert mode deletes a lot. Use CTRL-G u to first break undo, so
  -- that you can undo CTRL-U after inserting a line break.
  nmap({ '<C-u>', '<C-G>u<C-U>', mode = 'i' })

  nmap({ '<C-CR>', '<C-o>o', desc = 'Move & insert a newline under cursor', mode = 'i' })
  nmap({ '<A-CR>', '<C-o>o', desc = 'Move & insert a newline under cursor', mode = 'i' })
  nmap({ '<A-o>', '<CR><C-o>O', desc = 'Open HTML tags', mode = 'i' })

  nmap({ '<C-g><C-e>', '<c-g>u<Esc>bgUiwgi', desc = 'Uppercase current word', mode = 'i' })
  nmap({ '<C-g><C-g>', '<c-g>u<Esc>[s1z=`]a<c-g>u', desc = 'Fix previous misspelled world', mode = 'i' })

  -- Leader keys ----------------------------------
  -- Save file
  nmap({ '<C-s>', '<cmd>w<cr>', desc = 'Save File', mode = { 'i', 'x', 'n' } })
  nmap({ '<leader>s', '<cmd>w<cr>', desc = 'Save File', mode = nx })
  vmap({ '<leader>s', '<cmd>lua require("vscode").action("workbench.action.files.save")<CR>', mode = nx })
  vmap({ '<leader>fs', '<cmd>lua require("vscode").action("editor.action.formatDocument")<CR>', mode = 'n' })
  vmap({ '<leader>fs', '<cmd>lua require("vscode").action("editor.action.formatSelection")<CR>', mode = 'x' })
  vmap({ '<leader>fxx', '<cmd>lua require("vscode").action("editor.action.trimTrailingWhitespace")<cr>' })

  amap({ '<leader>r', '<cmd>lua require("hasan.utils.win").cycle_numbering()<CR>', desc = 'Cycle number', mode = 'n' })
  vmap({ '<leader>u', '<cmd>lua require("vscode").action("workbench.action.toggleZenMode")<CR>', mode = nx })

  -- Git
  vmap({ '<leader>gg', '<cmd>lua require("vscode").action("workbench.view.scm")<CR>' })
  vmap({ '<leader>g.', '<cmd>lua require("vscode").action("git.stage")<CR>' })
  vmap({ '<leader>gp', '<cmd>lua require("vscode").action("editor.action.dirtydiff.next")<CR>', mode = nx })
  vmap({ '<leader>gr', '<cmd>lua require("vscode").action("git.revertSelectedRanges")<CR>', mode = nx })
  vmap({ '<leader>gs', '<cmd>lua require("vscode").action("git.stageSelectedRanges")<CR>', mode = nx })
  vmap({ '<leader>gd', '<cmd>lua require("vscode").action("git.viewChanges")<CR>', mode = nx })
  -- keymap({ 'n', 'x' }, '<leader>gu', '<cmd>lua require("vscode").action("git.unstageSelectedRanges")<CR>')

  -- Debugger
  vmap({ '<leader>dc', '<cmd>lua require("vscode").action("workbench.action.debug.continue")<CR>' })
  vmap({ '<leader>ds', '<cmd>lua require("vscode").action("workbench.action.debug.continue")<CR>' })
  vmap({ '<leader>da', '<cmd>lua require("vscode").action("workbench.action.debug.selectandstart")<CR>' })
  vmap({ '<leader>dq', '<cmd>lua require("vscode").action("workbench.action.debug.stop")<CR>' })
  vmap({ '<leader>db', '<cmd>lua require("vscode").action("editor.debug.action.toggleBreakpoint")<CR>' })
  vmap({ '<leader>di', '<cmd>lua require("vscode").action("workbench.action.debug.stepInto")<CR>' })
  vmap({ '<leader>do', '<cmd>lua require("vscode").action("workbench.action.debug.stepOver")<CR>' })
  vmap({ '<leader>dh', '<cmd>lua require("vscode").action("editor.debug.action.showDebugHover")<CR>' })

  -- Editor
  vmap({ '<leader>vo', '<cmd>lua require("vscode").action("notifications.clearAll")<CR>', mode = nx })

  -- Explorer
  vmap({ '<leader>op', '<cmd>lua require("vscode").action("workbench.view.explorer")<CR>' })
  vmap({ '-', '<cmd>lua require("vscode").action("workbench.files.action.showActiveFileInExplorer")<CR>' })

  local run_cmd = require('hasan.utils.run_cmd').run_cmd

  -- Window Management ----------------------------
  nmap({ 'ZZ', '<cmd>Quit!<CR>', desc = 'close the current window', mode = nx })
  amap({ '<leader>q', run_cmd('Quit'), desc = 'Close current window', mode = nx })
  amap({ '<leader>wc', run_cmd('Quit'), desc = 'Close current window', mode = nx })
  amap({ '<leader>bd', run_cmd('Bufdelete'), mode = nx })

  amap({ '<leader>h', run_cmd('wincmd h'), desc = 'which_key_ignore', mode = nx })
  amap({ '<leader>j', run_cmd('wincmd j'), desc = 'which_key_ignore', mode = nx })
  amap({ '<leader>k', run_cmd('wincmd k'), desc = 'which_key_ignore', mode = nx })
  amap({ '<leader>l', run_cmd('wincmd l'), desc = 'which_key_ignore', mode = nx })

  amap({ '<leader>wh', run_cmd('wincmd h'), desc = 'Window left', mode = nx })
  amap({ '<leader>wj', run_cmd('wincmd j'), desc = 'Window down', mode = nx })
  amap({ '<leader>wk', run_cmd('wincmd k'), desc = 'Window up', mode = nx })
  amap({ '<leader>wl', run_cmd('wincmd l'), desc = 'Window right', mode = nx })

  amap({ '<leader>ws', run_cmd('wincmd s'), desc = 'Window split', mode = nx })
  amap({ '<leader>wv', run_cmd('wincmd v'), desc = 'Windwo vsplit', mode = nx })

  amap({ '<leader>wo', run_cmd('only'), desc = 'Keep only window', mode = nx })
  amap({ '<leader>wO', run_cmd('tabonly'), desc = 'Keep only tab', mode = nx })
  amap({ '<Bar>', run_cmd('wincmd ='), desc = 'Equalize all windows', mode = nx })

  amap({ '<leader>wp', '<cmd>lua run_cmd("wincmd p")<CR>', desc = 'Window previous', mdoe = nx })
  amap({ '<leader>ww', '<cmd>lua run_cmd("wincmd w")<CR>', desc = 'Window next', mode = nx })
  amap({ '<leader>wW', '<cmd>lua run_cmd("wincmd W")<CR>', desc = 'Window previous', mode = nx })

  -- Resize splits
  nmap({ '<A-=>', '<cmd>resize +3<CR>', mode = nx })
  nmap({ '<A-->', '<cmd>resize -3<CR>', mode = nx })
  nmap({ '<A-.>', '<cmd>vertical resize +5<CR>', mode = nx })
  nmap({ '<A-,>', '<cmd>vertical resize -5<CR>', mode = nx })

  -- Jump between tabs
  nmap({ 'gh', 'gT', desc = 'Jump to left tab', mode = nx })
  nmap({ 'gl', 'gt', desc = 'Jump to right tab', mode = nx })
  nmap({ 'gH', '<cmd>tabmove-<CR>', desc = 'Move tab to left' })
  nmap({ 'gL', '<cmd>tabmove+<CR>', desc = 'Move tab to right' })
  vmap({ 'gh', '<cmd>lua require("vscode").action("workbench.action.previousEditorInGroup")<CR>', mode = nx })
  vmap({ 'gl', '<cmd>lua require("vscode").action("workbench.action.nextEditorInGroup")<CR>', mode = nx })
  vmap({ 'gH', '<cmd>lua require("vscode").action("workbench.action.firstEditorInGroup")<CR>', mode = nx })
  vmap({ 'gL', '<cmd>lua require("vscode").action("workbench.action.lastEditorInGroup")<CR>', mode = nx })

  -- File commands
  nmap({ '<leader>fC', ':w <C-R>=expand("%")<CR>', desc = 'Copy this file', silent = false })
  nmap({ '<leader>fe', ":edit <C-R>=expand('%:p:h') . '\\'<CR>", desc = 'Edit in current dir', silent = false })
  nmap({ '<leader>fM', ':Move <C-R>=expand("%")<CR>', desc = 'Move/rename file', silent = false })
  for _, key in pairs({ '<leader>fi', '<c-g>' }) do
    nmap({ key, '<cmd>lua require("hasan.widgets.file_info").show_file_info()<CR>', desc = 'Show file info' })
  end

  -- Lsp
  vmap({ 'gd', '<cmd>lua require("vscode").action("editor.action.revealDefinition")<CR>' })
  vmap({ 'gr', '<cmd>lua vim.lsp.buf.references()<CR>' })
  vmap({ 'gR', '<cmd>lua require("vscode").action("references-view.findReferences")<CR>' })
  vmap({ 'gI', '<cmd>lua vim.lsp.buf.implementation()<CR>' })
  vmap({ 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>' })
  vmap({ 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>' })
  vmap({ 'go', '<cmd>lua vim.lsp.buf.document_symbol()<CR>' })
  vmap({ '<leader>ad', '<cmd>lua require("vscode").action("workbench.panel.markers.view.focus")<CR>' })
end

local header = [[
local M = {}

]]

local footer = [[
M.set_opts()
M.disable_keys()
M.set_keymaps(maps_common)
M.set_keymaps(maps)
]]

local genereate = require('hasan.utils.genereate_keys')

local function run(vscode)
  vim.g.vscode = vscode
  M.all = {}
  M.nvim = {}
  M.vscode = {}

  if vscode then
    setup()
    genereate.run(M.all, M.vscode, 'nvim/lua/core/keymaps/code.lua', { footer = footer, header = header })
    genereate.copyContent('nvim/lua/hasan/pseudo-text-objects.lua', 'nvim/lua/core/keymaps/code.lua')
    genereate.copyContent('nvim/lua/core/keymaps/code_autocmds.lua', 'nvim/lua/core/keymaps/code.lua')
  else
    setup()
    genereate.run(M.all, M.nvim, 'nvim/lua/core/keymaps/nvim.lua', { footer = footer, header = header })
  end
end

run(true)
run(false)
