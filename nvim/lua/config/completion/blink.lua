-- snippet trigger cookbook => https://github.com/linkarzu/dotfiles-latest/blob/main/neovim/neobean/lua/plugins/blink-cmp.lua

local hover = require('core.state').ui.hover
local function tab_out_available()
  local tab_out_chars = '>)}\'"`,;]'
  return vim.fn.search('\\%#[]' .. tab_out_chars, 'n') ~= 0
end
local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

return {
  'saghen/blink.cmp',
  version = '*',
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
      ['<C-y>'] = { 'select_and_accept', 'fallback' },
      ['<C-l>'] = {
        function(cmp)
          return cmp.show({ providers = { 'snippets' } })
        end,
      },

      ['<Tab>'] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.accept()
          elseif cmp.is_visible() then
            return cmp.select_and_accept()
          elseif tab_out_available() then
            feedkeys('<Right>', 'n')
            return true
          elseif has_words_before() and not cmp.is_visible() then
            return cmp.show()
          end
        end,
        'snippet_forward',
        'fallback',
      },
      ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

      ['<A-n>'] = { 'select_next', 'fallback' },
      ['<A-p>'] = { 'select_prev', 'fallback' },
      ['<C-j>'] = { 'snippet_forward', 'fallback' },
      ['<C-k>'] = { 'snippet_backward', 'fallback' },

      ['<A-u>'] = { 'scroll_documentation_up', 'fallback' },
      ['<A-d>'] = { 'scroll_documentation_down', 'fallback' },

      cmdline = {
        ['<C-y>'] = { 'select_and_accept', 'fallback' },
        ['<C-e>'] = { 'cancel', 'fallback' },

        ['<Tab>'] = {
          function(cmp)
            if not cmp.is_visible() then
              return cmp.show({ callback = cmp.select_next })
            end
          end,
          'select_next',
          'fallback',
        },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },

        ['<C-n>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<A-n>'] = { 'select_next', 'fallback' },
        ['<A-p>'] = { 'select_prev', 'fallback' },
      },
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' }, -- 'luasnip'
      -- per_filetype = {},
      cmdline = function()
        local type = vim.fn.getcmdtype()
        -- Search forward and backward
        if type == '/' or type == '?' or type == '@' then
          return { 'buffer' }
        end
        -- Commands
        if type == ':' then
          return { 'cmdline' }
        end
        return {}
      end,
      providers = {
        path = { name = ' ', score_offset = 110 },
        lsp = { name = ' ', score_offset = 100 },
        luasnip = { name = ' ', score_offset = 90 },
        snippets = { name = ' ', score_offset = 80 },
        buffer = { name = ' ', score_offset = 70, min_keyword_length = 2 },
        -- cmdline = { name = ' ' },
      },
    },

    completion = {
      accept = {
        auto_brackets = { enabled = true }, -- experimental auto-brackets support
      },
      trigger = { show_in_snippet = true },
      list = {
        selection = function(ctx)
          return ctx.mode == 'cmdline' and 'auto_insert' or 'preselect'
        end,
      },
      menu = {
        enabled = true,
        auto_show = function(ctx)
          return ctx.mode ~= 'cmdline'
        end,
        min_width = 52,
        max_height = vim.o.pumheight,
        border = 'none',
        winhighlight = 'Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None',
        draw = {
          align_to = 'cursor',
          padding = 1,
          gap = 1,
          columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1, fill = true }, { 'source_name' } },
          components = {
            label = { width = { fill = true, max = 48, min = 48 } }, -- {fixed?, fill?, min?, max? }
            -- source_name = { width = { max = 2 } },
          },
        },
        cmdline_position = function()
          if vim.g.ui_cmdline_pos ~= nil then
            local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
            return { pos[1], pos[2] - 3 }
          end
          local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
          return { vim.o.lines - height, 0 }
        end,
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
