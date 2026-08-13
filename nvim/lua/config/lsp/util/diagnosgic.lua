local M = {}

local diagnostic_icons = require('hasan.utils.ui.icons').diagnostics
local border = require('core.state').ui.border.style

local diagnostic_count_ns = vim.api.nvim_create_namespace('custom_diagnostic_counts')

local diagnostic_styles = {
  [vim.diagnostic.severity.ERROR] = {
    icon = diagnostic_icons.Error,
    highlight = 'DiagnosticError',
    numhl = 'DiagnosticLineNrError',
  },
  [vim.diagnostic.severity.WARN] = {
    icon = diagnostic_icons.Warn,
    highlight = 'DiagnosticWarn',
    numhl = 'DiagnosticLineNrWarn',
  },
  [vim.diagnostic.severity.INFO] = {
    icon = diagnostic_icons.Info,
    highlight = 'DiagnosticInfo',
    numhl = 'DiagnosticLineNrInfo',
  },
  [vim.diagnostic.severity.HINT] = {
    icon = diagnostic_icons.Hint,
    highlight = 'DiagnosticHint',
    numhl = 'DiagnosticLineNrHint',
  },
}

local function build_count_text(errors, warnings)
  local virt_text = {}

  if errors > 0 then
    table.insert(virt_text, {
      '✖ ' .. errors,
      'DiagnosticError',
    })
  end

  if warnings > 0 then
    if #virt_text > 0 then
      table.insert(virt_text, { ' ', 'None' })
    end

    table.insert(virt_text, {
      '⚠ ' .. warnings,
      'DiagnosticWarn',
    })
  end

  return virt_text
end

function M.diagnostic_icon_by_severity(severity)
  local style = diagnostic_styles[severity]

  if not style then
    return '', 'Normal'
  end

  return style.icon, style.highlight
end

function M.get_signs()
  local signs = {
    text = {},
    numhl = {},
  }

  for severity, style in pairs(diagnostic_styles) do
    signs.text[severity] = ''
    signs.numhl[severity] = style.numhl
  end

  return signs
end

function M.setup_custom_counts()
  vim.diagnostic.handlers.custom_counts = {
    show = function(_, bufnr)
      if not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end

      vim.api.nvim_buf_clear_namespace(bufnr, diagnostic_count_ns, 0, -1)

      local diagnostics = vim.diagnostic.get(bufnr)
      local line_counts = {}

      for _, diagnostic in ipairs(diagnostics) do
        local counts = line_counts[diagnostic.lnum]

        if not counts then
          counts = {
            errors = 0,
            warnings = 0,
          }

          line_counts[diagnostic.lnum] = counts
        end

        if diagnostic.severity == vim.diagnostic.severity.ERROR then
          counts.errors = counts.errors + 1
        elseif diagnostic.severity == vim.diagnostic.severity.WARN then
          counts.warnings = counts.warnings + 1
        end
      end

      local line_count = vim.api.nvim_buf_line_count(bufnr)

      for lnum, counts in pairs(line_counts) do
        if lnum < line_count then
          local virt_text = build_count_text(counts.errors, counts.warnings)

          if #virt_text > 0 then
            vim.api.nvim_buf_set_extmark(bufnr, diagnostic_count_ns, lnum, 0, {
              virt_text = virt_text,
              virt_text_pos = 'eol',
              hl_mode = 'combine',
            })
          end
        end
      end
    end,

    hide = function(_, bufnr)
      if vim.api.nvim_buf_is_valid(bufnr) then
        vim.api.nvim_buf_clear_namespace(bufnr, diagnostic_count_ns, 0, -1)
      end
    end,
  }
end

function M.setup()
  -- M.setup_custom_counts()

  vim.diagnostic.config({
    custom_counts = true,

    -- virtual_text = { current_line = true },
    virtual_text = false,
    -- virtual_lines = false,

    signs = M.get_signs(),
    underline = true,
    update_in_insert = false,
    severity_sort = true,

    float = {
      focusable = true,
      border = border,
      source = 'if_many',
      header = { '󰒡 Diagnostics', 'DiagnosticInfo' },

      prefix = function(diagnostic, index, total)
        local icon, highlight = M.diagnostic_icon_by_severity(diagnostic.severity)
        local prefix = total > 1 and (index .. '. ') or ''
        return prefix .. icon .. ' ', highlight
      end,
    },
  })
end

return M
