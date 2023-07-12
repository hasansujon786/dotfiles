local ok, alpha = pcall(require, 'alpha')
if not ok then
  return
end
local v = vim.version()

local function button(map, sc, desc, cmd)
  local opts = {
    position = 'center',
    text = desc,
    shortcut = sc,
    cursor = 5,
    width = 38,
    align_shortcut = 'right',
    hl = 'AlphaButtons',
    hl_shortcut = 'AlphaShourtCut',
  }

  if cmd then
    opts.keymap = { 'n', map, cmd, { noremap = true, silent = true } }
  end

  return {
    type = 'button',
    val = desc,
    on_press = function()
      local key = vim.api.nvim_replace_termcodes(map, true, false, true) or ''
      vim.api.nvim_feedkeys(key, 'normal', false)
    end,
    opts = opts,
  }
end

-- dynamic header padding
-- local marginTopPercent = 0.1
-- local headerPadding = vim.fn.max({ 2, vim.fn.floor(vim.fn.winheight(0) * marginTopPercent) }) - 1

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
    },
    opts = {
      position = 'center',
      hl = 'AlphaHeader',
    },
  },
  version = {
    type = 'text',
    val = {
      string.format([[-- NeoVim %s.%s.%s --]], v.major, v.minor, v.patch),
    },
    opts = {
      position = 'center',
      hl = 'AlphaTag',
    },
  },
  buttons = {
    type = 'group',
    val = {
      button(
        '<leader>pr',
        ' SPC P R ',
        '  Recent File',
        '<cmd>lua require("telescope.builtin").oldfiles({cwd_only = true})<CR>'
      ),
      button('<leader>pl', ' SPC P L ', '  Load session', '<cmd>SessionLoad<CR>'),
      button('<leader>ff', ' SPC F F ', '  Find Files', '<cmd>Telescope find_files<CR>'),
      button('<leader>ot', ' SPC O T ', '  Open terminal', '<cmd>FloatermNew --wintype=normal --height=10<CR>'),
      button('<leader>vs', ' SPC V S ', '  Settings', '<cmd>lua require("hasan.utils.file").open_settings()<CR>'),
    },
    opts = { spacing = 1 },
  },
  headerPaddingTop = { type = 'padding', val = 1 },
  headerPaddingBottom = { type = 'padding', val = 1 },
}

alpha.setup({
  layout = {
    options.headerPaddingTop,
    options.header,
    options.headerPaddingBottom,
    options.version,
    options.headerPaddingBottom,
    options.buttons,
  },
  opts = {},
})
