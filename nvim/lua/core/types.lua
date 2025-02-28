---@alias lsp.AttachCb fun(client:vim.lsp.Client,bufnr:number)

---@class lsp.ServerConfig
---@field lsp_attach? lsp.AttachCb
---@field opts? {settings:table}

---@class state.Completion
---@field module "cmp"|"blink"

---@alias conform.LspFormatOpts
---| '"never"' # never use the LSP for formatting (default)
---| '"fallback"' # LSP formatting is used when no other formatters are available
---| '"prefer"' # use only LSP formatting when available
---| '"first"' # LSP formatting is used when available and then other formatters
---| '"last"' # other formatters are used then LSP formatting when available

---@class conform.FormatOpts
---@field timeout_ms? integer Time in milliseconds to block for formatting. Defaults to 1000. No effect if async = true.
---@field lsp_format? conform.LspFormatOpts Configure if and when LSP should be used for formatting. Defaults to "never".
---@field stop_after_first? boolean Only run the first available formatter in the list. Defaults to false.
---@field quiet? boolean Don't show any notifications for warnings or failures. Defaults to false.
---@field id? integer Passed to |vim.lsp.buf.format| when using LSP formatting
---@field name? string Passed to |vim.lsp.buf.format| when using LSP formatting
---@field filter? fun(client: table): boolean Passed to |vim.lsp.buf.format| when using LSP formatting

---@class state.FormatterConfig
---@field filetype string|string[]
---@field formatter conform.FormatOpts

---@class state.Lsp
---@field formatters_by_ft state.FormatterConfig[]
