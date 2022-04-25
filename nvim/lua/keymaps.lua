local noSilent = { silent = false }

-- Hide search highlighting
if vim.fn.exists('g:loaded_HLNext') then
  keymap({ 'n', 'v' }, 'q', '<ESC>:<C-u>call HLNextOff()<BAR>:nohlsearch<BAR>echo ""<BAR>ColorizerReloadAllBuffers<CR>')
else
  keymap({ 'n', 'v' }, 'q', '<ESC>:<C-u>nohlsearch<BAR>echo ""<BAR>ColorizerReloadAllBuffers<CR><CR>')
end

keymap('n', 'ZZ', ':Quit!<CR>') -- Prompt before quitting
keymap('n', 'Q', 'q') -- Use Q to record macros
keymap('v', '@', ':norm @', noSilent) -- run macro on selection
keymap({ 'n', 'v' }, '<CR>', ':<up>', noSilent) -- run last : command easily

-- Copy Paste -----------------------------------
keymap('v', 'p', 'pgvy') -- Prevent selecting and pasting from overwriting what you originally copied.
keymap('v', 'y', 'ygv<Esc>') -- Keep cursor at the bottom of the visual selection after you yank it.
keymap('n', 'Y', 'y$') -- Ensure Y works similar to D,C.
keymap('n', 'gV', '`[v`]') -- Select the last yanked text
keymap({ 'n', 'x' }, 'x', '"_x') -- Prevent x from overriding the clipboard.
keymap({ 'n', 'x' }, 'X', '"_X')
keymap({ 'i', 'c' }, '<C-v>', '<C-R>+', noSilent) -- Paste from + register (system clipboard)
keymap({ 'i', 'c' }, '<A-p>', '<C-R>"', noSilent) -- Paste the last item from register

-- Modify & rearange texts ----------------------
-- maps.vnoremap('ao', '<ESC>va{%V%') -- Select a block {} of code
-- maps.nnoremap('yao', 'va{%V%y')
-- maps.nnoremap('dao', 'va{%V%d')

keymap('x', '$', 'g_') -- A fix to select end of line
keymap('v', '.', ':norm.<cr>') -- map . in visual mode
keymap('v', '>', '>gv') -- Keep selection when indenting/outdenting.
keymap('v', '<', '<gv')
vim.api.nvim_set_keymap('v', '<C-g>', '*<C-O>:%s///gn<CR>', noSilent) -- Print the number of occurrences of the current word under the cursor

vim.api.nvim_set_keymap('n', '<C-_>', 'mz_gcc`z', {}) -- Comment or uncomment lines
vim.api.nvim_set_keymap('i', '<C-_>', '<ESC>_gccgi', {})
vim.api.nvim_set_keymap('v', '<C-_>', 'mz_gcgv`z', {})

keymap('n', '<A-j>', ':move +1<CR>==') -- Move lines up and down in normal & visual mode
keymap('n', '<A-k>', ':move -2<CR>==')
keymap('x', '<A-k>', ':call hasan#utils#visual_move_up()<CR>')
keymap('x', '<A-j>', ':call hasan#utils#visual_move_down()<CR>')
-- vnoremap <silent> <A-k> :move '<-2<CR>gv=gv
-- vnoremap <silent> <A-j> :move '>+1<CR>gv=gv

keymap('n', 'gx', '<Plug>(exchange-operator)') -- Exchange_operator.vim
keymap('v', 'gx', '<Plug>(exchange-operator)')
keymap('n', '<P', '<Plug>(swap-parameter-prev):call repeat#set("\\<Plug>(swap-parameter-prev)")<CR>')
keymap('n', '>P', '<Plug>(swap-parameter-next):call repeat#set("\\<Plug>(swap-parameter-next)")<CR>')

keymap('n', 'z.', ':%foldclose<CR>') -- Fold
keymap('n', '<tab>', 'za')
keymap('n', '<s-tab>', 'zA')

-- Navigation -----------------------------------
keymap('n', 'H', 'H:exec "norm! ". &scrolloff . "k"<cr>') -- jump in file
keymap('n', 'L', 'L:exec "norm! ". &scrolloff . "j"<cr>')

keymap('n', "'", '`') -- Character wise jumps always
keymap('v', "'", '`')
keymap('n', "''", "`'")
keymap('v', "''", "`'")

keymap({ 'n', 'v' }, '<A-d>', '<C-d>') -- Vertical scrolling
keymap({ 'n', 'v' }, '<A-o>', '<C-d>')
keymap({ 'n', 'v' }, '<A-u>', '<C-u>')
keymap({ 'n', 'v' }, '<A-f>', '<C-f>')
keymap({ 'n', 'v' }, '<A-b>', '<C-b>')
keymap({ 'n', 'v' }, '<A-y>', '<C-y>')
keymap({ 'n', 'v' }, '<A-e>', '<C-e>')

keymap({ 'n', 'v' }, '<A-l>', '20zl') -- Horizontal scroll ---- <ScrollWheelRight> <ScrollWheelLeft>
keymap({ 'n', 'v' }, '<A-h>', '20zh')

keymap('n', '<A-=>', ':resize +3<CR>') -- Resize splits
keymap('n', '<A-->', ':resize -3<CR>')
keymap('n', '<A-.>', ':vertical resize +5<CR>')
keymap('n', '<A-,>', ':vertical resize -5<CR>')

keymap('n', '\\', ':ZoomToggle<CR>') -- Zoom a vim pane
keymap('n', '<Bar>', ':wincmd =<cr>')

keymap('n', '<C-j>', '<C-i>') -- Jump between tabs
keymap({ 'n', 'v' }, 'gl', 'gt')
keymap({ 'n', 'v' }, 'gh', 'gT')

keymap('n', 'gL', ':tabmove+<CR>') -- Move tabs
keymap('n', 'gH', ':tabmove-<CR>')

keymap('n', ']a', ':lnext<CR>') -- Quickfix list
keymap('n', '[a', ':lprev<CR>')
keymap('n', ']q', ':cnext<CR>')
keymap('n', '[q', ':cprev<CR>')
keymap('n', ']Q', ':clast<CR>')
keymap('n', '[Q', ':cfirst<CR>')

keymap('n', ']e', ':lua require("harpoon.ui").nav_next()<CR>') -- harpoon
keymap('n', '[e', ':lua require("harpoon.ui").nav_prev()<CR>')

-- Search ---------------------------------------
-- Pressing * or # searches for the current selection
keymap('v', '*', ':<C-u>call hasan#utils#visualSelection("", "")<CR>/<C-R>=@/<CR><CR>')
keymap('v', '#', ':<C-u>call hasan#utils#visualSelection("", "")<CR>?<C-R>=@/<CR><CR>')
-- vnoremap * "xy/<C-R>x<CR>

-- Type a replacement term and press . to repeat the replacement again. Useful
-- for replacing a few instances of the term (alternative to multiple cursors).
keymap('n', 'c*', ":let @/='\\<'.expand('<cword>').'\\>'<CR>cgn")
keymap('x', 'C', '"cy:let @/=@c<CR>cgn')

keymap('n', 'dm', ':%s/<c-r>///g<CR>', noSilent) -- Delete & change all matches
keymap('n', 'cm', ':%s/<c-r>///g<Left><Left>', noSilent)

-- Insert mode ----------------------------------
keymap({ 'i', 'c' }, 'jk', '<ESC>') -- Use jk to return to normal mode
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

keymap('i', '<A-CR>', '<C-o>o') -- Make & move to a new line under the cursor
keymap('i', '<A-o>', '<CR><C-o>O') -- Open HTML tags

keymap('i', '<C-u>', '<C-G>u<C-U>') -- CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo, so that you can undo CTRL-U after inserting a line break.

keymap('i', '<C-k><C-p>', '<c-g>u<Esc>[s1z=`]a<c-g>u') -- Fix previous misspelled world
keymap('i', '<C-k><C-u>', '<c-g>u<Esc>BgUiwgi') -- Uppercase current word

-- Function keys --------------------------------
keymap('n', '<F3>', ':set paste! paste?<CR>')

keymap('n', '<F7>', ':setlocal spell! spell?<CR>') -- Toggle spelling and show it's status
keymap('i', '<F7>', '<C-o>:setlocal spell! spell?<CR>')
keymap('n', '<F5>', '<Esc>:syntax sync fromstart<CR>')
keymap('i', '<F5>', '<C-o>:syntax sync fromstart<CR>')

-- Leader keys ----------------------------------
-- Easier system clipboard usage
keymap({ 'n', 'v' }, '<leader>ip', '"+p')
keymap('n', '<leader>y', '"+y')
keymap('v', '<leader>y', '"+ygv<Esc>')
-- maps.nnoremap('<leader>d', '"+d')
-- maps.vnoremap('<leader>d', '"+d')
-- File commands
keymap('n', '<leader>fC', ':w <C-R>=expand("%")<CR>', noSilent)
keymap('n', '<leader>fM', ':Move <C-R>=expand("%")<CR>', noSilent)
keymap('n', '<leader>fe', ":edit <C-R>=expand('%:p:h') . '\\'<CR>", noSilent)
-- packer commands
keymap('n', '<leader>vpc', ':PackerCompile<CR>', noSilent)

-- maps.nnoremap('<leader>p:', ':silent ! tmux-windowizer $(pwd) ', {silent = false}) -- run project cmd
-- maps.nnoremap('<leader>p;', ':silent ! tmux-send-keys $(pwd) ', {silent = false})

-- Floaterm
vim.g.floaterm_keymap_new = '<C-\\>c'
vim.g.floaterm_keymap_prev = '<C-\\>p'
vim.g.floaterm_keymap_next = '<C-\\>n'
vim.g.floaterm_keymap_kill = '<A-q>'
vim.g.floaterm_keymap_toggle = '<A-m>'
keymap('n', '<A-m>', '<cmd>FloatermToggle<CR>')
keymap('n', ']t', '<cmd>FloatermToggle<CR><C-\\><C-n>')
keymap('n', '[t', '<cmd>FloatermToggle<CR><C-\\><C-n>')

keymap('n', '//', '<cmd>lua require("hasan.telescope.custom").curbuf(false)<cr>')
keymap('v', '/', '<cmd>lua require("hasan.telescope.custom").curbuf(true)<cr>')
keymap('n', '<C-p>', require('telescope.builtin').oldfiles) -- Telescope
keymap('n', '<A-x>', require('hasan.telescope.custom').commands)
keymap({ 'n', 'x' }, '<A-/>', require('hasan.telescope.custom').grep_string)
