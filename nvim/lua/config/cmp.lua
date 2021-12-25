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
  Method        = '',
  Constructor   = '',
  Variable      = '',
  Field         = '',
  TypeParameter = '',
  Constant      = '',
  Class         = 'פּ ',
  Interface     = '蘒',
  Struct        = '',
  Event         = '',
  Operator      = '',
  Module        = '',
  Property      = '',
  Value         = '',
  Enum          = '',
  EnumMember    = '',
  Reference     = '',
  Keyword       = '',
  File          = '',
  Folder        = '',
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
    ['<C-q>'] = cmp.mapping.complete(),
    ['<C-l>'] = cmp.mapping.complete({config={sources={{name='vsnip'}}}}),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
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
    { name = 'buffer',
      option = {
        get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end,
      },
    },
    { name = 'vsnip' },
    { name = 'path' },
  },
  formatting = {
    fields = { 'kind', 'abbr', 'menu' },
    format = function(entry, vim_item)
      -- NOTE: order matters
      vim_item.menu = ({
        nvim_lsp =   'ﲳ',
        nvim_lua =   '',
        treesitter = '',
        path =       'ﱮ',
        buffer =     '﬘',
        zsh =        '',
        vsnip =      '',
        spell =      '暈',
        orgmode =    '✿',
      })[entry.source.name]
      vim_item.menu = string.format('%s %s', string.sub(vim_item.kind, 1,4), vim_item.menu)

      -- Kind icons
      -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
      vim_item.kind = string.format('%s', kind_icons[vim_item.kind])
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

--  inoremap <C-S> <Cmd>lua require('cmp').complete({ config = { sources = { { name = 'vsnip' } } } })<CR>


