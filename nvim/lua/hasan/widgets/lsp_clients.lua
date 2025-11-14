local text_utils = require('super-kanban.utils.text')
local hl_utils = require('hasan.utils.hl')
local ns = vim.api.nvim_create_namespace('ns_lsp_clients')

---Create segments for lines
---@param text string
---@param hl? string
---@return table
local function t(text, hl)
  return { text, hl }
end

local M = {}

function M.show()
  local buf = vim.api.nvim_get_current_buf()
  local path = vim.api.nvim_buf_get_name(0)
  local filename = (path == '' and '[No Name]') or path:match('([^/\\]+)[/\\]*$')

  local width = #filename + 14
  local lines = {}

  vim.list_extend(lines, {
    { t('# Active Clients', '@variable') },
  })

  local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
  for _, client in pairs(clients) do
    vim.list_extend(lines, {
      { t(' - '), t(client.name), t(' (id:' .. client.id .. ')') },
    })
    if #client.name + 4 > width then
      width = #client.name + 4
    end
  end

  vim.list_extend(lines, {
    { t('# Buffer ', '@variable'), t(tostring(buf), 'Number') },
    { t('# Buffer Name ', '@variable'), t(filename, 'string') },
  })

  local win = Snacks.win({
    width = width,
    max_width = 100,
    height = #clients + 3,
    enter = true,
    row = vim.o.lines - 1,
    col = vim.o.columns,
    wo = {
      winhighlight = hl_utils.winhighlight({
        Normal = 'NormalFloatFlat',
        NormalNC = 'NormalFloatFlat',
        FloatBorder = 'FloatBorderFlatHidden',
      }),
    },
    border = 'hpad',
    anchor = 'SW',
  })

  win:on({ 'BufLeave', 'WinLeave' }, function()
    win:destroy()
  end, { buf = true })

  text_utils.render_lines(win.buf, ns, lines)
end

return M
