local get_lua_files_path = function()
  local nvim_dir = vim.fn.stdpath('config')
  -- local dirs_to_check = { '/lua/*', '/lua/config/*', '/lua/lsp/*', '/lua/hasan/utils/*' }
  local dirs_to_check = { '/lua/*', '/lua/lsp/*', '/lua/hasan/utils/*' }
  local lua_dirs = {}
  for _, from in ipairs(dirs_to_check) do
    local sub_dirs = vim.fn.glob(nvim_dir .. from, 0, 1)
    table.insert(lua_dirs, sub_dirs)
  end

  local lua_files = vim.tbl_filter(function(p)
    return vim.fn.filereadable(p) == 1
  end, vim.tbl_flatten(lua_dirs))

  return lua_files
end

local reload_lua_modules = function()
  local system_slash = '\\'
  local nvim_dir = vim.fn.stdpath('config')
  local lua_files = get_lua_files_path()

  for _, dir in ipairs(lua_files) do
    dir = dir:gsub(nvim_dir .. system_slash, '')
    local ok = pcall(function()
      local m_name = require('hasan.utils').get_module_name(dir)
      R(m_name)
    end)

    if not ok then
      P(dir)
    end
  end
end

return {
  reload_lua_modules = reload_lua_modules,
}
