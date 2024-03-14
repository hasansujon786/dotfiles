local noSilent = { silent = false }
local nvim_set_keymap = vim.api.nvim_set_keymap

keymap('n', 'q', '<ESC><Cmd>nohlsearch<CR><C-l>')
keymap('v', 'q', '<ESC>')
keymap('n', 'ZZ', ':Quit!<CR>') -- Prompt before quitting
keymap('n', 'Q', 'q') -- Use Q to record macros
keymap('v', '@', ':norm @', noSilent) -- run macro on selection
keymap({ 'n', 'x' }, '<CR>', ':<up>', noSilent) -- run last : command easily

-- fix InsertEnter zz
keymap('n', 'A', 'zzA')
keymap('n', 'I', 'zzI')
keymap('n', 'i', 'zzi')
keymap('n', 'a', 'zza')

-- Copy Paste -----------------------------------
keymap('v', 'p', 'pgvy') -- Prevent selecting and pasting from overwriting what you originally copied.
keymap('v', 'y', 'ygv<Esc>') -- Keep cursor at the bottom of the visual selection after you yank it.
keymap('n', 'Y', 'y$') -- Ensure Y works similar to D,C.
keymap('n', 'gV', '`[v`]', { desc = 'Select the last yanked text' })
keymap({ 'n', 'x' }, 'x', '"_x') -- Prevent x from overriding the clipboard.
keymap({ 'n', 'x' }, 'X', '"_X')
keymap({ 'i', 'c' }, '<C-v>', '<C-R>+', noSilent) -- Paste from + register (system clipboard)
keymap({ 'i', 'c' }, '<A-p>', '<C-R>"', noSilent) -- Paste the last item from register
-- Easier system clipboard usage
keymap('n', '<leader>y', '"+y', { desc = 'Yank to system' })
keymap('v', '<leader>y', '"+ygv<Esc>', { desc = 'Yank to system' })
keymap({ 'n', 'v' }, '<leader>ip', '"+p', { desc = 'Paste from system' })
keymap({ 'n', 'v' }, '<leader>iP', '"+P', { desc = 'Paste from system' })

-- Modify & rearange texts ----------------------
-- maps.vnoremap('ao', '<ESC>va{%V%') -- Select a block {} of code
-- maps.nnoremap('yao', 'va{%V%y')
-- maps.nnoremap('dao', 'va{%V%d')

keymap('x', '$', 'g_') -- A fix to select end of line
keymap('v', '.', ':norm.<cr>') -- map . in visual mode
keymap('v', '>', '>gv') -- Keep selection when indenting/outdenting.
keymap('v', '<', '<gv')
nvim_set_keymap('v', '<C-g>', '*<C-O>:%s///gn<CR>', noSilent) -- Print the number of occurrences of the current word under the cursor

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

keymap({ 'n', 'v' }, 'gx', '<Plug>(exchange-operator)', { desc = 'Exchange vnoremap' })

keymap('n', 'z.', ':%foldclose<CR>') -- Fold
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
keymap({ 'n', 'x' }, "'", '`') -- Character wise jumps always

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

keymap({ 'n', 'v' }, '<A-l>', '20zl') -- Horizontal scroll ---- <ScrollWheelRight> <ScrollWheelLeft>
keymap({ 'n', 'v' }, '<A-h>', '20zh')

keymap('n', '<A-=>', ':resize +3<CR>') -- Resize splits
keymap('n', '<A-->', ':resize -3<CR>')
keymap('n', '<A-.>', ':vertical resize +5<CR>')
keymap('n', '<A-,>', ':vertical resize -5<CR>')

keymap('n', '\\', ':ZenMode<CR>') -- Zoom a vim pane
keymap('n', '<leader>u', ':ZenMode<CR>') -- Zoom a vim pane
keymap('n', '<Bar>', ':wincmd =<cr>')
-- Jumplist
keymap('n', '<C-i>', '<C-i>')
keymap('n', '<C-j>', '<C-i>')
-- Jump between tabs
keymap({ 'n', 'v' }, 'gl', 'gt')
keymap({ 'n', 'v' }, 'gh', 'gT')
keymap({ 'n', 'v' }, 'gl', '<cmd>!wezterm cli activate-tab --tab-relative 1<CR>')
keymap({ 'n', 'v' }, 'gh', '<cmd>!wezterm cli activate-tab --tab-relative -1<CR>')

keymap('n', 'gL', ':tabmove+<CR>') -- Move tabs
keymap('n', 'gH', ':tabmove-<CR>')

keymap('n', ']a', ':lnext<CR>') -- Quickfix list
keymap('n', '[a', ':lprev<CR>')
keymap('n', ']q', ':cnext<CR>')
keymap('n', '[q', ':cprev<CR>')
keymap('n', ']Q', ':clast<CR>')
keymap('n', '[Q', ':cfirst<CR>')

-- Search ---------------------------------------
-- Pressing * or # searches for the current selection
keymap('v', '*', '<Cmd>call hasan#utils#visualSelection("", "")<CR>/<C-R>=@/<CR><CR>')
keymap('v', '#', '<Cmd>call hasan#utils#visualSelection("", "")<CR>?<C-R>=@/<CR><CR>')

-- Type a replacement term and press . to repeat the replacement again. Useful
-- for replacing a few instances of the term (alternative to multiple cursors).
keymap('n', 'c*', ":let @/='\\<'.expand('<cword>').'\\>'<CR>cgn")
keymap('x', 'C', '"cy:let @/=@c<CR>cgn')

keymap('n', 'cm', ':%s/<c-r>///g<Left><Left>', { desc = 'Change all matches with prompt', silent = false })
keymap('n', 'dm', ':%s/<c-r>///g<CR>', { desc = 'Delete all matches' })
keymap('n', 'dM', ':%g/<c-r>//d<CR>', { desc = 'Delete all lines with matches' })
keymap(
  { 'n', 'v' },
  '<leader>cw',
  '<cmd>lua require("hasan.widgets.inputs").substitute_word()<CR>',
  { desc = 'Substitute word' }
)

keymap({ 'n', 'v' }, 'z/', '<ESC>/\\%V', noSilent) -- search in visual selection
keymap('n', 'Z/', function() -- search in visible viewport
  local scrolloff = vim.wo.scrolloff
  vim.wo.scrolloff = 0
  feedkeys('VHoLo0<Esc>/\\%V')

  vim.defer_fn(function()
    vim.wo.scrolloff = scrolloff
  end, 10)
end, noSilent)
-- keymap({ 'n', 'v' }, 'z/', '/\\%><C-r>=line("w0")-1<CR>l\\%<<C-r>=line("w$")+1<CR>l', { silent = false })

-- Insert mode ----------------------------------
-- keymap({ 'i', 'c' }, 'jk', '<ESC>') -- Use jk to return to normal mode
keymap('t', '<C-o>', '<C-\\><C-n>')

keymap({ 'i', 'c' }, '<A-h>', '<left>', noSilent) -- Move cursor by character
keymap({ 'i', 'c' }, '<A-l>', '<right>', noSilent)
keymap({ 'i', 'c' }, '<A-j>', '<down>', noSilent)
keymap({ 'i', 'c' }, '<A-k>', '<up>', noSilent)

keymap({ 'i', 'c' }, '<A-f>', '<S-right>', noSilent) -- Move cursor by words
keymap({ 'i', 'c' }, '<A-b>', '<S-left>', noSilent)

keymap('i', '<C-a>', '<C-o>^<C-g>u') -- Jump cursor to start & end of a line
keymap('c', '<C-a>', '<Home>', noSilent)
keymap({ 'i', 'c' }, '<C-e>', '<End>')
keymap({ 'i', 'c' }, '<C-d>', '<Delete>', noSilent)

keymap({ 'i', 'c' }, '<A-BS>', '<C-W>', noSilent) -- Delete by characters & words
keymap('i', '<A-d>', '<C-O>dw')
keymap('c', '<A-d>', '<S-Right><C-W><Delete>', noSilent)

keymap('i', '<C-CR>', '<C-o>o') -- Make & move to a new line under the cursor
keymap('i', '<A-CR>', '<C-o>o') -- Make & move to a new line under the cursor
keymap('i', '<A-o>', '<CR><C-o>O') -- Open HTML tags

keymap('i', '<C-u>', '<C-G>u<C-U>') -- CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo, so that you can undo CTRL-U after inserting a line break.

keymap('i', '<C-i>', '<c-g>u<Esc>BgUiwgi', { desc = 'Uppercase current word' })
keymap('i', '<C-g><C-g>', '<c-g>u<Esc>[s1z=`]a<c-g>u', { desc = 'Fix previous misspelled world' })

-- Function keys --------------------------------
keymap('n', '<F3>', ':set paste! paste?<CR>')

keymap('n', '<F7>', ':setlocal spell! spell?<CR>') -- Toggle spelling and show it's status
keymap('i', '<F7>', '<C-o>:setlocal spell! spell?<CR>')
keymap('n', '<F5>', '<Esc>:syntax sync fromstart<CR>')
keymap('i', '<F5>', '<C-o>:syntax sync fromstart<CR>')

-- Leader keys ----------------------------------
keymap({ 'n', 'x' }, '<leader>s', '<cmd>silent w<cr>', { desc = 'Save current file' })

-- Window Management ----------------------------
keymap({ 'n', 'x' }, '<leader>q', '<cmd>Quit<CR>', { desc = 'Close window' })
keymap({ 'n', 'x' }, '<leader>h', '<cmd>lua handle_win_cmd("wincmd h")<CR>', { desc = 'which_key_ignore' })
keymap({ 'n', 'x' }, '<leader>j', '<cmd>lua handle_win_cmd("wincmd j")<CR>', { desc = 'which_key_ignore' })
keymap({ 'n', 'x' }, '<leader>k', '<cmd>lua handle_win_cmd("wincmd k")<CR>', { desc = 'which_key_ignore' })
keymap({ 'n', 'x' }, '<leader>l', '<cmd>lua handle_win_cmd("wincmd l")<CR>', { desc = 'which_key_ignore' })

-- File commands
keymap('n', '<leader>fC', ':w <C-R>=expand("%")<CR>', { silent = false, desc = 'Copy this file' })
keymap('n', '<leader>fe', ":edit <C-R>=expand('%:p:h') . '\\'<CR>", { silent = false, desc = 'Edit in current dir' })
keymap('n', '<leader>fM', ':Move <C-R>=expand("%")<CR>', { silent = false, desc = 'Move/rename file' })
for _, key in pairs({ '<leader>fi', '<c-g>' }) do
  keymap('n', key, '<cmd>lua require("hasan.widgets.file_info").show_file_info()<CR>', { desc = 'Show file info' })
end
