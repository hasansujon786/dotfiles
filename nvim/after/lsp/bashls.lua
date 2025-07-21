return {
  on_attach = function(_, bufnr)
    vim.api.nvim_create_autocmd('BufWritePost', {
      buffer = bufnr,
      callback = function()
        require('lint').try_lint()
      end,
    })
  end,
}
