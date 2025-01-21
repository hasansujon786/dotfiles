return {
  'mfussenegger/nvim-lint',
  lazy = true,
  module = 'lint',
  -- event = 'BufWritePost',
  config = function()
    require('lint').linters_by_ft = require('core.state').lsp.linters_by_ft
  end,
}
