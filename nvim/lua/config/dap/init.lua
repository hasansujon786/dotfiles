local M = {}

function M.configure_dap_ui()
  local dap, dapui = require('dap'), require('dapui')
  dapui.setup({
    icons = { expanded = '▾', collapsed = '▸' },
    floating = {
      max_height = nil, -- These can be integers or a float between 0 and 1.
      max_width = nil, -- Floats will be treated as percentage of your screen.
      border = 'double', -- Border style. Can be "single", "double" or "rounded"
      mappings = {
        close = { 'q', '<Esc>' },
      },
    },
    windows = { indent = 1 },
  })
  dap.listeners.after.event_initialized['dapui_config'] = dapui.open
  dap.listeners.before.event_terminated['dapui_config'] = dapui.close
  dap.listeners.before.event_exited['dapui_config'] = dapui.close

  local dap_sign = {
    stopped = { text = '', texthl = 'NuiMenuNr', numhl = 'NuiMenuNr', linehl = 'CursorLineDap' },
    breakpoint = { text = '', texthl = 'RedText', numhl = '', linehl = '' },
    bcondition = { text = '', texthl = 'RedText', numhl = '', linehl = '' },
    rejected = { text = '', texthl = 'GrayText', numhl = '', linehl = '' },
  }
  vim.fn.sign_define('DapStopped', dap_sign.stopped)
  vim.fn.sign_define('DapBreakpoint', dap_sign.breakpoint)
  vim.fn.sign_define('DapBreakpointRejected', dap_sign.rejected)
  vim.fn.sign_define('DapBreakpointCondition', dap_sign.bcondition)

  -- - `DapLogPoint` for log points (default: `L`)
end

function M.configure_virtual_text()
  require('nvim-dap-virtual-text').setup()
end

local function configure_debuggers()
  require('config.dap.node').setup()
  -- require('config.dap.lua').setup()
end

function M.setup()
  require('config.dap.keymaps').setup()
  require('dap').set_log_level('TRACE') --TRACE DEBUG INFO WARN ERROR
  configure_debuggers()
end

return M
