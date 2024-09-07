---@type ServerConfig
return {
  setup = function(_, bufnr)
    local peekTw = require('config.lsp.servers.tailwindcss.peek_tw_styles')
    keymap('n', 'gK', peekTw.peekTwStyles, { desc = 'Peek tailwind styles', buffer = bufnr })

    vim.cmd([[setlocal conceallevel=2]])
  end,
  opts = {
    root_dir = require('lspconfig.util').root_pattern(
      'tailwind.config.js',
      'tailwind.config.ts',
      'postcss.config.js',
      'postcss.config.ts'
      -- 'package.json',
      -- 'node_modules'
      -- '.git'
    ),
  },
}
