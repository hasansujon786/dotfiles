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
  local plenary_reload = require('plenary.reload').reload_module


  R = function(name)
    plenary_reload(name)
    -- print(string.format('[%s] - module reloaded', name))
    return require(name)
  end
end

-- local disabled_built_ins = {
--   'netrw',
--   'netrwPlugin',
--   'netrwSettings',
--   'netrwFileHandlers',
--   'gzip',
--   'zip',
--   'zipPlugin',
--   'tar',
--   'tarPlugin',
--   'getscript',
--   'getscriptPlugin',
--   'vimball',
--   'vimballPlugin',
--   '2html_plugin',
--   'logipat',
--   'rrhelper',
--   'spellfile_plugin',
--   'matchit'
-- }

-- for _, plugin in pairs(disabled_built_ins) do
--   vim.g["loaded_" .. plugin] = 1
-- end

