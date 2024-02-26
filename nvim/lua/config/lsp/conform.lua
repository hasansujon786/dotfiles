local function save_cb(err)
  if err then
    return
  end
  vim.cmd.write()
end

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
        require('conform').format({ async = true, lsp_fallback = true }, save_cb)
      end,
      mode = '',
      desc = 'Lsp: format and save',
    },
  },
  opts = {
    formatters_by_ft = {
      {
        filetype = {
          'javascript',
          'javascriptreact',
          'typescript',
          'typescriptreact',
          'vue',
          'css',
          'scss',
          'less',
          'html',
          'json',
          'jsonc',
          'yaml',
          'markdown',
          'markdown.mdx',
          'graphql',
          'handlebars',
        },
        formatter = { { 'prettierd', 'prettier' } }, -- Use a sub-list to run only the first available formatter
      },
      {
        filetype = 'lua',
        formatter = { 'stylua' },
      },
      {
        filetype = { 'bash', 'sh' },
        formatter = { 'shfmt' },
      },
      {
        filetype = '_', -- "_" filetypes that don't have other formatters configured.
        formatter = { 'trim_whitespace' },
      },
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
    -- Format command
    local function get_visual_range(args)
      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        return {
          start = { args.line1, 0 },
          ['end'] = { args.line2, end_line:len() },
        }
      end
      return nil
    end
    local function get_formatter_list(formatters_by_ft)
      local formatters_by_ft_mod = {}
      for _, item in ipairs(formatters_by_ft) do
        if type(item.filetype) == 'string' then
          formatters_by_ft_mod[item.filetype] = item.formatter
        else
          for _, ft in ipairs(item.filetype) do
            formatters_by_ft_mod[ft] = item.formatter
          end
        end
      end
      return formatters_by_ft_mod
    end

    command('Format', function(args)
      require('conform').format({
        async = true,
        lsp_fallback = true,
        range = get_visual_range(args),
      }, save_cb)
    end, { range = true })
    command('FormatSync', function(args)
      require('conform').format({
        async = false,
        lsp_fallback = true,
        range = get_visual_range(args),
      }, save_cb)
    end, { range = true })

    opts.formatters_by_ft = get_formatter_list(opts.formatters_by_ft)
    require('conform').setup(opts)
    -- Format with gq key
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
