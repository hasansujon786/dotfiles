local Job = require('plenary.job')

local Path = require('plenary.path')
local function normalize_path(buf_name, root)
  return Path:new(buf_name):make_relative(root)
end

local M = {}

M.get_root_dir = function()
  return vim.loop.cwd()
end

--- @param buffer buffer
--- @return string
M.get_buf_name_relative = function(buffer)
  return normalize_path(vim.api.nvim_buf_get_name(buffer), M.get_root_dir())
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

local on_windows = vim.loop.os_uname().version:match('Windows')
function M.join_paths(...) -- Function from nvim-lspconfig
  local path_sep = on_windows and '\\' or '/'
  local result = table.concat({ ... }, path_sep)
  return result
end

function M.quickLook(args)
  local bg_job = nil
  bg_job = Job:new({
    command = 'C:\\Users\\hasan\\AppData\\Local\\Programs\\QuickLook\\QuickLook.exe',
    args = args,
    -- cwd = vim.loop.cwd(),
  })
  bg_job:start()

  -- bg_job:after_success(vim.schedule_wrap(function(_)
  --   -- on_pub_get(j:result())
  --   bg_job = nil
  --   P('after_success')
  -- end))
  bg_job:after_failure(vim.schedule_wrap(function(_)
    -- on_pub_get(j:stderr_result(), true)
    bg_job = nil
    vim.notify('There someting went wrong while opening QuickLook', vim.log.levels.WARN)
  end))
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
