local M = {}

---@param text string
---@param opts? {sl?:string,tl?:string}
local function open_translate(text, opts)
  opts = opts or {}
  local src_lang = opts.sl or 'en'
  local tgt_lang = opts.tl or 'bl'

  local url_template = 'https://translate.google.com/?sl=%s&tl=%s&text=%s&op=translate'
  local encoded = vim.uri_encode(text)
  vim.ui.open(string.format(url_template, src_lang, tgt_lang, encoded))
end

M.translate = function(ctx)
  local text = require('hasan.utils.visual').get_range_or_visual_text(ctx.range) or vim.fn.expand('<cword>')
  open_translate(text)
end

local function open_google(query)
  if not query or query == '' then
    return
  end

  local url_template = 'https://www.google.com/search?q=%s'
  local search_query = query:gsub(' ', '+')
  vim.ui.open(string.format(url_template, search_query))
end

M.search_with_google = function(ctx)
  local text = require('hasan.utils.visual').get_range_or_visual_text(ctx.range)

  if text then
    return open_google(text)
  end

  vim.ui.input({ prompt = 'Search on Google', icon = ' ' }, function(input)
    open_google(input)
  end)
end

return M
