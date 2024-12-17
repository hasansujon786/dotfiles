return {
  'rebelot/heirline.nvim',
  lazy = true,
  enabled = true,
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    vim.o.laststatus = 3
    vim.opt.showcmdloc = 'statusline'
    local conditions = require('heirline.conditions')
    -- local utils = require('heirline.utils')
    local sl = require('config.ui.heirline.statusline')
    local wb = require('config.ui.heirline.winbar')
    local dapui_filetypes = { 'dapui_scopes', 'dapui_breakpoints', 'dapui_stacks', 'dapui_watches' }

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
        sl.ViMode,
        sl.Tabs,
        sl.GitBranch,
        sl.GitBranchAlt,
        sl.layerEndleft,
        sl.MacroRec,
        {
          sl.Fill,
          -- sl.SearchCount,
          sl.Diagnostics,
          sl.Fill,
        },
        sl.ShowCmd,
        sl.Harpoon,
        sl.LSPActive,
        sl.SpaceInfo,
        sl.FileFormat,
        sl.FileType,
        sl.ScrollPercentageBall,
        sl.Location,
      },
    }

    local WinBars = {
      fallthrough = false,
      { -- DapUI sidebar
        fallthrough = false,
        condition = function()
          return conditions.buffer_matches({ filetype = dapui_filetypes })
        end,
        {
          { provider = ' ', hl = { bg = 'bg_d' } },
          { wb.FileNameBlock(), hl = { fg = 'light_grey', bg = 'bg_d', force = true } },
          wb.Rest,
        },
      },
      {
        fallthrough = false,
        { -- Default inactive winbar for regular files
          condition = function()
            return not conditions.is_active()
          end,
          { sl.Space, { hl = { fg = 'muted', force = true }, wb.WinBarFileName }, wb.BarEnd, wb.Rest },
        },
        -- Default active winbar for regular files
        { wb.BarStart, wb.WinBarFileName, wb.BarEnd, wb.Rest },
      },
    }

    require('heirline').setup({
      statusline = StatusLine,
      winbar = WinBars,
      opts = {
        disable_winbar_cb = function(args)
          if conditions.buffer_matches({ filetype = dapui_filetypes }, args.buf) then
            return false
          end
          return conditions.buffer_matches({
            buftype = { 'nofile', 'prompt', 'help', 'quickfix' },
            filetype = { '^git.*', 'fugitive', 'Trouble', 'dashboard', 'harpoon', 'floaterm', 'terminal' },
          }, args.buf)
        end,
        colors = require('hasan.utils.ui.palette').colors,
      },
    })
  end,
}
