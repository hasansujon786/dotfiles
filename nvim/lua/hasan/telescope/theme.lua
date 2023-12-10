local state = require('hasan.core.state')
local M = {}

M.top_panel_default_opts = {
  -- entry_maker = M.gen_from_file({}),
  sorting_strategy = 'ascending',
  layout_strategy = 'top_panel',
  border = true,
  borderchars = state.border_groups[state.ui.telescope_border_style],
  layout_config = {
    anchor = 'N',
    width = function(_, max_columns, _, _)
      if max_columns <= 106 then
        return max_columns - 10
      end
      return 100
    end,
    height = 0.6,
  },
  -- prompt_title = false,
  results_title = false,
  preview_title = false,
  previewer = false,
}

M.get_top_panel = function(opts)
  return not opts and M.top_panel_default_opts or vim.tbl_deep_extend('force', M.top_panel_default_opts, opts)
end

M.get_dropdown = function(opts)
  local d = { borderchars = require('hasan.core.state').border_groups.edged_top }
  opts = vim.tbl_deep_extend('force', d, opts or {})
  return require('telescope.themes').get_dropdown(opts)
end

M.get_cursor = function(opts)
  local d = { borderchars = require('hasan.core.state').border_groups.edged_top }
  opts = vim.tbl_deep_extend('force', d, opts or {})
  return require('telescope.themes').get_cursor(opts)
end

M.setup = function()
  -- Setup custom layout_strategy
  local layout_strategies = require('telescope.pickers.layout_strategies')
  layout_strategies.top_panel = function(self, max_columns, max_lines, layout_config)
    local layout = layout_strategies.center(self, max_columns, max_lines, layout_config)
    -- layout.prompt.line = layout.prompt.line - 1
    -- layout.results.line = layout.results.line - 1
    layout.results.borderchars = { '▁', '▕', '▁', '▏', '🭼', '🭿', '🭿', '🭼' }
    if layout.preview then
      layout.preview.line = layout.preview.line - 1
    end
    return layout
  end
end

return M
