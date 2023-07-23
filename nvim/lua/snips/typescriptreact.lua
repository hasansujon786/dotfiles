local ls = require('luasnip')
local shared = require('snips.js_shared')

ls.add_snippets('typescriptreact', {
  shared.jsxClassName,
}, { key = 'my_tsx_snips' })
