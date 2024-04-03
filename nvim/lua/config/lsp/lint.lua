return {
  'mfussenegger/nvim-lint',
  lazy = true,
  module = 'lint',
  event = 'BufWritePost',
  config = function()
    require('lint').linters_by_ft = {
      -- markdown = { 'vale' },
      sh = { 'shellcheck' },
      -- text = { 'vale' },
      -- json = { 'jsonlint' },
      -- markdown = { 'vale' },
    }
    require('lint').try_lint()
    vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
      callback = function()
        require('lint').try_lint()
      end,
    })
  end,
}
