---@module "vim.lsp.client"
---@class vim.lsp.ClientConfig
return {
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
}
