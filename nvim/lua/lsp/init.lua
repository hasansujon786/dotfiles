local M = {}

local borderStyle = 'rounded' -- none, single, double, shadow

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = borderStyle })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = borderStyle })

if vim.fn.has "nvim-0.6.0" == 1  then
  vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = true,
    severity_sort = true,
    float = {
      focusable = false,
      close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
      border = borderStyle,
      source = 'always',  -- show source in diagnostic popup window
      -- prefix = ' '
    }
  })

  local signs = { Error = '', Warn = '', Hint = '', Info = '' }
  for type, _ in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, {
      text = '', -- disable diagnostic icon for gitsign
      texthl = hl,
      numhl = hl,
    })
  end
else
  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = true,
  })
  local signs = { Error = '', Warning = '', Hint = '', Information = '' }
  for type, _ in pairs(signs) do
    local hl = 'LspDiagnosticsSign' .. type
    vim.fn.sign_define(hl, { text = '', texthl = hl, numhl = hl })
  end
  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    signs = false,
    underline = true,
    update_in_insert = true,
  })
end

local function lsp_document_highlight(client)
  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
    augroup lsp_document_highlight
      autocmd! * <buffer>
      autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
      autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
      ]], false)
  end
end

-- buf_set_keymap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
-- buf_set_keymap('n', '<C-space>', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
local function lsp_buffer_keymaps(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=false }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gY', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', 'gI', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gp', '<cmd>lua require"lsp.peek".Peek("definition")<CR>', opts)

  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<F2>', '<cmd>lua require("lsp.util").rename_with_quickfix()<CR>', opts)
  buf_set_keymap('n', '<C-q>', '<cmd>lua require("telescope.builtin").lsp_code_actions(require("telescope.themes").get_cursor())<CR>', opts)
  buf_set_keymap('n', '<C-space>', '<cmd>lua require("telescope.builtin").lsp_code_actions(require("telescope.themes").get_cursor())<CR>', opts)
  buf_set_keymap('v', '<C-q>', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
  buf_set_keymap('v', '<C-space>', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
  buf_set_keymap('n', '<C-LeftMouse>', '<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>', opts)
  if filetype ~= 'lua' and filetype ~= 'vim' then
    buf_set_keymap('n', '<F9>', '<cmd>lua vim.lsp.buf.formatting_sync()<CR><cmd>update<CR>', opts)
  end

  buf_set_keymap('n', '<leader>fs', '<cmd>lua vim.lsp.buf.formatting_sync()<CR><cmd>update<CR>', opts)
  buf_set_keymap('n', '<leader>a+', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>a-', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>a?', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<leader>ah', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>ad', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<leader>.',  '<cmd>lua require("telescope.builtin").lsp_document_symbols()<CR>', opts)

  if vim.fn.has "nvim-0.6.0" == 1  then
    buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<leader>al', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  else
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev({popup_opts = {border = "double"}})<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next({popup_opts = {border = "double"}})<CR>', opts)
    buf_set_keymap('n', '<leader>al', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({show_header=false,border="double"})<CR>', opts)
  end
end

local function lsp_tsserver_config(client, bufnr)
  -- disable tsserver formatting if you plan on formatting via null-ls
  client.resolved_capabilities.document_formatting = false
  client.resolved_capabilities.document_range_formatting = false

  local ts_utils = require('nvim-lsp-ts-utils')

  -- defaults
  ts_utils.setup {
    debug = false,
    disable_commands = false,
    enable_import_on_completion = true,

    -- import all
    import_all_timeout = 5000, -- ms
    import_all_priorities = {
      buffers = 4, -- loaded buffer names
      buffer_content = 3, -- loaded buffer content
      local_files = 2, -- git files or files with relative path markers
      same_file = 1, -- add to existing import statement
    },
    import_all_scan_buffers = 100,
    import_all_select_source = false,

    -- eslint
    eslint_enable_code_actions = true,
    eslint_enable_disable_comments = true,
    eslint_bin = 'eslint',
    eslint_enable_diagnostics = false,
    eslint_opts = {},

    -- formatting
    enable_formatting = true,
    formatter = 'prettier',
    formatter_opts = {},

    -- update imports on file move
    update_imports_on_move = false,
    require_confirmation_on_move = false,
    watch_dir = nil,

    -- filter diagnostics
    filter_out_diagnostics_by_severity = {},
    filter_out_diagnostics_by_code = {},
  }

  -- required to fix code action ranges and filter diagnostics
  ts_utils.setup_client(client)
  vim.cmd('command! -buffer Formatting lua vim.lsp.buf.formatting()')
  vim.cmd('command! -buffer FormattingSync lua vim.lsp.buf.formatting_sync()')
  -- format on save
  -- vim.cmd('autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()')
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
M.on_attach = function(client, bufnr)
  lsp_document_highlight(client)
  lsp_buffer_keymaps(client, bufnr)

  if client.name == 'tsserver' then
    lsp_tsserver_config(client, bufnr)
  end
  -- lunarvim
  -- vim.cmd 'command! -nargs=0 LspVirtualTextToggle lua require('lsp/virtual_text').toggle()'
end

return M
