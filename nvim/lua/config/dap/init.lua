-- Dap configs:
-- https://github.com/dreamsofcode-io/neovim-nodejs/blob/main/configs/dap.lua

local function configure_debuggers()
  local dap = require('dap')
  require('config.dap.typescript').setup(dap)
  -- require('config.dap.node').setup(dap)
  -- require('config.dap.lua').setup()
end

return {
  'mfussenegger/nvim-dap',
  lazy = true,
  module = 'dap',
  config = function()
    require('config.dap.keymaps').setup()
    require('dap').set_log_level('TRACE') --TRACE DEBUG INFO WARN ERROR
    configure_debuggers()
  end,
  keys = {
    {
      '<leader>ds',
      '<cmd>lua require"dap".continue()<cr>',
      desc = 'Start',
    },
    {
      '<leader>db',
      '<cmd>lua require"dap".toggle_breakpoint()<CR>',
      desc = 'Start',
    },
    {
      '<leader>d/',
      '<cmd>lua require"telescope".extensions.dap.commands()<CR>',
      desc = 'Start',
    },

    -- {
    --   '<leader>da',
    --   function()
    --     if vim.fn.filereadable('.vscode/launch.json') then
    --       local dap_vscode = require('dap.ext.vscode')
    --       dap_vscode.load_launchjs(nil, {
    --         ['pwa-node'] = js_based_languages,
    --         ['chrome'] = js_based_languages,
    --         ['pwa-chrome'] = js_based_languages,
    --       })
    --     end
    --     require('dap').continue()
    --   end,
    --   desc = 'Run with Args',
    -- },
  },
  dependencies = {
    'nvim-telescope/telescope-dap.nvim',
    'mxsdev/nvim-dap-vscode-js',
    'theHamsta/nvim-dap-virtual-text',
    'nvim-neotest/nvim-nio',
    -- 'jbyuki/one-small-step-for-vimkind',
    {
      'rcarriga/nvim-dap-ui',
      opts = {
        icons = { expanded = '', collapsed = '', current_frame = '' },
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
          breakpoint = { text = '', texthl = 'RedText', numhl = '', linehl = '' },
          bcondition = { text = '', texthl = 'RedText', numhl = '', linehl = '' },
          rejected = { text = '', texthl = 'MutedText', numhl = '', linehl = '' },
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
        -- dap.listeners.after.event_initialized['dapui_config'] = dapui.open
        dap.listeners.before.event_terminated['dapui_config'] = dapui.close
        dap.listeners.before.event_exited['dapui_config'] = dapui.close
      end,
    },
  },
}
