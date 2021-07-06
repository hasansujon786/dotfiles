-- Global functions
-- P = function(...)
--   local objects = vim.tbl_map(vim.inspect, {...})
--   print(unpack(objects))
-- end
P = function(v)
  print(vim.inspect(v))
  return v
end

if pcall(require, 'plenary') then
  RELOAD = require('plenary.reload').reload_module


  R = function(name)
    RELOAD(name)
    print(string.format('[%s] - module reloaded', name))
    return require(name)
  end
end

