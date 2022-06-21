local M = {}

function M.configure_ui()
  require('dapui').setup({
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

  local dap_breakpoint = {
    breakpoint = { text = '🟥', texthl = 'DiagnosticError', linehl = '', numhl = '' },
    rejected = { text = '', texthl = 'DiagnosticError', linehl = '', numhl = '' },
    stopped = { text = '', texthl = 'String', numhl = 'String', linehl = 'DiagnosticUnderlineError' },
  }
  vim.fn.sign_define('DapBreakpoint', dap_breakpoint.breakpoint)
  vim.fn.sign_define('DapStopped', dap_breakpoint.stopped)
  vim.fn.sign_define('DapBreakpointRejected', dap_breakpoint.rejected)
end

-- local function configure_debuggers()
--   require('config.dap.lua').setup()
--   -- require("config.dap.python").setup()
--   -- require("config.dap.rust").setup()
--   -- require("config.dap.go").setup()
-- end

function M.setup()
  require('config.dap.keymaps').setup()
  require('dap').set_log_level('TRACE') --TRACE DEBUG INFO WARN ERROR
end

return M
