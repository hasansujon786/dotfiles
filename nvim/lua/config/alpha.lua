local present, alpha = pcall(require, 'alpha')

if not present then
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

-- -- dynamic header padding
-- local fn = vim.fn
-- local marginTopPercent = 0.1
-- local headerPadding = fn.max({ 2, fn.floor(fn.winheight(0) * marginTopPercent) })

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
      button('SPC e s', '  Settings', ':e $MYVIMRC | :cd ~/dotfiles/ <CR>'),
    },
    opts = { spacing = 1 },
  },
  headerPaddingTop = { type = 'padding', val = 1 },
  headerPaddingBottom = { type = 'padding', val = 2 },
}

alpha.setup({
  layout = {
    -- options.headerPaddingTop,
    options.header,
    options.headerPaddingBottom,
    options.buttons,
  },
  opts = {},
})

-- Disable statusline in dashboard
-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = 'alpha',
--   callback = function()
--     -- store current statusline value and use that
--     local old_laststatus = vim.opt.laststatus
--     vim.api.nvim_create_autocmd('BufUnload', {
--       buffer = 0,
--       callback = function()
--         vim.opt.laststatus = old_laststatus
--       end,
--     })
--     vim.opt.laststatus = 0
--   end,
-- -- })
-- vim.cmd([[autocmd User AlphaReady set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2]])
