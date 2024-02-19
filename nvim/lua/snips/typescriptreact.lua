local ls = require('luasnip')
local common = require('snips.utils')

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

ls.add_snippets('typescriptreact', {
  s(
    'useCounterContext',
    fmt(
      [[
      import {{ PropsWithChildren, createContext, useContext, useState }} from 'react'

      type {2}ContextState = {{
        {3}: number
        set{5}: React.Dispatch<React.SetStateAction<number>>
      }}

      const {1}Context = createContext<{2}ContextState | null>(null)
      export const {2}ContextProvider = (props: PropsWithChildren) => {{
        const [{4}, set{5}] = useState<number>(0)

        return (
          <{2}Context.Provider
            value={{{{
              {4},
              set{5},
            }}}}
          >
            {{props.children}}
          </{2}Context.Provider>
        )
      }}

      export function use{2}Context() {{
        const context = useContext({2}Context)

        if (!context) {{
          throw new Error(
            'use{2}Context must be used within a {2}ContextProvider'
          )
        }}

        return context
      }}
      ]],
      {
        i(1, 'Counter'),
        f(common.get_insert_node, { 1 }),
        i(2, 'counter'),
        f(common.get_insert_node, { 2 }),
        f(common.get_insert_node_and_upper_first_char, { 2 }),
      }
    )
  ),
}, { key = 'my_tsx_snips' })
