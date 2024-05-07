return {
  setup = function(_, bufnr)
    local conceal = require('config.lsp.servers.tailwindcss.class_conceal')
    local peekTw = require('config.lsp.servers.tailwindcss.peek_tw_styles')

    if state.treesitter.auto_conceal_html_class then
      conceal.setup_conceal(bufnr)
    end

    -- Tip: make sure concealcursor is disabled by default
    keymap('n', 'gK', peekTw.peekTwStyles, { desc = 'Peek tailwind styles', buffer = bufnr })
    keymap('n', '<leader>to', conceal.toggle_conceallevel, { desc = 'Toggle conceallevel', buffer = bufnr })
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
