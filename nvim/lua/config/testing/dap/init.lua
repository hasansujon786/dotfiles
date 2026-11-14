-- Dap configs:
-- https://github.com/dreamsofcode-io/neovim-nodejs/blob/main/configs/dap.lua

local function configure_debuggers()
  require('config.testing.dap.typescript').setup()
  -- require('config.testing.dap.lua').setup()
end
local function configure_dapui()
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
end

return {
  'mfussenegger/nvim-dap',
  lazy = true,
  module = 'dap',
  config = function()
    require('dap').set_log_level('TRACE') --TRACE DEBUG INFO WARN ERROR
    configure_dapui()
    configure_debuggers()
  end,
  dependencies = {
    {
      'theHamsta/nvim-dap-virtual-text',
      opts = {
        virt_text_pos = 'eol',
        --- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
        --- @param buf number
        --- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
        --- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
        --- @param options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
        --- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
        display_callback = function(variable, buf, stackframe, node, options)
          if variable.type == 'Function' then
            return nil
          end

          -- by default, strip out new line characters
          if options.virt_text_pos == 'inline' then
            return ' = ' .. variable.value:gsub('%s+', ' ')
          else
            return variable.name .. ' = ' .. variable.value:gsub('%s+', ' ')
          end
        end,
      },
    },
    'nvim-neotest/nvim-nio',
    {
      -- https://github.com/igorlfs/nvim-dap-view
      'igorlfs/nvim-dap-view',
      opts = {
        -- Auto open when a session is started and auto close when all sessions finish
        -- Alternatively, can be a string:
        -- - "open_term": open the terminal when starting a new session, nothing else
        -- - "keep_terminal": as above, but keeps the terminal when the session finishes
        -- - "open": self explanatory
        auto_toggle = 'open_term',
        -- Reopen dapview when switching to a different tab
        -- Can also be a function to dynamically choose when to follow, by returning a boolean
        -- If a function, receives the name of the adapter for the current session as an argument
        follow_tab = true,

        help = {
          border = 'rounded',
        },
        hover = {
          border = 'rounded',
        },
        winbar = {
          controls = {
            enabled = true,
            position = 'right',
            buttons = {
              'play',
              'step_into',
              'step_over',
              'step_out',
              'step_back',
              'run_last',
              'terminate',
              'disconnect',
            },
          },
        },
      },
      config = function(_, opts)
        require('dap-view').setup(opts)
        -- Belt and suspenders: dap-view only auto-opens via `auto_toggle`
        -- (attach/launch) and `follow_tab` (TabEnter) — both are false above.
        -- It has no BufEnter logic, but strip its auto-open listeners anyway
        -- so a future default bump can't re-enable it.
        local dap_ok, dap = pcall(require, 'dap')
        if dap_ok then
          for _, event in ipairs({ 'attach', 'launch' }) do
            if dap.listeners.before[event] then
              dap.listeners.before[event]['dap-view'] = nil
            end
          end
        end
      end,
    },
  },
}
