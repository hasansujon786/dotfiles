-- local common = require('nvim.snippets.luasnip.utils')
local ls = require('luasnip')

-- local l = require('luasnip.extras').lambda
-- local p = require('luasnip.extras').partial
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

ls.add_snippets('javascript', {
  s(
    { trig = 'for([%w_]+)', regTrig = true, hidden = true },
    fmt(
      [[
      for (let {1} = 0; {2} < {3}; {4}++) {{
        {5}
      }}
      {6}
      ]],
      {
        d(1, function(_, snip)
          return sn(nil, i(1, snip.captures[1]))
        end),
        rep(1),
        c(2, { i(1, 'num'), sn(1, { i(1, 'arr'), t('.length') }) }),
        rep(1),
        i(3, '// TODO:'),
        i(4),
      }
    )
  ),
  s(
    'fetchthen',
    fmt(
      [[
      fetch({})
        .then((response) => response.json())
        .then((json) => {{
          console.log(json)
        }})
        .catch((error) => console.error(error))
      ]],
      {
        i(1, "'api-endpoint'"),
      }
    )
  ),
  s(
    'fetchtry',
    fmt(
      [[
      try {{
        var res = await fetch({})
        var data = res.json()
        console.log(data)
      }} catch (error) {{
        console.log(error)
      }}
      ]],
      {
        i(1, "'api-endpoint'"),
      }
    )
  ),
}, { key = 'my_js_snips' })
