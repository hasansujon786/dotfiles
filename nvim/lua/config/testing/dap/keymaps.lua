local M = {}

-- lua require('osv').run_this()
-- require("dap.ext.vscode").load_launchjs()

function M.setup()
  keymap('n', '<leader>dc', '<cmd>lua require"dap".continue()<cr>', { desc = 'Continue' })
  keymap('n', '<leader>dR', '<cmd>lua require"dap".run_to_cursor()<cr>', { desc = 'Run to Cursor' })
  keymap('n', '<leader>db', '<cmd>lua require"dap".toggle_breakpoint()<cr>', { desc = 'Toggle Breakpoint' })
  keymap(
    'n',
    '<leader>dB',
    '<cmd>lua require"dap".set_breakpoint(vim.fn.input"[Condition] > ")<cr>',
    { desc = 'Conditional Breakpoint' }
  )

  keymap('n', '<leader>di', '<cmd>lua require"dap".step_into()<cr>', { desc = 'Step Into' })
  keymap('n', '<leader>do', '<cmd>lua require"dap".step_over()<cr>', { desc = 'Step Over' })
  keymap('n', '<leader>dI', '<cmd>lua require"dap".step_back()<cr>', { desc = 'Step Back' })
  keymap('n', '<leader>dO', '<cmd>lua require"dap".step_out()<cr>', { desc = 'Step Out' })

  keymap('n', '<leader>dh', '<cmd>lua require"dap.ui.widgets".hover()<cr>', { desc = 'Hover Variables' })
  keymap('n', '<leader>dr', '<cmd>lua require"dap".repl.toggle()<cr>', { desc = 'Toggle Repl' })
  keymap('n', '<leader>du', '<cmd>lua require"dapui".toggle()<cr>', { desc = 'Toggle UI' })
  keymap('n', '<leader>dS', '<cmd>lua require"dap.ui.widgets".scopes()<cr>', { desc = 'Scopes' })
  keymap('n', '<leader>dp', '<cmd>lua require"dap".pause.toggle()<cr>', { desc = 'Pause' })

  keymap('n', '<leader>dq', '<cmd>lua require"dap".close()<cr>', { desc = 'Quit' })
  keymap('n', '<leader>dD', '<cmd>lua require"dap".disconnect()<cr>', { desc = 'Disconnect' })
  keymap('n', '<leader>dX', '<cmd>lua require"dap".terminate()<cr>', { desc = 'Terminate' })
  keymap('n', '<leader>dg', '<cmd>lua require"dap".session()<cr>', { desc = 'Get Session' })

  keymap({ 'n', 'x' }, '<leader>de', '<cmd>lua require"dapui".eval()<cr>', { desc = 'Evaluate' })
  keymap(
    'n',
    '<leader>dE',
    '<cmd>lua require"dapui".eval(vim.fn.input "[Expression] > ")<cr>',
    { desc = 'Evaluate Input' }
  )

  keymap(
    'n',
    '<leader>d.',
    '<cmd>lua require"dapui".float_element("scopes",{enter=true})<CR>',
    { desc = 'Show Scopes' }
  )

  -- Launch single file
  keymap('n', '<F5>', function()
    local dap = require('dap')
    if dap.session() then
      dap.terminate() -- stop previous run (if exists)
    end
    vim.cmd('write')
    dap.run(dap.configurations.javascript[5]) -- pick 5th config
  end)
  -- keymap('n', '['/']',  '<cmd>lua require"telescope".extensions.dap.commands()<cr>', { desc = 'Find DAP Commands' },
  -- l = {
  -- keymap('n', 'c',  '<cmd>lua require'telescope'.extensions.dap.configurations()<cr>', { desc = 'Find DAP configurations' },
  -- keymap('n', 'l',  '<cmd>lua require'telescope'.extensions.dap.list_breakpoints()<cr>', { desc = 'Find DAP list_breakpoints' },
  -- keymap('n', 'v',  '<cmd>lua require'telescope'.extensions.dap.variables()<cr>', { desc = 'Find DAP variables' },
  -- keymap('n', 'f',  '<cmd>lua require'telescope'.extensions.dap.frames()<cr>', { desc = 'Find DAP frames' },
  -- }
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

-- vim.keymap.set('n', '<leader>d?', function() local widgets=require"dap.ui.widgets";widgets.centered_float(widgets.scopes) end)
-- vim.keymap.set('n', '<leader>dk', ':lua require"dap".up()<CR>zz')
-- vim.keymap.set('n', '<leader>dj', ':lua require"dap".down()<CR>zz')
-- vim.keymap.set('n', '<leader>dr', ':lua require"dap".repl.toggle({}, "vsplit")<CR><C-w>l')
