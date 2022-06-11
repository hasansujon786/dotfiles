local M = {}

function M.configure_ui()
  require('dapui').setup()

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
end

return M
