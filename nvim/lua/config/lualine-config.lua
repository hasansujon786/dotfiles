local cp = {
  get_lsp_client = function()
    local msg =  'LSP Inactive'
    local buf_ft = vim.bo.filetype
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
      return msg
    end
    local lsps = ''
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        if lsps == '' then
          lsps = client.name
        else
          if not string.find(lsps, client.name) then
            lsps = lsps .. ', ' .. client.name
          end
        end
      end
    end
    if lsps == '' then
      return msg
    else
      return lsps
    end
  end,
  space_info = function()
    return "%{&expandtab?'Spc:'.&shiftwidth:'Tab:'.&shiftwidth}"
  end,
  harpoon = {
    toggle = function ()
      local ok, harpoon_mark = pcall(require, 'harpoon.mark')
      return ok and harpoon_mark.status() ~= ''
    end,
    fn = function ()
      local ok, harpoon_mark = pcall(require, 'harpoon.mark')
      return ok and 'H:'..harpoon_mark.status()
    end
  },
}

local onedark = require'lualine.themes.onedark'
-- onedark.normal.b.bg = '#68707E'
onedark.normal.c.fg = '#68707E'

require('lualine').setup {
  options = {
    theme = onedark,
    component_separators = '',
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
    lualine_b = {
      { 'filetype', colored = true, icon_only = true, padding = { left = 1, right = 0 }, },
      { 'filename', file_status = false, path = 1, shorting_target = 40 }
    },
    lualine_c = {},
    lualine_x = {
      { cp.harpoon.fn, cond = cp.harpoon.toggle },
      cp.get_lsp_client,
      {'branch', icon = '' },
      cp.space_info,
      { 'filetype', icons_enabled = false }
    },
    lualine_y = { 'progress' },
    lualine_z = { { 'location', separator = { right = '' }, left_padding = 2 } },

    -- {'harpoon', 'lsp_status', 'git_branch', 'task_timer', 'space_width', 'filetype', 'scroll_info', 'line_info'}
  },
  inactive_sections = {
    lualine_a = { 'filename' },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'progress' },
  },
  tabline = { },
  extensions = {'fern', 'quickfix'},
}
