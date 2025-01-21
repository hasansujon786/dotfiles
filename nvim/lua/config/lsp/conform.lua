local function save_cb(err)
  if err then
    return
  end
  vim.cmd.write()
end
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

---My Custom formatters_by_ft api
---@param formatters_by_ft table
---@return table
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

return {
  'stevearc/conform.nvim',
  lazy = true,
  enabled = true,
  cmd = { 'ConformInfo', 'Format', 'FormatSync' },
  module = 'conform',
  event = 'BufWritePre',
  keys = {
    { '<leader>fs', '<cmd>Format<CR>', mode = '', desc = 'Lsp: format and save' },
  },
  opts = {
    default_format_opts = {
      lsp_format = 'fallback',
    },
    -- formatters_by_ft = {},
    -- format_on_save = function(_) -- bufnr
    --   -- Disable with a global or buffer-local variable
    --   -- if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
    --   if not state.file.auto_format then
    --     return
    --   end
    --   return { lsp_format = 'fallback' }
    -- end,
    -- formatters = { shfmt = { prepend_args = { '-i', '2' } } },
  },
  config = function(_, opts)
    opts.formatters_by_ft = get_formatter_list(require('core.state').lsp.formatters_by_ft)
    require('conform').setup(opts)

    command('Format', function(args)
      require('conform').format({ async = true, range = get_visual_range(args) }, save_cb)
    end, { range = true })
    command('FormatSync', function(args)
      require('conform').format({ async = false, range = get_visual_range(args) }, save_cb)
    end, { range = true })
    -- Format with gq key
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
