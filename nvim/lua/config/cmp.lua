print('cmp loded')
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
    border = 'double'
  },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    -- ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-e>'] = cmp.mapping.close(),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = function(fallback)
      if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(t('<C-n>'), 'n')
      elseif check_back_space() then
        vim.fn.feedkeys(t('<Tab>'), 'n')
      elseif vim.fn['vsnip#available']() == 1 then
        vim.fn.feedkeys(t('<Plug>(vsnip-expand-or-jump)'), '')
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'vsnip' },
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'spell' }
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = ({
        vsnip    = '',
        nvim_lsp = '',
        buffer   = '',
        path     = '',
        spell    = '',
      })[entry.source.name]

      -- set a name for each source
      vim_item.menu = ({
        vsnip    = '[Snippet]',
        nvim_lsp = '[LSP]',
        buffer   = '[Buffer]',
        path     = '[Path]',
        spell    = '[Spell]',
      })[entry.source.name]
      return vim_item
    end,
  },
})
