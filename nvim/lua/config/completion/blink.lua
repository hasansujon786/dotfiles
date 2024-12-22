local hover = require('core.state').ui.hover
local function tab_out_available()
  return vim.fn.search('\\%#[]>)}\'"`,;]', 'n') ~= 0
end

return {
  'saghen/blink.cmp',
  version = 'v0.*',
  enabled = true,
  event = { 'InsertEnter', 'CmdlineEnter' },
  dependencies = {
    'rafamadriz/friendly-snippets',
    'windwp/nvim-autopairs',
    'mattn/emmet-vim',
    -- 'L3MON4D3/LuaSnip',
  },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {

    keymap = {
      preset = 'super-tab',
      ['<C-q>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<CR>'] = { 'accept', 'fallback' },
      ['<C-y>'] = { 'select_and_accept' },

      ['<Tab>'] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.accept()
          elseif cmp.is_visible() then
            return cmp.select_and_accept()
          elseif tab_out_available() then
            feedkeys('<Right>', 'n')
            return true
          end
        end,
        'snippet_forward',
        'fallback',
      },
      ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
      ['<A-p>'] = { 'select_prev', 'fallback' },
      ['<A-n>'] = { 'select_next', 'fallback' },
      ['<C-k>'] = { 'snippet_backward', 'fallback' },
      ['<C-j>'] = { 'snippet_forward', 'fallback' },

      ['<A-u>'] = { 'scroll_documentation_up', 'fallback' },
      ['<A-d>'] = { 'scroll_documentation_down', 'fallback' },
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' }, -- 'luasnip'
      cmdline = {},
      providers = {
        path = { name = ' ', score_offset = 110 },
        lsp = { name = ' ', score_offset = 100 },
        luasnip = { name = ' ', score_offset = 90 },
        snippets = { name = ' ', score_offset = 80 },
        buffer = { name = ' ', score_offset = 70, min_keyword_length = 2 },
      },
    },

    completion = {
      accept = {
        auto_brackets = { enabled = true }, -- experimental auto-brackets support
      },
      trigger = { show_in_snippet = true },

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
          columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1, fill = true }, { 'source_name' } },
          components = {
            label = { width = { fill = true, max = 48, min = 48 } }, -- {fixed?, fill?, min?, max? }
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
          winhighlight = hover.winhighlight, -- 'Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None',
          scrollbar = true,
          direction_priority = { menu_north = { 'w', 'e' }, menu_south = { 'w', 'e' } },
        },
      },
    },

    -- signature = { enabled = true, window = { border = 'single' } },
    appearance = {
      use_nvim_cmp_as_default = true, -- use cmp's highlights
      nerd_font_variant = 'normal',
      kind_icons = require('hasan.utils.ui.icons').kind,
    },
  },
  opts_extend = { 'sources.default' },
}
