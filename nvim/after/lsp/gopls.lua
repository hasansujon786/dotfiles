---@module "vim.lsp.client"
---@class vim.lsp.ClientConfig
return {
  on_attach = function(_, bufnr)
    keymap('n', '<leader>ag', '<Plug>(GoErrDeclToggle)', { desc = 'GoErrDeclToggle', buffer = bufnr })
  end,
}
