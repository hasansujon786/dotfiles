local M = {}

function M.capitalize_first_char(str)
  return str:sub(1, 1):upper() .. str:sub(2)
end

function M.snake_to_camel_case(str)
  return str
    :gsub('_(%a)', function(letter)
      return letter:upper()
    end)
    :gsub('^%l', string.upper)
end

return M
