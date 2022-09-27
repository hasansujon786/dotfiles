local common = {}

common.choiceSemicolon = function(args)
  local choice = args[1][1]
  if choice == '' then
    return ''
  end
  return ';'
end

common.comment_chars = function(_, _, _)
  return require('luasnip.util.util').buffer_comment_chars()[1]
end

return common
