-- local common = require('hasan.utils.snip')
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

ls.add_snippets('lua', {
  -- s(
  --   'rq',
  --   fmt("local {} = require('{}')", {
  --     f(function(import_name)
  --       local parts = vim.split(import_name[1][1], '.', true)
  --       return parts[#parts]
  --     end, { 1 }),
  --     i(1),
  --   })
  -- ),
  -- s(
  --   'schedule-timer',
  --   fmt(
  --     [[
  --     local timer = vim.loop.new_timer()
  --     timer:start(0, 3000, vim.schedule_wrap(function()
  --       -- timer:close()
  --       {}
  --     end))
  --     ]],
  --     {
  --       i(0, '-- write something'),
  --     }
  --   )
  -- ),
  s(
    'metaclass',
    fmta(
      [[
      local <name> = {}
      <module_name>.__index = <module_name>

      ---@param initial_opts table
      function <module_name>:new(initial_opts)
        return setmetatable({
          opts = initial_opts,
        }, self)
      end

      ---@param opts table
      function <module_name>:configure(opts)
        self.opts = opts
      end

      return <module_name>
      ]],
      {
        name = i(1, 'Module'),
        module_name = rep(1),
      }
    )
  ),
}, { key = 'my_lua_snips' })
