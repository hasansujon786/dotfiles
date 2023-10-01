return {
  'stevearc/conform.nvim',
  lazy = true,
  enabled = true,
  cmd = 'ConformInfo',
  module = 'conform',
  event = 'BufWritePre',
  config = function()
    local prettier = { { 'prettierd', 'prettier' } } -- Use a sub-list to run only the first available formatter

    require('conform').setup({
      formatters_by_ft = {

        lua = { 'stylua' },

        javascript = prettier,
        typescript = prettier,
        javascriptreact = prettier,
        typescriptreact = prettier,
        html = prettier,
        css = prettier,
        json = prettier,
        jsonc = prettier,

        ['_'] = { 'trim_whitespace' },
      },
      format_on_save = function(_) -- bufnr
        -- Disable with a global or buffer-local variable
        -- if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        if not state.file.auto_format then
          return
        end
        return { timeout_ms = 500, lsp_fallback = true }
      end,
    })

    -- Format command
    vim.api.nvim_create_user_command('Format', function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = { args.line1, 0 },
          ['end'] = { args.line2, end_line:len() },
        }
      end
      require('conform').format({ async = true, lsp_fallback = true, range = range })
    end, { range = true })

    -- Format with gq key
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
