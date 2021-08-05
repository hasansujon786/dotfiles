local nvim_lsp = require('lspconfig')
local lsp = {}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
lsp.on_attach = function(client, bufnr)
  lsp.common_on_attach(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=false }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gp', '<cmd>lua require"lsp".PeekDefinition()<CR>', opts)
  buf_set_keymap('n', 'gY', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', 'gI', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)

  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev({popup_opts = {border = "single"}})<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next({popup_opts = {border = "single"}})<CR>', opts)
  buf_set_keymap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  -- buf_set_keymap("n", "<F9>", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  -- buf_set_keymap('n', '<C-space>', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

  buf_set_keymap('n', '<leader>aa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>ar', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>al', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<leader>ad', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '<leader>ah', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>aq', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- lunarvim
  -- vim.cmd 'command! -nargs=0 LspVirtualTextToggle lua require("lsp/virtual_text").toggle()'
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
-- local servers = { "pyright", "rust_analyzer", "tsserver" }
local servers = { "tsserver" }
for _, lspName in ipairs(servers) do
  nvim_lsp[lspName].setup {
    on_attach = lsp.on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end


-- TODO: figure out why this don't work
vim.fn.sign_define(
  "LspDiagnosticsSignError",
  { texthl = "LspDiagnosticsSignError", text = "", numhl = "LspDiagnosticsSignError" }
)
vim.fn.sign_define(
  "LspDiagnosticsSignWarning",
  { texthl = "LspDiagnosticsSignWarning", text = "", numhl = "LspDiagnosticsSignWarning" }
)
vim.fn.sign_define(
  "LspDiagnosticsSignHint",
  { texthl = "LspDiagnosticsSignHint", text = "", numhl = "LspDiagnosticsSignHint" }
)
vim.fn.sign_define(
  "LspDiagnosticsSignInformation",
  { texthl = "LspDiagnosticsSignInformation", text = "", numhl = "LspDiagnosticsSignInformation" }
)

-- symbols for autocomplete
vim.lsp.protocol.CompletionItemKind = {
  "   (Text) ",
  "   (Method)",
  "   (Function)",
  "   (Constructor)",
  " ﴲ  (Field)",
  "[] (Variable)",
  "   (Class)",
  " ﰮ  (Interface)",
  "   (Module)",
  " 襁 (Property)",
  "   (Unit)",
  "   (Value)",
  " 練 (Enum)",
  "   (Keyword)",
  "   (Snippet)",
  "   (Color)",
  "   (File)",
  "   (Reference)",
  "   (Folder)",
  "   (EnumMember)",
  " ﲀ  (Constant)",
  " ﳤ  (Struct)",
  "   (Event)",
  "   (Operator)",
  "   (TypeParameter)",
}

local function documentHighlight(client, bufnr)
  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec(
      [[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
      false
    )
  end
end

function lsp.common_on_attach(client, bufnr)
  documentHighlight(client, bufnr)
end

function lsp.PeekDefinition()
  if vim.tbl_contains(vim.api.nvim_list_wins(), lsp.floating_win) then
    vim.api.nvim_set_current_win(lsp.floating_win)
  else
    local params = vim.lsp.util.make_position_params()
    return vim.lsp.buf_request(0, "textDocument/definition", params, lsp.preview_location_callback)
  end
end

-- function lsp_config.PeekTypeDefinition()
--   if vim.tbl_contains(vim.api.nvim_list_wins(), lsp_config.floating_win) then
--     vim.api.nvim_set_current_win(lsp_config.floating_win)
--   else
--     local params = vim.lsp.util.make_position_params()
--     return vim.lsp.buf_request(0, "textDocument/typeDefinition", params, lsp_config.preview_location_callback)
--   end
-- end

-- function lsp_config.PeekImplementation()
--   if vim.tbl_contains(vim.api.nvim_list_wins(), lsp_config.floating_win) then
--     vim.api.nvim_set_current_win(lsp_config.floating_win)
--   else
--     local params = vim.lsp.util.make_position_params()
--     return vim.lsp.buf_request(0, "textDocument/implementation", params, lsp_config.preview_location_callback)
--   end
-- end

-- -- Taken from https://www.reddit.com/r/neovim/comments/gyb077/nvimlsp_peek_defination_javascript_ttserver/
-- function lsp_config.preview_location(location, context, before_context)
--   -- location may be LocationLink or Location (more useful for the former)
--   context = context or 15
--   before_context = before_context or 0
--   local uri = location.targetUri or location.uri
--   if uri == nil then
--     return
--   end
--   local bufnr = vim.uri_to_bufnr(uri)
--   if not vim.api.nvim_buf_is_loaded(bufnr) then
--     vim.fn.bufload(bufnr)
--   end

--   local range = location.targetRange or location.range
--   local contents = vim.api.nvim_buf_get_lines(
--     bufnr,
--     range.start.line - before_context,
--     range["end"].line + 1 + context,
--     false
--   )
--   local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
--   return vim.lsp.util.open_floating_preview(contents, filetype, { border = O.lsp.popup_border })
-- end

-- function lsp_config.preview_location_callback(_, method, result)
--   local context = 15
--   if result == nil or vim.tbl_isempty(result) then
--     print("No location found: " .. method)
--     return nil
--   end
--   if vim.tbl_islist(result) then
--     lsp_config.floating_buf, lsp_config.floating_win = lsp_config.preview_location(result[1], context)
--   else
--     lsp_config.floating_buf, lsp_config.floating_win = lsp_config.preview_location(result, context)
--   end
-- end

-- function lsp_config.tsserver_on_attach(client, bufnr)
--   -- lsp_config.common_on_attach(client, bufnr)
--   client.resolved_capabilities.document_formatting = false

--   local ts_utils = require "nvim-lsp-ts-utils"

--   -- defaults
--   ts_utils.setup {
--     debug = false,
--     disable_commands = false,
--     enable_import_on_completion = false,
--     import_all_timeout = 5000, -- ms

--     -- eslint
--     eslint_enable_code_actions = true,
--     eslint_enable_disable_comments = true,
--     eslint_bin = O.lang.tsserver.linter,
--     eslint_config_fallback = nil,
--     eslint_enable_diagnostics = true,

--     -- formatting
--     enable_formatting = O.lang.tsserver.autoformat,
--     formatter = O.lang.tsserver.formatter.exe,
--     formatter_config_fallback = nil,

--     -- parentheses completion
--     complete_parens = false,
--     signature_help_in_parens = false,

--     -- update imports on file move
--     update_imports_on_move = false,
--     require_confirmation_on_move = false,
--     watch_dir = nil,
--   }

--   -- required to fix code action ranges
--   ts_utils.setup_client(client)

--   -- TODO: keymap these?
--   -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>", {silent = true})
--   -- vim.api.nvim_buf_set_keymap(bufnr, "n", "qq", ":TSLspFixCurrent<CR>", {silent = true})
--   -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", ":TSLspRenameFile<CR>", {silent = true})
--   -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", ":TSLspImportAll<CR>", {silent = true})
-- end

--[[ " autoformat
autocmd BufWritePre *.js lua vim.lsp.buf.formatting_sync(nil, 100)
autocmd BufWritePre *.jsx lua vim.lsp.buf.formatting_sync(nil, 100)
autocmd BufWritePre *.lua lua vim.lsp.buf.formatting_sync(nil, 100) ]]
-- Java
-- autocmd FileType java nnoremap ca <Cmd>lua require('jdtls').code_action()<CR>
return lsp
