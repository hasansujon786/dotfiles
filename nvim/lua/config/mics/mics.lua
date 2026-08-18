local nx, nxo = { 'n', 'x' }, { 'n', 'x', 'o' }

return {
  {
    'rachartier/tiny-inline-diagnostic.nvim',
    event = 'VeryLazy',
    priority = 1000,
    config = function()
      require('tiny-inline-diagnostic').setup({
        -- Available: "modern", "classic", "minimal", "powerline", "ghost", "simple", "nonerdfont", "amongus"
        preset = 'powerline',
        hi = {
          error = 'DiagnosticError', -- Highlight for error diagnostics
          warn = 'DiagnosticWarn', -- Highlight for warning diagnostics
          info = 'DiagnosticInfo', -- Highlight for info diagnostics
          hint = 'DiagnosticHint', -- Highlight for hint diagnostics
          arrow = 'NonText', -- Highlight for the arrow pointing to diagnostic
          background = 'CursorLine', -- Background highlight for diagnostics
          mixing_color = 'Normal', -- Color to blend background with (or "None")
        },
        options = {
          -- Only show diagnostics when the cursor is directly over them, no fallback to line diagnostics
          -- show_diags_only_under_cursor = true,
          add_messages = {
            display_count = true,
          },
          multilines = {
            enabled = true,
            always_show = true,
            severity = {
              vim.diagnostic.severity.ERROR,
              vim.diagnostic.severity.WARN,
              -- vim.diagnostic.severity.INFO,
              -- vim.diagnostic.severity.HINT,
            },
          },
        },
      })
    end,
  },
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
    -- commit = '1a3df9a', --  4a0f7ac, ac5c4a8
    enabled = true,
    opts = {
      smear_insert_mode = false,
      smear_to_cmd = true,
      normal_bg = '#242B38',
      smear_between_buffers = true,
      never_draw_over_target = true,
      hide_target_hack = true,
      --
      particles_enabled = false,
      particle_max_num = 200,
      -- particles_per_length = 2.0,
      stiffness = 0.8,
      trailing_stiffness = 0.4,
      trailing_exponent = 5,
      damping = 0.8,
      gradient_exponent = 0,
      --
      -- stiffness = 0.8,
      -- trailing_stiffness = 0.6,
      -- -- trailing_exponent = 0.8,
      -- damping = 0.8,
      -- distance_stop_animating = 0.5,
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
  {
    keys = {
      { 'Z', '<Plug>VSurround', mode = { 'x' } },
      { '.', ':norm.<cr>', desc = 'Repeat in visual selection', mode = { 'x' } },
    },
    'tpope/vim-repeat',
    lazy = true,
    event = 'BufReadPost',
    dependencies = { 'tpope/vim-sleuth', 'tpope/vim-surround' },
  },
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
  --   opts = { window = { general = { background = 'none', blend = 0 } } },
  -- },
}
