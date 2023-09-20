return {
  'hrsh7th/nvim-cmp',
  lazy = true,
  event = 'InsertEnter',
  config = function()
    require('config.completion.cmp')
  end,
  dependencies = {
    -- completion sources
    'f3fora/cmp-spell',
    'hrsh7th/cmp-buffer',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-path',

    -- Other dependencies
    {
      'L3MON4D3/LuaSnip',
      lazy = true,
      module = 'luasnip',
      dependencies = { 'rafamadriz/friendly-snippets' },
      config = function()
        require('config.completion.lua_snip').config()
      end,
    },
    {
      'mattn/emmet-vim',
      config = function()
        require('config.completion.emmet').config()
      end,
    },
    {
      'windwp/nvim-autopairs',
      config = function()
        require('config.completion.autopairs').config()
      end,
    },
  },
}
