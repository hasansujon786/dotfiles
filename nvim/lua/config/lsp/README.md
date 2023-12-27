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
```
