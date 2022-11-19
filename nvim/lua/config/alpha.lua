local ok, alpha = pcall(require, 'alpha')
if not ok then
  return
end

local function button(sc, txt, keybind)
  local sc_ = sc:gsub('%s', ''):gsub('SPC', '<leader>')

  local opts = {
    position = 'center',
    text = txt,
    shortcut = sc,
    cursor = 5,
    width = 38,
    align_shortcut = 'right',
    hl = 'AlphaButtons',
  }

  if keybind then
    opts.keymap = { 'n', sc_, keybind, { noremap = true, silent = true } }
  end

  return {
    type = 'button',
    val = txt,
    on_press = function()
      local key = vim.api.nvim_replace_termcodes(sc_, true, false, true) or ''
      vim.api.nvim_feedkeys(key, 'normal', false)
    end,
    opts = opts,
  }
end

-- dynamic header padding
local marginTopPercent = 0.1
local headerPadding = vim.fn.max({ 2, vim.fn.floor(vim.fn.winheight(0) * marginTopPercent) }) - 1

local options = {
  header = {
    type = 'text',
    val = {
      [[       ,               ,         ]],
      [[     ,//,              %#*,      ]],
      [[   ,((((//,            /###%*,   ]],
      [[ ,((((((////,          /######%. ]],
      [[ ///((((((((((,        *#######. ]],
      [[ //////(((((((((,      *#######. ]],
      [[ //////(/(((((((((,    *#######. ]],
      [[ //////(. /(((((((((,  *#######. ]],
      [[ //////(.   (((((((((*,*#######. ]],
      [[ //////(.    ,#((((((((########. ]],
      [[ /////((.      /#((((((##%%####. ]],
      [[ (((((((.        .(((((#####%%#. ]],
      [[  /(((((.          ((((#%#%%/*   ]],
      [[    ,(((.            /(%%#*      ]],
      [[       *               *         ]],
      [[                                 ]],
      [[         -- aim lower --         ]],
    },
    opts = {
      position = 'center',
      hl = 'AlphaHeader',
    },
  },

  buttons = {
    type = 'group',
    val = {
      button('SPC p r', '  Recent File', ':lua require("telescope.builtin").oldfiles({cwd_only = true})<CR>'),
      button('SPC p l', '  Load session', ':SessionLoad<CR>'),
      button('SPC f f', '  Find Files', ':Telescope find_files<CR>'),
      button('SPC o t', '  Open terminal', ':FloatermNew --wintype=normal --height=10 bash<CR>'),
      button('SPC v s', '  Settings', ':e $MYVIMRC | :cd ~/dotfiles/ <CR>'),
    },
    opts = { spacing = 1 },
  },
  headerPaddingTop = { type = 'padding', val = headerPadding },
  headerPaddingBottom = { type = 'padding', val = 2 },
}

alpha.setup({
  layout = {
    options.headerPaddingTop,
    options.header,
    options.headerPaddingBottom,
    options.buttons,
  },
  opts = {},
})

-- Disable statusline in dashboard
vim.api.nvim_create_augroup('alpha_tabline', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = 'alpha_tabline',
  pattern = 'alpha',
  callback = function()
    -- store current statusline value and use that
    local old_winbar = vim.opt.winbar
    local old_laststatus = vim.opt.laststatus
    local old_showtabline = vim.opt.showtabline
    vim.api.nvim_create_autocmd('BufUnload', {
      buffer = 0,
      callback = function()
        vim.opt.laststatus = old_laststatus
        vim.opt.showtabline = old_showtabline
        vim.opt.winbar = old_winbar
      end,
    })
    vim.opt.laststatus = 0
    vim.opt.showtabline = 0
    vim.opt.winbar = ''
  end,
})
