return {
  'nvimtools/none-ls.nvim',
  lazy = true,
  module = 'null-ls',
  enabled = true,
  config = function()
    local null_ls = require('null-ls')
    local b = null_ls.builtins -- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/MAIN.md
    local eslint_d = {
      condition = function(utils)
        return utils.root_has_file({ '.eslintrc.js', '.eslintrc.json' })
      end,
    }
    local sources = {
      b.formatting.stylua,

      -- b.diagnostics.todo_comments

      b.formatting.prettierd,
      b.diagnostics.eslint_d.with(eslint_d),
      b.code_actions.eslint_d.with(eslint_d),
      b.formatting.eslint_d.with(eslint_d),
    }

    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
    null_ls.setup({
      border = 'rounded',
      sources = sources,
      on_attach = function(client, bufnr)
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
      end,
      diagnostics_format = '#{m} (#{s})',
    })
  end,
}
