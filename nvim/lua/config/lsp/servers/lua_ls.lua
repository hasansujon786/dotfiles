return {
  -- setup = function()
  --   P('I am from lua_ls')
  -- end,
  -- https://github.com/neovim/nvim-lspconfig/wiki/User-contributed-tips#range-formatting-with-a-motion
  -- commands = {
  --   TestCmd = {
  --     function()
  --       P('asdf')
  --     end,
  --     description = 'Open source/header in current buffer',
  --   },
  -- },
  opts = {
    settings = {
      Lua = {
        completion = {
          callSnippet = 'Replace',
        },
        runtime = { version = 'LuaJIT' },
        diagnostics = { globals = { 'vim', 'jit', 'keymap', 'P' } },
        workspace = {
          -- library = vim.api.nvim_get_runtime_file('', true),
          library = { 'C:\\Users\\hasan\\dotfiles\\nvim\\lua' }, -- Make the server aware of Neovim runtime files
        },
        telemetry = { enable = false },
        -- semantic = { enable = false },
      },
    },
  },
}
