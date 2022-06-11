local M = {}

local whichkey = require('which-key')

-- lua require('osv').run_this()

function M.setup()
  local keymap = {
    d = {
      name = 'Debug',
      s = { "<cmd>lua require'dap'.continue()<cr>",          'Start' },
      c = { "<cmd>lua require'dap'.continue()<cr>",          'Continue' },
      R = { "<cmd>lua require'dap'.run_to_cursor()<cr>",     'Run to Cursor' },
      t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", 'Toggle Breakpoint' },
      b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", 'Toggle Breakpoint' },

      i = { "<cmd>lua require'dap'.step_into()<cr>",         'Step Into' },
      o = { "<cmd>lua require'dap'.step_over()<cr>",         'Step Over' },
      I = { "<cmd>lua require'dap'.step_back()<cr>",         'Step Back' },
      O = { "<cmd>lua require'dap'.step_out()<cr>",          'Step Out' },

      h = { "<cmd>lua require'dap.ui.widgets'.hover()<cr>",  'Hover Variables' },
      r = { "<cmd>lua require'dap'.repl.toggle()<cr>",       'Toggle Repl' },
      u = { "<cmd>lua require'dapui'.toggle()<cr>",          'Toggle UI' },
      S = { "<cmd>lua require'dap.ui.widgets'.scopes()<cr>", 'Scopes' },
      p = { "<cmd>lua require'dap'.pause.toggle()<cr>",      'Pause' },

      q = { "<cmd>lua require'dap'.close()<cr>",             'Quit' },
      x = { "<cmd>lua require'dap'.terminate()<cr>",         'Terminate' },
      d = { "<cmd>lua require'dap'.disconnect()<cr>",        'Disconnect' },
      g = { "<cmd>lua require'dap'.session()<cr>",           'Get Session' },

      e = { "<cmd>lua require'dapui'.eval()<cr>",            'Evaluate' },
      E = { "<cmd>lua require'dapui'.eval(vim.fn.input '[Expression] > ')<cr>",       'Evaluate Input' },
      B = { "<cmd>lua require'dap'.set_breakpoint(vim.fn.input '[Condition] > ')<cr>",'Conditional Breakpoint' },

      ['.'] = { "<cmd>lua require'telescope'.extensions.dap.commands()<cr>",       'Find DAP Commands' },
      l = {
        c = { "<cmd>lua require'telescope'.extensions.dap.configurations()<cr>",   'Find DAP configurations'},
        l = { "<cmd>lua require'telescope'.extensions.dap.list_breakpoints()<cr>", 'Find DAP list_breakpoints'},
        v = { "<cmd>lua require'telescope'.extensions.dap.variables()<cr>",        'Find DAP variables'},
        f = { "<cmd>lua require'telescope'.extensions.dap.frames()<cr>",           'Find DAP frames'},
      }
    },
  }

  whichkey.register(keymap, {
    mode = 'n',
    prefix = '<leader>',
    buffer = nil,
    silent = true,
    nowait = false,
    noremap = true,
  })

  local keymap_v = {
    name = 'Debug',
    e = { "<cmd>lua require'dapui'.eval()<cr>", 'Evaluate' },
  }
  whichkey.register(keymap_v, {
    mode = 'v',
    prefix = '<leader>',
    buffer = nil,
    silent = true,
    nowait = false,
    noremap = true,
  })
end

return M
