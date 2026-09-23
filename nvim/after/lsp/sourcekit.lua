---@module "vim.lsp.client"
---@class vim.lsp.ClientConfig
return {
  cmd = {
    'sourcekit-lsp',
  },
  filetypes = {
    'swift',
    'objective-c',
    'objective-cpp',
  },
  root_markers = {
    'buildServer.json',
    'Package.swift',
    '.git',
  },
  -- on_attach = function(_, bufnr)
  -- end,
}
