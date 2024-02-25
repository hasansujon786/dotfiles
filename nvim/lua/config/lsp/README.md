## null-ls

```lua
local null_condition = {
  eslint_d = function(utils)
    return utils.root_has_file(
      '.eslintrc',
      '.eslintrc.js',
      '.eslintrc.cjs',
      '.eslintrc.yaml',
      '.eslintrc.yml',
      '.eslintrc.json'
    )
  end,
}

b.formatting.stylua.with({
  extra_args = { '--indent-type', 'Spaces', '--indent-width', '2', '--quote-style', 'AutoPreferSingle' },
}),

-- Format
keymap({ 'n', 'x' }, '<leader>fs', '<cmd>lua vim.lsp.buf.format()<CR><cmd>w<CR>', desc('Lsp: format and save'))
command('Format', function(_)
  vim.lsp.buf.format({ async = true })
end)
command('FormatSync', function()
  vim.lsp.buf.format({ async = false })
end)

```
