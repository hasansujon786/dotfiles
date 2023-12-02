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

function M.toggle(option, silent)
  local info = vim.api.nvim_get_option_info(option)
  local scopes = { buf = 'bo', win = 'wo', global = 'o' }
  local scope = scopes[info.scope]
  local options = vim[scope]
  options[option] = not options[option]
  if silent ~= true then
    if options[option] then
      M.Logger:log('enabled vim.' .. scope .. '.' .. option)
    else
      M.Logger:warn('disabled vim.' .. scope .. '.' .. option)
    end
  end
end

return M
