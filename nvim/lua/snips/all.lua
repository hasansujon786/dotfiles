local ls = require('luasnip')
-- ls.cleanup()
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

ls.add_snippets('all', {
  s('bang', t('#!/usr/bin/env ')),
  s('date', p(os.date, '%d.%m.%Y')),
  s('time', p(os.date, '%H:%M:%S')),
  s('ctime', {
    c(1, {
      f(function()
        return os.date('%D - %H:%M')
      end),
      p(os.date, '%d.%m.%Y'),
    }),
  }),
  s(
    'todo',
    fmt([[{} {}: {} {}]], {
      f(function(_, _, _)
        return require('luasnip.util.util').buffer_comment_chars()[1]
      end, {}),
      c(1, { i(nil, 'TODO'), i(nil, 'FIXME'), i(nil, 'DONE'), i(nil, 'INFO') }),
      p(os.date, '<%d.%m.%y>'),
      i(0),
    })
  ),
  -- there's some built-in conditions in "luasnip.extras.expand_conditions".
  s('cond2', {
    t('will only expand at the beginning of the line'),
  }, {
    condition = conds.line_begin,
  }),
}, { key = 'my_global_snips' })

ls.add_snippets({ 'scss', 'css' }, {
  s('v', fmt('var(--{1})', { i(1) })),
}, { key = 'my_css_snips' })
