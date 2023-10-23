local M = {}

M.theme_top_panel_opt = (function()
  -- Setup custom layout_strategy
  local layout_strategies = require('telescope.pickers.layout_strategies')
  layout_strategies.top_panel = function(self, max_columns, max_lines, layout_config)
    local layout = layout_strategies.center(self, max_columns, max_lines, layout_config)
    layout.prompt.line = layout.prompt.line - 1
    layout.results.line = layout.results.line - 1
    if layout.preview then
      layout.results.borderchars = { '─', '│', '─', '│', '├', '┤', '┤', '├' }
      layout.preview.line = layout.preview.line - 2
    end
    return layout
  end

  return {
    -- entry_maker = M.gen_from_file({}),
    sorting_strategy = 'ascending',
    layout_strategy = 'top_panel',
    border = true,
    borderchars = {
      -- prompt = { '▔', ' ', ' ', ' ', '▔', '▔', ' ', ' ' },
      -- results = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },

      -- prompt = { '▔', '▕', '3', '▏', '🭽', '🭾', '7', '8' },
      -- results = { '▁', '▕', '▁', '▏', '🭼', '🭿', '🭿', '🭼' },

      prompt = { '─', '│', ' ', '│', '╭', '╮', '│', '│' },
      results = { '─', '│', '─', '│', '├', '┤', '╯', '╰' },
      preview = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    },
    layout_config = {
      anchor = 'N',
      width = 100,
      height = 0.6,
    },
    results_title = false,
    previewer = false,
    -- prompt_title = false,
  }
end)()

M.get_top_panel = function(opts)
  if not opts then
    return M.theme_top_panel_opt
  end
  return vim.tbl_deep_extend('force', M.theme_top_panel_opt, opts)
end

return M
