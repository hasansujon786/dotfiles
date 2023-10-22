local M = {}

M.theme_top_panel_opt = (function()
  return {
    -- entry_maker = M.gen_from_file({}),
    sorting_strategy = 'ascending',
    layout_strategy = 'center',
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
