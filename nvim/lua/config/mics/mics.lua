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
  {
    'nvim-mini/mini.ai',
    version = false,
    config = function()
      local function ai_buffer(ai_type)
        local start_line, end_line = 1, vim.fn.line('$')
        if ai_type == 'i' then
          -- Skip first and last blank lines for `i` textobject
          local first_nonblank, last_nonblank = vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
          -- Do nothing for buffer with all blanks
          if first_nonblank == 0 or last_nonblank == 0 then
            return { from = { line = start_line, col = 1 } }
          end
          start_line, end_line = first_nonblank, last_nonblank
        end

        local to_col = math.max(vim.fn.getline(end_line):len(), 1)
        return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
      end
      -- local spec_treesitter = require('mini.ai').gen_spec.treesitter
      -- vim.b.miniai_config = {
      --   custom_textobjects = {
      --     t = spec_treesitter({ a = '@function.outer', i = '@function.inner' }),
      --   },
      -- }

      -- NOTE: with default config, built-in LSP mappings |v_an| and |v_in| on Neovim>=0.12
      -- are overridden. Either use different `around_next` / `inside_next` keys or
      -- map manually using |vim.lsp.buf.selection_range()|. For example: >lua
      --
      --   local map_lsp_selection = function(lhs, desc)
      --     local s = vim.startswith(desc, 'Increase') and 1 or -1
      --     local rhs = function() vim.lsp.buf.selection_range(s * vim.v.count1) end
      --     vim.keymap.set('x', lhs, rhs, { desc = desc })
      --   end
      --   map_lsp_selection('<Leader>ls', 'Increase selection')
      --   map_lsp_selection('<Leader>lS', 'Decrease selection')

      local gen_spec = require('mini.ai').gen_spec
      require('mini.ai').setup({
        n_lines = 500,
        custom_textobjects = {
          o = gen_spec.treesitter({ -- code block
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
          }),
          f = gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
          c = gen_spec.function_call(),
          C = gen_spec.function_call({ name_pattern = '[%w_]' }), -- Without dot in function name
          m = gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }),
          ['='] = gen_spec.treesitter({ a = '@attribute.outer', i = '@attribute.inner' }),
          P = gen_spec.treesitter({ a = '@_pair.outer', i = '@_pair.inner' }),

          -- ['*'] = gen_spec.pair('*', '*', { type = 'greedy' }),
          -- ['_'] = gen_spec.pair('_', '_', { type = 'greedy' }),

          t = false,
          -- t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- tags
          r = { { '%b[]' }, '^.().*().$' },
          k = { { '^().*()$' }, { '^%s*().-()%s*$', '^().*()$' } },
          d = { '%f[%d]%d+' }, -- digits
          e = { -- Word with case
            { '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]' },
            '^().*()$',
          },
          g = ai_buffer, -- buffer
        },
      })
    end,
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
