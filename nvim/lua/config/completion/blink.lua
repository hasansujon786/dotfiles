-- snippet trigger cookbook => https://github.com/linkarzu/dotfiles-latest/blob/main/neovim/neobean/lua/plugins/blink-cmp.lua

local hover = require('core.state').ui.hover
local function tab_out_available()
  local tab_out_chars = '>)}\'"`,;]'
  return vim.fn.search('\\%#[]' .. tab_out_chars, 'n') ~= 0
end
local function has_words_before()
  local skip_ft = vim.tbl_contains({ 'spectre_input', 'spectre_file_input' }, vim.bo.filetype)
  if skip_ft then
    return false
  end

  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  if col == 0 then
    return false
  end
  local text = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
  return text:sub(col, col):match('%s') == nil
end
-- Hack to tab makes work
keymap('i', '<tab>', '<space><space>')
keymap('i', '<s-tab>', '<BS>')

return {
  'saghen/blink.cmp',
  version = '*',
  enabled = require('core.state').completion.module == 'blink',
  event = { 'InsertEnter', 'CmdlineEnter' },
  dependencies = {
    'rafamadriz/friendly-snippets',
    'windwp/nvim-autopairs',
    -- 'L3MON4D3/LuaSnip',
    'echasnovski/mini.snippets',
    'mattn/emmet-vim',
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
        -- 'fallback_to_mappings',
      },
      ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

      ['<A-n>'] = { 'select_next', 'fallback' },
      ['<A-p>'] = { 'select_prev', 'fallback' },
      ['<C-j>'] = { 'snippet_forward', 'fallback' },
      ['<C-k>'] = { 'snippet_backward', 'fallback' },

      ['<A-u>'] = { 'scroll_documentation_up', 'fallback' },
      ['<A-d>'] = { 'scroll_documentation_down', 'fallback' },
    },
    fuzzy = { implementation = 'prefer_rust' },
    snippets = {
      -- preset = 'luasnip',
      preset = 'mini_snippets',
    },
    sources = {
      -- https://github.com/Saghen/blink.cmp/blob/main/docs/configuration/sources.md#community-sources
      default = { 'lsp', 'path', 'snippets', 'buffer' },
      per_filetype = {
        spectre_input = { 'buffer' },
        spectre_file_input = { 'path' },
      },
      providers = {
        path = { name = ' ', score_offset = 110 },
        lsp = { name = ' ', score_offset = 100 },
        -- luasnip = { name = ' ', score_offset = 90 },
        snippets = {
          name = ' ',
          score_offset = 10,
          should_show_items = function(ctx)
            return ctx.trigger.initial_kind ~= 'trigger_character'
          end,
        },
        buffer = { name = ' ', score_offset = 70, min_keyword_length = 2 },
        cmdline = {
          name = ' ',
          min_keyword_length = function(ctx)
            -- when typing a command, only show when the keyword is 3 characters or longer
            if ctx.mode == 'cmdline' and string.find(ctx.line, ' ') == nil then
              return 2
            end
            return 0
          end,
        },
      },
    },

    completion = {
      ghost_text = { enabled = true },
      accept = {
        auto_brackets = { enabled = true }, -- experimental auto-brackets support
      },
      trigger = { show_in_snippet = true },
      list = {
        selection = {
          auto_insert = function(ctx)
            return ctx.mode == 'cmdline'
          end,
          preselect = function(ctx)
            return ctx.mode ~= 'cmdline'
          end,
        },
      },
      menu = {
        enabled = true,
        -- auto_show = function(ctx)
        --   return ctx.mode ~= 'cmdline'
        -- end,
        min_width = 52,
        max_height = vim.o.pumheight,
        border = 'none',
        draw = {
          -- treesitter = { 'lsp' },
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
            return { pos[1], pos[2] }
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
          scrollbar = true,
          direction_priority = { menu_north = { 'e', 'w' }, menu_south = { 'e', 'w' } },
        },
      },
    },

    -- signature = { enabled = true, window = { border = 'single' } },
    appearance = {
      use_nvim_cmp_as_default = false, -- use cmp's highlights
      nerd_font_variant = 'normal',
      kind_icons = require('hasan.utils.ui.icons').kind,
    },

    cmdline = {
      keymap = {
        ['<C-y>'] = { 'select_and_accept', 'fallback' },
        ['<C-e>'] = { 'cancel', 'fallback' },

        ['<Tab>'] = {
          function(cmp)
            if cmp.get_selected_item_idx() == 1 and not require('blink.cmp.completion.list').is_explicitly_selected then
              require('blink.cmp.completion.list').select(1, {})
              return true
            end
          end,
          'show_and_insert',
          'select_next',
        },
        ['<S-Tab>'] = { 'show_and_insert', 'select_prev' },

        ['<C-n>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<A-n>'] = { 'select_next', 'fallback' },
        -- ['<A-p>'] = { 'select_prev', 'fallback' },
      },
      completion = {
        menu = {
          auto_show = true,
          draw = {
            columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1, fill = true } },
          },
        },
      },
    },
  },
  opts_extend = { 'sources.default' },
}
