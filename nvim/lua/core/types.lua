---@alias LspAttachCb fun(client:vim.lsp.Client,bufnr:number)

---@class ServerConfig
---@field setup? LspAttachCb
---@field opts? {}
