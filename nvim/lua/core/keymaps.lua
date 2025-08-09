vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local noSilent = { silent = false }
local nvim_set_keymap = vim.api.nvim_set_keymap
local nx, ic, nxo = { 'n', 'x' }, { 'i', 'c' }, { 'n', 'x', 'o' }

keymap({ 'n', 'x', 'i' }, '<C-c>', '<nop>')
keymap(nx, 'q', '<esc><cmd>noh<CR><C-l>')
keymap(nx, 'Q', function()
  return require('hasan.widgets.register_editor').start_recording()
end, { expr = true, desc = 'Record a macro' })
keymap('v', '@', ':norm @', noSilent) -- run macro on selection
keymap(nx, '<CR>', ':<up>', { silent = false, desc = 'Run last command easily' })
keymap(nx, '<leader><cr>', 'q:', { silent = false, desc = 'Open command history' })
-- keymap({ 'i', 'n', 's' }, '<esc>', function()
--   vim.cmd('noh')
--   vim.snippet.stop()
--   return '<esc>'
-- end, { expr = true, desc = 'Escape and Clear hlsearch' })

-- Center window on insert
-- require('hasan.center_cursor').attach_mappings()
require('hasan.pseudo-text-objects')

for _, mode in ipairs(nx) do
  nvim_set_keymap(mode, 'n', 'nzz', noSilent)
  nvim_set_keymap(mode, 'N', 'Nzz', noSilent)

  nvim_set_keymap(mode, "'", '`', noSilent)
end

if vim.fn.has('nvim-0.11') == 1 then
  local keys_to_del = {
    { 'gra', mode = { 'n', 'x' } },
    'grn',
    'grr',
    'gri',
    'grt',
  }
  for _, key in ipairs(keys_to_del) do
    if type(key) == 'string' then
      pcall(vim.keymap.del, 'n', key)
    else
      pcall(vim.keymap.del, key.mode or 'n', key[1])
    end
  end
end

-- Copy Paste -----------------------------------
keymap('v', 'p', 'pgvy') -- Prevent selecting and pasting from overwriting what you originally copied.
keymap('v', 'y', 'ygv<Esc>') -- Keep cursor at the bottom of the visual selection after you yank it.
keymap('n', 'Y', 'y$') -- Ensure Y works similar to D,C.
keymap('n', 'gV', '`[v`]', { desc = 'Select the last yanked text' })
keymap(nx, 'x', '"_x') -- Prevent x from overriding the clipboard.
keymap(nx, 'X', '"_X')
keymap(ic, '<C-v>', '<C-R>+', noSilent) -- Paste from + register (system clipboard)
keymap(ic, '<C-g><C-v>', '<C-v>', noSilent) -- Paste from + register (system clipboard)
keymap(ic, '<A-p>', '<C-R>"', noSilent) -- Paste the last item from register TODO: vscode-neovim.send
-- Easier system clipboard usage
keymap('n', '<leader>y', '"+y', { desc = 'Yank to system' })
keymap('v', '<leader>y', '"+ygv<Esc>', { desc = 'Yank to system' })
keymap(nx, '<leader>ip', '"+p', { desc = 'Paste from system' })
keymap(nx, '<leader>iP', '"+P', { desc = 'Paste from system' })

-- Modify & rearrange texts ----------------------
local uncomment_block = function()
  require('vim._comment').textobject()
  feedkeys('gc')
end
keymap({ 'n' }, 'gcu', uncomment_block, { desc = 'Uncomment block' })
keymap({ 'n' }, 'gc/', uncomment_block, { desc = 'Uncomment block' })
keymap({ 'o' }, 'a/', '<cmd>lua require("vim._comment").textobject()<CR>', { desc = 'Comment textobject' })
keymap({ 'x' }, 'a/', '<Esc><cmd>lua require("vim._comment").textobject()<CR>', { desc = 'Comment textobject' })

keymap({ 'x' }, 'Z', '<Plug>VSurround')

keymap('x', '$', 'g_') -- A fix to select end of line
keymap('v', '.', ':norm.<cr>') -- Map (.) in visual mode
keymap('v', '>', '>gv') -- Keep selection when indenting/outdenting.
keymap('v', '<', '<gv')
nvim_set_keymap('v', '<C-g>', '*<C-O>:%s///gn<CR>', noSilent) -- Print the number of occurrences of the current word under the cursor

-- Search ---------------------------------------
-- Type a replacement term and press . to repeat the replacement again. Useful
-- for replacing a few instances of the term (alternative to multiple cursors).
keymap('n', 'c*', "<cmd>let @/='\\<'.expand('<cword>').'\\>'<CR>cgn")
keymap('x', 'C', '"cy<cmd>let @/=@c<CR>cgn')
keymap(nx, 'gx', '<Plug>(exchange-operator)', { desc = 'Exchange word' })

local function do_open(uri)
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
local gx_desc = 'Opens filepath or URI under cursor'
keymap('n', 'gB', function()
  do_open(vim.fn.expand('<cfile>'))
end, { desc = gx_desc })
keymap('x', 'gB', function()
  local lines = vim.fn.getregion(vim.fn.getpos('.'), vim.fn.getpos('v'), { type = vim.fn.mode() })
  -- Trim whitespace on each line and concatenate.
  do_open(table.concat(vim.iter(lines):map(vim.trim):totable()))
end, { desc = gx_desc })

keymap({ 'n', 'x' }, 'gW', '<cmd>Translate<CR>')
keymap({ 'n', 'x' }, 'gG', '<cmd>Google<CR>', { desc = 'Search on google' })
keymap('n', 'gpp', '<cmd>lua require("config.lsp.util.extras").hover()<cr>', { desc = 'Preview image under cursor' })

keymap('n', 'cm', ':%s/<c-r>///g<Left><Left>', { desc = 'Change all matches with prompt', silent = false })
keymap('n', 'dm', ':%s/<c-r>///g<CR>', { desc = 'Delete all matches' })
keymap('n', 'dM', ':%g/<c-r>//d<CR>', { desc = 'Delete all lines with matches' })
keymap(nx, '<leader>cw', '<cmd>lua require("hasan.widgets.inputs").substitute_word()<CR>', { desc = 'Substitute word' })

local search_viewport = '/\\%><C-r>=line("w0")-1<CR>l\\%<<C-r>=line("w$")+1<CR>l'
keymap('n', 'z/', search_viewport, { silent = false, desc = 'Search in viewport' })
keymap('x', 'z/', '<ESC>/\\%V', { silent = false, desc = 'Search in visual selection' })

keymap('n', '<leader>r', '<cmd>lua require("hasan.utils.win").cycle_numbering()<CR>', { desc = 'Cycle number' })

if not vim.g.vscode then
  nvim_set_keymap('n', '<C-_>', 'mz_gcc`z', {}) -- Comment or uncomment lines
  nvim_set_keymap('i', '<C-_>', '<ESC>_gccgi', {})
  nvim_set_keymap('v', '<C-_>', 'mz_gcgv`z', {})

  for _, keys in ipairs({ { '<A-k>', '<A-j>' } }) do
    keymap('i', keys[1], '<esc><cmd>m .-2<cr>==gi', { desc = 'Move Up' })
    keymap('i', keys[2], '<esc><cmd>m .+1<cr>==gi', { desc = 'Move Down' })
    -- keymap('n', keys[1], '<cmd>lua require("hasan.utils.buffer").norm_move_up()<cr>')
    -- keymap('n', keys[2], '<cmd>lua require("hasan.utils.buffer").norm_move_down()<cr>')
    -- keymap('x', keys[1], ':MoveUp<CR>')
    -- keymap('x', keys[2], ':MoveDown<CR>')
  end

  -- Fold
  nvim_set_keymap('n', 'zuu', '0vai:foldclose!<CR>zazt', { silent = true, desc = 'Fold current context' })
  nvim_set_keymap('x', 'zu', ':foldclose!<CR>zazt', { silent = true, desc = 'Fold current context' })
  keymap('n', 'z.', '<cmd>%foldclose<CR>zb', { desc = 'Fold all buf' })
  keymap('n', 'z;', '<cmd>setl foldlevel=1<CR>zb', { desc = 'Fold all buf' })
  keymap('n', '<tab>', 'za')
  keymap('n', '<s-tab>', 'zA')

  -- Navigation -----------------------------------
  keymap('n', 'j', function()
    vim.fn['reljump#jump']('j')
  end)
  keymap('n', 'k', function()
    vim.fn['reljump#jump']('k')
  end)

  keymap('n', 'H', 'H<cmd>exec "norm! ".&scrolloff."k"<cr>') -- jump in file
  keymap('n', 'L', 'L<cmd>exec "norm! ".&scrolloff."j"<cr>')

  keymap(nx, '<BS>', '<c-^>')
  keymap(nx, 'g<BS>', '<c-w><c-p>')

  -- Vertical scrolling
  local scroll_maps = {
    { '<A-u>', '<C-u>' },
    { '<A-d>', '<C-d>' },
    { '<A-o>', '<C-d>' },
    { '<PageUp>', '<C-u>' },
    { '<PageDown>', '<C-d>' },
    { '<A-f>', '<C-f>' },
    { '<A-b>', '<C-b>' },
    { '<A-y>', '<C-y>' },
    { '<A-e>', '<C-e>' },
  }
  for _, k in pairs(scroll_maps) do
    -- nvim_set_keymap('n', k[2], k[2] .. 'zz', { noremap = false })
    nvim_set_keymap('n', k[1], k[2], { noremap = false })
    nvim_set_keymap('x', k[1], k[2], { noremap = false })
  end
  -- Horizontal scroll
  keymap(nx, '<A-l>', '20zl')
  keymap(nx, '<A-h>', '20zh')
  -- Jumplist
  keymap('n', '<C-i>', '<C-i>')
  keymap('n', '<C-j>', '<C-i>')

  -- Insert mode ----------------------------------
  -- keymap(ic, 'jk', '<ESC>') -- Use jk to return to normal mode
  keymap('t', '<C-o>', '<C-\\><C-n>', { desc = 'Exit Term mode' })
  keymap('t', '<M-m>', '<cmd>close<cr>', { desc = 'Hide Terminal' })
  -- Add undo break-points
  keymap('i', ',', ',<c-g>u')
  keymap('i', '.', '.<c-g>u')
  keymap('i', ';', ';<c-g>u')

  -- commenting
  keymap('n', 'gco', 'o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>', { desc = 'Add Comment Below' })
  keymap('n', 'gcO', 'O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>', { desc = 'Add Comment Above' })

  keymap(ic, '<A-h>', '<left>', noSilent) -- Move cursor by character
  keymap(ic, '<A-l>', '<right>', noSilent)
  keymap(ic, '<C-n>', '<down>', noSilent)
  keymap(ic, '<C-p>', '<up>', noSilent)
  -- keymap(ic, '<A-j>', '<down>', noSilent)
  -- keymap(ic, '<A-k>', '<up>', noSilent)

  keymap(ic, '<A-f>', '<S-right>', noSilent) -- Move cursor by words
  keymap(ic, '<A-b>', '<S-left>', noSilent)

  keymap('i', '<C-a>', '<C-o>^<C-g>u') -- Jump cursor to start & end of a line
  keymap('c', '<C-a>', '<Home>', noSilent)
  keymap(ic, '<C-e>', '<End>')
  keymap(ic, '<C-d>', '<Delete>', noSilent)

  keymap(ic, '<A-BS>', '<C-W>', noSilent) -- Delete by characters & words
  keymap('i', '<A-d>', '<C-O>dw')
  keymap('c', '<A-d>', '<S-Right><C-W><Delete>', noSilent)
  keymap('i', '<C-CR>', '<C-o>o') -- Make & move to a new line under the cursor
  keymap('i', '<A-CR>', '<C-o>o') -- Make & move to a new line under the cursor
  keymap('i', '<A-o>', '<CR><C-o>O') -- Open HTML tags

  keymap('i', '<C-u>', '<C-G>u<C-U>') -- CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo, so that you can undo CTRL-U after inserting a line break.

  keymap('i', '<C-g><C-e>', '<c-g>u<Esc>bgUiwgi', { desc = 'Uppercase current word' })
  keymap('i', '<C-g><C-g>', '<c-g>u<Esc>[s1z=`]a<c-g>u', { desc = 'Fix previous misspelled world' })

  -- Leader keys ----------------------------------
  keymap(nx, '<leader>s', '<cmd>w<cr>', { desc = 'Save File' })
  keymap({ 'i', 'x', 'n' }, '<C-s>', '<cmd>w<cr>', { desc = 'Save File' })

  -- Window Management ----------------------------
  keymap('n', 'ZZ', '<cmd>Quit!<CR>') -- Prompt before quitting
  keymap('n', '<Bar>', '<cmd>wincmd =<cr>') -- Event all windows
  keymap(nx, '<leader>q', '<cmd>Quit<CR>', { desc = 'Close window' })
  keymap(nx, '<leader>h', '<cmd>lua handle_win_cmd("wincmd h")<CR>', { desc = 'which_key_ignore' })
  keymap(nx, '<leader>j', '<cmd>lua handle_win_cmd("wincmd j")<CR>', { desc = 'which_key_ignore' })
  keymap(nx, '<leader>k', '<cmd>lua handle_win_cmd("wincmd k")<CR>', { desc = 'which_key_ignore' })
  keymap(nx, '<leader>l', '<cmd>lua handle_win_cmd("wincmd l")<CR>', { desc = 'which_key_ignore' })
  -- Resize splits
  keymap('n', '<A-=>', '<cmd>resize +3<CR>')
  keymap('n', '<A-->', '<cmd>resize -3<CR>')
  keymap('n', '<A-.>', '<cmd>vertical resize +5<CR>')
  keymap('n', '<A-,>', '<cmd>vertical resize -5<CR>')
  -- Jump between tabs
  keymap(nx, 'gl', 'gt')
  keymap(nx, 'gh', 'gT')
  keymap('n', 'gL', '<cmd>tabmove+<CR>') -- Move tabs
  keymap('n', 'gH', '<cmd>tabmove-<CR>')
  -- keymap(nx, 'gl',<cmd>'<cmd>!wezterm cli activate-tab --tab-relative 1<CR>')
  -- keymap(nx, 'gh',<cmd>'<cmd>!wezterm cli activate-tab --tab-relative -1<CR>')

  -- File commands
  keymap('n', '<leader>fC', ':w <C-R>=expand("%")<CR>', { silent = false, desc = 'Copy this file' })
  keymap('n', '<leader>fe', ":edit <C-R>=expand('%:p:h') . '\\'<CR>", { silent = false, desc = 'Edit in current dir' })
  keymap('n', '<leader>fM', ':Move <C-R>=expand("%")<CR>', { silent = false, desc = 'Move/rename file' })
  for _, key in pairs({ '<leader>fi', '<c-g>' }) do
    keymap('n', key, '<cmd>lua require("hasan.widgets.file_info").show_file_info()<CR>', { desc = 'Show file info' })
  end

  keymap('n', '<leader>vi', '<Plug>(inspect-pos)', { desc = 'Inspect TS highlight' })
  keymap('n', '<leader>vI', function()
    vim.treesitter.inspect_tree()
    vim.api.nvim_input('I')
  end, { desc = 'Inspect Tree' })
end
