local events = require('neo-tree.events')
local function on_move(data)
  Snacks.rename.on_rename_file(data.source, data.destination)
end

local M = {
  ---@type neotree.Config.SourceSelector
  source_selector = {
    winbar = true, -- toggle to show selector on winbar
    statusline = false, -- toggle to show selector on statusline
    show_scrolled_off_parent_node = false, -- boolean
    sources = { -- table
      { source = 'filesystem', display_name = '  Files' },
      { source = 'buffers', display_name = '  Bufs ' },
      { source = 'git_status', display_name = '  Git ' },
    },
    content_layout = 'center', -- "start"|"end"|"center"
    tabs_layout = 'equal', -- "equal"|"start"|"end"|"center"|"focus"
    truncation_character = '…', -- string
    tabs_min_width = nil, -- int | nil
    tabs_max_width = nil, -- int | nil
    padding = 0, -- int | { left: int, right: int }
    separator = { left = '▏', right = '▕' }, -- string | { left: string, right: string, override: string | nil }
    separator_active = nil, -- string | { left: string, right: string, override: string | nil } | nil
    show_separator_on_edge = false, -- boolean
  },
  ---@type neotree.Event.Handler[]
  event_handlers = {
    {
      event = events.NEO_TREE_POPUP_INPUT_READY,
      -- ---@param input NuiInput
      handler = function(_)
        local cursor = vim.api.nvim_win_get_cursor(0)
        if cursor[2] > 1 then
          vim.cmd.stopinsert()
          vim.cmd.normal('F.a')
        end
      end,
    },
    {
      event = events.NEO_TREE_POPUP_BUFFER_ENTER,
      handler = function()
        local buffer = vim.api.nvim_get_current_buf()
        vim.keymap.set('i', '<Esc>', function()
          return '<C-u><Cr>'
        end, { buffer = buffer, expr = true, noremap = true, desc = 'Close popup' })
      end,
    },
    { event = events.FILE_MOVED, handler = on_move },
    { event = events.FILE_RENAMED, handler = on_move },
  },
}

-- Alternate source_selector_style
if require('core.state').ui.neotree.source_selector_style == 'minimal' then
  M.source_selector.sources = {
    { source = 'filesystem', display_name = '   ' },
    { source = 'buffers', display_name = '   ' },
    { source = 'git_status', display_name = '   ' },
  }
  M.source_selector.separator = { left = '', right = ' ' }

  M.source_selector.tabs_layout = 'start'
  M.source_selector.padding = { left = 1, right = 16 }
end

return M
