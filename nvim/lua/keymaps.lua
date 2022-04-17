local maps = require('hasan.utils.maps')

-- Use jk to return to normal mode
maps.inoremap('jk', '<ESC>')
maps.cnoremap('jk', '<ESC>')
-- Hide search highlighting
if vim.fn.exists('g:loaded_HLNext') then
  maps.nnoremap('q', '<ESC>:call HLNextOff()<BAR>:nohlsearch<BAR>echo ""<BAR>ColorizerReloadAllBuffers<CR>')
  maps.vnoremap('q', '<ESC>:call HLNextOff()<BAR>:nohlsearch<CR>')
else
  maps.nnoremap('q', '<ESC>:nohlsearch<BAR>echo ""<BAR>ColorizerReloadAllBuffers<CR><CR>')
  maps.vnoremap('q', '<ESC>:nohlsearch<CR>')
end
-- run last : command easily
maps.nnoremap('<CR>', ':<up>', { silent = false })
vim.cmd([[autocmd CmdwinEnter * nnoremap <buffer><CR> <CR>]])
-- Prompt before quitting
maps.nnoremap('ZZ', ':Quit!<CR>')
-- Use Q to record macros
maps.nnoremap('Q', 'q')
maps.vnoremap('@', ':norm @', { silent = false })

-- Copy Paste -----------------------------------
-- Prevent selecting and pasting from overwriting what you originally copied.
maps.vnoremap('p', 'pgvy')
-- Keep cursor at the bottom of the visual selection after you yank it.
maps.vnoremap('y', 'ygv<Esc>')
--- Ensure Y works similar to D,C.
maps.nnoremap('Y', 'y$')
-- Select the last yanked text
maps.nnoremap('gV', '`[v`]')
-- Prevent x from overriding the clipboard.
maps.nnoremap('x', '"_x')
maps.nnoremap('X', '"_X')
maps.xnoremap('x', '"_x')
maps.xnoremap('X', '"_X')
-- Paste from + register (system clipboard)
maps.inoremap('<C-v>', '<C-R>+')
maps.cnoremap('<C-v>', '<C-R>+')
-- Paste the last item from register
maps.cnoremap('<A-p>', '<C-R>"')

-- Modify & rearange texts ----------------------
-- increase selected numbers
maps.xnoremap('+', ' g<C-a>')
maps.xnoremap('-', 'g<C-x>')
-- Print the number of occurrences of the current word under the cursor
maps.vmap('<C-g>', '*<C-O>:%s///gn<CR>', { silent = false })
-- A fix to select end of line
maps.xnoremap('$', 'g_')
-- Select a block {} of code
-- maps.vnoremap('ao', '<ESC>va{%V%')
-- maps.nnoremap('yao', 'va{%V%y')
-- maps.nnoremap('dao', 'va{%V%d')
-- map . in visual mode
maps.vnoremap('.', ':norm.<cr>')
-- Keep selection when indenting/outdenting.
maps.vnoremap('>', '>gv')
maps.vnoremap('<', '<gv')
-- Comment or uncomment lines
maps.nmap('<C-_>', 'mz_gcc`z')
maps.imap('<C-_>', '<ESC>_gccgi')
maps.vmap('<C-_>', '_gcgv')
-- Move lines up and down in normal & visual mode
maps.nnoremap('<A-j>', ':move +1<CR>==')
maps.nnoremap('<A-k>', ':move -2<CR>==')
maps.xnoremap('<A-k>', ':call hasan#utils#visual_move_up()<CR>')
maps.xnoremap('<A-j>', ':call hasan#utils#visual_move_down()<CR>')
-- vnoremap <silent> <A-k> :move '<-2<CR>gv=gv
-- vnoremap <silent> <A-j> :move '>+1<CR>gv=gv
-- Exchange_operator.vim
maps.nmap('gx', '<Plug>(exchange-operator)')
maps.vmap('gx', '<Plug>(exchange-operator)')
maps.nmap('<P', '<Plug>(swap-parameter-prev):call repeat#set("\\<Plug>(swap-parameter-prev)")<CR>')
maps.nmap('>P', '<Plug>(swap-parameter-next):call repeat#set("\\<Plug>(swap-parameter-next)")<CR>')
-- Fold
maps.nnoremap('z.', ':%foldclose<CR>')
maps.nnoremap('<tab>', 'za')
maps.nnoremap('<s-tab>', 'zA')

-- Navigation -----------------------------------
-- jump in file
maps.nnoremap('H', 'H:exec "norm! ". &scrolloff . "k"<cr>')
maps.nnoremap('L', 'L:exec "norm! ". &scrolloff . "j"<cr>')
-- Character wise jumps always
maps.nnoremap("'", '`')
maps.vnoremap("'", '`')
maps.nnoremap("''", "`'")
maps.vnoremap("''", "`'")
-- Vertical scrolling
maps.nmap('<A-d>', '<C-d>')
maps.nmap('<A-o>', '<C-d>')
maps.nmap('<A-u>', '<C-u>')
maps.nmap('<A-f>', '<C-f>')
maps.nmap('<A-b>', '<C-b>')
maps.nmap('<A-y>', '<C-y>')
maps.nmap('<A-e>', '<C-e>')
maps.vmap('<A-d>', '<C-d>')
maps.vmap('<A-u>', '<C-u>')
maps.vmap('<A-f>', '<C-f>')
maps.vmap('<A-b>', '<C-b>')
maps.vmap('<A-y>', '<C-y>')
maps.vmap('<A-e>', '<C-e>')
-- Horizontal scroll
-- maps.nmap('<A-l>', '<ScrollWheelRight>')
-- maps.nmap('<A-h>', '<ScrollWheelLeft>')
maps.nmap('<A-l>', '20zl')
maps.nmap('<A-h>', '20zh')

-- Resize splits
maps.nnoremap('<A-=>', ':resize +3<CR>')
maps.nnoremap('<A-->', ':resize -3<CR>')
maps.nnoremap('<A-.>', ':vertical resize +5<CR>')
maps.nnoremap('<A-,>', ':vertical resize -5<CR>')
-- Zoom a vim pane
maps.nnoremap('\\', ':ZoomToggle<CR>')
maps.nnoremap('<Bar>', ':wincmd =<cr>')
-- Jump between tabs
maps.nnoremap('<C-j>', '<C-i>')
maps.nnoremap('gl', 'gt')
maps.nnoremap('gh', 'gT')
maps.vnoremap('gl', 'gt')
maps.vnoremap('gh', 'gT')
-- Move tabs
maps.nnoremap('gL', ':tabmove+<CR>')
maps.nnoremap('gH', ':tabmove-<CR>')
-- Quickfix list
maps.nmap(']a', ':lnext<CR>')
maps.nmap('[a', ':lprev<CR>')
maps.nmap(']q', ':cnext<CR>')
maps.nmap('[q', ':cprev<CR>')
maps.nmap(']Q', ':clast<CR>')
maps.nmap('[Q', ':cfirst<CR>')

-- Search ---------------------------------------
-- Pressing * or # searches for the current selection
maps.vnoremap('*', ':<C-u>call hasan#utils#visualSelection("", "")<CR>/<C-R>=@/<CR><CR>')
maps.vnoremap('#', ':<C-u>call hasan#utils#visualSelection("", "")<CR>?<C-R>=@/<CR><CR>')
-- vnoremap * "xy/<C-R>x<CR>

-- Type a replacement term and press . to repeat the replacement again. Useful
-- for replacing a few instances of the term (alternative to multiple cursors).
maps.nnoremap('c*', ":let @/='\\<'.expand('<cword>').'\\>'<CR>cgn")
maps.xnoremap('C', '"cy:let @/=@c<CR>cgn')
-- Delete & change all matches
maps.nnoremap('dm', ':%s/<c-r>///g<CR>', { silent = false })
maps.nnoremap('cm', ':%s/<c-r>///g<Left><Left>', { silent = false })

-- Insert mode ----------------------------------
maps.inoremap('<A-p>', '<Esc>p')
-- Move cursor by character
maps.inoremap('<A-h>', '<left>')
maps.inoremap('<A-l>', '<right>')
maps.inoremap('<A-j>', '<down>')
maps.inoremap('<A-k>', '<up>')
-- Move cursor by words
maps.inoremap('<A-f>', '<S-right>')
maps.inoremap('<A-b>', '<S-left>')
maps.cnoremap('<A-b>', '<S-Left>')
maps.cnoremap('<A-f>', '<S-Right>')
-- Jump cursor to start & end of a line
maps.inoremap('<C-a>', '<C-o>^<C-g>u')
maps.inoremap('<C-e>', '<End>')
maps.cnoremap('<C-a>', '<Home>')
maps.cnoremap('<C-e>', '<End>')
-- Delete by characters & words
maps.inoremap('<C-d>', '<Delete>')
maps.inoremap('<A-d>', '<C-O>dw')
maps.inoremap('<A-BS>', '<C-W>')
maps.cnoremap('<C-d>', '<Delete>')
maps.cnoremap('<A-d>', '<S-Right><C-W><Delete>')
maps.cnoremap('<A-BS>', '<C-W>')
-- Make & move to a new line under the cursor
maps.inoremap('<A-CR>', '<C-o>o')
-- Open HTML tags
maps.inoremap('<A-o>', '<CR><C-o>O')
-- CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
-- so that you can undo CTRL-U after inserting a line break.
maps.inoremap('<C-u>', '<C-G>u<C-U>')
-- Fix previous misspelled world
maps.inoremap('<C-k><C-p>', '<c-g>u<Esc>[s1z=`]a<c-g>u')
-- Uppercase current word
maps.inoremap('<C-k><C-u>', '<c-g>u<Esc>BgUiwgi')

-- Terminal -------------------------------------
maps.map('t', '<C-o>', '<C-\\><C-n>')

-- Function keys --------------------------------
maps.nnoremap('<F3>', ':set paste! paste?<CR>')
-- Toggle spelling and show it's status
maps.nnoremap('<F7>', ':setlocal spell! spell?<CR>')
maps.inoremap('<F7>', '<C-o>:setlocal spell! spell?<CR>')
maps.nnoremap('<F5>', '<Esc>:syntax sync fromstart<CR>')
maps.inoremap('<F5>', '<C-o>:syntax sync fromstart<CR>')

-- Leader keys ----------------------------------
-- Easier system clipboard usage
maps.nnoremap('<leader>ip', '"+p')
maps.vnoremap('<leader>ip', '"+p')
maps.nnoremap('<leader>y', '"+y')
maps.vnoremap('<leader>y', '"+ygv<Esc>')
-- maps.nnoremap('<leader>d', '"+d')
-- maps.vnoremap('<leader>d', '"+d')
-- File commands
maps.nnoremap('<leader>fC', ':w <C-R>=expand("%")<CR>', { silent = false })
maps.nnoremap('<leader>fM', ':Move <C-R>=expand("%")<CR>', { silent = false })
maps.nnoremap('<leader>fe', ":edit <C-R>=expand('%:p:h') . '\\'<CR>", { silent = false })
-- packer commands
maps.nnoremap('<leader>vpc', ':PackerCompile<CR>', { silent = false })
-- run project cmd
-- maps.nnoremap('<leader>p:', ':silent ! tmux-windowizer $(pwd) ', {silent = false})
-- maps.nnoremap('<leader>p;', ':silent ! tmux-send-keys $(pwd) ', {silent = false})

-- Floaterm
vim.g.floaterm_keymap_new = '<C-\\>c'
vim.g.floaterm_keymap_prev = '<C-\\>p'
vim.g.floaterm_keymap_next = '<C-\\>n'
vim.g.floaterm_keymap_kill = '<A-q>'
vim.g.floaterm_keymap_toggle = '<A-m>'
maps.nnoremap('<A-m>', ':FloatermToggle<CR>')
maps.nnoremap(']t', ':FloatermToggle<CR><C-\\><C-n>')
maps.nnoremap('[t', ':FloatermToggle<CR><C-\\><C-n>')
-- Telescope
maps.nnoremap('<C-p>', ':lua require("telescope.builtin").oldfiles()<CR>')
maps.nnoremap('<A-x>', '<cmd>lua require("hasan.telescope.custom").commands()<cr>')
maps.nnoremap('<A-/>', '<cmd>lua require("hasan.telescope.custom").grep_string()<CR>')
maps.xnoremap('<A-/>', '<cmd>lua require("hasan.telescope.custom").grep_string()<CR>')
maps.nnoremap('//', ':lua require("hasan.telescope.custom").curbuf(false)<cr>')
maps.vnoremap('/', ':lua require("hasan.telescope.custom").curbuf(true)<cr>')
