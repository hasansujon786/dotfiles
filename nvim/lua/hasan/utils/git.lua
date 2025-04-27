local M = {}

--- Get date as YY/MM/DD HH:MM:SSxx
---@return string|osdate
local function get_formatted_time()
  return os.date('%y/%m/%d %H:%M:%S')
end

local function try_git_push(cwd)
  local git_push = require('plenary.job'):new({ command = 'git', args = { 'push' }, cwd = cwd })
  git_push:after_failure(vim.schedule_wrap(function(_)
    git_push = nil
    vim.notify('Someting went wrong while git push', 'error', { title = 'Vault' })
  end))
  git_push:after_success(vim.schedule_wrap(function(_)
    git_push = nil
    vim.notify('Successfully pushed to repo', 'info', { title = 'Vault' })
  end))

  vim.notify('Git pushing...', 'error', { title = 'Vault' })
  git_push:start()
end

local function has_local_commits_to_push(cwd)
  local git_status =
    require('plenary.job'):new({ command = 'git', args = { 'status', '--porcelain=2', '--branch' }, cwd = cwd })
  local ok, output = pcall(function()
    return git_status:sync()
  end)

  if not ok then
    return false
  end

  for _, line in ipairs(output) do
    if line:match('^# branch%.ab') then
      -- Extract ahead and behind counts (e.g., # branch.ab +2 -1)
      local ahead = tonumber(line:match('+%d+')) or 0
      if ahead > 0 then
        return true -- Local commits exist that can be pushed
      else
        return false -- No local commits to push
      end
    end
  end

  return false
end

local function try_git_commit(cwd)
  local date = get_formatted_time()
  local git_commit = require('plenary.job'):new({ command = 'git', args = { 'acm', date }, cwd = cwd })
  git_commit:after_failure(vim.schedule_wrap(function(_)
    git_commit = nil
    vim.notify('Someting went wrong while git commit', 'error', { title = 'Vault' })
  end))
  git_commit:after_success(vim.schedule_wrap(function(_)
    git_commit = nil

    if has_local_commits_to_push() then
      try_git_push(cwd)
      return
    end
  end))
  git_commit:start()
end

function M.auto_commit(cwd)
  local exists = require('hasan.utils.file').dir_exists(cwd)
  if not exists then
    vim.notify(string.format('Could not found given directory `%s`', cwd), 'error', { title = 'Vault' })
    return
  end

  local git_status = require('plenary.job'):new({ command = 'git', args = { 'status', '--porcelain' }, cwd = cwd })
  git_status:after_failure(vim.schedule_wrap(function(_)
    git_status = nil
    vim.notify('Nothing to commit', 'error', { title = 'Vault' })
  end))
  git_status:after_success(vim.schedule_wrap(function(job)
    git_status = nil

    local status_output = job:result()
    if status_output == false or #status_output == 0 then
      if has_local_commits_to_push() then
        vim.notify('pushing from status', 'info', { title = 'Vault' })
        try_git_push(cwd)
        return
      end

      vim.notify('Nothing to commit', 'info', { title = 'Vault' })
      return
    end

    try_git_commit(cwd)
  end))
  git_status:start()
end

local cwd = '~/my_vault/'
cwd = '~/dotfiles/'
M.auto_commit(cwd)

return M
