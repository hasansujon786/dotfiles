return {
  'stevearc/quicker.nvim',
  enabled = true,
  event = 'FileType qf',
  ---@module "quicker"
  opts = {
    ---@type quicker.SetupOptions
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
      E = 'E',
      W = 'W',
      I = 'I',
      N = 'N',
      H = 'H',
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
  dependencies = {
    {
      'kevinhwang91/nvim-bqf',
      lazy = true,
      module = 'bqf',
      opts = { preview = { winblend = 0 } },
    },
  },
}
