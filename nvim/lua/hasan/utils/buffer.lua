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

return M
