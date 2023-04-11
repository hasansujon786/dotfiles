local ls = require('luasnip')
local icons = require('hasan.utils.ui.icons')
local types = require('luasnip.util.types')
ls.config.set_config({
  -- This tells LuaSnip to remember to keep around the last snippet.
  -- You can jump back into it even if you move outside of the selection
  history = true,
  -- This one is cool cause if you have dynamic snippets, it updates as you type!
  update_events = 'TextChanged,TextChangedI,InsertEnter,InsertLeave',
  region_check_events = 'InsertEnter,CursorMoved',
  delete_check_events = 'TextChanged,InsertLeave',
  -- Autosnippets:
  enable_autosnippets = false,
  -- ext_opts = nil,
  ext_opts = {
    [types.choiceNode] = {
      passive = { virt_text = { { '', 'Comment' } } },
      active = { virt_text = { { '', 'CmpItemKindClass' } } },
    },
    [types.insertNode] = {
      passive = { virt_text = { { icons.ui.Circle, 'Comment' } } },
      active = { virt_text = { { icons.ui.Circle, 'String' } } },
    },
  },
})

-- require('luasnip').filetype_extend('javascriptreact', { 'javascript' }) -- (to, {from})
-- require('luasnip').filetype_extend('javascript', { 'javascriptreact' })
-- require('luasnip').filetype_extend('typescript', { 'javascript' })
-- require('luasnip').filetype_extend('typescriptreact', { 'javascript' })

vim.cmd([[command! LuaSnipEditLocal :lua require("luasnip.loaders.from_lua").edit_snippet_files()]])
vim.defer_fn(function()
  require('luasnip.loaders.from_lua').lazy_load({ paths = { '~/dotfiles/nvim/lua/snips' } })
  require('luasnip.loaders.from_vscode').lazy_load({ paths = { '~/dotfiles/nvim/.vsnip' } })
  require('luasnip.loaders.from_vscode').lazy_load()
end, 100)
