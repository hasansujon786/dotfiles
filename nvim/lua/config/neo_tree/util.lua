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

M.copy_path = function(state, modifire)
  local node = state.tree:get_node()
  local path_name = node.path
  if modifire ~= nil then
    path_name = vim.fn.fnamemodify(node.path, modifire)
  end
  path_name = vim.fs.normalize(path_name)
  vim.fn.setreg('+', path_name)
  notify(path_name, vim.log.levels.TRACE, { title = 'Neotree' })
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

  local readonly = vim.api.nvim_buf_get_option(0, 'readonly')
  local modifiable = vim.api.nvim_buf_get_option(0, 'modifiable')

  if readonly or not modifiable then
    vim.cmd([[Neotree filesystem position=current]])
  else
    vim.cmd([[Neotree filesystem position=current dir=%:p:h reveal_file=%:p]])
  end
end

function M.edit_alternate_file()
  if vim.o.filetype == 'neo-tree' then
    if vim.b['neo_tree_position'] == 'current' then
      return feedkeys('<c-^>')
    end
    return feedkeys('q')
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
