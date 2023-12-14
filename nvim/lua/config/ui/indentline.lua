return {
  'lukas-reineke/indent-blankline.nvim',
  lazy = true,
  event = 'BufReadPost', -- V2: 9637670896b68805430e2f72cf5d16be5b97a22a
  main = 'ibl',
  opts = {
    indent = {
      char = '│',
      smart_indent_cap = true,
      -- highlight = '',
    },
    scope = {
      enabled = false,
      show_start = false,
      show_exact_scope = false,
    },
    exclude = {
      filetypes = {
        'Glance',
        'qf',
        'help',
        'neo-tree',
        'dashboard',
        'packer',
        'NvimTree',
        'Trouble',
        'WhichKey',
        'lsp-installer',
        'lspinfo',
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
      -- buftypes = { },
    },
  },
  -- config = function(_, opts)
  --   require('ibl').setup(opts)
  -- end,
}
