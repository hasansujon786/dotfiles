return {
  'hrsh7th/nvim-cmp',
  lazy = true,
  event = { 'InsertEnter', 'CmdlineEnter' },
  config = function()
    local cmp = require('cmp')
    local compare = require('cmp.config.compare')
    local kind_icons = require('hasan.utils.ui.icons').kind
    local luasnip = require('luasnip')
    local hover = require('hasan.core.state').ui.hover
    local types = require('cmp.types')

    -- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#completionItemKind
    local kind_mapper = types.lsp.CompletionItemKind
    local kind_score = {
      -- Field = 2,
      Variable = 1,
    }

    local ELLIPSIS_CHAR = '…'
    local MAX_LABEL_WIDTH = 40

    local function get_ws(max, len)
      return (' '):rep(max - len)
    end
    local function tab_out_available()
      return vim.fn.search('\\%#[]>)}\'"`,;]', 'n') ~= 0
    end
    -- local function has_words_before()
    --   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    --   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
    -- end

    local function mapping_open_suggetions()
      return cmp.mapping({
        i = cmp.mapping.complete(),
        c = cmp.mapping.complete(),
        s = function(_)
          if luasnip.choice_active() then
            require('luasnip.extras.select_choice')()
          end
        end,
      })
    end

    cmp.setup({
      window = {
        documentation = cmp.config.window.bordered({
          winhighlight = hover.winhighlight,
          border = hover.border,
        }),
        completion = cmp.config.window.bordered({
          winhighlight = hover.winhighlight,
          border = 'none',
          col_offset = 1,

          -- border = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' },
          -- side_padding = 0,
        }),
      },
      experimental = {
        ghost_text = false,
      },
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      view = {
        entries = { name = 'custom', selection_order = 'top_down' },
      },
      mapping = cmp.mapping.preset.insert({
        ['<A-u>'] = cmp.mapping.scroll_docs(-4),
        ['<A-d>'] = cmp.mapping.scroll_docs(4),
        ['<A-n>'] = cmp.mapping(function(_)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.choice_active() then
            luasnip.change_choice(1)
          else
            cmp.complete()
          end
        end, { 'i', 'c', 's' }),
        ['<A-p>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.choice_active() then
            luasnip.change_choice(-1)
          else
            fallback()
          end
        end, { 'i', 'c', 's' }),
        ['<C-l>'] = cmp.mapping(function(_)
          if luasnip.choice_active() then
            luasnip.change_choice(1)
          else
            cmp.complete({ config = { sources = { { name = 'luasnip' } } } })
          end
        end, { 'i', 's' }),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-e>'] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
        ['<C-q>'] = mapping_open_suggetions(),
        ['<c-space>'] = mapping_open_suggetions(),
        ['<M-space>'] = mapping_open_suggetions(),
        ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Select, select = true }),
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          -- elseif has_words_before() then
          --   cmp.complete()
          elseif tab_out_available() then
            feedkeys('<Right>', 'n')
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(_)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            local _, col = unpack(vim.api.nvim_win_get_cursor(0))
            if col ~= 0 then
              feedkeys('<Bs>')
            end
          end
        end, { 'i', 's' }),
        ['<C-k>'] = cmp.mapping(function()
          if cmp.visible_docs() then
            cmp.close_docs()
          end
          vim.lsp.buf.signature_help()
        end, { 'i', 's' }),
      }),
      sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        {
          name = 'buffer',
          keyword_length = 4,
          -- option = {
          --   get_bufnrs = function()
          --     return vim.api.nvim_list_bufs()
          --   end,
          -- },
        },
        { name = 'path' },
        -- { name = 'cmp-tw2css' }
      },
      sorting = {
        priority_weight = 2,
        comparators = {
          compare.offset,
          compare.exact,
          -- compare.scopes,
          compare.score,
          compare.recently_used,
          -- compare.kind,
          function(entry1, entry2)
            local kind1 = entry1:get_kind()
            local kind2 = entry2:get_kind()
            -- my custom sort
            kind1 = kind1 == types.lsp.CompletionItemKind.Text and 100 or kind_score[kind_mapper[kind1]] or kind1
            kind2 = kind2 == types.lsp.CompletionItemKind.Text and 100 or kind_score[kind_mapper[kind2]] or kind2
            if kind1 ~= kind2 then
              if kind1 == types.lsp.CompletionItemKind.Snippet then
                return true
              end
              if kind2 == types.lsp.CompletionItemKind.Snippet then
                return false
              end
              local diff = kind1 - kind2
              if diff < 0 then
                return true
              elseif diff > 0 then
                return false
              end
            end
            return nil
          end,
          compare.locality,
          -- compare.sort_text,
          compare.length,
          compare.order,
        },
      },
      formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = function(entry, item)
          -- NOTE: order matters
          item.menu = ({
            nvim_lsp = 'ﲳ',
            nvim_lua = '',
            treesitter = '',
            path = 'ﱮ',
            buffer = '﬘',
            zsh = '',
            vsnip = '',
            spell = '暈',
            orgmode = '✿',
            luasnip = '',
          })[entry.source.name]
          item.menu = string.format('%s %s', string.sub(item.kind, 1, 3), item.menu)

          -- Kind icons
          -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
          item.kind = string.format('%s', kind_icons[item.kind])

          -- Turncate label
          local content = item.abbr
          if #content > MAX_LABEL_WIDTH then
            item.abbr = vim.fn.strcharpart(content, 0, MAX_LABEL_WIDTH) .. ELLIPSIS_CHAR
          else
            item.abbr = content .. get_ws(MAX_LABEL_WIDTH, #content)
          end

          return item
        end,
      },
    })

    augroup('CMP_AUGROUP')(function(autocmd)
      autocmd('FileType', 'lua CmpOrgmodeSetup()', { pattern = { 'org' } })
      autocmd('FileType', 'lua CmpNeogitCommitMessageSetup()', { pattern = { 'NeogitCommitMessage' } })
    end)

    -- hot fix: after using / <tab> completion stops working
    keymap('c', '<tab>', '<C-z>', { silent = false })
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline({
        ['<CR>'] = cmp.mapping(function(fallback)
          if cmp.visible() and cmp.get_selected_entry() then
            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
            feedkeys('<CR>', '')
          else
            fallback()
          end
        end),
        ['<C-y>'] = cmp.mapping(function(_)
          cmp.close()
          vim.defer_fn(function()
            feedkeys('<CR>', '')
          end, 10)
        end),
      }),
      sources = {
        { name = 'buffer', keyword_length = 2 },
      },
      view = {
        entries = { name = 'wildmenu', separator = ' | ' },
      },
      formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = function(_, item)
          return item
        end,
      },
    })
  end,
  dependencies = {
    'windwp/nvim-autopairs',
    'mattn/emmet-vim',
    'L3MON4D3/LuaSnip',
    -- completion sources
    'f3fora/cmp-spell',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-buffer',
    'saadparwaiz1/cmp_luasnip',
  },
}
