local M = {
  source_selector = {
    winbar = true, -- toggle to show selector on winbar
    statusline = false, -- toggle to show selector on statusline
    show_scrolled_off_parent_node = false, -- boolean
    sources = { -- table
      {
        source = 'filesystem', -- string
        display_name = '  Files', -- string | nil
      },
      {
        source = 'buffers', -- string
        display_name = ' ﬘ Bufs ', -- string | nil
      },
      {
        source = 'git_status', -- string
        display_name = '  Git ', -- string | nil
      },
    },
    content_layout = 'center', -- string
    tabs_layout = 'equal', -- string
    truncation_character = '…', -- string
    tabs_min_width = nil, -- int | nil
    tabs_max_width = nil, -- int | nil
    padding = 0, -- int | { left: int, right: int }
    separator = { left = '▏', right = '▕' }, -- string | { left: string, right: string, override: string | nil }
    separator_active = nil, -- string | { left: string, right: string, override: string | nil } | nil
    show_separator_on_edge = false, -- boolean
  },
  event_handlers = {
    {
      event = 'neo_tree_popup_input_ready',
      -- ---@param input NuiInput
      handler = function(_)
        vim.cmd.stopinsert()
        vim.cmd.normal('F.a')
      end,
    },
  },
}

-- Alternate source_selector_style
if require('core.state').ui.neotree.source_selector_style == 'minimal' then
  M.source_selector.sources = {
    {
      source = 'filesystem', -- string
      display_name = '  ', -- string | nil
    },
    {
      source = 'buffers', -- string
      display_name = ' ﬘ ', -- string | nil
    },
    {
      source = 'git_status', -- string
      display_name = '  ', -- string | nil
    },
  }
  M.source_selector.content_layout = 'start'
  M.source_selector.tabs_layout = false
  M.source_selector.separator = { left = '', right = ' ' }
  M.source_selector.padding = 1
end

return M
