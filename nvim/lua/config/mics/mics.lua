local nx, nxo = { 'n', 'x' }, { 'n', 'x', 'o' }

return {
  -- require("hasan.neo_glance")
  {
    'jinh0/eyeliner.nvim',
    keys = { { 'f', mode = nxo }, { 'F', mode = nxo }, { 't', mode = nxo }, { 'T', mode = nxo } },
    opts = {
      dim = false,
      highlight_on_key = true,
    },
  },
  {
    'max397574/better-escape.nvim',
    lazy = true,
    event = { 'InsertEnter', 'CmdlineEnter' },
    opts = {
      timeout = 350, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
      mappings = {
        i = { j = { k = '<Esc>', j = false } },
        c = { j = { k = '<Esc>', j = false } },
        t = { j = { k = '<Esc>', j = false } },
        s = { j = { k = '<Esc>' } },
        v = { j = { k = false } },
      },
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
  { 'MunifTanjim/nui.nvim', lazy = true, module = 'nui' },
  { 'nvim-lua/plenary.nvim', lazy = true, module = 'plenary' },
  { 'tpope/vim-repeat', lazy = true, event = 'BufReadPost', dependencies = 'tpope/vim-surround' },
  { 'dhruvasagar/vim-table-mode', cmd = { 'TableModeToggle', 'TableModeEnable', 'TableModeRealign' } },
  -- { 'tpope/vim-eunuch', lazy = true, cmd = { 'Delete', 'Move', 'Rename', 'Mkdir', 'Chmod' } },
}
