local nx, nxo = { 'n', 'x' }, { 'n', 'x', 'o' }

return {
  -- require("hasan.neo_glance")
  {
    'max397574/better-escape.nvim',
    lazy = true,
    event = { 'InsertEnter', 'CmdlineEnter' },
    opts = {
      timeout = 350, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
      mappings = {
        i = { j = { k = '<Esc>', j = false } },
        c = { j = { k = '<Esc>', j = false } },
        s = { j = { k = '<Esc>' } },
        t = { j = { k = false } },
        v = { j = { k = false } },
      },
    },
  },
  {
    'sphamba/smear-cursor.nvim',
    event = 'CursorMoved',
    commit = '7d96674ee3466083ab3f9ef82281ee59fee5d991',
    enabled = true,
    opts = {
      smear_insert_mode = false,
      smear_to_cmd = true,
      normal_bg = '#242B38',
      smear_between_buffers = true,
      -- --                                 Default  Range
      -- stiffness = 0.8, --                0.6      [0, 1]
      -- trailing_stiffness = 0.5, --       0.3      [0, 1]
      -- distance_stop_animating = 0.1, --  0.1      > 0
      -- hide_target_hack = true, --        true     boolean
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
  -- {
  --   'skardyy/neo-img',
  --   lazy = true,
  --   cmd = { 'NeoImgShow' },
  --   -- build = 'cd ttyimg && go build', -- build ttyimg
  --   opts = {
  --     auto_open = false,
  --     oil_preview = false,
  --     backend = 'auto', -- auto detect: kitty / iterm / sixel
  --     size = { main = { x = 800, y = 800 } },
  --     offset = { main = { x = 10, y = 3 } },
  --     resizeMode = 'Fit', -- Fit / Strech / Crop
  --   },
  -- },
  -- { 'mbbill/undotree' },
  -- {
  --   'wolfwfr/vimatrix.nvim',
  --   cmd = { 'VimatrixOpen' },
  --   opts = {
  --     window = {
  --       general = {
  --         background = '#111111',
  --         blend = 0,
  --       },
  --     },
  --   },
  -- },
}
