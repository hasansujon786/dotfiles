local action_state = require('telescope.actions.state')
local Path = require('plenary.path')
local Popup = require('nui.popup')
local Layout = require('nui.layout')
local popup = require('plenary.popup')
local M = {}

M.root_has = function(fname)
  local fpath = Path:new(vim.fn.getcwd(), fname)
  local exists = fpath:exists()
  return exists, exists and fpath or nil
end

M.get_project_scripts = function(fpath)
  local data = vim.fn.readfile(fpath)
  ---@type WezWorkSpace
  local sc = vim.fn.json_decode(data)

  return sc.tabs[3]
end

local wins_ids = {}

M.create_tabs = function()
  local wez_height = 46
  local wez_width = 192

  local start_col = 30
  local start_row = 8

  local max_height = 30
  local max_width = 100

  local data =
    M.get_project_scripts('C:\\Users\\hasan\\dotfiles\\gui\\wezterm\\wezterm-session-manager\\klark-app-rn.json')
  local boxes = {}

  local pos = {
    {
      line = start_row,
      col = start_col,
      minwidth = 50,
      minheight = 30,
    },
    {
      line = start_row,
      col = start_col + 54,
      minwidth = 50,
      minheight = 15 - 1,
    },
    {
      line = start_row + 14 + 2,
      col = start_col + 54,
      minwidth = 50,
      minheight = 15 - 1,
    },
  }

  for pan_nr, pane in pairs(data.panes) do
    local bufnr = vim.api.nvim_create_buf(false, true)
    keymap('n', 'x', function()
      foo()
    end, { buffer = bufnr })

    local p = pos[pan_nr]
    local main_win_id, win = popup.create(bufnr, {
      relative = 'editor',
      highlight = 'Float',
      -- line = 10,
      -- col = 10,
      line = p.line,
      col = p.col,
      minwidth = p.minwidth,
      minheight = p.minheight,
      -- borderchars = borderchars,
      border = true,
      focusable = false,
    })

    table.insert(wins_ids, main_win_id)
  end
end
-- M.create_tabs()

-- _G.foo = function()
--   for _, id in ipairs(wins_ids) do
--     vim.api.nvim_win_close(id, true)
--   end
-- end
-- M.get_project_scripts('C:\\Users\\hasan\\dotfiles\\gui\\wezterm\\wezterm-session-manager\\klark-app-rn.json')

function M.browse_sessions()
  require('telescope').extensions.file_browser.file_browser({
    cwd = '~/dotfiles/gui/wezterm/wezterm-session-manager',
    hide_parent_dir = true,
    prompt_path = true,
    previewer = true,
    hidden = true,
    respect_gitignore = false,
    -- attach_mappings = function(_, map)
    --   map({ 'n', 'i' }, '<CR>', function(prompt_bufnr)
    --     require('telescope.actions').close(prompt_bufnr)
    --     P(action_state.get_selected_entry().value)
    --   end)
    --   return true
    -- end,
  })
end

M.browse_sessions()

-- Define Pane type for individual pane objects
---@class Pane
---@field cwd string -- The current working directory
---@field action string -- Action command to execute in pane
---@field height number -- Pane height
---@field index number -- Pane index in tab
---@field is_active boolean -- Whether the pane is active
---@field is_zoomed boolean -- Whether the pane is zoomed
---@field left number -- Pane's left position
---@field pane_id string -- Unique pane identifier
---@field pixel_height number -- Pane pixel height
---@field pixel_width number -- Pane pixel width
---@field top number -- Pane's top position
---@field tty string -- Terminal type
---@field width number -- Pane width

-- Define Tab type for individual tab objects containing multiple panes
---@class Tab
---@field panes Pane[] -- Array of Pane objects
---@field tab_id string -- Unique tab identifier

-- Define KlarkAppRn type for the root JSON object
---@class WezWorkSpace
---@field size { dpi:number,pixel_height:number,pixel_width:number,cols:number,rows:number }
---@field name string -- Name of the configuration
---@field tabs Tab[] -- Array of Tab objects

return M
