local M = {}

local whichkey = require('which-key')

-- lua require('osv').run_this()
-- require("dap.ext.vscode").load_launchjs()

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

-- map({ "n", "<F4>", ":lua require('dapui').toggle()<CR>" })
-- map({ "n", "<F5>", ":lua require('dap').toggle_breakpoint()<CR>" })
-- map({ "n", "<F9>", ":lua require('dap').continue()<CR>" })

-- map({ "n", "<F1>", ":lua require('dap').step_over()<CR>" })
-- map({ "n", "<F2>", ":lua require('dap').step_into()<CR>" })
-- map({ "n", "<F3>", ":lua require('dap').step_out()<CR>" })

-- map({ "n", "<Leader>dsc", ":lua require('dap').continue()<CR>" })
-- map({ "n", "<Leader>dsv", ":lua require('dap').step_over()<CR>" })
-- map({ "n", "<Leader>dsi", ":lua require('dap').step_into()<CR>" })
-- map({ "n", "<Leader>dso", ":lua require('dap').step_out()<CR>" })

-- map({ "n", "<Leader>dhh", ":lua require('dap.ui.variables').hover()<CR>" })
-- map({ "v", "<Leader>dhv", ":lua require('dap.ui.variables').visual_hover()<CR>" })

-- map({ "n", "<Leader>duh", ":lua require('dap.ui.widgets').hover()<CR>" })
-- map({ "n", "<Leader>duf", ":lua local widgets=require('dap.ui.widgets');widgets.centered_float(widgets.scopes)<CR>" })

-- map({ "n", "<Leader>dro", ":lua require('dap').repl.open()<CR>" })
-- map({ "n", "<Leader>drl", ":lua require('dap').repl.run_last()<CR>" })

-- map({ "n", "<Leader>dbc", ":lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>" })
-- map({ "n", "<Leader>dbm", ":lua require('dap').set_breakpoint({ nil, nil, vim.fn.input('Log point message: ') })<CR>" })
-- map({ "n", "<Leader>dbt", ":lua require('dap').toggle_breakpoint()<CR>" })

-- map({ "n", "<Leader>dc", ":lua require('dap.ui.variables').scopes()<CR>" })
-- map({ "n", "<Leader>di", ":lua require('dapui').toggle()<CR>" })

-- local status_ok, dap = pcall(require, "dap")
-- if not status_ok then
--   return
-- end
-- vim.keymap.set('n', '<leader>dh', function() require"dap".toggle_breakpoint() end)
-- vim.keymap.set('n', '<leader>dH', ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
-- vim.keymap.set('n', '<A-k>', function() require"dap".step_out() end)
-- vim.keymap.set('n', "<A-l>", function() require"dap".step_into() end)
-- vim.keymap.set('n', '<A-j>', function() require"dap".step_over() end)
-- vim.keymap.set('n', '<A-h>', function() require"dap".continue() end)
-- vim.keymap.set('n', '<leader>dn', function() require"dap".run_to_cursor() end)
-- vim.keymap.set('n', '<leader>dc', function() require"dap".terminate() end)
-- vim.keymap.set('n', '<leader>dR', function() require"dap".clear_breakpoints() end)
-- vim.keymap.set('n', '<leader>de', function() require"dap".set_exception_breakpoints({"all"}) end)
-- vim.keymap.set('n', '<leader>da', function() require"debugHelper".attach() end)
-- vim.keymap.set('n', '<leader>dA', function() require"debugHelper".attachToRemote() end)
-- vim.keymap.set('n', '<leader>di', function() require"dap.ui.widgets".hover() end)
-- vim.keymap.set('n', '<leader>d?', function() local widgets=require"dap.ui.widgets";widgets.centered_float(widgets.scopes) end)
-- vim.keymap.set('n', '<leader>dk', ':lua require"dap".up()<CR>zz')
-- vim.keymap.set('n', '<leader>dj', ':lua require"dap".down()<CR>zz')
-- vim.keymap.set('n', '<leader>dr', ':lua require"dap".repl.toggle({}, "vsplit")<CR><C-w>l')
