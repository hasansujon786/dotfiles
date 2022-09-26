local cmp = require('cmp')
local utils = require('hasan.utils')
local kind_icons = require('hasan.utils.ui.icons').kind
local luasnip = require('luasnip')

local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local function tab_out_available()
  return vim.fn.search('\\%#[]>)}\'"`,;]', 'n') ~= 0
end

cmp.setup({
  window = {
    -- completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered({
      winhighlight = 'Normal:Normal,FloatBorder:TelescopeBorder,CursorLine:Visual,Search:None',
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
      cmp.complete({ config = { sources = { { name = 'luasnip' } } } })
    end),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-e>'] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
    ['<C-q>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<c-space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<M-space>'] = cmp.mapping({
      i = cmp.mapping.complete(),
      c = cmp.mapping.complete(),
      s = function(_)
        if luasnip.choice_active() then
          require('luasnip.extras.select_choice')()
        end
      end,
    }),
    ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Select, select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
        -- elseif has_words_before() then
        --   cmp.complete()
      elseif tab_out_available() then
        feedkeys('<Right>', 'n')
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer', keyword_length = 4 },
    { name = 'path' },
    -- { name = 'cmp-tw2css' }
  },
  formatting = {
    fields = { 'kind', 'abbr', 'menu' },
    format = function(entry, vim_item)
      -- NOTE: order matters
      vim_item.menu = ({
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
      vim_item.menu = string.format('%s %s', string.sub(vim_item.kind, 1, 3), vim_item.menu)

      -- Kind icons
      -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
      vim_item.kind = string.format('%s', kind_icons[vim_item.kind])
      return vim_item
    end,
  },
})

local CMP_AUGROUP = utils.augroup('CMP_AUGROUP')
CMP_AUGROUP(function(autocmd)
  autocmd('FileType', 'lua CmpOrgmodeSetup()', { pattern = { 'org' } })
  autocmd('FileType', 'lua CmpNeogitCommitMessageSetup()', { pattern = { 'NeogitCommitMessage' } })
end)

-- hot fix : after using / <tab> completion stops working
keymap('c', '<tab>', '<C-z>', { silent = false })
for _, v in pairs({ '/', '?' }) do
  cmp.setup.cmdline(v, {
    mapping = cmp.mapping.preset.cmdline({
      ['<CR>'] = cmp.mapping(function(fallback)
        if cmp.visible() and cmp.get_selected_entry() then
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
          feedkeys('<CR>', '')
        else
          fallback()
        end
      end, { 'c' }),
      ['<C-y>'] = cmp.mapping(function(_)
        cmp.close()
        vim.defer_fn(function()
          feedkeys('<CR>', '')
        end, 10)
      end, { 'c' }),
    }),
    sources = {
      { name = 'buffer', keyword_length = 2 },
    },
    view = {
      entries = { name = 'wildmenu', separator = ' | ' },
    },
  })
end
