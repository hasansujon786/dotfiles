---@module "vim.lsp.client"
---@class vim.lsp.ClientConfig
return {
  settings = {
    tailwindCSS = {
      classFunctions = { 'cva', 'cx', 'cn' },
    },
  },
  on_attach = function(_, bufnr)
    local peekTw = require('config.lsp.servers.tailwindcss.peek_tw_styles')
    keymap('n', 'gK', peekTw.peekTwStyles, { desc = 'Peek tailwind styles', buffer = bufnr })

    -- Conceal is applied through treesitter. check nvim/after/queries/tsx/highlights.scm
    vim.wo.conceallevel = 2
  end,
}

