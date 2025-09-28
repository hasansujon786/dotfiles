local group = vim.api.nvim_create_augroup('CODE_AUTOCMDS', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  group = group,
  callback = function()
    vim.hl.on_yank({ on_visual = true, higroup = 'Search', timeout = 200 })
  end,
})

vim.api.nvim_create_autocmd('InsertEnter', {
  group = group,
  callback = function()
    vim.schedule(function()
      vim.cmd('nohlsearch')
    end)
  end,
})
