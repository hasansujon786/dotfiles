local common = require('hasan.utils.snip')
local ls = require('luasnip')

-- local l = require('luasnip.extras').lambda
local p = require('luasnip.extras').partial
-- local m = require('luasnip.extras').match
-- local n = require('luasnip.extras').nonempty
-- local dl = require('luasnip.extras').dynamic_lambda
-- local types = require('luasnip.util.types')
-- local conds = require('luasnip.extras.expand_conditions')

local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta
local rep = require('luasnip.extras').rep

local s = ls.snippet
local c = ls.choice_node
local d = ls.dynamic_node
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local r = ls.restore_node
local sn = ls.snippet_node

ls.add_snippets('all', {
  s('bang', t('#!/usr/bin/env ')),
  s(
    'cdate',
    fmt([[{} {} ]], {
      f(common.comment_chars, {}),
      c(1, {
        p(os.date, '%d.%m.%Y - %H:%M'),
        p(os.date, '%d.%m.%Y'),
      }),
    })
  ),
  s(
    'todo',
    fmt([[{} {}: {}]], {
      f(common.comment_chars, {}),
      c(1, { i(nil, 'TODO'), i(nil, 'FIXME'), i(nil, 'DONE'), i(nil, 'INFO') }),
      i(0),
    })
  ),
  s('<f', fmt('[[file:' .. org_root_path .. '{}]]', { i(0) })),
  s('<F', fmt(org_root_path .. '{}', { i(0) })),
  s(
    '<t',
    fmt(
      [[
      {} ------------------------------------------------
      {} ------ {} --------------------------------------
      {} ------------------------------------------------
      ]],
      {
        f(common.comment_chars, {}),
        f(common.comment_chars, {}),
        i(0),
        f(common.comment_chars, {}),
      }
    )
  ),
}, { key = 'my_global_snips' })
