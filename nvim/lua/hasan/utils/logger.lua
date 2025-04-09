---@class Logger
---@overload fun(...: any): Logger
local M = setmetatable({}, {
  __call = function(t, ...)
    return t.info(...)
  end,
})
M.__index = M

M.log_file = vim.fn.stdpath('data') .. '/nvim.log'

-- Function to convert a table to a readable string
local function table_to_string(tbl, indent)
  if type(tbl) ~= 'table' then
    return tostring(tbl)
  end
  indent = indent or 0
  local to_return = '{\n'
  for k, v in pairs(tbl) do
    local key = tostring(k)
    local value = (type(v) == 'table') and table_to_string(v, indent + 2) or tostring(v)
    to_return = to_return .. string.rep(' ', indent + 2) .. '[' .. key .. '] = ' .. value .. ',\n'
  end
  return to_return .. string.rep(' ', indent) .. '}'
end

-- Function to join multiple arguments into a single string
local function format_message(...)
  local args = { ... }
  local parts = {}

  for _, v in ipairs(args) do
    if type(v) == 'table' then
      table.insert(parts, table_to_string(v))
    else
      table.insert(parts, tostring(v))
    end
  end

  return table.concat(parts, ' ') -- Join all parts with spaces
end

-- Function to write logs
local function write_log(level, ...)
  local file = io.open(M.log_file, 'a')
  if not file then
    return
  end

  local timestamp = os.date('%Y-%m-%d %H:%M:%S')
  local message = format_message(...)

  local log_entry = string.format('[%s] [%s] %s\n', timestamp, level, message)

  file:write(log_entry)
  file:close()
end

-- Log levels
function M.info(...)
  write_log('INFO', ...)
end

function M.warn(...)
  write_log('WARN', ...)
end

function M.error(...)
  write_log('ERROR', ...)
end

function M.debug(...)
  write_log('DEBUG', ...)
end

-- Function to view logs inside Neovim
function M.view()
  vim.cmd('edit ' .. M.log_file)
end

return M
