local M = {}

local get_lsp_client = function()
  local msg = 'LSP Inactive'
  local buf_ft = vim.bo.filetype
  local clients = vim.lsp.get_active_clients()
  if next(clients) == nil then
    return msg
  end
  local lsps = ''
  for _, client in ipairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
      if lsps == '' then
        lsps = client.name
      else
        if not string.find(lsps, client.name) then
          lsps = lsps .. ',' .. client.name
        end
      end
    end
  end
  if lsps == '' then
    return msg
  else
    return lsps
  end
end

M.lsp_status = {
  fn = function()
    local progress_message = vim.lsp.util.get_progress_messages()
    if #progress_message == 0 then
      return get_lsp_client()
    end

    local status = {}
    for _, msg in pairs(progress_message) do
      table.insert(status, (msg.percentage or 0) .. '%% ' .. (msg.title or ''))
    end
    return table.concat(status, ' ')
  end,
}

--     return '%='
M.tabs = {
  fn = function()
    local lastTabNr = vim.fn.tabpagenr('$')
    local curTabNr = vim.fn.tabpagenr()
    P(lastTabNr, curTabNr)
    local list = {}
    for i = 1, lastTabNr do
      if i == curTabNr then
        --  
        table.insert(list, '')
      else
        table.insert(list, '')
      end
    end
    P(table.concat(list, ' '))
    return table.concat(list, ' ')
  end,
}
-- require('hasan.utils.statusline').tabs.fn()

M.space_info = function()
  return "%{&expandtab?'Spc:'.&shiftwidth:'Tab:'.&shiftwidth}"
end

M.harpoon = {
  toggle = function()
    local ok, harpoon_mark = pcall(require, 'harpoon.mark')
    return ok and harpoon_mark.status() ~= ''
  end,
  fn = function()
    local ok, harpoon_mark = pcall(require, 'harpoon.mark')
    return ok and 'H:' .. harpoon_mark.status()
  end,
}

M.spell = {
  use_mode_hl = true,
  toggle = function()
    return vim.api.nvim_win_get_option(0, 'spell')
  end,
  fn = [[%"]],
}

M.readonly = {
  toggle = function()
    return not vim.bo.modifiable or vim.bo.readonly
  end,
  fn = [[%"]],
}

M.DapMessages = {
  -- display the dap messages only on the debugged file
  condition = function()
    local dap = prequire('dap')
    -- local session = dap_available and dap.session()
    local session = dap.session()
    if session then
      local filename = vim.api.nvim_buf_get_name(0)
      if session.config then
        local progname = session.config.program
        return filename == progname
      end
    end
    return false
  end,
  provider = function()
    local dap = prequire('dap')
    return ' ' .. dap.status() .. ' '
  end,
}

M.wrap = {
  use_mode_hl = true,
  toggle = function()
    return vim.api.nvim_win_get_option(0, 'wrap')
  end,
  fn = [[%"w]],
}

M.task_timer = {
  toggle = function()
    if vim.g.tt_loaded == 1 then
      return vim.fn['tt#is_running']() == 1 or vim.fn['hasan#tt#is_tt_paused']() == 1
    end
  end,
  fn = function()
    return vim.fn['hasan#tt#statusline_status']()
  end,
}

M.search_count = {
  fn = function()
    -- vim.fn.getreg('/')
    local res = vim.fn.searchcount({ maxcount = 1000, timeout = 500 })

    if res.total > 0 and vim.v.hlsearch == 1 and res.incomplete ~= 1 then
      return string.format('[%d/%d]', res.current, res.total)
    else
      return ''
    end
  end,
}

M.progress_bar = {
  fn = function()
    local sbar = { '▁', '▂', '▃', '▄', '▅', '▆', '▇' }
    local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_line_count(0)
    local i = math.floor(curr_line / lines * (#sbar - 1)) + 1
    return sbar[i]
  end,
}

return M
