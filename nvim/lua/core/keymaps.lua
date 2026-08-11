vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

if not vim.g.vscode then
  require('hasan.pseudo-text-objects')
end

local M = {}

function M.disable_keys()
  if vim.fn.has('nvim-0.11') == 1 then
    local keys_to_del = {
      -- { 'gra', mode = { 'n', 'x' } },
      -- 'grn',
      -- 'grr',
      -- 'gri',
      -- 'grt',
    }
    for _, key in ipairs(keys_to_del) do
      if type(key) == 'string' then
        pcall(vim.keymap.del, 'n', key)
      else
        pcall(vim.keymap.del, key.mode or 'n', key[1])
      end
    end
  end
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

maps({
  -----------------------------------------------------------------------------
  -- Basic Editing
  -----------------------------------------------------------------------------
  { 'q', '<esc><cmd>noh<CR>', mode = { 'n', 'x' } },
  { '<CR>', ':<up>', mode = { 'n', 'x' }, desc = 'Run last command easily', silent = false },
  { 'n', 'nzz', mode = { 'n', 'x' }, remap = true, desc = 'Repeat search forward' },
  { 'N', 'Nzz', mode = { 'n', 'x' }, remap = true, desc = 'Repeat search backward' },
  { "'", '`', mode = { 'n', 'x' }, remap = true, desc = 'Jump to mark' },
  { 'p', 'pgvy', mode = 'v' },
  { 'y', 'ygv<Esc>', mode = 'v', desc = 'Keep cursor position' },
  { 'gV', '`[v`]', desc = 'Select last yanked text' },
  { 'x', '"_x', mode = { 'n', 'x' }, desc = 'Delete without yanking' },
  { 'X', '"_X', mode = { 'n', 'x' }, desc = 'Delete without yanking' },
  { '$', 'g_', mode = 'x', desc = 'Select to end of line' },
  { '>', '>gv', mode = 'v', desc = 'Keep selection after indent' },
  { '<', '<gv', mode = 'v', desc = 'Keep selection after outdent' },

  -----------------------------------------------------------------------------
  -- Clipboard & Registers
  -----------------------------------------------------------------------------
  { '<leader>y', '"+y', mode = 'n', desc = 'Yank to system clipboard' },
  { '<leader>y', '"+ygv<Esc>', mode = 'v', desc = 'Yank to system clipboard' },
  { '<leader>ip', '"+p', mode = { 'n', 'x' }, desc = 'Paste from system clipboard' },
  { '<leader>iP', '"+P', mode = { 'n', 'x' }, desc = 'Paste from system clipboard' },

  { '<C-v>', '<C-R>+', mode = { 'i', 'c' }, desc = 'Paste from system clipboard', silent = false },
  { '<C-g><C-v>', '<C-v>', mode = { 'i', 'c' }, desc = 'Literal paste', silent = false },
  { '<A-p>', '<C-R>"', mode = { 'i', 'c' }, desc = 'Paste from register' },

  -----------------------------------------------------------------------------
  -- Comments
  -----------------------------------------------------------------------------
  { 'gcu', M.uncomment_block, desc = 'Uncomment block' },
  { 'gc/', M.uncomment_block, desc = 'Uncomment block' },
  { 'gcO', M.comment_at('O'), desc = 'Comment above' },
  { 'gco', M.comment_at('o'), desc = 'Comment below' },
  { 'gcI', M.comment_at('I'), desc = 'Comment at line start' },
  { 'gcA', M.comment_at('A '), desc = 'Comment at line end' },

  { 'a/', '<cmd>lua require("vim._comment").textobject()<CR>', mode = 'o', desc = 'Comment textobject' },
  { 'a/', '<Esc><cmd>lua require("vim._comment").textobject()<CR>', mode = 'x', desc = 'Comment textobject' },

  -- TODO: not working
  { '<C-_>', 'mz_gcc`z', mode = 'n', remap = true, desc = 'Toggle comment' },
  { '<C-_>', '<Esc>_gccgi', mode = 'i', remap = true, desc = 'Toggle comment' },
  { '<C-_>', 'mz_gcgv`z', mode = 'v', remap = true, desc = 'Toggle comment' },

  -----------------------------------------------------------------------------
  -- Search & Replace
  -----------------------------------------------------------------------------
  { 'cm', ':%s/<C-r>///g<Left><Left>', desc = 'Substitute with prompt', silent = false },
  { 'dm', ':%s/<C-r>///g<CR>', desc = 'Delete matches' },
  { 'dM', ':%g/<C-r>//d<CR>', desc = 'Delete matching lines' },
  {
    '<leader>cw',
    '<cmd>lua require("hasan.widgets.inputs").substitute_word()<CR>',
    mode = { 'n', 'x' },
    desc = 'Substitute word',
  },

  { 'z/', '/\\%><C-r>=line("w0")-1<CR>l\\%<<C-r>=line("w$")+1<CR>l', desc = 'Search in viewport', silent = false },
  { 'z/', '<Esc>/\\%V', mode = 'x', desc = 'Search in selection', silent = false },

  { 'gB', M._open, desc = 'Open URI under cursor' },
  { 'gB', M._open_v, mode = 'x', desc = 'Open URI under selection' },
  { 'gG', '<cmd>Google<CR>', mode = { 'n', 'x' }, desc = 'Search Google' },
  { 'gW', '<cmd>Translate<CR>', mode = { 'n', 'x' }, desc = 'Translate' },

  -----------------------------------------------------------------------------
  -- Folding
  -----------------------------------------------------------------------------
  { 'zuu', '0vai:foldclose!<CR>zazt', mode = { 'n', 'x' }, remap = true, desc = 'Fold context' },
  { 'zu', ':foldclose!<CR>zazt', mode = { 'n', 'x' }, remap = true, desc = 'Fold context' },
  { '<Tab>', 'za', mode = { 'n', 'x' }, desc = 'Toggle fold' },
  { '<S-Tab>', 'zA', mode = { 'n', 'x' }, desc = 'Toggle recursive fold' },
  { 'z.', '<cmd>%foldclose<CR>zb', mode = { 'n', 'x' }, desc = 'Fold all' },
  { 'z;', '<cmd>lua require("hasan.utils.fold").close_level(2)<CR>zb', mode = { 'n', 'x' }, desc = 'Fold level 1' },

  -----------------------------------------------------------------------------
  -- Navigation & Scrolling
  -----------------------------------------------------------------------------
  { 'j', 'v:count == 0 ? "gj" : "j"', expr = true, remap = false, desc = 'Move down' },
  { 'k', 'v:count == 0 ? "gk" : "k"', expr = true, remap = false, desc = 'Move up' },
  { '<BS>', '<C-^>', mode = { 'n', 'x' }, desc = 'Alternate file' },
  { '<C-j>', '<C-i>', mode = { 'n', 'x' }, remap = false },
  { 'g<BS>', '<C-w><C-p>', mode = { 'n', 'x' } },

  { '<A-u>', '<C-u>', mode = { 'n', 'x' }, remap = true, desc = 'Scroll up' },
  { '<A-d>', '<C-d>', mode = { 'n', 'x' }, remap = true, desc = 'Scroll down' },
  { '<A-o>', '<C-d>', remap = true, desc = 'Scroll window', mode = { 'n', 'x' } },
  { '<PageUp>', '<C-u>', mode = { 'n', 'x' }, remap = true },
  { '<PageDown>', '<C-d>', mode = { 'n', 'x' }, remap = true },
  { '<A-f>', '<C-f>', mode = { 'n', 'x' }, remap = true },
  { '<A-b>', '<C-b>', mode = { 'n', 'x' }, remap = true },
  { '<A-y>', '<C-y>', mode = { 'n', 'x' }, remap = true },
  { '<A-e>', '<C-e>', mode = { 'n', 'x' }, remap = true },
  { '<A-h>', '20zh', mode = { 'n', 'x' } },
  { '<A-l>', '20zl', mode = { 'n', 'x' } },

  -----------------------------------------------------------------------------
  -- Windows
  -----------------------------------------------------------------------------
  { '<leader>q', '<Cmd>Quit<CR>', mode = { 'n', 'x' }, desc = 'Close window' },
  { '<leader>wc', '<Cmd>Quit<CR>', mode = { 'n', 'x' }, desc = 'Close window' },

  { '<leader>h', '<Cmd>wincmd h<CR>', mode = { 'n', 'x' }, desc = 'which_key_ignore' },
  { '<leader>j', '<Cmd>wincmd j<CR>', mode = { 'n', 'x' }, desc = 'which_key_ignore' },
  { '<leader>k', '<Cmd>wincmd k<CR>', mode = { 'n', 'x' }, desc = 'which_key_ignore' },
  { '<leader>l', '<Cmd>wincmd l<CR>', mode = { 'n', 'x' }, desc = 'which_key_ignore' },

  { '<Bar>', '<Cmd>wincmd =<CR>', mode = { 'n', 'x' }, desc = 'Equalize windows' },
  { '<leader>wh', '<Cmd>wincmd h<CR>', mode = { 'n', 'x' }, desc = 'Window left' },
  { '<leader>wj', '<Cmd>wincmd j<CR>', mode = { 'n', 'x' }, desc = 'Window down' },
  { '<leader>wk', '<Cmd>wincmd k<CR>', mode = { 'n', 'x' }, desc = 'Window up' },
  { '<leader>wl', '<Cmd>wincmd l<CR>', mode = { 'n', 'x' }, desc = 'Window right' },
  { '<leader>ws', '<Cmd>wincmd s<CR>', mode = { 'n', 'x' }, desc = 'Horizontal split' },
  { '<leader>wv', '<Cmd>wincmd v<CR>', mode = { 'n', 'x' }, desc = 'Vertical split' },
  { '<leader>wo', '<Cmd>only<CR>', mode = { 'n', 'x' }, desc = 'Only window' },
  { '<leader>wO', '<Cmd>tabonly<CR>', mode = { 'n', 'x' }, desc = 'Only tab' },
  { '<leader>wt', '<cmd>-tab split<CR>', mode = { 'n', 'x' }, desc = 'Edit to new tab' },
  { '<leader>wH', '<cmd>wincmd H<CR>', mode = { 'n', 'x' }, desc = 'Move window far left' },
  { '<leader>wJ', '<cmd>wincmd J<CR>', mode = { 'n', 'x' }, desc = 'Move window far bottom' },
  { '<leader>wK', '<cmd>wincmd K<CR>', mode = { 'n', 'x' }, desc = 'Move window far top' },
  { '<leader>wL', '<cmd>wincmd L<CR>', mode = { 'n', 'x' }, desc = 'Move window far right' },
  { '<leader>wr', '<cmd>wincmd r<CR>', mode = { 'n', 'x' }, desc = 'Rotate window cw' },
  { '<leader>wR', '<cmd>wincmd R<CR>', mode = { 'n', 'x' }, desc = 'Rotate window ccw' },
  { '<leader>wp', '<cmd>lua run_cmd("wincmd p")<CR>', mode = { 'n', 'x' }, desc = 'Previous window' },
  { '<leader>ww', '<cmd>lua run_cmd("wincmd w")<CR>', mode = { 'n', 'x' }, desc = 'Next window' },
  { '<leader>wW', '<cmd>lua run_cmd("wincmd W")<CR>', mode = { 'n', 'x' }, desc = 'Previous window' },

  -----------------------------------------------------------------------------
  -- Buffers & Tabs
  -----------------------------------------------------------------------------
  { '<leader>bK', '<cmd>call hasan#utils#buffer#_clear_all()<CR>', desc = 'Kill all buffers' },

  { 'gh', 'gT', mode = { 'n', 'x' }, desc = 'Previous tab' },
  { 'gl', 'gt', mode = { 'n', 'x' }, desc = 'Next tab' },
  { 'gH', '<Cmd>tabmove -1<CR>', desc = 'Move tab left' },
  { 'gL', '<Cmd>tabmove +1<CR>', desc = 'Move tab right' },

  -----------------------------------------------------------------------------
  -- File Management
  -----------------------------------------------------------------------------
  { '<leader>fC', ':w <C-R>=expand("%")<CR>', desc = 'Copy file', silent = false },
  { '<leader>fe', ":edit <C-R>=expand('%:p:h') . '\\'<CR>", desc = 'Edit current directory', silent = false },
  { '<leader>fM', ':Move <C-R>=expand("%")<CR>', desc = 'Move file', silent = false },
  {
    '<leader>fi',
    function()
      require('hasan.widgets.file_info').show_file_info()
    end,
    desc = 'File info',
  },
  {
    '<C-g>',
    function()
      require('hasan.widgets.file_info').show_file_info()
    end,
    desc = 'File info',
  },

  -----------------------------------------------------------------------------
  -- Macros
  -----------------------------------------------------------------------------
  {
    'Q',
    function()
      return require('hasan.widgets.register_editor').start_recording()
    end,
    mode = { 'n', 'x' },
    expr = true,
    desc = 'Record macro',
  },
  { '@', ':norm @', mode = 'v', desc = 'Run macro', silent = false },

  -----------------------------------------------------------------------------
  -- Terminal
  -----------------------------------------------------------------------------
  { '<C-o>', '<C-\\><C-n>', mode = 't', desc = 'Exit terminal mode' },
  { '<M-m>', '<Cmd>close<CR>', mode = 't', desc = 'Hide terminal' },

  -----------------------------------------------------------------------------
  -- Insert & Command-line
  -----------------------------------------------------------------------------
  -- Movement
  { '<A-k>', '<Esc><Cmd>m .-2<CR>==gi', mode = 'i', desc = 'Move line up' },
  { '<A-j>', '<Esc><Cmd>m .+1<CR>==gi', mode = 'i', desc = 'Move line down' },

  { ',', ',<C-g>u', mode = 'i' },
  { '.', '.<C-g>u', mode = 'i' },
  { ';', ';<C-g>u', mode = 'i' },

  { '<C-n>', '<Down>', mode = { 'i', 'c' } },
  { '<C-p>', '<Up>', mode = { 'i', 'c' } },
  { '<A-h>', '<Left>', mode = { 'i', 'c' } },
  { '<A-l>', '<Right>', mode = { 'i', 'c' } },
  { '<A-f>', '<S-Right>', mode = { 'i', 'c' } },
  { '<A-b>', '<S-Left>', mode = { 'i', 'c' } },

  { '<C-a>', '<C-o>^<C-g>u', mode = 'i' },
  { '<C-a>', '<Home>', mode = 'c' },
  { '<C-e>', '<End>', mode = { 'i', 'c' } },
  { '<C-d>', '<Delete>', mode = { 'i', 'c' } },
  { '<A-d>', '<C-o>dw', mode = 'i' },
  { '<A-d>', '<S-Right><C-W><Delete>', mode = 'c' },
  { '<C-u>', '<C-g>u<C-u>', mode = 'i' },

  { '<C-CR>', '<C-o>o', mode = 'i', desc = 'New line below' },
  { '<A-CR>', '<C-o>o', mode = 'i', desc = 'New line below' },
  { '<A-o>', '<CR><C-o>O', mode = 'i', desc = 'Open HTML tag' },

  { '<C-g><C-e>', '<C-g>u<Esc>bgUiwgi', mode = 'i', desc = 'Uppercase word' },
  { '<C-g><C-g>', '<C-g>u<Esc>[s1z=`]a<C-g>u', mode = 'i', desc = 'Fix spelling' },

  -----------------------------------------------------------------------------
  -- Saving
  -----------------------------------------------------------------------------
  { '<C-s>', '<Cmd>w<CR>', mode = { 'n', 'i', 'x' }, desc = 'Save file' },
  { '<leader>s', '<Cmd>w<CR>', mode = { 'n', 'x' }, desc = 'Save file' },
  { 'ZZ', '<Cmd>Quit!<CR>', mode = { 'n', 'x' }, desc = 'Quit window' },

  -----------------------------------------------------------------------------
  -- Window Resizing
  -----------------------------------------------------------------------------
  { '<A-=>', '<Cmd>resize +3<CR>', mode = { 'n', 'x' } },
  { '<A-->', '<Cmd>resize -3<CR>', mode = { 'n', 'x' } },
  { '<A-.>', '<Cmd>vertical resize +5<CR>', mode = { 'n', 'x' } },
  { '<A-,>', '<Cmd>vertical resize -5<CR>', mode = { 'n', 'x' } },

  -----------------------------------------------------------------------------
  -- Utilities
  -----------------------------------------------------------------------------
  { '<leader>r', '<cmd>lua require("hasan.utils.win").cycle_numbering()<CR>', desc = 'Cycle numbers' },
  { '<leader>m', '<cmd>lua require("music.actions").ytm_toggle()<CR>', desc = 'Toggle YouTube Music' },
})

M.disable_keys()
