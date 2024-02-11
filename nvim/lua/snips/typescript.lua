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

ls.add_snippets('typescript', {
  s(
    '_scaffoldGoToRoute',
    fmt(
      [[
      export const routes = {{
        home: '/',
        blog: '/blog',
        about: '/about',
      }} as const

      type Route = (typeof routes)[keyof typeof routes]

      export function goToRoute(route: Route) {{
        console.log('goToRoute', route)
      }}
      ]],
      {}
    )
  ),
}, { key = 'my_ts_snips' })
