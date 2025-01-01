vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local noSilent = { silent = false }
local nvim_set_keymap = vim.api.nvim_set_keymap
local nx, ic = { 'n', 'x' }, { 'i', 'c' }

keymap(nx, 'q', '<esc><cmd>noh<CR><C-l>')
keymap('n', 'Q', 'q') -- Use Q to record macros
keymap('v', '@', ':norm @', noSilent) -- run macro on selection
keymap(nx, '<CR>', ':<up>', { silent = false, desc = 'Run last command easily' })
keymap(nx, '<leader><cr>', 'q:', { silent = false, desc = 'Open command history' })

-- Center window on insert
require('hasan.center_cursor').attach_mappings()
require('hasan.pseudo-text-objects')

for _, mode in ipairs(nx) do
  nvim_set_keymap(mode, 'n', 'nzz', noSilent)
  nvim_set_keymap(mode, 'N', 'Nzz', noSilent)

  nvim_set_keymap(mode, "'", '`', noSilent)
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

-- Modify & rearange texts ----------------------
-- maps.vnoremap('ao', '<ESC>va{%V%') -- Select a block {} of code
-- maps.nnoremap('yao', 'va{%V%y')
-- maps.nnoremap('dao', 'va{%V%d')

keymap('x', '$', 'g_') -- A fix to select end of line
keymap('v', '.', ':norm.<cr>') -- map . in visual mode
keymap('v', '>', '>gv') -- Keep selection when indenting/outdenting.
keymap('v', '<', '<gv')
nvim_set_keymap('v', '<C-g>', '*<C-O>:%s///gn<CR>', noSilent) -- Print the number of occurrences of the current word under the cursor

-- Search ---------------------------------------
-- Type a replacement term and press . to repeat the replacement again. Useful
-- for replacing a few instances of the term (alternative to multiple cursors).
keymap('n', 'c*', ":let @/='\\<'.expand('<cword>').'\\>'<CR>cgn")
keymap('x', 'C', '"cy:let @/=@c<CR>cgn')
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
keymap('n', 'gO', function()
  do_open(vim.fn.expand('<cfile>'))
end, { desc = gx_desc })
keymap('x', 'gO', function()
  local lines = vim.fn.getregion(vim.fn.getpos('.'), vim.fn.getpos('v'), { type = vim.fn.mode() })
  -- Trim whitespace on each line and concatenate.
  do_open(table.concat(vim.iter(lines):map(vim.trim):totable()))
end, { desc = gx_desc })

keymap('n', 'g/', '<cmd>lua require("hasan.utils").google_search()<CR>', { desc = 'Search on google' })
keymap('x', 'g/', '<Esc><cmd>lua require("hasan.utils").google_search(true)<CR>', { desc = 'Search on google' })

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

  local code_action_keys = { { '<A-k>', '<A-j>' }, { '<up>', '<down>' } }
  for _, action_key in ipairs(code_action_keys) do
    keymap('n', action_key[1], '<cmd>lua require("hasan.utils.buffer").norm_move_up()<cr>')
    keymap('n', action_key[2], '<cmd>lua require("hasan.utils.buffer").norm_move_down()<cr>')
    keymap('x', action_key[1], ':MoveUp<CR>')
    keymap('x', action_key[2], ':MoveDown<CR>')
  end

  -- Fold
  nvim_set_keymap('n', 'zuu', 'vai:foldclose!<CR>zazz', { silent = true, desc = 'Fold under cursor' })
  nvim_set_keymap('x', 'zu', ':foldclose!<CR>zazz', { silent = true, desc = 'Fold under cursor' })
  keymap('n', 'z.', ':%foldclose<CR>', { desc = 'Fold all buf' })
  keymap('n', '<tab>', 'za')
  keymap('n', '<s-tab>', 'zA')

  -- Navigation -----------------------------------
  keymap('n', 'j', function()
    vim.fn['reljump#jump']('j')
  end)
  keymap('n', 'k', function()
    vim.fn['reljump#jump']('k')
  end)

  keymap('n', 'H', 'H:exec "norm! ". &scrolloff . "k"<cr>') -- jump in file
  keymap('n', 'L', 'L:exec "norm! ". &scrolloff . "j"<cr>')

  keymap('n', '<BS>', '<c-^>')

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
  for _, value in pairs(scroll_maps) do
    nvim_set_keymap('n', value[1], value[2], { noremap = false })
    nvim_set_keymap('x', value[1], value[2], { noremap = false })
  end
  -- Horizontal scroll
  keymap(nx, '<A-l>', '20zl')
  keymap(nx, '<A-h>', '20zh')
  -- Resize splits
  keymap('n', '<A-=>', ':resize +3<CR>')
  keymap('n', '<A-->', ':resize -3<CR>')
  keymap('n', '<A-.>', ':vertical resize +5<CR>')
  keymap('n', '<A-,>', ':vertical resize -5<CR>')
  -- Jumplist
  keymap('n', '<C-i>', '<C-i>')
  keymap('n', '<C-j>', '<C-i>')
  -- Jump between tabs
  keymap(nx, 'gl', 'gt')
  keymap(nx, 'gh', 'gT')
  keymap('n', 'gL', ':tabmove+<CR>') -- Move tabs
  keymap('n', 'gH', ':tabmove-<CR>')
  -- keymap(nx, 'gl', '<cmd>!wezterm cli activate-tab --tab-relative 1<CR>')
  -- keymap(nx, 'gh', '<cmd>!wezterm cli activate-tab --tab-relative -1<CR>')

  -- Quickfix list
  -- keymap('n', ']l', ':lnext<CR>')
  -- keymap('n', '[l', ':lprev<CR>')
  -- keymap('n', ']q', ':cnext<CR>')
  -- keymap('n', '[q', ':cprev<CR>')
  -- keymap('n', ']Q', ':clast<CR>')
  -- keymap('n', '[Q', ':cfirst<CR>')

  -- Insert mode ----------------------------------
  -- keymap(ic, 'jk', '<ESC>') -- Use jk to return to normal mode
  keymap('t', '<C-o>', '<C-\\><C-n>')

  keymap(ic, '<A-h>', '<left>', noSilent) -- Move cursor by character
  keymap(ic, '<A-l>', '<right>', noSilent)
  keymap(ic, '<A-j>', '<down>', noSilent)
  keymap(ic, '<A-k>', '<up>', noSilent)

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
  keymap(nx, '<leader>s', '<cmd>silent w<cr>', { desc = 'Save current file' })
  keymap(nx, '<C-s>', '<cmd>silent w<cr>', { desc = 'Save current file' })

  -- Window Management ----------------------------
  keymap('n', 'ZZ', ':Quit!<CR>') -- Prompt before quitting
  keymap('n', '<Bar>', ':wincmd =<cr>') -- Event all windows
  keymap(nx, '<leader>q', '<cmd>Quit<CR>', { desc = 'Close window' })
  keymap(nx, '<leader>h', '<cmd>lua handle_win_cmd("wincmd h")<CR>', { desc = 'which_key_ignore' })
  keymap(nx, '<leader>j', '<cmd>lua handle_win_cmd("wincmd j")<CR>', { desc = 'which_key_ignore' })
  keymap(nx, '<leader>k', '<cmd>lua handle_win_cmd("wincmd k")<CR>', { desc = 'which_key_ignore' })
  keymap(nx, '<leader>l', '<cmd>lua handle_win_cmd("wincmd l")<CR>', { desc = 'which_key_ignore' })

  -- File commands
  keymap('n', '<leader>fC', ':w <C-R>=expand("%")<CR>', { silent = false, desc = 'Copy this file' })
  keymap('n', '<leader>fe', ":edit <C-R>=expand('%:p:h') . '\\'<CR>", { silent = false, desc = 'Edit in current dir' })
  keymap('n', '<leader>fM', ':Move <C-R>=expand("%")<CR>', { silent = false, desc = 'Move/rename file' })
  for _, key in pairs({ '<leader>fi', '<c-g>' }) do
    keymap('n', key, '<cmd>lua require("hasan.widgets.file_info").show_file_info()<CR>', { desc = 'Show file info' })
  end
end
