local NuiLine = require('nui.line')
local NuiText = require('nui.text')
local Widget = require('hasan.widgets')
local M = {}

local last_file_info_pop = nil
M.show_file_info = function()
  if last_file_info_pop ~= nil then
    last_file_info_pop:unmount()
  end

  local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':.') or '[No Name]'
  fname = NuiText(string.format('"%s"', fname))

  local last_line = vim.fn.line('$')
  local line_count = NuiText(string.format('%d lines', last_line), 'WarningMsg')
  local scroll = math.floor((vim.fn.line('.') * 100) / last_line)
  scroll = NuiText(string.format('--%d%%--', scroll), 'DiagnosticInfo')

  local readonly = vim.api.nvim_buf_get_option(0, 'readonly')
  local modified = vim.api.nvim_buf_get_option(0, 'modified')
  local file_status = NuiText(readonly and '[Readonly] ' or modified and '[Modified] ' or '', 'ErrorMsg')

  local gap = NuiText(' ')
  local line = NuiLine({ fname, gap, file_status, line_count, gap, scroll })

  local pop = Widget.get_notify_popup({
    size = { width = line:width() },
    border = { style = 'rounded' },
  }, nil)
  last_file_info_pop = pop

  local bufnr, ns_id, linenr_start = pop.bufnr, -1, 1
  line:render(bufnr, ns_id, linenr_start)

  pop:mount()
  vim.defer_fn(function()
    pop:unmount()
  end, 3000)
end

return M
