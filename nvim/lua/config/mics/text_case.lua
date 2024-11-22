local nx, nxo = { 'n', 'x' }, { 'n', 'x', 'o' }

return {
  'johmsalas/text-case.nvim',
  lazy = true,
  module = 'textcase',
  config = function()
    require('which-key').add({
      { 'ga', group = 'TextCase' },
      { 'ga.', '<cmd>TextCaseOpenTelescopeQuickChange<CR>', mode = nx, desc = 'Telescope Quick Change' },
      { 'ga,', '<cmd>TextCaseOpenTelescopeLSPChange<CR>', mode = nx, desc = 'Telescope LSP Change' },
      { 'ga,', '<cmd>TextCaseOpenTelescopeLSPChange<CR>', mode = nx, desc = 'Telescope LSP Change' },
    })
    require('textcase').setup({ default_keymappings_enabled = true })
  end,
  -- commit = 'ec9925b27dd54809653cc766b8673acd979a888e',
  keys = {
    {
      'ga',
      function()
        vim.cmd('Lazy load text-case.nvim')
        vim.defer_fn(function()
          vim.keymap.del(nx, 'ga')
          feedkeys('ga')
        end, 10)
      end,
      desc = 'TextCase',
      mode = nx,
    },
    {
      'gak',
      '<cmd>lua require("textcase").quick_replace("to_dash_case")<CR>',
      mode = nx,
      desc = 'Convert to-kabab-case',
    },
    {
      'gaK',
      '<cmd>lua require("textcase").lsp_rename("to_dash_case")<CR>',
      mode = nx,
      desc = 'LSP rename to-kabab-case',
    },
  },
  cmd = {
    'TextCaseOpenTelescope',
    'TextCaseOpenTelescopeQuickChange',
    'TextCaseOpenTelescopeLSPChange',
    'TextCaseStartReplacingCommand',
  },
}
