vim.api.nvim_create_user_command('DocGenerate', function(opts)
  R('scripts.minidoc')
  vim.cmd.checktime()
end, { nargs = 0, desc = 'DocGenerate' })

return {
  'echasnovski/mini.doc',
  -- 'hasansujon786/mini.doc',
  -- dev = true,
  lazy = true,
  opts = {},
  version = false,
}
