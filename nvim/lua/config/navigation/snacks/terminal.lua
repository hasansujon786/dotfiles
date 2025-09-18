local index = nil

local function open_term(is_previous, opts)
  opts = opts or {}
  local list = Snacks.terminal.list()

  local buf = vim.api.nvim_get_current_buf()
  local conf = vim.b[buf].snacks_terminal
  local is_snacks_term = conf ~= nil

  if #list < 1 then
    if not opts.hide_empty_msg then
      vim.notify('There is no opened terminal', 'info', { title = 'Snacks' })
    end
    return false
  end

  if is_snacks_term and type(index) == 'number' then
    -- Show warn msg about the end of the cycle
    if not is_previous and index == #list then
      vim.notify('No next terminal', 'info', { title = 'Snacks' })
      return false
    elseif is_previous and index == 1 then
      vim.notify('No previous terminal', 'info', { title = 'Snacks' })
      return
    end

    -- Close current opened term
    local term = list[index]
    if term and not term.closed then
      term:hide()
    end
  end

  -- If term is not opened then open the last open term
  if type(index) ~= 'number' then
    index = is_previous and #list or 1
  elseif is_snacks_term and type(index) == 'number' then
    -- Cycle term
    index = index + (is_previous and -1 or 1)
  end

  -- Check if the index is inside the list
  if index > #list or index < 1 then
    index = 1
  end

  local term = list[index]
  if term == nil then
    return false
  end

  -- Open term
  if term.closed then
    local win = term:show()

    if opts.open_in_normal_mode then
      vim.defer_fn(function()
        feedkeys('<C-\\><C-n>')
      end, 10)
    end

    return win
  end
end

local M = {}

function M.next()
  return open_term(false, { open_in_normal_mode = true })
end
function M.prev()
  return open_term(true, { open_in_normal_mode = true })
end

function M.toggle()
  local ft = vim.o.ft
  if ft == 'snacks_terminal' or ft == 'terminal' then
    return vim.cmd([[close]])
  end

  -- Open last opened term
  local opened = open_term(false, { hide_empty_msg = true })

  -- Or create a new term
  if not opened then
    Snacks.terminal(nil, { shell = 'bash', win = { position = 'float' } })
  end
end

return M
