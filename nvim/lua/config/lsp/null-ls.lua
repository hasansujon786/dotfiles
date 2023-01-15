-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/MAIN.md
local null_ls = require('null-ls')
local b = null_ls.builtins
local sources = {
  -- b.formatting.prettier,
  b.formatting.prettierd,
  b.formatting.stylua,
  -- b.formatting.stylua.with({
  --   extra_args = { '--indent-type', 'Spaces', '--indent-width', '2', '--quote-style', 'AutoPreferSingle' },
  -- }),
  -- b.code_actions.eslint, -- eslint or eslint_d
  -- b.diagnostics.eslint, -- eslint or eslint_d

  -- b.diagnostics.eslint.with({
  --   only_local = "node_modules/.bin",
  --   -- prefer_local = "node_modules/.bin",
  --   condition = function(utils)
  --     return utils.root_has_file(".eslintrc.js")
  --   end,
  -- }),
  -- b.diagnostics.todo_comments
}
local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
local on_attach = function(client, bufnr)
  if client.supports_method('textDocument/formatting') then
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = augroup,
      buffer = bufnr,
      callback = function()
        if not state.file.format_save then
          return
        end
        vim.lsp.buf.format({ bufnr = bufnr }) -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
      end,
    })
  end
end

null_ls.setup({ sources = sources, on_attach = on_attach })
