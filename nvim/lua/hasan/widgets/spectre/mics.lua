local M = {}

function M.open_quickfix()
  local spectre_state = require('spectre.state')
  local results = spectre_state.groups
  if not results then
    return vim.notify('There is no item', vim.log.levels.INFO, { title = 'Spectre' })
  end

  -- Flatten results into quickfix format
  local qf_list = {}
  for _, file_results in pairs(results) do
    for _, item in ipairs(file_results) do
      table.insert(qf_list, {
        filename = item.filename,
        lnum = item.lnum,
        col = item.col,
        text = item.text,
      })
    end
  end

  vim.fn.setqflist(qf_list, 'r') -- 'r' replaces the list
  vim.cmd('copen')
end

return M
