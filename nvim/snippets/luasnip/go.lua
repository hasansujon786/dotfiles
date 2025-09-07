-- local common = require('hasan.utils.snip')
local ls = require('luasnip')

-- local l = require('luasnip.extras').lambda
-- local p = require('luasnip.extras').partial
-- local m = require('luasnip.extras').match
-- local n = require('luasnip.extras').nonempty
-- local dl = require('luasnip.extras').dynamic_lambda
-- local types = require('luasnip.util.types')
-- local conds = require('luasnip.extras.expand_conditions')

-- local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta
-- local rep = require('luasnip.extras').rep

local s = ls.snippet
-- local c = ls.choice_node
-- local d = ls.dynamic_node
local i = ls.insert_node
-- local t = ls.text_node
local f = ls.function_node
-- local r = ls.restore_node
-- local sn = ls.snippet_node

ls.add_snippets('go', {
  s(
    'iferr',
    fmta(
      [[
			if err := <call>; err != nil {
				<output>
			}
      ]],
      {
        call = f(function(_, snip)
          return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        output = i(1, 'return err'),
      }
    )
  ),
}, { key = 'my_go_snips' })
