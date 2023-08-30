-- { 'mkropat/vim-tt', lazy = true, event = 'CursorHold', config = function() vim.g.tt_loaded = 1 end },
return {
  { 'nvim-lua/plenary.nvim', lazy = true, module = 'plenary' },
  { 'MunifTanjim/nui.nvim', lazy = true, module = 'nui' },
  { 'tpope/vim-eunuch', lazy = true, cmd = { 'Delete', 'Move', 'Rename', 'Mkdir', 'Chmod' } },
  {
    'olimorris/persisted.nvim',
    lazy = true,
    module = 'persisted',
    cmd = { 'SessionLoad', 'SessionLoadLast', 'SessionSave' },
    config = function()
      require('configs.module.persisted').setup()
    end,
  },
  {
    'tpope/vim-commentary',
    lazy = true,
    event = 'BufReadPost',
    dependencies = {
      'mg979/vim-visual-multi',
      'tpope/vim-surround',
      'tpope/vim-repeat',
      'mg979/vim-visual-multi',
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
          -- Repeat the last Sneak
          keymap({ 'n', 'x' }, 'gs', '<Plug>Sneak_s<CR>')
          keymap({ 'n', 'x' }, 'gS', '<Plug>Sneak_S<CR>')

          local function is_sneaking()
            return vim.fn['sneak#is_sneaking']() == 1
          end

          keymap({ 'n', 'x' }, ';', function()
            return is_sneaking() and '<Plug>Sneak_;' or ';'
          end, { expr = true })
          keymap({ 'n', 'x' }, ',', function()
            return is_sneaking() and '<Plug>Sneak_,' or ','
          end, { expr = true })
        end,
      },
    },
  },
}
