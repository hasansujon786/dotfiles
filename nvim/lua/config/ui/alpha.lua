return {
  'goolord/alpha-nvim',
  lazy = true, -- make sure we load this during startup if it is your main colorscheme
  cmd = { 'Alpha' },
  -- priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
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
        cursor = 3,
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
    local contetnHeight = 27
    local winHeight = vim.fn.winheight(0)
    local marginTopPercent = 0.1
    local headerPadding = 0
    if winHeight > contetnHeight and winHeight - contetnHeight > 3 then
      headerPadding = math.max(2, math.floor(winHeight * marginTopPercent))
    end

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
          button('r', ' R ', '  Recent file', '<cmd>lua require("telescope.builtin").oldfiles({cwd_only=true})<CR>'),
          button('l', ' L ', '  Load session', '<cmd>SessionLoad<CR>'),
          button('f', ' F ', '  Find files', '<cmd>lua require("hasan.telescope.custom").my_find_files()<CR>'),
          button('t', ' T ', '  Open terminal', '<cmd>FloatermNew --wintype=normal --height=10<CR>'),
          button('s', ' S ', '  Open settings', '<cmd>lua require("hasan.utils.file").open_settings()<CR>'),
          button('p', ' P ', '  Lazy dashboard', '<cmd>Lazy<CR>'),
        },
        opts = { spacing = 1 },
      },
      padding1 = { type = 'padding', val = 1 },
      paddingAuto = { type = 'padding', val = headerPadding },
    }

    alpha.setup({
      layout = {
        options.paddingAuto,
        options.header,
        options.padding1,
        options.version,
        options.padding1,
        options.buttons,
      },
      opts = {},
    })
  end,
}
