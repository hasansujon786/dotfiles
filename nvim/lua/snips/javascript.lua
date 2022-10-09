local ls = require('luasnip')

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
}, { key = 'my_js_snips' })
