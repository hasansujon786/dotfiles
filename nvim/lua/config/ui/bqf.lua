return {
  'kevinhwang91/nvim-bqf',
  lazy = true,
  module = 'bqf',
  ft = { 'qf' }, -- event = 'FileType qf',
  opts = {
    preview = { winblend = 0 },
  },
  keys = {
    {
      'gw',
      function()
        require('hasan.utils.ui.qf').showLspReferencesInLocList()
      end,
      desc = 'Show LSP references in loclist',
    },
  },
  dependencies = {
    'stevearc/quicker.nvim',
    enabled = true,
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {
      -- Border characters
      borders = {
        vert = '│',
        strong_header = '─',
        strong_cross = '┼',
        strong_end = '┤',
        soft_header = '╌',
        soft_cross = '┼',
        soft_end = '┤',
      },
      type_icons = {
        E = ' ',
        W = ' ',
        I = ' ',
        N = '󰌵 ',
        H = '󰌵 ',
      },
      highlight = {
        treesitter = true,
        lsp = true, -- Use LSP semantic token highlighting
        load_buffers = false, -- Load the referenced buffers to apply more accurate highlights (may be slow)
      },
      keys = {
        {
          '>',
          function()
            require('quicker').expand({ before = 2, after = 2, add_to_existing = true })
          end,
          desc = 'Expand quickfix context',
        },
        {
          '<',
          function()
            require('quicker').collapse()
          end,
          desc = 'Collapse quickfix context',
        },
      },
    },
  },
}
