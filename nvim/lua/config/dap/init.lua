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
  dependencies = {
    'nvim-telescope/telescope-dap.nvim',
    'mxsdev/nvim-dap-vscode-js',
    {
      'rcarriga/nvim-dap-ui',
      config = function()
        require('config.dap.dap-ui').configure_dap_ui()
      end,
    },
    {
      'theHamsta/nvim-dap-virtual-text',
      config = function()
        require('nvim-dap-virtual-text').setup()
      end,
    },
    -- 'jbyuki/one-small-step-for-vimkind',
  },
}
