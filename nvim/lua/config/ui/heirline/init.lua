return {
  'rebelot/heirline.nvim',
  lazy = true,
  enabled = true,
  event = { 'BufReadPost', 'VeryLazy' },
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    vim.opt.showcmdloc = 'statusline'
    local conditions = require('heirline.conditions')

    local c = require('config.ui.heirline.comp')
    local w = require('config.ui.heirline.win')

    local StatusLine = {
      static = {
        mode_colors_map = {
          n = 'blue',
          i = 'green',
          v = 'purple',
          V = 'purple',
          ['\22'] = 'cyan',
          c = 'orange',
          s = 'purple',
          S = 'purple',
          ['\19'] = 'purple',
          R = 'red',
          -- r = 'orange',
          ['!'] = 'orange',
          t = 'green',
        },
        mode_color = function(self)
          local mode = vim.fn.mode() or 'n'
          return self.mode_colors_map[mode] or self.mode_colors_map['n']
        end,
      },
      {
        c.ViMode,
        c.GitBranch,
        c.MacroRec,
        {
          c.Fill,
          c.SearchCount,
          c.Diagnostics,
          c.Fill,
        },
        c.ShowCmd,
        c.Harpoon,
        c.LSPActive,
        c.FileTypeWithIcon,
        c.SpaceInfo,
        c.ScrollPercentageBall,
        c.Location,
      },
    }

    local WinBars = {
      fallthrough = false,
      -- { -- A special winbar for terminals
      --   condition = function()
      --     return conditions.buffer_matches({ buftype = { 'terminal' } })
      --   end,
      --   utils.surround({ '', '' }, 'dark_red', {
      --     c.FileType,
      --     c.Gap,
      --     -- TerminalName,
      --   }),
      -- },
      { -- An inactive winbar for regular files
        condition = function()
          return not conditions.is_active()
        end,
        {
          { hl = { fg = 'muted', force = true }, w.BarStart },
          { hl = { fg = 'muted', force = true }, w.FileNameBlock },
          w.BarEnd,
          w.Rest,
        },
      },
      -- A winbar for regular files
      { w.BarStart, w.FileNameBlock, w.BarEnd, w.Rest },
    }

    require('heirline').setup({
      statusline = StatusLine,
      winbar = WinBars,
      opts = {
        disable_winbar_cb = function(args)
          return conditions.buffer_matches({
            buftype = { 'nofile', 'prompt', 'help', 'quickfix' },
            filetype = { '^git.*', 'fugitive', 'Trouble', 'dashboard', 'harpoon' },
          }, args.buf)
        end,
        colors = {
          bg0 = '#242b38',
          bg1 = '#2d3343',
          bg2 = '#343e4f',
          bg3 = '#363c51',
          bg_d = '#1e242e',
          black = '#151820',

          fg = '#a5b0c5',
          grey = '#546178',
          muted = '#68707E',
          layer = '#3E425D',
          light_grey = '#8b95a7',
          -- light_grey = '#7d899f',

          diff_add = '#303d27',
          diff_change = '#18344c',
          diff_delete = '#3c2729',
          diff_text = '#265478',

          aqua = '#6db9f7',
          yellow = '#ebc275',
          bg_yellow = '#f0d197',
          bg_blue = '#6db9f7',
          dark_yellow = '#9a6b16',

          red = '#ef5f6b',
          green = '#97ca72',
          orange = '#d99a5e',
          blue = '#5ab0f6',
          purple = '#ca72e4',
          cyan = '#4dbdcb',

          dark_purple = '#8f36a9',
          dark_red = '#a13131',
          dark_orange = '#9a6b16',
          dark_blue = '#127ace',
          dark_green = '#5e9437',
          dark_cyan = '#25747d',
        },
      },
    })
  end,
}
