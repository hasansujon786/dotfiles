---@class lsp.ServerConfig
return {
  -- lsp_attach = function(client, bufnr)
  --   dd(client)
  -- end,
  opts = {
    cmd = {
      'node',
      vim.fn.expand(vim.fn.stdpath('data') .. '/vscode-autohotkey2-lsp/server/dist/server.js'),
      '--stdio',
    },
    filetypes = { 'ahk', 'autohotkey', 'ah2' },
  },
}
