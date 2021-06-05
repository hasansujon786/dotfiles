-- Global functions
P = function(...)
  local objects = vim.tbl_map(vim.inspect, {...})
  print(unpack(objects))
end
-- imports
require('hasan/telescope')



