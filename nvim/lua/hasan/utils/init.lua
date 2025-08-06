local M = {}

M.select = function(prompt, choices, callback)
  vim.ui.select(choices, { prompt = prompt }, callback)
end

M.reload_this_module = function()
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':.')
  local m_name = M.get_module_name(path)
  R(m_name, 'module reloaded')
end

M.get_module_name = function(path)
  local m_name = vim.fs.normalize(path)
  m_name = m_name:gsub('nvim/', '')
  m_name = m_name:gsub('lua/', '')
  m_name = m_name:gsub('/init', '')
  m_name = m_name:gsub('%.lua', '')
  return m_name:gsub('/', '.')
end

M.get_default = function(x, default)
  return M.if_nil(x, default, x)
end

M.if_nil = function(x, was_nil, was_not_nil)
  if x == nil then
    return was_nil
  else
    return was_not_nil
  end
end

function M.tbl_length(T)
  local count = 0
  for _ in pairs(T) do
    count = count + 1
  end
  return count
end

function M.tbl_isempty(T)
  if not T or not next(T) then
    return true
  end
  return false
end

function M.tbl_concat(...)
  local result = {}
  local n = 0

  for _, t in ipairs({ ... }) do
    for i, v in ipairs(t) do
      result[n + i] = v
    end
    n = n + #t
  end

  return result
end

M.is_floating_win = function(winid)
  return vim.api.nvim_win_get_config(winid).relative ~= ''
end

M.get_os = function()
  --[[
Target OS names:
  - Windows
  - Linux
  - OSX
  - BSD
  - POSIX
  - Other
--]]

  -- We make use of JIT because LuaJIT is bundled in Neovim
  return jit.os
end

M.is_windows = function()
  local has = vim.fn.has('win32') or vim.fn.has('wsl')
  return has == 1
end

-- Search if a table have the value we are looking for,
-- useful for plugins management
M.has_value = function(tabl, val)
  for _, value in ipairs(tabl) do
    if value == val then
      return true
    end
  end

  return false
end

-- Check if string is empty or if it's nil
-- @return bool
M.is_empty = function(str)
  return str == '' or str == nil
end

M.map = function(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

M.open_git_remote = function(open_with_file)
  local Job = require('plenary.job')
  local fpath = nil
  if not vim.bo.readonly and vim.bo.modifiable then
    fpath = vim.fs.normalize(vim.fn.expand('%'))
  end

  local j = Job:new({
    command = 'git',
    args = { 'config', '--get', 'remote.origin.url' },
    cwd = vim.fn.expand('%:p:h'),
  })
  local k = Job:new({
    command = 'git',
    -- args = {'rev-parse', '--abbrev-ref', 'HEAD'},
    args = { 'branch', '--show-current' },
    cwd = vim.fn.expand('%:p:h'),
  })

  local ok_remote, remote_root = pcall(function()
    return vim.trim(j:sync()[1])
  end)
  local ok_branch, branch = pcall(function()
    return vim.trim(k:sync()[1])
  end)

  if ok_remote and ok_branch then
    local full_remote_path = remote_root
    if fpath and open_with_file then
      full_remote_path = string.format('%s/blob/%s/%s', remote_root, branch, fpath)
    end

    vim.ui.open(full_remote_path)
    vim.notify(full_remote_path, vim.log.levels.INFO)
  else
    return ''
  end
end

-- opts = utils.merge({
--   timeout = 2000,
-- }, opts or {})
M.merge = function(...)
  return vim.tbl_deep_extend('force', ...)
end

---Get index of given value
---@param tbl table
---@param value any
---@return integer
M.index_of = function(tbl, value)
  for i, el in ipairs(tbl) do
    if el == value then
      return i
    end
  end
  return -1
end

M.flatten = (function()
  if vim.fn.has('nvim-0.11') == 1 then
    return function(t)
      return vim.iter(t):flatten():totable()
    end
  else
    return function(t)
      return vim.tbl_flatten(t)
    end
  end
end)()

return M
