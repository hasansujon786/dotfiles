local nx, nxo = { 'n', 'x' }, { 'n', 'x', 'o' }

return {
  {
    'max397574/better-escape.nvim',
    lazy = true,
    event = { 'InsertEnter', 'CmdlineEnter' },
    opts = {
      timeout = 350, -- The time in which the keys must be hit in ms. Use option timeoutlen by default
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
    event = 'VeryLazy',
    commit = '1a3df9a', --  4a0f7ac, ac5c4a8
    enabled = true,
    opts = {
      smear_insert_mode = false,
      smear_to_cmd = true,
      normal_bg = '#242B38',
      smear_between_buffers = true,

      stiffness = 0.8,
      trailing_stiffness = 0.6,
      -- trailing_exponent = 0.8,
      damping = 0.8,
      distance_stop_animating = 0.5,
      never_draw_over_target = true,
      hide_target_hack = true,
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
  { 'mbbill/undotree', keys = { { '<leader>ou', '<cmd>UndotreeToggle<cr>' } } },
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
