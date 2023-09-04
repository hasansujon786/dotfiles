-- https://alpha2phi.medium.com/neovim-for-beginners-debugging-using-dap-44626a767f57
-- use {
--   "mfussenegger/nvim-dap",
--   opt = true,
--   event = "BufReadPre",
--   module = { "dap" },
--   wants = { "nvim-dap-virtual-text", "DAPInstall.nvim", "nvim-dap-ui", "which-key.nvim" },
--   requires = {
--     "Pocco81/DAPInstall.nvim",
--     "theHamsta/nvim-dap-virtual-text",
--     "rcarriga/nvim-dap-ui",
--     "mfussenegger/nvim-dap-python",
--     "nvim-telescope/telescope-dap.nvim",
--     -- { "leoluz/nvim-dap-go", module = "dap-go" },
--   { "jbyuki/one-small-step-for-vimkind", module = "osv" },
--   },
--   config = function()
--     require("config.dap").setup()
--   end,
-- }

-- require('nvim-dap-virtual-text').setup({
--   commented = true,
-- })

-- local dap, dapui = require('dap'), require('dapui')
-- dap.listeners.after.event_initialized['dapui_config'] = function()
--   dapui.open()
-- end
-- dap.listeners.before.event_terminated['dapui_config'] = function()
--   dapui.close()
-- end
-- dap.listeners.before.event_exited['dapui_config'] = function()
--   dapui.close()
-- end
