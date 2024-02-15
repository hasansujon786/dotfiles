local nx, nxo = { 'n', 'x' }, { 'n', 'x', 'o' }
return {
  'unblevable/quick-scope',
  enable = true,
  keys = { { 'f', mode = nxo }, { 'F', mode = nxo }, { 't', mode = nxo }, { 'T', mode = nxo } },
  init = function()
    vim.g.qs_highlight_on_keys = { 'f', 'F', 't', 'T' }
  end,
}

-- QuickScopePrimary   = { fg = 'tomato', underline = true },
-- QuickScopeSecondary = { fg = '#d78787', underline = true },
