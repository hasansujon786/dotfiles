local M = {}
local ui = require('core.state').ui
local diagnotic_icons = require('hasan.utils.ui.icons').Other.diagnostics

-- local borderOpts = { border = require('core.state').ui.border.style }
-- vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, borderOpts)
-- vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, borderOpts)

function M.diagnostic_icon_by_severity(severity)
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
    icon = diagnotic_icons.Hint
    highlight = 'DiagnosticHint'
  end
  return icon, highlight
end

local jump_opts = {
  float = {
    prefix = function(diagnostic)
      local icon, highlight = M.diagnostic_icon_by_severity(diagnostic.severity)
      return icon .. ' ', highlight
    end,
  },
}

function M.jump_to_diagnostic(direction)
  if direction == 'prev' then
    vim.diagnostic.goto_prev(jump_opts)
  else
    vim.diagnostic.goto_next(jump_opts)
  end
end

function M.setup()
  if vim.fn.has('nvim-0.6.0') == 0 then
    return 0
  end

  for icon_type, icon in pairs(diagnotic_icons) do
    local hl = 'DiagnosticSign' .. icon_type
    vim.fn.sign_define(hl, { numhl = 'DiagnosticLineNr' .. icon_type })
    -- vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end
  vim.diagnostic.config({
    signs = true,
    underline = true,
    update_in_insert = false,
    virtual_text = false,
    severity_sort = true,
    float = {
      focusable = true,
      border = ui.border.style,
      source = false,
      header = { ' Diagnostics:', 'TextInfo' },
      prefix = function(diagnostic, i, total)
        local icon, highlight = M.diagnostic_icon_by_severity(diagnostic.severity)
        return i .. '/' .. total .. ' ' .. icon .. ' ', highlight
      end,
    },
  })
end

return M
