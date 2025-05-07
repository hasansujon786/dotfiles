return {
  cmd = {
    'node',
    vim.fn.expand(vim.fn.stdpath('data') .. '/packages/vscode-autohotkey2-lsp/server/dist/server.js'),
    '--stdio',
  },
  filetypes = { 'ahk', 'autohotkey', 'ah2' },
}
