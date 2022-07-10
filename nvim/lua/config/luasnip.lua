local ls = require('luasnip')
local types = require('luasnip.util.types')
ls.config.set_config({
  -- This tells LuaSnip to remember to keep around the last snippet.
  -- You can jump back into it even if you move outside of the selection
  history = true,
  -- This one is cool cause if you have dynamic snippets, it updates as you type!
  updateevents = 'TextChanged,TextChangedI,InsertEnter,InsertLeave',
  region_check_events = 'InsertEnter',
  delete_check_events = 'TextChanged,InsertLeave',
  -- Autosnippets:
  enable_autosnippets = false,
  -- ext_opts = nil,
  ext_opts = {
    [types.choiceNode] = {
      passive = { virt_text = { { '●', 'Comment' } } },
      active = { virt_text = { { '●', 'CmpItemKindClass' } } },
    },
    [types.insertNode] = {
      passive = { virt_text = { { '●', 'Comment' } } },
      active = { virt_text = { { '●', 'String' } } },
    },
  },
})

vim.defer_fn(function()
  require('luasnip.loaders.from_vscode').lazy_load()
  require('luasnip.loaders.from_vscode').lazy_load({ paths = { '~/dotfiles/nvim/.vsnip' } })
  require('config.my_luasnip')
end, 100)
