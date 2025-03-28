local M = {}
local diagnotic_icons = require('hasan.utils.ui.icons').diagnostics

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

-- local diagnostic_prefix = function(diagnostic)
--   local icon, highlight = M.diagnostic_icon_by_severity(diagnostic.severity)
--   return icon .. ' ', highlight
-- end
-- credit: https://www.joshmedeski.com/
-- M.diagnostic_goto = function(next, severity)
--   local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
--   severity = severity and vim.diagnostic.severity[severity] or nil
--   return function()
--     go({ severity = severity, float = { prefix = diagnostic_prefix } })
--   end
-- end
-- keymap('n', ']d', require('config.lsp.util.diagnosgic').diagnostic_goto(true), desc('Lsp: Next diagnosgic'))
-- keymap('n', '[d', require('config.lsp.util.diagnosgic').diagnostic_goto(false), desc('Lsp: Prev diagnosgic'))
-- keymap('n', ']E', require('config.lsp.util.diagnosgic').diagnostic_goto(true, 'ERROR'), desc('Lsp: Next Error'))
-- keymap('n', '[E', require('config.lsp.util.diagnosgic').diagnostic_goto(false, 'ERROR'), desc('Lsp: Prev Error'))
-- keymap('n', ']w', require('config.lsp.util.diagnosgic').diagnostic_goto(true, 'WARN'), desc('Lsp: Next Warning'))
-- keymap('n', '[w', require('config.lsp.util.diagnosgic').diagnostic_goto(false, 'WARN'), desc('Lsp: Prev Warning'))

local function get_signs()
  local signs_config = {
    [vim.diagnostic.severity.HINT] = {
      icon = diagnotic_icons.Hint,
      numhl = 'DiagnosticLineNrHint',
    },
    [vim.diagnostic.severity.INFO] = {
      icon = diagnotic_icons.Info,
      numhl = 'DiagnosticLineNrInfo',
    },
    [vim.diagnostic.severity.WARN] = {
      icon = diagnotic_icons.Warn,
      numhl = 'DiagnosticLineNrWarn',
    },
    [vim.diagnostic.severity.ERROR] = {
      icon = diagnotic_icons.Error,
      numhl = 'DiagnosticLineNrError',
    },
  }

  local signs = { text = {}, linehl = {}, numhl = {} }
  for severity, val in pairs(signs_config) do
    signs.text[severity] = ''
    signs.numhl[severity] = val.numhl
    -- signs.linehl[severity] = val.linehl
  end

  return signs
end

function M.setup()
  vim.diagnostic.config({
    signs = get_signs(),
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
    -- virtual_text = { current_line = true },
    -- virtual_text = false,
    -- virtual_lines = false,
    float = {
      focusable = true,
      border = require('core.state').ui.border.style,
      source = false,
      header = { ' Diagnostics:', 'DiagnosticHint' },
      prefix = function(diagnostic, i, total)
        local icon, highlight = M.diagnostic_icon_by_severity(diagnostic.severity)
        if total > 1 then
          return i .. '. ' .. icon .. ' ', highlight
        end
        return icon .. ' ', highlight
      end,
    },
  })
end
M.setup()

return M
