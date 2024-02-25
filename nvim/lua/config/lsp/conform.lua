local prettier = { { 'prettierd', 'prettier' } } -- Use a sub-list to run only the first available formatter

return {
  'stevearc/conform.nvim',
  lazy = true,
  enabled = true,
  cmd = { 'ConformInfo', 'Format', 'FormatSync' },
  module = 'conform',
  event = 'BufWritePre',
  keys = {
    {
      '<leader>fs',
      function()
        require('conform').format({ async = true, lsp_fallback = true })
      end,
      mode = '',
      desc = 'Lsp: format and save',
    },
  },
  opts = {
    formatters_by_ft = {
      -- Scripting
      lua = { 'stylua' },
      bash = { 'shfmt' },
      sh = { 'shfmt' },

      -- Webdev
      javascript = prettier,
      typescript = prettier,
      javascriptreact = prettier,
      typescriptreact = prettier,
      html = prettier,
      css = prettier,
      json = prettier,
      jsonc = prettier,

      ['_'] = { 'trim_whitespace' }, -- "_" filetypes that don't have other formatters configured.
    },
    format_on_save = function(_) -- bufnr
      -- Disable with a global or buffer-local variable
      -- if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      if not state.file.auto_format then
        return
      end
      return { lsp_fallback = true }
    end,
    -- formatters = {
    --   shfmt = {
    --     prepend_args = { '-i', '2' },
    --   },
    -- },
  },
  config = function(_, opts)
    require('conform').setup(opts)

    -- Format command
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

    command('Format', function(args)
      require('conform').format({
        async = true,
        lsp_fallback = true,
        range = get_visulal_range(args),
      }, save_cb)
    end, { range = true })
    command('FormatSync', function(args)
      require('conform').format({
        async = false,
        lsp_fallback = true,
        range = get_visulal_range(args),
      }, save_cb)
    end, { range = true })

    -- Format with gq key
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
