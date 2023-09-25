local M = {}
local diagnotic_icons = require('hasan.utils.ui.icons').Other.diagnostics

-- local borderOpts = { border = require('hasan.core.state').ui.border.style }
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
function M.diagnostic_prev()
  vim.diagnostic.goto_prev(jump_opts)
end
function M.diagnostic_next()
  vim.diagnostic.goto_next(jump_opts)
end

function M.setup()
  for icon_type, _ in pairs(diagnotic_icons) do
    local hl = 'DiagnosticSign' .. icon_type
    vim.fn.sign_define(hl, { numhl = 'DiagnosticLineNr' .. icon_type })
    -- vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end
  vim.diagnostic.config({
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    -- virtual_text = {
    --   spacing = 4,
    --   source = 'if_many',
    --   prefix = '●',
    --   -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
    --   -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
    --   -- prefix = "icons",
    -- },
    virtual_text = false,
    float = {
      focusable = true,
      border = require('hasan.core.state').ui.border.style,
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
