---@diagnostic disable: missing-fields, inject-field
---@type wk.Plugin
local M = {}

M.name = 'harpoon'

M.mappings = {
  icon = { icon = '󰸕 ', color = 'orange' },
  plugin = 'harpoon',
  { '`', desc = 'marks' },
  { "'", desc = 'marks' },
  { 'g`', desc = 'marks' },
  { "g'", desc = 'marks' },
}

M.cols = {
  { key = 'lnum', hl = 'Number', align = 'right' },
}
---@class wk.Plugin.harpoon
---@field enabled boolean
---@field keys string[]
---@field marks {enabled:boolean,filter:fun(item):boolean}
M.opts = {}

---@type wk.Plugin.harpoon
local default_opts = {
  keys = { '1', '2', '3', '4', '5', '6', '7', '8', '9' },
  marks = {
    enabled = true,
    filter = function(item)
      return not item.key:match('^[1-9]$')
    end,
  },
}

function M.setup(opts)
  M.opts = vim.tbl_deep_extend('force', default_opts, opts)
end

function M.expand()
  local items = {} ---@type wk.Plugin.item[]

  local harpoon = require('harpoon')
  local list = harpoon:list()
  for index, key in pairs(M.opts.keys) do
    local harpoon_item = list.items[index]
    local item = { key = key, value = '-', desc = 'No item', action = function() end }

    if harpoon_item then
      local file = harpoon_item.value

      local _, devicons = pcall(require, 'nvim-web-devicons')
      local icon = devicons.get_icon(file, string.match(file, '%a+$'), { default = true })
      local nb_space = '\u{00A0}' -- non-breaking space

      item = {
        key = key,
        desc = file and ('harpoon: ' .. file) or '',
        value = vim.trim(file and vim.fs.basename(file) or ''),
        -- highlights = { { 1, 5, 'Number' } },
        lnum = string.format('%s%s', icon, nb_space),
        action = function()
          require('harpoon'):list():select(index)
        end,
      }
    end

    table.insert(items, item)
  end

  if M.opts.marks.enabled then
    local marks = vim.tbl_filter(M.opts.marks.filter, require('which-key.plugins.marks').expand())
    vim.list_extend(items, marks)
  end

  return items
end

-- Reload = function()
--   vim.cmd.wa()
--   R('which-key.plugins.harpoon')
--   vim.cmd([[Lazy reload which-key.nvim]])
-- end
--
return M
