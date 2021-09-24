local cmp = require'cmp'
local has_words_before = function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  return not vim.api.nvim_get_current_line():sub(1, cursor[2]):match('^%s$')
end
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

cmp.setup({
  documentation = {
    border = 'double',
    maxwidth = 120,
    minwidth = 60,
    maxheight = math.floor(vim.o.lines * 0.3),
    minheight = 1,
  },
  -- experimental = { ghost_text = true, },
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end,
  },
  mapping = {
    ['<A-u>'] = cmp.mapping.scroll_docs(-4),
    ['<A-d>'] = cmp.mapping.scroll_docs(4),
    ['<A-n>'] = cmp.mapping(function()
      if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(t('<C-n>'), 'n')
      else
        vim.fn.feedkeys(t('<ESC>n'), '')
      end
    end, { 'i', 's' }),
    ['<A-p>'] = cmp.mapping(function()
      if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(t('<C-p>'), 'n')
      else
        vim.fn.feedkeys(t('<ESC>p'), '')
      end
    end, { 'i', 's' }),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-e>'] = cmp.mapping.close(),
    ['<C-Space>'] = cmp.mapping.complete(),
    -- ['<CR>'] = cmp.mapping.confirm({
    --   behavior = cmp.ConfirmBehavior.Replace,
    --   select = true,
    -- }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if vim.fn.pumvisible() == 1 then
        -- vim.fn.feedkeys(t('<C-n>'), 'n')
        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
      elseif vim.fn['hasan#compe#check_front_char']() then
        vim.fn.feedkeys(t('<Right>'), 'n')
      elseif has_words_before() and vim.fn['vsnip#available']() == 1 then
        vim.fn.feedkeys(t('<Plug>(vsnip-expand-or-jump)'), '')
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(t('<C-p>'), 'n')
      elseif vim.fn['vsnip#jumpable'](-1) == 1 then
        vim.fn.feedkeys(t('<Plug>(vsnip-jump-prev)'), '')
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'spell' },
    { name = 'orgmode' },
  },
  formatting = {
    format = function(_, vim_item)
      vim_item.menu = vim_item.kind
      -- vim_item.menu = ({
      --   vsnip    = '[Snippet]',
      --   nvim_lsp = '[LSP]',
      --   buffer   = '[Buffer]',
      --   path     = '[Path]',
      --   spell    = '[Spell]',
      --   orgmode  = '[orgmode]',
      -- })[entry.source.name]

      vim_item.kind = ({
        Function      = '',
        Constructor   = '',
        Method        = '',
        Variable      = '',
        Field         = 'ﴲ',
        TypeParameter = '',
        Constant      = '',
        Class         = '',
        Interface     = 'ﰮ',
        Struct        = '',
        Event         = '',
        Operator      = '',
        Module        = '',
        Property      = '',
        Enum          = '',
        EnumMember    = '',
        Value         = '',
        Reference     = '',
        Keyword       = '',
        File          = '',
        Folder        = 'ﱮ',
        Color         = '',
        Unit          = '',
        Snippet       = '',
        Text          = '',
      })[vim_item.kind]
      return vim_item
    end,
  },
})

vim.g.vsnip_filetypes = {
  javascript = {'javascriptreact'},
  typescript = {'typescriptreact'},
  javascriptreact = {'javascript'},
  typescriptreact = {'typescript'},
}

