local ls = require('luasnip')
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require('luasnip.extras').lambda
local rep = require('luasnip.extras').rep
local p = require('luasnip.extras').partial
local m = require('luasnip.extras').match
local n = require('luasnip.extras').nonempty
local dl = require('luasnip.extras').dynamic_lambda
local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta
local types = require('luasnip.util.types')
local conds = require('luasnip.extras.expand_conditions')

ls.add_snippets('lua', {
  -- s('req', fmt("local {} = require('{}')", { i(1, 'module'), rep(1) })),
  s('pr', fmt('P({})', i(1, "'write something'"))),
  s(
    'rq',
    fmt("local {} = require('{}')", {
      f(function(import_name)
        local parts = vim.split(import_name[1][1], '.', true)
        return parts[#parts]
      end, { 1 }),
      i(1),
    })
  ),
  s(
    'defer',
    fmt(
      [[
      vim.defer_fn(function()
        {2}
      end, {1})
      ]],
      {
        i(1, '1000'),
        i(0, '-- write something'),
      }
    )
  ),
  s(
    'ei',
    fmt(
      [[
      elseif {} then
        {}
      ]],
      { i(1), i(0) }
    )
  ),
  s('ee', {
    t({ 'else', '\t' }),
    i(0),
  }),
}, { key = 'my_lua_snips' })

