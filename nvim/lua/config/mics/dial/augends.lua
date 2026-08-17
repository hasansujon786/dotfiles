function custom_augend()
  local augend = require('dial.augend')
  local toggle = function(...)
    return require('dial.augend').constant.new(...)
  end

  local M = {}

  M.typescript_types = toggle({
    elements = { 'number', 'string', 'boolean', 'unknown', 'any', 'void', 'null', 'undefined', 'never', 'bigint' },
    word = false,
  })

  M.http = toggle({
    elements = { 'GET', 'POST', 'PUT', 'PATCH', 'DELETE' },
    word = false,
  })

  M.todo_status = toggle({
    elements = { 'TODO:', 'DONE:', 'INFO:', 'FIXME:', 'BUG:', 'FIXIT:', 'ISSUE:', 'OPTIM:', 'OPTIMIZE:' },
    word = false,
  })

  return M
end

return {
  custom_augend = custom_augend,
}
