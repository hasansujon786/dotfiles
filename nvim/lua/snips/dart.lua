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
local common = require('snips.common')

ls.add_snippets('dart', {
  s('s', fmt('String {1}{2}', { i(1), t(';') })),
  s('S', fmt('String? {1}{2}', { i(1), t(';') })),
  s('i', fmt('int {1}{2}', { i(1), t(';') })),
  s('I', fmt('int? {1}{2}', { i(1), t(';') })),
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
    'rpStateNotifier',
    fmt(
      [[
      final {1}Provider = StateNotifierProvider<{2}StateNotifier, int>((ref) {{
        return {2}StateNotifier();
      }});

      class {2}StateNotifier extends StateNotifier<int> {{
        {2}StateNotifier(initialState) : super(initialState);
        void increment() => state++;
      }}
      ]],
      {
        i(1, 'counter'),
        f(common.get_insert_node_and_upper_first_char, { 1 }),
      }
    )
  ),
  s(
    'rpStateModel',
    fmt(
      [[
      class {1} {{
        {2}({{required this.name, required this.age}});

        String name;
        int age;

        {2} copyWith({{String? name, int? age}}) {{
          return {2}(
            name: name ?? this.name,
            age: age ?? this.age,
          );
        }}
      }}
      ]],
      {
        i(1, 'UserModel'),
        f(common.get_insert_node, { 1 }),
      }
    )
  ),
  s(
    'si',
    fmt([[final {} = MediaQuery.of(context).size{};]], {
      c(1, { t('width'), t('height'), t('size') }),
      f(function(args)
        local choice = args[1][1]
        if choice == 'size' then
          return ''
        end
        return '.' .. choice
      end, { 1 }),
    })
  ),
  s(
    'mq',
    fmt([[{}MediaQuery.of(context){}]], {
      c(1, { t('final mq = '), t('') }),
      f(common.choiceSemicolon, { 1 }),
    })
  ),
  s(
    'tt',
    fmt([[{}Theme.of(context).textTheme{}]], {
      c(1, { t('final tt = '), t('') }),
      f(common.choiceSemicolon, { 1 }),
    })
  ),
  s(
    'animationController',
    fmt(
      [[
      late AnimationController _controller;
      late Animation<double> _opacityAnim;

      @override
      void initState() {{
        super.initState();
        _controller = AnimationController(
          vsync: this,
          duration: const Duration(seconds: 2),
        );
        final curveAnim = CurvedAnimation(
          parent: _controller,
          curve: Curves.fastOutSlowIn,
          // curve: const Interval(0, 1, curve: Curves.easeOut),
        );
        _opacityAnim = Tween<double>(begin: 0, end: 1).animate(curveAnim);

        // _controller.forward();
        // _controller.repeat(reverse: true);
      }}

      @override
      void dispose() {{
        _controller.dispose();
        super.dispose();
      }}
      ]],
      {}
    )
  ),
}, { key = 'my_dart_snips' })
