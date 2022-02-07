local M = {}
local ui = require('state').ui
local diagnotic_icons = ui.icons.diagnotic

M.diagnostic_icon_by_severity = function (severity)
  local icon, highlight
  if severity == 1 then
    icon = diagnotic_icons.Error
    highlight = 'DiagnosticError'
  elseif severity == 2 then
    icon = diagnotic_icons.Warn
    highlight = 'DiagnosticWarn'
  elseif severity == 3 then
    icon = diagnotic_icons.Info
    highlight = 'DiagnosticInfo'
  elseif severity == 4 then
    icon = diagnotic_icons.Error
    highlight = 'DiagnosticHint'
  end
  return icon, highlight
end

M.jump_to_diagnostic = function (direction)
  local opts = {
    float = {
      prefix = function(diagnostic)
        local icon, highlight = M.diagnostic_icon_by_severity(diagnostic.severity)
        return icon .. ' ', highlight
      end,
    }
  }
  if direction == "prev" then
    vim.diagnostic.goto_prev(opts)
  else
    vim.diagnostic.goto_next(opts)
  end
end

M.setup = function ()
  if vim.fn.has "nvim-0.6.0" == 0  then
    return 0
  end

  for icon_type, _ in pairs(diagnotic_icons) do
    local hl = 'DiagnosticSign' .. icon_type
    vim.fn.sign_define(hl, { text = '', texthl = hl, numhl = hl })
  end
  vim.diagnostic.config({
    signs = true,
    underline = true,
    update_in_insert = false,
    virtual_text = false,
    severity_sort = true,
    float = {
      focusable = false,
      border = ui.border.style,
      source = false,
      header = { 'Diagnostics:', 'DiagnosticHeader' },
      prefix = function(diagnostic, i, total)
        local icon, highlight = M.diagnostic_icon_by_severity(diagnostic.severity)
        return i .. '/' .. total .. ' ' .. icon .. ' ', highlight
      end,
    }
  })
end

return M
