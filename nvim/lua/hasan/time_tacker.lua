local M = {}

M.state = {
  --- @type boolean
  active = false, -- is tracker active
  --- @type { [number]: { id: number, timestamp: number } } -- client id -> {id, timestamp}
  timestamps = {}, -- last activity time for each client
  --- @type integer|nil
  group_id = nil, -- autocommand group id for tracking
}

function M.track()
  vim.api.nvim_create_autocmd({ 'ModeChanged', 'BufEnter' }, {
    group = M.state.group_id,
    desc = 'Hypnos idle: debounce client detach',
    callback = function(args)
      local buf = args.buf
      vim.tbl_map(
        --- @param client vim.lsp.Client
        function(client)
          M.update(client.id)
        end,
        vim.lsp.get_clients({ bufnr = buf })
      )
    end,
  })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = M.state.group_id,
    desc = 'Hypnos idle: register new LSP clients',
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client then
        M.update(client.id)
      end
    end,
  })
end

--- @param client_id number
function M.update(client_id)
  M.state.timestamps[client_id] = { id = client_id, timestamp = vim.uv.now() }
end

--- @param client_id number
--- Get the last activity timestamp for a client
--- @return number|nil
function M.get(client_id)
  local stamp = M.state.timestamps[client_id]
  return stamp and stamp.timestamp
end

--- @param client_id number
function M.remove(client_id)
  M.state.timestamps[client_id] = nil
end

--- Get all tracked client times
--- @return { [number]: { id: number, timestamp: number } }
function M.get_times()
  return M.state.timestamps
end

function M.stop()
  if not M.state.active then
    return
  end
  M.state.active = false
  if M.state.group_id then
    vim.api.nvim_clear_autocmds({ group = M.state.group_id })
    vim.api.nvim_del_augroup_by_name('HypnosTracker')
    M.state.group_id = nil
  end
end

function M.reset()
  M.start(true)
end

--- @param reset? boolean
function M.start(reset)
  M.state.active = true
  M.state.timestamps = M.state.timestamps or {}
  if reset == true then
    M.state.timestamps = {}
  end
  M.state.group_id = vim.api.nvim_create_augroup('HypnosTracker', {})
  vim.tbl_map(function(client)
    M.state.timestamps[client.id] = { id = client.id, timestamp = vim.uv.now() }
  end, vim.lsp.get_clients())
  M.track()
end

function M.toggle()
  if M.state.active then
    M.stop()
  else
    M.start()
  end
end

function M.init()
  if M.state.active then
    return
  end
  M.start()
end
-- require("hasan.time_tacker").toggle()
return M
