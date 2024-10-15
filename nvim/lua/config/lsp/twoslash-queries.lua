local attached_buf = {}

local function attach_on_current_buf()
  local bufnr = vim.api.nvim_get_current_buf()
  -- Exit if buffer is already attached
  for _, value in ipairs(attached_buf) do
    if value == bufnr then
      return true
    end
  end

  local ts_client = vim.lsp.get_clients({ bufnr = bufnr, name = 'ts_ls' })[1]
  if ts_client == nil then
    return false
  end

  local ok, twoslash_queries = pcall(require, 'twoslash-queries')
  if ok then
    twoslash_queries.attach(ts_client, bufnr)
    table.insert(attached_buf, bufnr)
    return true
  end
  return false
end

vim.api.nvim_create_user_command('TwoslashQueriesBufAttach', function()
  attach_on_current_buf()
end, { nargs = 0, desc = 'Attach two slash queries on current buffer' })

return {
  'marilari88/twoslash-queries.nvim',
  lazy = true,
  module = 'twoslash-queries',
  keys = {
    {
      '<leader>iT',
      function()
        local attached = attach_on_current_buf()
        if attached then
          vim.cmd([[TwoslashQueriesInspect]])
        end
      end,
      desc = 'Add Twoslash Queries',
    },
  },
  cmd = { 'TwoslashQueriesEnable', 'TwoslashQueriesInspect' },
  config = function()
    require('twoslash-queries').setup({ multi_line = false, is_enabled = true })

    vim.api.nvim_create_user_command('TwoslashQueriesMultiLineToggle', function()
      require('twoslash-queries').setup({ multi_line = not require('twoslash-queries').config.multi_line })
      vim.cmd([[doautocmd User EnableTwoslashQueries]])
    end, { nargs = 0, desc = 'Toggle multi line for two slash queries' })
  end,
}
