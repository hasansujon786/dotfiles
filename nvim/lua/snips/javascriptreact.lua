local ls = require('luasnip')
local shared = require('snips.js_shared')

ls.add_snippets('javascriptreact', {
  shared.jsxClassName,
}, { key = 'my_jsx_snips' })
