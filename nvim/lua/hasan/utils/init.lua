local M = {}

M.reload_this_module = function ()
  local module_name = vim.fn.fnamemodify(vim.fn.expand('%'), ':r:gs?\\?.?:gs?nvim.lua.??')
  print(string.format('[%s] - module reloaded', module_name))
  R(module_name)
end

return M
