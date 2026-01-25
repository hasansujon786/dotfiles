---@module "vim.lsp.client"
---@class vim.lsp.ClientConfig
return {
  filetypes = { 'ahk', 'autohotkey', 'ah2' },
  cmd = {
    'node',
    vim.fn.expand(vim.fn.stdpath('data') .. '/packages/vscode-autohotkey2-lsp/server/dist/server.js'),
    '--stdio',
  },
}
