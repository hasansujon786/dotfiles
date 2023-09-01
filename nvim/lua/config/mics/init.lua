-- { 'mkropat/vim-tt', lazy = true, event = 'CursorHold', config = function() vim.g.tt_loaded = 1 end },
return {
  { 'nvim-lua/plenary.nvim', lazy = true, module = 'plenary' },
  { 'MunifTanjim/nui.nvim', lazy = true, module = 'nui' },
  { 'tpope/vim-eunuch', lazy = true, cmd = { 'Delete', 'Move', 'Rename', 'Mkdir', 'Chmod' } },
  {
    'tpope/vim-commentary',
    lazy = true,
    event = 'CursorHold',
    dependencies = {
      'mg979/vim-visual-multi',
      'tpope/vim-surround',
      'tpope/vim-repeat',
      'arthurxavierx/vim-caser',
      'NTBBloodbath/color-converter.nvim',
      'unblevable/quick-scope',
      { 'dhruvasagar/vim-open-url', cmd = 'OpenURL' },
      {
        'Konfekt/vim-CtrlXA',
        config = function()
          vim.fn['hasan#CtrlXA#update']()
        end,
      },
      {
        'justinmk/vim-sneak',
        config = function()
          require('config.mics.sneak')
        end,
      },
    },
  },
}
