local M = {}

M.select = function(prompt, choices, callback)
  vim.ui.select(choices, { prompt = prompt }, callback)
end

M.reload_this_module = function()
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':.')
  local m_name = require('hasan.utils').normalise_path(path)

  m_name = m_name:gsub('nvim/', '')
  m_name = m_name:gsub('lua/', '')
  m_name = m_name:gsub('/init', '')
  m_name = m_name:gsub('%.lua', '')
  m_name = m_name:gsub('/', '.')
  R(m_name, 'module reloaded')
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

M.is_floting_window = function(winid)
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

M.is_file_exist = function(path)
  local f = io.open(path, 'r')
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

M.get_relative_fname = function()
  local fname = vim.fn.expand('%:p')
  return fname:gsub(vim.fn.getcwd() .. '/', '')
end

M.read_file = function(path)
  local fd = vim.loop.fs_open(path, 'r', 438)
  local stat = vim.loop.fs_fstat(fd)
  local data = vim.loop.fs_read(fd, stat.size, 0)
  vim.loop.fs_close(fd)

  return data
end

-- write_file writes the given string into given file
-- @tparam string path The path of the file
-- @tparam string content The content to be written in the file
-- @tparam string mode The mode for opening the file, e.g. 'w+'
M.write_file = function(path, content, mode)
  -- 644 sets read and write permissions for the owner, and it sets read-only
  -- mode for the group and others.
  vim.loop.fs_open(path, mode, tonumber('644', 8), function(err, fd)
    if not err then
      local fpipe = vim.loop.new_pipe(false)
      vim.loop.pipe_open(fpipe, fd)
      vim.loop.write(fpipe, content)
    end
  end)
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

-- For autocommands, extracted from
-- https://github.com/norcalli/nvim_utils
M.create_augroups = function(definitions)
  for group_name, definition in pairs(definitions) do
    vim.api.nvim_command('augroup ' .. group_name)
    vim.api.nvim_command('autocmd!')
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten({ 'autocmd', def }), ' ')
      vim.api.nvim_command(command)
    end
    vim.api.nvim_command('augroup END')
  end
end

M.open_git_remote = function(openRoot)
  local Job = require('plenary.job')
  local fpath = nil
  local isReadonly = vim.api.nvim_buf_get_option(0, 'readonly')
  local isModifiable = vim.api.nvim_buf_get_option(0, 'modifiable')
  if not isReadonly and isModifiable then
    fpath = vim.fn.expand('%')
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
    if fpath and not openRoot then
      full_remote_path = string.format('%s/blob/%s/%s', remote_root, branch, fpath)
    end

    vim.cmd('OpenURL ' .. full_remote_path)
    print(full_remote_path)
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

M.index_of = function(tbl, item)
  for i, val in ipairs(tbl) do
    if val == item then
      return i
    end
  end
end

M.Logger = {}
M.Logger.__index = M.Logger

local function log(type, msg, opts)
  local title = 'msg title'
  local ok, notify = pcall(require, 'notify')
  if ok then
    notify(
      msg,
      type,
      M.merge({
        title = title,
      }, opts)
    )
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

M.augroup = function(group)
  -- local id = vim.api.nvim_create_augroup(group, { clear = true })
  vim.api.nvim_create_augroup(group, { clear = true })

  return function(autocmds)
    autocmds(function(event, command, opts)
      opts = opts and opts or {}
      -- opts.group = id
      opts.group = group
      local is_function = type(command) == 'function'
      opts.callback = is_function and command or nil
      opts.command = not is_function and command or nil

      vim.api.nvim_create_autocmd(event, opts)
    end)
  end
end
-- local NULL_LS_AUGROUP = augroup('NULL_LS_AUGROUP')
-- NULL_LS_AUGROUP(function(autocmd)
--   -- autocmd({ 'BufWritePre' }, { buffer = bufnr }, function()
--   --   vim.lsp.buf.formatting_sync()
--   -- end)

--   -- Also you can add a many autocmds as you'd like here
--   -- For example:
--   local count = 1
--   autocmd({ 'CursorMoved' }, { buffer = vim.api.nvim_win_get_buf(0) }, function()
--     print(string.format('cursor moved %d times', count))
--     count = count + 1
--   end)
-- end)

function M.normalise_path(path_to_normalise)
  local normalised_path = path_to_normalise:gsub('\\', '/'):gsub('//', '/')

  if M.is_windows() then
    normalised_path = normalised_path:sub(1, 1):lower() .. normalised_path:sub(2)
  end

  return normalised_path
end

function M.is_visual_mode()
  local mode = vim.api.nvim_get_mode().mode
  return mode == 'v' or mode == 'V' or mode == '', mode
end

function M.get_visual_selection()
  -- this will exit visual mode
  -- use 'gv' to reselect the text
  local _, csrow, cscol, cerow, cecol
  local mode = vim.fn.mode()
  if mode == 'v' or mode == 'V' or mode == '' then
    -- if we are in visual mode use the live position
    _, csrow, cscol, _ = unpack(vim.fn.getpos('.'))
    _, cerow, cecol, _ = unpack(vim.fn.getpos('v'))
    if mode == 'V' then
      -- visual line doesn't provide columns
      cscol, cecol = 0, 999
    end
    -- exit visual mode
    _G.feedkeys('<Esc>', 'n')
  else
    -- otherwise, use the last known visual position
    _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
    _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
  end
  -- swap vars if needed
  if cerow < csrow then
    csrow, cerow = cerow, csrow
  end
  if cecol < cscol then
    cscol, cecol = cecol, cscol
  end
  local lines = vim.fn.getline(csrow, cerow)
  -- local n = cerow-csrow+1
  local n = M.tbl_length(lines)
  if n <= 0 then
    return ''
  end
  lines[n] = string.sub(lines[n], 1, cecol)
  lines[1] = string.sub(lines[1], cscol)
  return table.concat(lines, '\n')
end

return M
