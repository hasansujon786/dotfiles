---@alias LspAttachCb fun(client:vim.lsp.Client,bufnr:number)

---@class ServerConfig
---@field lsp_attach? LspAttachCb
---@field opts? {settings:object}

---@class StateCompletion
---@field module "cmp"|"blink"
