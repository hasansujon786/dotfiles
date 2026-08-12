local hl_utils = require('hasan.utils.hl')
local text_utils = require('super-kanban.utils.text')
local ns = vim.api.nvim_create_namespace('ns_file_info')
local M = {}

---Create segments for lines
---@param text string
---@param hl? string
---@return table
local function seg(text, hl)
  return { text, hl }
end
local separator_char = '─'

M.open = function()
  local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':.')
  if fname == nil or fname == '' then
    fname = '[No Name]'
  end

  local last_line_num = vim.fn.line('$')
  local scroll = last_line_num > 0 and math.floor((vim.fn.line('.') * 100) / last_line_num) or 0

  local readonly = vim.bo.readonly
  local modified = vim.bo.modified
  local file_status = readonly and ' [Readonly]' or modified and ' [Modified]' or ''

  local line_text = string.format('"%s"%s %d lines --%d%%--', fname, file_status, last_line_num, scroll)
  local width = vim.fn.strdisplaywidth(line_text)

  local lines = {}
  local separator = nil

  local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
  if #clients > 0 then
    separator = string.rep(separator_char, math.max(width, 20))
    vim.list_extend(lines, {
      { seg('Active LSP Clients', 'String') },
    })
  end
  for _, client in pairs(clients) do
    vim.list_extend(lines, {
      { seg(' - '), seg(client.name), seg(' (id:' .. client.id .. ')', 'Boolean') },
    })
    local client_width = vim.fn.strdisplaywidth(client.name) + 4
    if client_width > width then
      width = client_width
    end
  end

  if separator ~= nil then
    vim.list_extend(lines, {
      { seg(separator, 'FloatBorder') },
    })
  end

  vim.list_extend(lines, {
    {
      seg(string.format('"%s"', fname), 'String'),
      seg(file_status, 'ErrorMsg'),
      seg(string.format(' %d lines', last_line_num), 'WarningMsg'),
      seg(string.format(' --%d%%--', scroll), 'DiagnosticInfo'),
    },
  })

  local win = Snacks.win({
    width = width,
    max_width = vim.o.columns,
    height = #lines,
    enter = false,
    row = vim.o.lines - 1,
    col = vim.o.columns,
    wo = {
      winhighlight = hl_utils.winhighlight({
        Normal = 'NormalFloat',
        FloatBorder = 'FloatBorder',
      }),
    },
    border = 'rounded',
    anchor = 'SW',
  })

  win:on({ 'BufLeave', 'WinLeave' }, function()
    win:destroy()
  end, { buf = true })

  text_utils.render_lines(win.buf, ns, lines)

  vim.defer_fn(function()
    if win and not win.closed then
      win:destroy()
    end
  end, 3000)
end

M.open()

return M
