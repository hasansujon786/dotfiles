local is_visual = function()
  -- vim.api.nvim_get_mode().mode is always "n", so using this instead:
  return vim.fn.visualmode() == 'V'
end

local move = function(address, should_move)
  if is_visual() and should_move then
    vim.cmd("'<,'>move " .. address)
    vim.api.nvim_feedkeys('gv=', 'n', true)
  end
  vim.api.nvim_feedkeys('gv', 'n', true)
end

local M = {
  norm_move_down = function()
    if not vim.o.modifiable then
      return feedkeys('j', 'v')
    end
    vim.cmd.move('+1')
    feedkeys('==', 'n')
  end,
  norm_move_up = function()
    if not vim.o.modifiable then
      return feedkeys('k', 'v')
    end
    vim.cmd.move('-2')
    feedkeys('==', 'n')
  end,
  move_down = function(lastline)
    if not vim.o.modifiable then
      feedkeys('gv', 'n')
      return feedkeys('j', 'v')
    end
    local count = vim.v.count == 0 and 1 or vim.v.count
    local max = vim.fn.line('$') - lastline
    local movement = vim.fn.min({ count, max })
    local address = "'>+" .. movement
    local should_move = movement > 0
    move(address, should_move)
  end,

  move_up = function(firstline)
    if not vim.o.modifiable then
      feedkeys('gv', 'n')
      return feedkeys('k', 'v')
    end
    local count = vim.v.count == 0 and -1 or -vim.v.count
    local max = (firstline - 1) * -1
    local movement = vim.fn.max({ count, max })
    local address = "'<" .. (movement - 1)
    local should_move = movement < 0
    move(address, should_move)
  end,
}

M.add_file_to_buflist = function(filename)
  local set_position = false
  filename = vim.fn.fnameescape(filename)
  local bufnr = vim.fn.bufnr(filename)

  if bufnr == -1 then
    set_position = true
    bufnr = vim.fn.bufnr(filename, true)
  end
  if not vim.api.nvim_buf_is_loaded(bufnr) then
    vim.fn.bufload(bufnr)
    vim.api.nvim_set_option_value('buflisted', true, { buf = bufnr })
  end
  return bufnr, set_position
end

function M.parse_cursor_text(bufnr)
  local root = vim.treesitter.get_node({ bufnr = bufnr })
  if not root then
    return
  end

  local root_type = root:type()
  if root_type == 'string_fragment' or root_type == 'string' or root_type == 'string_content' then
    return vim.treesitter.get_node_text(root, bufnr)
  end

  local function find_node(node)
    for child in node:iter_children() do
      local type = child:type()
      if type == 'string_fragment' or type == 'string' or type == 'string_content' then
        return vim.treesitter.get_node_text(child, bufnr)
      end
      local found = find_node(child)
      if found then
        return found
      end
    end
  end

  return find_node(root)
end

function M.parse_img_str_at_cursor()
  local buf = vim.api.nvim_get_current_buf()
  local text = require('hasan.utils.buffer').parse_cursor_text(buf)
  if type(text) ~= 'string' or text == '' then
    return nil
  end

  local file = vim.fs.normalize(vim.api.nvim_buf_get_name(buf))
  local dir = vim.fs.dirname(file)
  local absolute_path = require('hasan.utils.file').resolve_relative_path(dir, text)

  if vim.fn.filereadable(absolute_path) == 1 then
    return absolute_path
  end
end

return M
