return {
  'marilari88/twoslash-queries.nvim',
  lazy = true,
  module = 'twoslash-queries',
  keys = {
    { '<leader>iT', '<cmd>TwoslashQueriesInspect<CR>', desc = 'Add Twoslash Queries' },
  },
  cmd = { 'TwoslashQueriesEnable', 'TwoslashQueriesInspect' },
  opts = {
    multi_line = false, -- to print types in multi line mode
    is_enabled = false, -- to keep disabled at startup and enable it on request with the TwoslashQueriesEnable
    highlight = 'TwoslashQueries',
  },
}
