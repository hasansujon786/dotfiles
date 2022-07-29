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

ls.add_snippets('dart', {
  s('s', fmt('String {1}{2}', { i(1), t(';') })),
  s('S', fmt('String? {1}{2}', { i(1), t(';') })),
  s('i', fmt('Int {1}{2}', { i(1), t(';') })),
  s('I', fmt('Int? {1}{2}', { i(1), t(';') })),
  s('d', fmt('double {1}{2}', { i(1), t(';') })),
  s('D', fmt('double? {1}{2}', { i(1), t(';') })),
  s('f', fmt('final {1}{2}', { i(1), t(';') })),
  s('v', fmt('var {1}{2}', { i(1), t(';') })),
  s(
    'for',
    fmt(
      [[
      for (final {2} in {1}) {{
         {3}
      }}
      ]],
      { i(1), i(2), i(0) }
    )
  ),
  s(
    'rpcontroller',
    fmt(
      [[
      final {1}ControllerProvider = StateNotifierProvider<{2}Controller, int>((ref) {{
        return {2}Controller(0);
      }});

      class {2}Controller extends StateNotifier<int> {{
        {2}Controller(initialState) : super(initialState);
        void increment() => state++;
      }}
      ]],
      {
        i(1, 'counter'),
        f(function(args)
          return args[1][1]:gsub('^%l', string.upper)
        end, { 1 }),
      }
    )
  ),
}, { key = 'my_dart_snips' })
