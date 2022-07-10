local ls = require('luasnip')
-- ls.cleanup()
local types = require('luasnip.util.types')
ls.config.set_config({
  -- This tells LuaSnip to remember to keep around the last snippet.
  -- You can jump back into it even if you move outside of the selection
  history = true,
  -- This one is cool cause if you have dynamic snippets, it updates as you type!
  updateevents = 'TextChanged,TextChangedI,InsertEnter',
  region_check_events = 'InsertEnter',
  delete_check_events = 'TextChanged,InsertLeave',
  -- Autosnippets:
  enable_autosnippets = false,
  -- ext_opts = nil,
  ext_opts = {
    [types.choiceNode] = {
      passive = { virt_text = { { '●', 'Comment' } } },
      active = { virt_text = { { '●', 'CmpItemKindClass' } } },
    },
    [types.insertNode] = {
      passive = { virt_text = { { '●', 'Comment' } } },
      active = { virt_text = { { '●', 'String' } } },
    },
  },
})

vim.defer_fn(function()
  require('luasnip.loaders.from_vscode').lazy_load()
  require('luasnip.loaders.from_vscode').lazy_load({ paths = { '~/dotfiles/nvim/.vsnip' } })
end, 100)

-- some shorthands...
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

ls.add_snippets('lua', {
  s('req', fmt("local {} = require('{}')", { i(1, 'module'), rep(1) })),
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
}, { key = 'my_lua_snips' })

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
}, { key = 'my_dart_snips' })

ls.add_snippets({ 'scss', 'css' }, {
  s('v', fmt('var(--{1})', { i(1) })),
}, { key = 'my_css_snips' })
