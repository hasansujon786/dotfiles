local M = {}

M.Logger = {}
M.Logger.__index = M.Logger

local function log(type, msg, opts)
  local title = 'msg title'
  local ok, notify = pcall(require, 'notify')
  if ok then
    notify(msg, type, require('hasan.utils').merge({ title = title }, opts))
  else
    if vim.tbl_islist(msg) then
      -- regular vim.notify can't take tables of strings
      local tmp_list = msg
      msg = ''
      for _, v in pairs(tmp_list) do
        msg = msg .. v
      end
    end

    vim.notify(msg, type)
  end
end

function M.Logger:log(msg, opts)
  log(vim.log.levels.INFO, msg, opts or {})
end

function M.Logger:warn(msg, opts)
  log(vim.log.levels.WARN, msg, opts or {})
end

function M.Logger:error(msg, opts)
  log(vim.log.levels.ERROR, msg, opts or {})
end

---Get index of given value
---@param array table
---@param value any
---@return integer|nil
local function indexOf(array, value)
  for i, v in ipairs(array) do
    if v == value then
      return i
    end
  end
  return nil
end

---Toggle vim option with ease
---@param option string
---@param given_states table
---@param silent boolean
function M.toggle(option, given_states, silent)
  local info = vim.api.nvim_get_option_info(option)
  local scopes = { buf = 'bo', win = 'wo', global = 'o' }
  local scope = scopes[info.scope]
  local options = vim[scope]

  if given_states ~= nil then
    local foundIndex = require('hasan.utils').index_of(given_states, options[option])
    if foundIndex == #given_states or foundIndex == -1 then
      options[option] = given_states[1]
    else
      options[option] = given_states[foundIndex + 1]
    end
  else
    options[option] = not options[option]
  end

  if silent ~= true then
    if options[option] and options[option] ~= '' then
      local msg = 'enabled vim.' .. scope .. '.' .. option
      if given_states ~= nil then
        msg = msg .. ' [' .. options[option] .. ']'
      end
      M.Logger:log(msg)
    else
      M.Logger:warn('disabled vim.' .. scope .. '.' .. option)
    end
  end
end

return M
