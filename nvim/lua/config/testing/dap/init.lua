-- Dap configs:
-- https://github.com/dreamsofcode-io/neovim-nodejs/blob/main/configs/dap.lua

-- local Icons = require('hasan.utils.ui.icons').Other -- only used by nvim-dap-ui (currently disabled)

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

    configure_debuggers()
  end,
  keys = {
    { '<leader>ds', '<cmd>lua require"dap".continue()<cr>', desc = 'Continue' },
    { '<leader>db', '<cmd>lua require"dap".toggle_breakpoint()<CR>', desc = 'Toggle Breakpoint' },
  },
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
        auto_toggle = "open_term",
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
      keys = {
        { '<leader>du', '<cmd>DapViewToggle!<cr>', desc = 'Toggle DAP View' },
        { '<leader>dU', '<cmd>DapViewClose!<cr>', desc = 'Toggle DAP View' },
        { '<leader>dh', '<cmd>DapViewHover!<cr>', desc = 'Toggle DAP View' },
        { '<leader>dW', '<cmd>lua require("dap-view").add_expr()<cr>', desc = 'A to Watch' },
        {
          '<leader>dE',
          '<cmd>lua require("dap-view").hover(vim.fn.input("[Expression] > "))',
          desc = 'Evaluate Input',
        },
        { '<leader>d.', '<cmd>DapViewJump scopes<cr>', desc = 'Show Scopes' },
      },
    },
    -- {
    --   'rcarriga/nvim-dap-ui',
    --   opts = {
    --     icons = { expanded = Icons.ChevronSlimDown, collapsed = Icons.ChevronSlimRight, current_frame = '' },
    --     floating = {
    --       max_height = 0.9, -- These can be integers or a float between 0 and 1.
    --       max_width = 0.8, -- Floats will be treated as percentage of your screen.
    --       border = 'rounded', -- Border style. Can be "single", "double" or "rounded"
    --       mappings = {
    --         close = { 'q', '<Esc>' },
    --       },
    --     },
    --     layouts = {
    --       {
    --         position = 'right',
    --         size = 36,
    --         elements = {
    --           { id = 'scopes', size = 0.40 },
    --           { id = 'watches', size = 0.20 },
    --           { id = 'stacks', size = 0.20 },
    --           { id = 'breakpoints', size = 0.20 },
    --         },
    --       },
    --       {
    --         position = 'bottom',
    --         size = 10,
    --         elements = {
    --           { id = 'repl', size = 1 },
    --           -- { id = 'console', size = 0.5 },
    --         },
    --       },
    --     },
    --   },
    --   config = function(_, opts)
    --     local dap, dapui = require('dap'), require('dapui')
    --
    --     -- Dap sign icons
    --     local dap_sign = {
    --       stopped = { text = '', texthl = 'Number', numhl = 'Number', linehl = 'DapCursorLine' },
    --       breakpoint = { text = '●', texthl = 'RedText', numhl = '', linehl = '' },
    --       bcondition = { text = '◉', texthl = 'RedText', numhl = '', linehl = '' },
    --       rejected = { text = '○', texthl = 'MutedText', numhl = '', linehl = '' },
    --     }
    --     vim.fn.sign_define('DapStopped', dap_sign.stopped)
    --     vim.fn.sign_define('DapBreakpoint', dap_sign.breakpoint)
    --     vim.fn.sign_define('DapBreakpointRejected', dap_sign.rejected)
    --     vim.fn.sign_define('DapBreakpointCondition', dap_sign.bcondition)
    --
    --     -- Dapui
    --     dapui.setup(opts)
    --     dap.listeners.after.event_initialized['dapui_config'] = function()
    --       vim.notify('Debugger ui connected', vim.log.levels.INFO)
    --     end
    --     -- dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    --     -- dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    --     -- dap.listeners.before.event_exited['dapui_config'] = dapui.close
    --   end,
    -- },
  },
}
