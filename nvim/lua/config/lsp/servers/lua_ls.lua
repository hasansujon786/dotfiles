-- https://luals.github.io/wiki/settings/
-- Wiki https://github.com/neovim/nvim-lspconfig/wiki/User-contributed-tips#range-formatting-with-a-motion

---@class ServerConfig
local M = {
  -- lsp_attach = function()
  --   dd('lua_ls attach for this buf')
  -- end,
  opts = {
    -- on_init = function()
    --   P('from on_init luals')
    -- end,
    -- commands = {
    --   TestCmd = {
    --     function()
    --       P('asdf')
    --     end,
    --     description = 'Open source/header in current buffer',
    --   },
    -- },
    settings = {
      Lua = {
        hint = {
          enable = true,
          setType = true,
          -- arrayIndex = "Disable",
        },
        completion = { callSnippet = 'Replace' },
        runtime = { version = 'LuaJIT' },
        diagnostics = { globals = { 'vim', 'jit', 'keymap', 'P', 'log', 'Snacks' } },
        workspace = {
          library = {
            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
            [vim.fn.stdpath('config') .. '/lua'] = true,
            [plugin_path .. '/nui.nvim'] = true,
            [plugin_path .. '/snacks.nvim'] = true,
          },
        },
        telemetry = { enable = false },
        -- semantic = { enable = false },
      },
    },
  },
}

return M
