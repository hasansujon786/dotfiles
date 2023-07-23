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

local shared = {
  jsxClassName = s('cn', fmt([[className='{}']], { i(0) })),
  exim = s('exim', fmt([[export * from './{}']], { i(0) })),
  eximDefault = s('eximDefault', fmt([[export {{ default as {} }} from './{}']], { i(0, 'packageName'), i(1) })),
}

return shared
