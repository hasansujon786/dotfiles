local ls = require('luasnip')
-- ls.cleanup()
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node

local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local f = ls.function_node
local sn = ls.snippet_node

local fmt = require('luasnip.extras.fmt').fmt
local rep = require('luasnip.extras').rep

local p = require('luasnip.extras').partial
local l = require('luasnip.extras').lambda
local m = require('luasnip.extras').match
local n = require('luasnip.extras').nonempty
local dl = require('luasnip.extras').dynamic_lambda
local fmta = require('luasnip.extras.fmt').fmta
local types = require('luasnip.util.types')
local conds = require('luasnip.extras.expand_conditions')

local comment_chars = function(_, _, _)
  return require('luasnip.util.util').buffer_comment_chars()[1]
end

ls.add_snippets('all', {
  s('bang', t('#!/usr/bin/env ')),
  s(
    'cdate',
    fmt([[{} {} ]], {
      f(comment_chars, {}),
      c(1, {
        p(os.date, '%d.%m.%Y - %H:%M'),
        p(os.date, '%d.%m.%Y'),
      }),
    })
  ),
  s(
    'todo',
    fmt([[{} {}: {} {}]], {
      f(comment_chars, {}),
      c(1, { i(nil, 'TODO'), i(nil, 'FIXME'), i(nil, 'DONE'), i(nil, 'INFO') }),
      p(os.date, '<%d.%m.%y>'),
      i(0),
    })
  ),
  s(
    '<t',
    fmt(
      [[
      {} ================================================
      {} => {}
      {} ================================================
      ]],
      {
        f(comment_chars, {}),
        f(comment_chars, {}),
        i(0),
        f(comment_chars, {}),
      }
    )
  ),
}, { key = 'my_global_snips' })

-- TODO: <10.08.22> maybe array don't work
ls.add_snippets({ 'scss', 'css' }, {
  s('v', fmt('var(--{1})', { i(1) })),
}, { key = 'my_css_snips' })
