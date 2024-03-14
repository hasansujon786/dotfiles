local nx, nxo = { 'n', 'x' }, { 'n', 'x', 'o' }
return {
  { 'folke/neodev.nvim', lazy = true, ft = { 'lua' } },
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
      { 'gB', '<Plug>(open-url-browser)', desc = 'Url: Open on browser', mode = nx },
      { 'gG', '<Plug>(open-url-search-google)', desc = 'Url: Search on Google', mode = nx },
    },
    cmd = 'OpenURL',
    init = function()
      vim.g.open_url_default_mappings = 0
    end,
  },
  {
    'mg979/vim-visual-multi',
    keys = {
      { 'gb', '<Plug>(VM-Find-Under)', desc = 'VM: Select under cursor', mode = 'n' },
      { 'gb', '<Plug>(VM-Find-Subword-Under)', desc = 'VM: Select under cursor', mode = 'x' },
      { 'g<cr>', '<Plug>(VM-Select-All)', desc = 'VM: Select under cursor', mode = 'n' },
      { 'g<cr>', '<Plug>(VM-Visual-All)', desc = 'VM: Select under cursor', mode = 'x' },
      { '<leader>n', mode = nx },
      { '<C-n>', mode = nx },
      { '<C-up>', mode = nx },
      { '<C-down>', mode = nx },
    },
    init = function()
      vim.g.VM_leader = '<leader>n'
      vim.g.VM_theme = ''
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
    'jinh0/eyeliner.nvim',
    keys = { { 'f', mode = nxo }, { 'F', mode = nxo }, { 't', mode = nxo }, { 'T', mode = nxo } },
    opts = {
      dim = false,
      highlight_on_key = true,
    },
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
  {
    'max397574/better-escape.nvim',
    lazy = true,
    event = 'InsertEnter',
    opts = {
      mapping = { 'jk' }, -- a table with mappings to use
      timeout = 350, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
    },
  },
  {
    'hasansujon786/neo-glance.nvim_local',
    dev = true,
    config = function()
      keymap('n', '<leader>e', function()
        vim.cmd.wa()
        vim.defer_fn(function()
          R('neo_glance.lsp')
          R('neo_glance.ui')
          R('neo_glance.ui.list')
          local glance = R('neo_glance')
          -- peep:setup()
          glance:open()
          -- require('peep.lsp').references()
        end, 50)
      end, { desc = 'Open neo-glance' })
    end,
    -- dir = 'E:/repoes/lua/peep.nvim',
  },
}
