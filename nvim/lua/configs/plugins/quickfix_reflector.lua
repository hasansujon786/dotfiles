return {
  'stefandtw/quickfix-reflector.vim',
  lazy = true,
  ft = { 'qf' },
  dependencies = {
    -- {
    --   'kevinhwang91/nvim-bqf',
    --   lazy = true,
    --   module = 'bqf',
    -- },
  },
  config = function()
    -- vim.defer_fn(function()
    -- require('bqf').setup({
    --   preview = {
    --     winblend = 0,
    --   },
    -- })
    -- require('bqf').bootstrap()
    -- end, 50)
  end,
}
