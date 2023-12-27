local prettier = { { 'prettierd', 'prettier' } } -- Use a sub-list to run only the first available formatter

return {
  'stevearc/conform.nvim',
  lazy = true,
  enabled = false,
  cmd = { 'ConformInfo', 'FormatBuf', 'FormatBufSync' },
  module = 'conform',
  event = 'BufWritePre',
  opts = {
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
  },
  config = function(_, opts)
    -- keymap('n', '<leader>fs', '<cmd>FormatBuf<CR>', desc('Lsp: format and save'))
    -- keymap('x', '<leader>fs', 'gq<cmd>silent noa write<cr>', desc('Lsp: format current selection'))

    require('conform').setup(opts)
    -- utils
    local function get_visulal_range(args)
      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        return {
          start = { args.line1, 0 },
          ['end'] = { args.line2, end_line:len() },
        }
      end

      return nil
    end
    local function save_cb(err)
      if err then
        return
      end
      vim.cmd.write()
    end

    -- Format command
    command('FormatBuf', function(args)
      local opt = {
        async = true,
        lsp_fallback = true,
        range = get_visulal_range(args),
      }
      require('conform').format(opt, save_cb)
    end, { range = true })
    command('FormatBufSync', function(args)
      local opt = {
        async = false,
        timeout_ms = 500,
        lsp_fallback = true,
        range = get_visulal_range(args),
      }
      require('conform').format(opt, save_cb)
    end, { range = true })

    -- Format with gq key
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
