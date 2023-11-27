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
  dap.listeners.after.event_initialized['dapui_config'] = function()
    vim.notify('Debugger connected', vim.log.levels.INFO)
  end
  -- dap.listeners.after.event_initialized['dapui_config'] = dapui.open
  dap.listeners.before.event_terminated['dapui_config'] = dapui.close
  dap.listeners.before.event_exited['dapui_config'] = dapui.close

  local dap_sign = {
    stopped = { text = '', texthl = 'NuiMenuItem', numhl = 'NuiMenuItem', linehl = 'CursorLineDap' },
    breakpoint = { text = '', texthl = 'RedText', numhl = '', linehl = '' },
    bcondition = { text = '', texthl = 'RedText', numhl = '', linehl = '' },
    rejected = { text = '', texthl = 'MutedText', numhl = '', linehl = '' },
  }
  vim.fn.sign_define('DapStopped', dap_sign.stopped)
  vim.fn.sign_define('DapBreakpoint', dap_sign.breakpoint)
  vim.fn.sign_define('DapBreakpointRejected', dap_sign.rejected)
  vim.fn.sign_define('DapBreakpointCondition', dap_sign.bcondition)
end

return M
