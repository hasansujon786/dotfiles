return {
  'lukas-reineke/indent-blankline.nvim',
  lazy = true,
  event = 'VeryLazy',
  -- init = function()
  --   -- vim.g.indent_blankline_show_first_indent_level = false

  --   -- vim.g.indent_blankline_char = '▏'
  --   -- vim.g.indent_blankline_show_current_context = false
  -- end,
  opts = {
    buftype_exclude = { 'terminal', 'prompt' },
    filetype_exclude = {
      'qf',
      'help',
      'neo-tree',
      'dashboard',
      'packer',
      'NvimTree',
      'Trouble',
      'WhichKey',
      'lsp-installer',
      'mason',
      'Outline',
      'alpha',
      'ccc-ui',
      '2048',
      'lazy',
      'noice',
      'NeogitPopup',
      'flutterToolsOutline',
      'neo-tree-popup',
    },
  },
  config = function(_, opts)
    require('indent_blankline').setup(opts)

    -- For wrapping mappings related to folding and horizontal shifting so that
    -- indent-blankline.nvim can update immediately. See:
    -- https://github.com/lukas-reineke/indent-blankline.nvim/issues/118
    local indent_wrap_mapping = function(mapping)
      if vim.g.loaded_indent_blankline == 1 then
        return mapping .. '<cmd>IndentBlanklineRefresh<CR>'
      else
        return mapping
      end
    end

    keymap('n', '0', indent_wrap_mapping('0'))
    keymap('n', 'zA', indent_wrap_mapping('zA'))
    keymap('n', 'zC', indent_wrap_mapping('zC'))
    keymap('n', 'zM', indent_wrap_mapping('zM'))
    keymap('n', 'z.', indent_wrap_mapping(':%foldclose<CR>'))
    keymap('n', 'zO', indent_wrap_mapping('zO'))
    keymap('n', 'zR', indent_wrap_mapping('zR'))
    keymap('n', 'zX', indent_wrap_mapping('zX'))
    keymap('n', 'za', indent_wrap_mapping('za'))
    keymap('n', 'zc', indent_wrap_mapping('zc'))
    keymap('n', 'zm', indent_wrap_mapping('zm'))
    keymap('n', 'zo', indent_wrap_mapping('zo'))
    keymap('n', 'zr', indent_wrap_mapping('zr'))
    keymap('n', 'zv', indent_wrap_mapping('zv'))
    keymap('n', 'zx', indent_wrap_mapping('zx'))
    keymap('n', '<<', indent_wrap_mapping('<<'))
    keymap('n', '>>', indent_wrap_mapping('>>'))
    keymap('n', '<Tab>', indent_wrap_mapping('za'))
    keymap('n', '<s-tab>', indent_wrap_mapping('zA'))
  end,
  dependencies = {
    -- { 'kevinhwang91/nvim-hlslens', config = function() require('config.hlslens') end },
    {
      'karb94/neoscroll.nvim',
      opts = {},
      config = function()
        require('neoscroll').setup()
        local map = {}
        local ease = 'circular'
        map['<C-u>'] = { 'scroll', { '-vim.wo.scroll', 'true', '80', ease } }
        map['<C-d>'] = { 'scroll', { 'vim.wo.scroll', 'true', '80', ease } }
        map['<C-f>'] = { 'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '250', ease } }
        map['<C-b>'] = { 'scroll', { '-vim.api.nvim_win_get_height(0)', 'true', '250', ease } }
        map['<C-y>'] = { 'scroll', { '-0.10', 'false', '30' } }
        map['<C-e>'] = { 'scroll', { '0.10', 'false', '30' } }
        map['zt'] = { 'zt', { '30' } }
        map['zz'] = { 'zz', { '150' } }
        map['zb'] = { 'zb', { '30' } }
        require('neoscroll.config').set_mappings(map)
      end,
    },
    {
      'chentoast/marks.nvim',
      opts = {
        mappings = {
          set = 'm',
          delete = 'm-', -- specific {key}
          delete_line = 'm--',
          delete_buf = 'dax',
          set_next = 'm,',
          toggle = 'm=',
          preview = 'm;',
          next = 'm]',
          prev = 'm[',

          -- set_bookmark0 = 'm0',
          -- delete_bookmark0 = 'dm0',
          -- next_bookmark = 'm}',
          -- prev_bookmark = 'm{',
          -- delete_bookmark = 'dm=',

          next_bookmark0 = "'0",
          prev_bookmark0 = "'0",
          next_bookmark1 = "'1",
          prev_bookmark1 = "'1",
          next_bookmark2 = "'2",
          prev_bookmark2 = "'2",
          next_bookmark3 = "'3",
          prev_bookmark3 = "'3",
          next_bookmark4 = "'4",
          prev_bookmark4 = "'4",
          next_bookmark5 = "'5",
          prev_bookmark5 = "'5",

          annotate = 'm<CR>',
        },
        default_mappings = true,
        -- builtin_marks = { ".", "<", ">", "^" }, -- which builtin marks to show. default {}
        cyclic = true,
        force_write_shada = true, -- whether the shada file is updated after modifying uppercase marks. default false
        refresh_interval = 250,
        sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
        -- disables mark tracking for specific filetypes. default {}
        excluded_filetypes = {},
        -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
        -- sign/virttext. Bookmarks can be used to group together positions and quickly move
        -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
        -- default virt_text is "".
        bookmark_0 = { sign = '' },
        bookmark_1 = { sign = '◉' },
        bookmark_2 = { sign = '○' },
        bookmark_3 = { sign = '✸' },
        bookmark_4 = { sign = '✿' },
        bookmark_5 = { sign = '♥' },
      },
    },
  },
}
