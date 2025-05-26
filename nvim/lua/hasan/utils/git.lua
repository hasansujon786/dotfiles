local async = require('hasan.utils.async')
local M = {}

---Get date as YY/MM/DD HH:MM:SSxx
---@return string
local function get_formatted_time()
  return tostring(os.date('%y/%m/%d %H:%M:%S'))
end

---@param on_exit fun(boolean)
---@param opts {cwd:string}
local function has_local_changes(on_exit, opts)
  async.async_cmd('git', { 'status', '--porcelain' }, function(status_ok, status_msg)
    on_exit(status_ok and #status_msg > 0)
  end, opts)
end

---@param on_exit fun(boolean)
---@param opts {cwd:string}
local function has_local_commits_to_push(on_exit, opts)
  async.async_cmd('git', { 'status', '--porcelain=2', '--branch' }, function(ok, output)
    if not ok then
      return on_exit(false)
    end

    for _, line in ipairs(output) do
      if line:match('^# branch%.ab') then
        -- Extract ahead and behind counts (e.g., # branch.ab +2 -1)
        local ahead = tonumber(line:match('+%d+')) or 0
        if ahead > 0 then
          return on_exit(true)
        end
      end
    end

    return on_exit(false)
  end, opts)
end

---@param on_exit fun(boolean, any)
---@param opts {cwd:string}
local function git_commit(on_exit, opts)
  async.async_cmd('git', { 'add', '--all' }, function()
    async.async_cmd('git', { 'commit', '-m', get_formatted_time() }, on_exit, opts)
  end, opts)
end

---@param opts {cwd:string}
local function git_push(opts)
  vim.notify('Auto pushing...', 'info', { title = 'Auto Push' })
  async.async_cmd('git', { 'push' }, function(push_ok)
    if not push_ok then
      return vim.notify('Someting went wrong while git push', 'error', { title = 'Auto Push' })
    end

    vim.notify('Auto pushed ' .. opts.cwd, 'info', { title = 'Auto Push' })
  end, opts)
end

---@param cwd string
function M.auto_commit(cwd)
  local exists = require('hasan.utils.file').dir_exists(cwd)
  if not exists then
    vim.notify(string.format('Could not found given directory `%s`', cwd), 'error', { title = 'Auto Push' })
    return
  end

  local opts = { cwd = cwd }

  async.async_cmd('git', { 'pull', '--rebase' }, function()
    has_local_changes(function(has_changes)
      if not has_changes then
        has_local_commits_to_push(function(has_local_commits)
          if has_local_commits then
            return git_push(opts)
          end

          vim.notify('Nothing to commit in ' .. cwd, 'info', { title = 'Auto Push' })
        end, opts)
        return
      end

      git_commit(function(commit_ok)
        if not commit_ok then
          return vim.notify('Someting went wrong while git commit', 'error', { title = 'Auto Push' })
        end

        git_push(opts)
      end, opts)
    end, opts)
  end, opts)
end

return M
