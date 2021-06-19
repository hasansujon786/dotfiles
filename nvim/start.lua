-- Global functions
P = function(...)
  local objects = vim.tbl_map(vim.inspect, {...})
  print(unpack(objects))
end

-- plugins
require('plugin.telescope')
require('plugin.treesitter')



