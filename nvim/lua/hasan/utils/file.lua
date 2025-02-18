local Path = require('plenary.path')

-- local on_windows = vim.loop.os_uname().version:match('Windows')
local sysname = vim.uv.os_uname().sysname:lower()
local iswin = not not (sysname:find('windows') or sysname:find('mingw'))
local os_sep = iswin and '\\' or '/'

local M = {}

M.get_root_dir = function()
  return vim.loop.cwd()
end

--- @param buffer number
--- @return string
M.get_buf_name_relative = function(buffer)
  return Path:new(vim.api.nvim_buf_get_name(buffer)):make_relative(M.get_root_dir())
end

function M.convert_path_to_windows(path)
  return path:gsub('/', '\\')
end

function M.resolve_relative_path(base, relative)
  base = vim.fs.normalize(base)
  relative = vim.fs.normalize(relative)
  local base_parts = vim.split(base, '/', { plain = true })

  for part in relative:gmatch('[^/]+') do
    if part == '..' then
      table.remove(base_parts)
    elseif part ~= '.' then
      table.insert(base_parts, part)
    end
  end
  return table.concat(base_parts, '/')
end

function M.get_relative_path(current_path, asset_path)
  local type = require('hasan.utils.file').get_path_type(current_path)

  local from_parts = vim.split(current_path, '/', { plain = true })
  local to_parts = vim.split(asset_path, '/', { plain = true })

  if type == 'file' then
    table.remove(from_parts) -- Remove filename
  end

  -- Find common ancestor
  local common_idx = 1
  while from_parts[common_idx] and to_parts[common_idx] and from_parts[common_idx] == to_parts[common_idx] do
    common_idx = common_idx + 1
  end

  -- Construct relative path
  local up_moves = #from_parts - (common_idx - 1)
  local prefix = up_moves == 0 and './' or ('../'):rep(up_moves)

  return prefix .. table.concat(vim.list_slice(to_parts, common_idx), '/')
end

M.config_root = function()
  local pvim_config = os.getenv('PVIM')
  if pvim_config then
    return pvim_config .. '/config'
  end

  local config = vim.fn.stdpath('config')
  if type(config) == 'table' then
    return config[1]
  end
  return config
end

M.open_settings = function()
  local path = vim.fs.normalize(M.config_root() .. '/lua/core/state.lua')
  vim.cmd.split(path)
end

M.path_exists = function(fname, cwd)
  cwd = cwd and cwd or M.get_root_dir()
  local fpath = Path:new(cwd, fname)
  return fpath:exists(), fpath
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
  if fd == nil then
    return
  end

  local stat = vim.loop.fs_fstat(fd)
  if stat == nil then
    return
  end

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
      if fpipe == nil then
        return
      end

      vim.loop.pipe_open(fpipe, fd)
      vim.loop.write(fpipe, content)
    end
  end)
end

function M.openInCode(only_file)
  local positin = vim.api.nvim_win_get_cursor(0)
  local buf = vim.api.nvim_buf_get_name(0)
  local cmd = ''

  if only_file then
    cmd = string.format('! code --goto "%s":%d:%d', buf, positin[1], positin[2] + 1)
  else
    cmd = string.format('! code "%s" --goto "%s":%d:%d', vim.loop.cwd(), buf, positin[1], positin[2] + 1)
  end
  vim.cmd(cmd)
end

local js = {
  comment = '\\/\\/',
  log = 'console.log(',
}
local filetype_options = {
  lua = {
    comment = '--',
    log = 'print(',
  },
  dart = {
    comment = '\\/\\/',
    log = 'print(',
  },
  yaml = {
    comment = '\\#',
  },
  javascript = js,
  typescript = js,
  javascriptreact = js,
  typescriptreact = js,
}

function M.delete_lines_with(what_to_delete)
  local opts = filetype_options[vim.bo.filetype]
  if not opts or not opts[what_to_delete] then
    return
  end

  local prefix = '^\\s*'
  vim.cmd('g/' .. prefix .. opts[what_to_delete] .. '/d')
end

-- M.delete_all_lines_with('comment')
-- M.delete_all_lines_with('log')
-- require('hasan.utils.file').delete_lines_with('comment')

function M.reload()
  if vim.bo.buftype == '' then
    -- if vim.fn.exists(':LspStop') ~= 0 then
    --   vim.cmd('LspStop')
    -- end

    for name, _ in pairs(package.loaded) do
      if name:match('^config') or name:match('^hasan') or name:match('^core') then
        package.loaded[name] = nil
        R(name)
        -- P(name)
      end
    end
    P('Neovim reloaded')
  end
end

local qlook = {
  args = nil,
  map_added = false,
}

function M.quickLook(args)
  local bg_job = nil
  qlook.args = args

  bg_job = require('plenary.job'):new({
    command = 'C:\\Users\\hasan\\AppData\\Local\\Programs\\QuickLook\\QuickLook.exe',
    args = args,
    -- cwd = vim.loop.cwd(),
  })
  bg_job:start()

  bg_job:after_failure(vim.schedule_wrap(function(_)
    bg_job = nil
    vim.notify('There someting went wrong while opening QuickLook', vim.log.levels.WARN)
  end))

  bg_job:after_success(vim.schedule_wrap(function(_)
    bg_job = nil
  end))

  if not qlook.map_added then
    keymap('n', '<leader>vo', function()
      M.quickLook_close()
    end, { desc = 'Toggle quickLook' })
    qlook.map_added = true
  end
end

function M.quickLook_close()
  M.quickLook(qlook.args)
end

M.system_open_cmd = vim.fn.has('win32') == 1 and 'explorer.exe' or vim.fn.has('mac') == 1 and 'open' or 'xdg-open'

function M.system_open(file, opts)
  opts = opts or {}
  local args = opts.args or {}

  if M.system_open_cmd == 'explorer.exe' then
    file = file:gsub('/', '\\')
  end

  if opts.reveal == true then
    table.insert(args, '/select,')
  end

  table.insert(args, file)
  require('plenary.job'):new({ command = M.system_open_cmd, args = args }):start()
end

---Check if path is file or directory
---@param path any
---@return "file"|"directory"|nil
function M.get_path_type(path)
  local stat = vim.uv.fs_stat(path)
  if stat then
    if stat.type == 'file' then
      return 'file'
    elseif stat.type == 'directory' then
      return 'directory'
    end
  end
  return nil
end

---Crate file
---@param file_path string
---@param default_text string|nil
M.create_file = function(file_path, default_text)
  local fd = vim.uv.fs_open(file_path, 'w', 438) -- 438 = 0o666 permission
  if not fd then
    vim.notify('Error: Could not create ' .. file_path, 'error')
    return
  end

  if default_text then
    vim.uv.fs_write(fd, default_text)
  end
  vim.uv.fs_close(fd)
end

function M.create_from_tree(base_path, tree, callback)
  local function create_node(path, node)
    if node.type == 'file' then
      M.create_file(path, node.content)
    else
      -- Create directory
      vim.uv.fs_mkdir(path, 511) -- 511 = 0o777 permissions

      -- Recursively create children
      if node.children then
        for _, child in ipairs(node.children) do
          create_node(path .. '/' .. child.name, child)
        end
      end
    end
  end

  -- Start processing the tree
  for _, node in ipairs(tree) do
    create_node(base_path .. '/' .. node.name, node)
  end

  -- Call the callback function if provided
  if callback then
    callback()
  end
end

return M

-- del lines            %s/\v(print).*/
-- insert end of lines  %s/\v(regex).*\zs/ \1
-- wrap all lines with quote %s/^\|$/'/g

-- :g/\zs-- /d only first match from a line
-- :g/foo/d - Delete all lines containing the string “foo”. ...
-- :g!/foo/d - Delete all lines not containing the string “foo”.
-- :g/^#/d - Remove all comments from a Bash script. ...
-- :g/^$/d - Remove all blank lines. ...
-- :g/^\s*$/d - Remove all blank lines.
