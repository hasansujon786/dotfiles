-- https://luals.github.io/wiki/settings/
-- Wiki https://github.com/neovim/nvim-lspconfig/wiki/User-contributed-tips#range-formatting-with-a-motion

return {
  -- on_init = function()
  -- end,
  -- on_attach = function(client, bufnr)
  -- end,
  -- cmd = { 'lua-language-server' },
  -- filetypes = { 'lua' },
  -- root_markers = { '.luarc.json', '.luarc.jsonc' },

  -- Specific settings to send to the server. The schema for this is
  -- defined by the server. For example the schema for lua-language-server
  -- can be found here https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
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
}
