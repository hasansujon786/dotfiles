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

local l = require('luasnip.extras').lambda
local p = require('luasnip.extras').partial
local m = require('luasnip.extras').match
local n = require('luasnip.extras').nonempty
local dl = require('luasnip.extras').dynamic_lambda
local fmta = require('luasnip.extras.fmt').fmta
local types = require('luasnip.util.types')
local conds = require('luasnip.extras.expand_conditions')

local date_input = function(args, snip, old_state, fmt)
  fmt = fmt or '%Y-%m-%d'
  return sn(nil, i(1, os.date(fmt)))
end

local function bash(_, _, command)
  local file = io.popen(command, 'r')
  local res = {}
  for line in file:lines() do
    table.insert(res, line)
  end
  return res
end

local comment_chars = function(_, _, _)
  return require('luasnip.util.util').buffer_comment_chars()[1]
end

ls.add_snippets('all', {
  s('time', p(os.date, '%H:%M:%S')),
  -- there's some built-in conditions in "luasnip.extras.expand_conditions".
  s('cond2', {
    t('will only expand at the beginning of the line'),
  }, {
    condition = conds.line_begin,
  }),
  s('hello', {
    t('hello '),
    i(1, 'World'),
    t({ '', 'how are you doing?' }),
  }),
  s(
    'fnc',
    fmt(
      [[
        local {} = function({})
          {}
        end
      ]],
      {
        i(1, ''),
        c(2, { t('myArg'), t('') }),
        rep(1),
        -- i(0, ''),
      }
    )
  ),
}, { key = 'my_example_snips' })
