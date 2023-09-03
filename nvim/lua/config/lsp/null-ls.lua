-- local conditions = {
--   eslint_d = function(utils)
--     return utils.root_has_file(
--       '.eslintrc',
--       '.eslintrc.js',
--       '.eslintrc.cjs',
--       '.eslintrc.yaml',
--       '.eslintrc.yml',
--       '.eslintrc.json'
--     )
--   end,
-- }

return {
  'jose-elias-alvarez/null-ls.nvim',
  lazy = true,
  module = 'null-ls',
  config = function()
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

      -- b.diagnostics.todo_comments

      -- b.code_actions.eslint, -- eslint or eslint_d
      -- b.diagnostics.eslint, -- eslint or eslint_d
      -- b.diagnostics.eslint.with({
      --   -- prefer_local = "node_modules/.bin",
      --   only_local = 'node_modules/.bin',
      -- }),
      -- buffer keybind => https://github.com/mantoni/eslint_d.js/
      -- b.code_actions.eslint_d.with({ condition = conditions.eslint_d, only_local = 'node_modules/.bin' }),
      -- b.diagnostics.eslint_d.with({ condition = conditions.eslint_d, only_local = 'node_modules/.bin' }),
    }
    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
    local function on_attach(client, bufnr)
      if client.supports_method('textDocument/formatting') then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd('BufWritePre', {
          group = augroup,
          buffer = bufnr,
          callback = function()
            if not state.file.auto_format then
              return
            end
            vim.lsp.buf.format({ bufnr = bufnr })
          end,
        })
      end
    end

    null_ls.setup({ border = 'rounded', sources = sources, on_attach = on_attach, diagnostics_format = '#{m} (#{s})' })
  end,
}
