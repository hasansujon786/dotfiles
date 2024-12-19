local hover = require('core.state').ui.hover
return {
  'saghen/blink.cmp',
  enabled = false,
  event = { 'InsertEnter' }, -- 'CmdlineEnter'
  dependencies = {
    'rafamadriz/friendly-snippets',
    'windwp/nvim-autopairs',
    'mattn/emmet-vim',
    'L3MON4D3/LuaSnip',
  },
  version = 'v0.*',
  -- version = '*',
  -- build = 'cargo build --release',
  opts_extend = {
    'sources.completion.enabled_providers',
    'sources.compat',
    'sources.default',
  },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- "super-tab" keymap
    --   you may want to set `completion.trigger.show_in_snippet = false`
    --   or use `completion.list.selection = "manual" | "auto_insert"`
    keymap = {
      preset = 'super-tab',
      ['<C-y>'] = { 'select_and_accept' },
      ['<C-q>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<A-p>'] = { 'select_prev', 'fallback' },
      ['<A-n>'] = { 'select_next', 'fallback' },
      ['<CR>'] = { 'accept', 'fallback' },
      ['<Tab>'] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.accept()
          else
            return cmp.select_and_accept()
          end
        end,
        'snippet_forward',
        'fallback',
      },
      ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
      ['<C-k>'] = { 'snippet_backward', 'fallback' },
      ['<C-j>'] = { 'snippet_forward', 'fallback' },
      ['<A-u>'] = { 'scroll_documentation_up', 'fallback' },
      ['<A-d>'] = { 'scroll_documentation_down', 'fallback' },
    },
    -- snippets = {
    --   expand = function(snippet)
    --     require('luasnip').lsp_expand(snippet)
    --   end,
    --   active = function(filter)
    --     if filter and filter.direction then
    --       return require('luasnip').jumpable(filter.direction)
    --     end
    --     return require('luasnip').in_snippet()
    --   end,
    --   jump = function(direction)
    --     require('luasnip').jump(direction)
    --   end,
    -- },

    completion = {
      accept = {
        auto_brackets = {
          enabled = true, -- experimental auto-brackets support
        },
      },
      trigger = {
        show_in_snippet = true,
      },
      menu = {
        enabled = true,
        min_width = 52,
        max_height = vim.o.pumheight,
        border = 'none',
        winhighlight = 'Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None',
        draw = {
          align_to_component = 'none',
          padding = 1,
          gap = 1,
          treesitter = false, -- { 'lsp' },
          columns = {
            { 'kind_icon' },
            { 'label', 'label_description', gap = 1, fill = true },
            { 'source_name' },
          },
          components = {
            label = {
              width = { fill = true, max = 48, min = 48 }, -- {fixed?, fill?, min?, max?, }
            },
          },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        treesitter_highlighting = true,
        window = {
          min_width = 10,
          max_width = 70,
          max_height = 20,
          border = hover.border,
          winhighlight = hover.winhighlight,
          -- winhighlight = 'Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None',
          scrollbar = true,
          direction_priority = {
            menu_north = { 'w', 'e' },
            menu_south = { 'w', 'e' },
          },
        },
      },
    },

    appearance = {
      use_nvim_cmp_as_default = true, -- use cmp's highlights
      nerd_font_variant = 'normal',
      kind_icons = require('hasan.utils.ui.icons').kind,
    },

    -- experimental signature help support
    -- signature = { enabled = true }
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' }, -- 'luasnip'
      compat = {},
      cmdline = {},
      completion = {
        enabled_providers = { 'lsp', 'path', 'luasnip', 'buffer', 'snippets' },
      },
      providers = {
        lsp = {
          name = ' ',
          module = 'blink.cmp.sources.lsp',
          -- score_offset = 10,
        },
        path = {
          name = ' ',
          module = 'blink.cmp.sources.path',
          score_offset = 3,
        },
        snippets = {
          name = ' ',
          module = 'blink.cmp.sources.snippets',
          score_offset = -3,
        },
        luasnip = {
          name = ' ',
          module = 'blink.cmp.sources.luasnip',
          -- score_offset = 3,
        },
        buffer = {
          name = ' ',
          module = 'blink.cmp.sources.buffer',
          fallbacks = { 'lsp' },
          -- fallback_for = { 'lsp' },
          -- score_offset = -3,
          min_keyword_length = 3,
        },
      },
    },
  },
}
