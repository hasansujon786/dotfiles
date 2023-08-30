return {
  { 'kevinhwang91/nvim-bqf', lazy = true, module = 'bqf' },
  {
    'stefandtw/quickfix-reflector.vim',
    lazy = true,
    ft = { 'qf' },
    config = function()
      vim.defer_fn(function()
        require('bqf').setup({
          preview = {
            winblend = 0,
          },
        })
        require('bqf').bootstrap()
      end, 50)
    end,
  },
}
