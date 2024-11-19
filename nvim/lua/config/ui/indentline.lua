local excluded_filetypes = {
  'Glance',
  'qf',
  'help',
  'neo-tree',
  'dashboard',
  'Trouble',
  'WhichKey',
  'lsp-installer',
  'lspinfo',
  'mason',
  'Outline',
  'alpha',
  'snacks_dashboard',
  'ccc-ui',
  '2048',
  'lazy',
  'noice',
  'NeogitPopup',
  'flutterToolsOutline',
  'neo-tree-popup',
  'org',
}

return {
  'lukas-reineke/indent-blankline.nvim',
  lazy = true,
  enabled = true,
  event = 'BufReadPost', -- V2: 9637670896b68805430e2f72cf5d16be5b97a22a
  main = 'ibl',
  opts = {
    indent = { char = '│', smart_indent_cap = true }, -- highlight = '',
    scope = { enabled = false, show_start = false, show_exact_scope = false },
    exclude = {
      filetypes = excluded_filetypes,
      -- buftypes = { },
    },
  },
  dependencies = {
    'echasnovski/mini.indentscope',
    version = false, -- wait till new 0.7.0 release to put it back on semver
    enabled = true,
    -- event = 'LazyFile',
    config = function()
      local opts = {
        symbol = '│',
        options = {
          try_as_border = false,
          indent_at_cursor = false,
        },
        mappings = {
          object_scope = 'ii',
          object_scope_with_border = 'ai',
          goto_top = '[e',
          goto_bottom = ']e',
        },
        draw = {
          delay = 150,
          -- animation = require('mini.indentscope').gen_animation.exponential(),
          -- animation = require('mini.indentscope').gen_animation.quartic(),
          -- animation = require('mini.indentscope').gen_animation.cubic(),
          -- animation = require('mini.indentscope').gen_animation.quadratic(),
          -- animation = require('mini.indentscope').gen_animation.linear(),
          animation = require('mini.indentscope').gen_animation.none(),
          priority = 2,
        },
      }
      require('mini.indentscope').setup(opts)
    end,
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = excluded_filetypes,
        callback = function()
          vim.b['miniindentscope_disable'] = true
        end,
      })
    end,
  },
}
