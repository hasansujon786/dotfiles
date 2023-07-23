local ls = require('luasnip')
local shared = require('snips.js_shared')

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
  shared.exim,
  shared.eximDefault,
}, { key = 'my_ts_snips' })
