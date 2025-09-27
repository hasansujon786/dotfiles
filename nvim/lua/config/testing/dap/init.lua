-- Dap configs:
-- https://github.com/dreamsofcode-io/neovim-nodejs/blob/main/configs/dap.lua

local Icons = require('hasan.utils.ui.icons').Other

local function configure_debuggers()
  require('config.testing.dap.typescript').setup()
  -- require('config.testing.dap.lua').setup()
end

return {
  'mfussenegger/nvim-dap',
  lazy = true,
  module = 'dap',
  config = function()
    require('config.testing.dap.keymaps').setup()
    require('dap').set_log_level('TRACE') --TRACE DEBUG INFO WARN ERROR
    configure_debuggers()
  end,
  keys = {
    { '<leader>ds', '<cmd>lua require"dap".continue()<cr>', desc = 'Continue' },
    { '<leader>db', '<cmd>lua require"dap".toggle_breakpoint()<CR>', desc = 'Toggle Breakpoint' },
  },
  dependencies = {
    { 'theHamsta/nvim-dap-virtual-text', opts = { virt_text_pos = 'eol' } },
    'nvim-neotest/nvim-nio',
    {
      'rcarriga/nvim-dap-ui',
      opts = {
        icons = { expanded = Icons.ChevronSlimDown, collapsed = Icons.ChevronSlimRight, current_frame = '' },
        floating = {
          max_height = 0.9, -- These can be integers or a float between 0 and 1.
          max_width = 0.8, -- Floats will be treated as percentage of your screen.
          border = 'rounded', -- Border style. Can be "single", "double" or "rounded"
          mappings = {
            close = { 'q', '<Esc>' },
          },
        },
        layouts = {
          {
            position = 'left',
            size = 40,
            elements = {
              { id = 'scopes', size = 0.40 },
              { id = 'watches', size = 0.20 },
              { id = 'stacks', size = 0.20 },
              { id = 'breakpoints', size = 0.20 },
            },
          },
          {
            position = 'bottom',
            size = 10,
            elements = {
              { id = 'repl', size = 1 },
              -- { id = 'console', size = 0.5 },
            },
          },
        },
      },
      config = function(_, opts)
        local dap, dapui = require('dap'), require('dapui')

        -- Dap sign icons
        local dap_sign = {
          stopped = { text = '', texthl = 'Number', numhl = 'Number', linehl = 'DapCursorLine' },
          breakpoint = { text = '●', texthl = 'RedText', numhl = '', linehl = '' },
          bcondition = { text = '◉', texthl = 'RedText', numhl = '', linehl = '' },
          rejected = { text = '○', texthl = 'MutedText', numhl = '', linehl = '' },
        }
        vim.fn.sign_define('DapStopped', dap_sign.stopped)
        vim.fn.sign_define('DapBreakpoint', dap_sign.breakpoint)
        vim.fn.sign_define('DapBreakpointRejected', dap_sign.rejected)
        vim.fn.sign_define('DapBreakpointCondition', dap_sign.bcondition)

        -- Dapui
        dapui.setup(opts)
        dap.listeners.after.event_initialized['dapui_config'] = function()
          vim.notify('Debugger ui connected', vim.log.levels.INFO)
        end
        dap.listeners.after.event_initialized['dapui_config'] = dapui.open
        -- dap.listeners.before.event_terminated['dapui_config'] = dapui.close
        -- dap.listeners.before.event_exited['dapui_config'] = dapui.close
      end,
    },
  },
}
