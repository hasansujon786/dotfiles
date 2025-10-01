local M = {}
-- function Foo()
--   P('alt=' .. vim.w.alt_file .. '| prealt=' .. vim.w.pre_alt_file)
-- end
M.isEmpty = function(s)
  return s == nil or s == ''
end
M.isNeoTreeWindow = function(name)
  return string.match(name, 'neo%-tree filesystem') ~= nil
      or string.match(name, 'neo%-tree buffers') ~= nil
      or string.match(name, 'neo%-tree git_status') ~= nil
end
M.save_altfile = function()
  vim.g.cwd = vim.loop.cwd()
  local alt = vim.fn.expand('%:p')
  local pre_alt = vim.fn.expand('#:p')
  if not M.isNeoTreeWindow(alt) then
    vim.w.alt_file = alt
  end
  if not M.isNeoTreeWindow(pre_alt) then
    vim.w.pre_alt_file = pre_alt
  end
end

M.copy_path = function(path_or_state, modifire)
  local path_name
  if type(path_or_state) == 'string' then
    path_name = path_or_state
  else
    local node = path_or_state.tree:get_node()
    path_name = node.path
  end
  if modifire ~= nil then
    path_name = vim.fn.fnamemodify(path_name, modifire)
  end
  path_name = vim.fs.normalize(path_name)

  vim.fn.setreg('+', path_name)
  vim.notify('Coppied ' .. path_name .. ' to clipboard', vim.log.levels.INFO, { title = 'Neotree' })
end

function M.vinegar_dir_up(state)
  local Path = require('plenary.path')
  -- local node = state.tree:get_node()
  -- P(node.is_last_child)

  local cur_dir = state.path
  local parent_dir = Path:new(cur_dir):parent()
  require('neo-tree.sources.filesystem').navigate(state, parent_dir.filename, cur_dir)
end

function M.open_vinegar()
  M.save_altfile()
  local reveal_file = vim.fn.expand('%:p')
  if (reveal_file == '') then
    reveal_file = vim.fn.getcwd()
  else
    local f = io.open(reveal_file, "r")
    if (f) then
      f.close(f)
    else
      reveal_file = vim.fn.getcwd()
    end
  end

  local parent_dir = vim.fs.dirname(reveal_file)

  require('neo-tree.command').execute({
    action = "focus",
    source = "filesystem",
    position = "current",
    reveal_file = reveal_file, -- path to file or folder to reveal
    reveal_force_cwd = true,   -- change cwd without asking if needed
    dir = parent_dir
  })
end

function M.edit_alternate_file()
  if vim.o.filetype == 'neo-tree' then
    if vim.b['neo_tree_position'] == 'current' then
      return feedkeys('<c-^>')
    end
    return feedkeys('<C-w>p')
  end

  local alt_file = vim.w.alt_file
  local pre_alt_file = vim.w.pre_alt_file
  -- store curret native values
  local current_file = vim.fn.expand('%:p')
  local current_alt_file = vim.fn.expand('#:p')

  if not M.isEmpty(current_alt_file) and not M.isNeoTreeWindow(current_alt_file) then
    return feedkeys('<c-^>')
  end

  -- if alt is neo-tree
  if M.isNeoTreeWindow(current_alt_file) then
    if current_file == alt_file and not M.isEmpty(pre_alt_file) then
      return vim.cmd.edit(pre_alt_file)
    elseif current_file ~= alt_file and not M.isEmpty(alt_file) then
      return vim.cmd.edit(alt_file)
    else
      return vim.notify('E23: No alternate file', vim.log.levels.ERROR)
    end
  else
    if current_file == alt_file and not M.isEmpty(pre_alt_file) then
      return vim.cmd.edit(pre_alt_file)
    end
  end

  feedkeys('<c-^>')
end

return M
