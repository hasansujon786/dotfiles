local cmp = require'cmp'
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local kind_icons = {
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
  Enum          = '',
  EnumMember    = '',
  Value         = '',
  Reference     = '',
  Keyword       = '',
  File          = '',
  Folder        = 'ﱮ',
  Color         = '',
  Unit          = '',
  Snippet       = '',
  Text          = '',
}

cmp.setup({
  documentation = {
    border = 'double',
    maxwidth = 120,
    minwidth = 60,
    maxheight = math.floor(vim.o.lines * 0.3),
    minheight = 1,
  },
  experimental = {
    native_menu = false,
    ghost_text = false,
  },
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end,
  },
  mapping = {
    ['<A-u>'] = cmp.mapping.scroll_docs(-4),
    ['<A-d>'] = cmp.mapping.scroll_docs(4),
    ['<A-n>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<A-p>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      else
        feedkey('<ESC>p', '')
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
      if cmp.visible() then
        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
      elseif vim.fn['hasan#compe#check_front_char']() then
        feedkey('<Right>', 'n')
      elseif has_words_before() and vim.fn['vsnip#available']() == 1 then
        feedkey('<Plug>(vsnip-expand-or-jump)', '')
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn['vsnip#jumpable'](-1) == 1 then
        feedkey('<Plug>(vsnip-jump-prev)', '')
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'buffer',
      opts = {
        get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end,
      },
    },
    { name = 'path' },
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
      vim_item.menu = ({
        nvim_lsp =   'ﲳ',
        nvim_lua =   '',
        treesitter = '',
        path =       'ﱮ',
        buffer =     '﬘',
        zsh =        '',
        vsnip =      '',
        spell =      '暈',
        orgmode =    '✿',
      })[entry.source.name]
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

vim.cmd[[autocmd FileType org lua CmpOrgmodeSetup()]]
vim.cmd[[autocmd FileType NeogitCommitMessage lua CmpNeogitCommitMessageSetup()]]

