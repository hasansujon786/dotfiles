local nx, nxo = { 'n', 'x' }, { 'n', 'x', 'o' }
return {
  { 'nvim-lua/plenary.nvim', lazy = true, module = 'plenary' },
  { 'MunifTanjim/nui.nvim', lazy = true, module = 'nui' },
  { 'tpope/vim-eunuch', lazy = true, cmd = { 'Delete', 'Move', 'Rename', 'Mkdir', 'Chmod' } },
  {
    'tpope/vim-repeat',
    lazy = true,
    event = 'BufReadPost',
    dependencies = 'tpope/vim-surround',
  },
  {
    'tpope/vim-commentary',
    keys = { { 'gc', desc = 'Commentary', mode = nxo } },
  },
  {
    'dhruvasagar/vim-open-url',
    keys = {
      { 'gB', desc = 'Url: Open on browser', mode = nx },
      { 'g<CR>', desc = 'Url: Search on Dukdukgo', mode = nx },
      { 'gG', desc = 'Url: Search on Google', mode = nx },
    },
    cmd = 'OpenURL',
  },
  {
    'mg979/vim-visual-multi',
    keys = {
      { 'gb', '<Plug>(VM-Find-Under)', desc = 'VM: Select under cursor', mode = 'n' },
      { 'gb', '<Plug>(VM-Find-Subword-Under)', desc = 'VM: Select under cursor', mode = 'x' },
      { '<leader>n', mode = nx },
      { '<C-n>', mode = nx },
      { '<C-up>', mode = nx },
      { '<C-down>', mode = nx },
    },
    init = function()
      vim.g.VM_leader = '<leader>n'
      vim.g.VM_theme_set_by_colorscheme = 0
      vim.g.VM_maps = {
        -- ['Slash Search'] = 'gM',
        ['I BS'] = '<C-h>',
      }
    end,
    config = function()
      augroup('MY_VM')(function(autocmd)
        autocmd('User', function()
          vim.api.nvim_set_hl(0, 'CurSearch', { link = 'None' })
        end, { pattern = 'visual_multi_start' })
        autocmd('User', function()
          vim.api.nvim_set_hl(0, 'CurSearch', { link = 'IncSearch' })
        end, { pattern = 'visual_multi_exit' })
      end)
    end,
  },
  {
    'arthurxavierx/vim-caser',
    keys = { { '<leader>cs', desc = 'vim-caser', mode = nx } },
    init = function()
      vim.g.caser_prefix = '<leader>cs'
    end,
  },
  {
    'unblevable/quick-scope',
    keys = { { 'f', mode = nxo }, { 'F', mode = nxo }, { 't', mode = nxo }, { 'T', mode = nxo } },
    init = function()
      vim.g.qs_highlight_on_keys = { 'f', 'F', 't', 'T' }
    end,
  },
  {
    'Konfekt/vim-CtrlXA',
    lazy = true,
    keys = {
      { '<C-a>', desc = 'Increment number and more' },
      { '<C-x>', desc = 'Decrement number and more' },
    },
    config = function()
      vim.fn['hasan#CtrlXA#update']()
    end,
  },
  {
    'Wansmer/treesj',
    opts = {
      use_default_keymaps = false,
      max_join_length = 1000,
      -- langs = {},
      dot_repeat = true,
    },
    keys = {
      { '<leader>fm', '<cmd>TSJToggle<CR>', desc = 'TreeSJ: Toggle' },
      { '<leader>fj', '<cmd>TSJSplit<CR>', desc = 'TreeSJ: Split' },
      { '<leader>fJ', '<cmd>TSJJoin<CR>', desc = 'TreeSJ: Join' },
    },
  },
}
