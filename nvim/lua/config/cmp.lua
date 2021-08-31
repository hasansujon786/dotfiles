local cmp = require'cmp'
local check_back_space = function()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
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
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    -- ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
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
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if vim.fn.pumvisible() == 1 then
        -- vim.fn.feedkeys(t('<C-n>'), 'n')
        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
      elseif vim.fn['hasan#compe#check_front_char']() then
        vim.fn.feedkeys(t('<Right>'), 'n')
      elseif vim.fn.call('vsnip#available', { 1 }) == 1 then
        vim.fn.feedkeys(t('<Plug>(vsnip-expand-or-jump)'), '')
      elseif check_back_space() then
        vim.fn.feedkeys(t('<Tab>'), 'n')
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(t('<C-p>'), 'n')
      elseif vim.fn.call('vsnip#jumpable', { -1 }) == 1 then
        vim.fn.feedkeys(t('<Plug>(vsnip-jump-prev)'), '')
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'vsnip' },
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'spell' },
    { name = 'orgmode' },
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = ({
        vsnip    = '',
        nvim_lsp = '',
        buffer   = '',
        path     = '',
        spell    = '',
        orgmode  = '✿',
      })[entry.source.name]

      -- set a name for each source
      vim_item.menu = ({
        vsnip    = '[Snippet]',
        nvim_lsp = '[LSP]',
        buffer   = '[Buffer]',
        path     = '[Path]',
        spell    = '[Spell]',
        orgmode  = '[orgmode]',
      })[entry.source.name]
      return vim_item
    end,
  },
})
