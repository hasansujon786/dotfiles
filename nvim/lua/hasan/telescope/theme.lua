local state = require('core.state')
local M = {}

M.border_groups = {
  rounded = {
    prompt = { '─', '│', ' ', '│', '╭', '╮', '│', '│' },
    results = { '─', '│', '─', '│', '├', '┤', '╯', '╰' },
    preview = { '─', '│', '─', '│', '├', '┤', '╯', '╰' },
  },
  edged = {
    prompt = { '▔', '▕', '▁', '▏', '🭽', '🭾', '🭿', '🭼' },
    results = { '▔', '▕', '▁', '▏', '🭽', '🭾', '🭿', '🭼' },
    preview = { '▔', '▕', '▁', '▏', '🭽', '🭾', '🭿', '🭼' },
    -- results = { '▁', '▕', '▁', '▏', '🭼', '🭿', '🭿', '🭼' },
  },
  edged_top = {
    prompt = { '▔', '▕', '▁', '▏', '🭽', '🭾', '🭿', '🭼' },
    preview = { '▔', '▕', ' ', '▏', '🭽', '🭾', '▕', '▏' },
    results = { '▁', '▕', '▁', '▏', '🭼', '🭿', '🭿', '🭼' },
  },
  edged_ivy = {
    prompt = { '▔', ' ', ' ', ' ', '▔', '▔', ' ', ' ' },
    results = { ' ', '▕', ' ', ' ', ' ', '▕', '▕', ' ' },
    preview = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
  },
  empty = {
    preview = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
    prompt = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
    results = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
  },
}

M.top_panel_default_opts = {
  -- entry_maker = M.gen_from_file({}),
  sorting_strategy = 'ascending',
  layout_strategy = 'top_panel',
  border = true,
  borderchars = M.border_groups.edged_top,
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
  opts = opts or {}
  opts.borderchars = M.border_groups.edged_top

  return require('telescope.themes').get_dropdown(opts)
end

M.get_cursor_vertical = function(opts)
  local theme_opts = {
    -- entry_maker = M.gen_from_file({}),
    sorting_strategy = 'ascending',
    layout_strategy = 'cursor_vertical',
    -- initial_mode = 'normal',
    border = true,
    borderchars = M.border_groups.edged_top,
    layout_config = {
      width = 80,
      height = 20,
    },
    -- prompt_title = false,
    results_title = false,
    preview_title = false,
    previewer = true,
  }
  return vim.tbl_deep_extend('force', theme_opts, opts or {})
end

M.setup = function()
  -- Setup custom layout_strategy
  local layout_strategies = require('telescope.pickers.layout_strategies')
  local resolve = require('telescope.config.resolve')

  layout_strategies.top_panel = function(self, max_columns, max_lines, layout_config)
    local layout = layout_strategies.center(self, max_columns, max_lines, layout_config)
    layout.prompt.line = layout.prompt.line - 1
    layout.results.line = layout.results.line - 1
    if layout.preview then
      layout.preview.line = layout.preview.line - 2
    end
    return layout
  end

  layout_strategies.cursor_vertical = function(self, max_columns, max_lines, layout_config)
    local layout = layout_strategies.cursor(self, max_columns, max_lines, layout_config)

    -- local height_opt = self.layout_config.height
    -- local height = resolve.resolve_height(height_opt)(self, max_columns, max_lines)

    local width_opt = self.layout_config.width
    local width = resolve.resolve_width(width_opt)(self, max_columns, max_lines)

    layout.prompt.width = width
    layout.results.width = width

    if layout.preview then
      layout.preview.height = 5
      layout.preview.width = width
      layout.preview.col = layout.prompt.col
      layout.preview.zindex = 51

      layout.results.height = layout.results.height - layout.preview.height - layout.prompt.height
      layout.preview.line = layout.preview.line + layout.results.height + 3
    end
    return layout
  end
end
return M
