return {
  'nvimtools/none-ls.nvim',
  lazy = true,
  module = 'null-ls',
  enabled = false,
  config = function()
    local null_ls = require('null-ls')
    local b = null_ls.builtins -- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/MAIN.md
    local sources = {
      --  lua & bash scripting
      b.formatting.stylua,
      b.formatting.shfmt,
      -- https://github.com/gbprod/none-ls-shellcheck.nvim

      -- b.diagnostics.todo_comments

      -- Front-end
      b.formatting.prettierd,
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
