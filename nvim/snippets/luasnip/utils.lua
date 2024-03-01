local utils = {}

utils.choiceSemicolon = function(args)
  local choice = args[1][1]
  if choice == '' then
    return ''
  end
  return ';'
end

utils.comment_chars = function(_, _, _)
  return require('luasnip.util.util').buffer_comment_chars()[1]
end

utils.get_insert_node = function(args)
  return args[1][1]
end

utils.get_insert_node_and_upper_first_char = function(args)
  return args[1][1]:gsub('^%l', string.upper)
end

utils.filename = function()
  local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':t:r')
  return fname or 'FILENAME'
end

return utils
