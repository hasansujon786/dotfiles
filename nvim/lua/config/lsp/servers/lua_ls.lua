-- https://luals.github.io/wiki/settings/
-- Wiki https://github.com/neovim/nvim-lspconfig/wiki/User-contributed-tips#range-formatting-with-a-motion

---@type ServerConfig
return {
  setup = function (client, bufnr)
    
  end,
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
        diagnostics = { globals = { 'vim', 'jit', 'keymap', 'P', 'log' } },
        workspace = {
          library = {
            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
            [vim.fn.stdpath('config') .. '/lua'] = true,
          },
        },
        telemetry = { enable = false },
        -- semantic = { enable = false },
      },
    },
  },
}
