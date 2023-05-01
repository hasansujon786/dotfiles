local feline_ok, feline = pcall(require, 'feline')
if not feline_ok then
  return
end

local separators = require('feline.defaults').statusline.separators.default_value
local function withHl(text, hl)
  return string.format('%%#%s#%s', hl, text)
end

local one_monokai = {
  fg = '#a5b0c5',
  bg = '#2D3343',
  bg1 = '#3e425d',
  bg_hidden = '#3E4452',
  green = '#97ca72',
  yellow = '#ebc275',
  purple = '#ca72e4',
  orange = '#d99a5e',
  red = '#ef5f6b',
  aqua = '#6db9f7',
  dark_red = '#f75f5f',
  dark_blue = '#282c34',
  gray = '#8b95a7',
  muted = '#68707E',
}

local hl_sections = {
  muted_text = { fg = 'muted' },
  layer1 = { bg = 'bg1', fg = 'gray' },
  main = function()
    return {
      bg = require('feline.providers.vi_mode').get_mode_color(),
      fg = 'dark_blue',
      style = 'bold',
      name = 'NeovimModeHLColor',
    }
  end,
  main_sep = function()
    return { fg = require('feline.providers.vi_mode').get_mode_color(), bg = 'NONE' }
  end,
}

local get_lsp_client = function()
  local msg = 'LSP Inactive'
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
          lsps = lsps .. ',' .. client.name
        end
      end
    end
  end
  if lsps == '' then
    return msg
  else
    return lsps
  end
end

local c = {
  vim_mode = {
    provider = {
      name = 'vi_mode',
      opts = { show_mode_name = true, padding = 'center' },
    },
    icon = '',
    hl = hl_sections.main,
    left_sep = { str = 'left_rounded', hl = hl_sections.main_sep },
  },
  separator = { provider = '' },
  file_name = {
    provider = {
      name = 'file_info',
      opts = {
        type = 'relative-short',
        file_modified_icon = '',
        file_readonly_icon = '',
        path_sep = '/',
      },
    },
    hl = hl_sections.layer1,
    left_sep = 'block',
    right_sep = { separators.block, separators.right_rounded },
  },
  lsp_status = {
    provider = function()
      local progress_message = vim.lsp.util.get_progress_messages()
      if #progress_message == 0 then
        return get_lsp_client()
      end

      local status = {}
      for _, msg in pairs(progress_message) do
        table.insert(status, (msg.percentage or 0) .. '%% ' .. (msg.title or ''))
      end
      return table.concat(status, ' ')
    end,
    hl = hl_sections.muted_text,
    left_sep = ' ',
    right_sep = ' ',
  },
  harpoon = {
    provider = function()
      local ok, harpoon_mark = pcall(require, 'harpoon.mark')

      if ok and harpoon_mark.status() ~= '' then
        return ok and 'H:' .. harpoon_mark.status()
      end
      return ''
    end,
    hl = hl_sections.muted_text,
    left_sep = ' ',
    right_sep = ' ',
  },
  file_format = {
    provider = 'file_format',
    hl = { fg = 'orange', bg = 'dark_blue', style = 'italic' },
    left_sep = 'block',
    right_sep = 'block',
  },
  scroll_percentage = {
    provider = 'line_percentage',
    hl = hl_sections.layer1,
    right_sep = 'block',
    left_sep = { separators.left_rounded, separators.block },
  },
  space_info = {
    provider = "%{&expandtab?'Spc:'.&shiftwidth:'Tab:'.&shiftwidth}",
    hl = hl_sections.muted_text,
    left_sep = ' ',
    right_sep = ' ',
  },
  location = {
    provider = '%3l:%-2v',
    hl = hl_sections.main,
    left_sep = 'block',
    right_sep = { str = 'right_rounded', hl = hl_sections.main_sep },
  },
  tabs = {
    provider = function()
      local last_tab_nr = vim.fn.tabpagenr('$')
      if last_tab_nr == 1 then
        return ''
      end

      local list = {}
      local tab = { active = '', inactive = '' }
      local cur_tab_nr = vim.fn.tabpagenr()

      for i = 1, last_tab_nr do
        if i == cur_tab_nr then
          table.insert(list, withHl(tab.active, 'LualineTabActive'))
        else
          table.insert(list, withHl(tab.inactive, 'LualineTabInactive'))
        end
      end
      return table.concat(list, ' ')
    end,
    left_sep = { str = ' ', hl = { bg = 'bg_hidden' } },
    right_sep = { str = '▕', hl = { fg = '#2c3545', bg = 'bg_hidden' } },
  },
  diagnostic_errors = { provider = 'diagnostic_errors', hl = { fg = 'red' } },
  diagnostic_warnings = { provider = 'diagnostic_warnings', hl = { fg = 'yellow' } },
  diagnostic_hints = { provider = 'diagnostic_hints', hl = { fg = 'aqua' } },
  diagnostic_info = { provider = 'diagnostic_info' },
}

local left = {
  c.vim_mode,
  c.tabs,
  c.file_name,
}
local middle = {
  c.diagnostic_errors,
  c.diagnostic_warnings,
  c.diagnostic_hints,
  c.diagnostic_info,
}
local right = {
  c.harpoon,
  c.lsp_status,
  c.space_info,
  c.scroll_percentage,
  c.location,
}

feline.setup({
  components = {
    active = {
      left,
      middle,
      right,
    },
  },
  theme = one_monokai,
  vi_mode_colors = {
    NORMAL = has_pvim and 'red' or 'green',
    OP = 'green',
    INSERT = 'aqua',
    VISUAL = 'purple',
    LINES = 'orange',
    BLOCK = 'dark_red',
    REPLACE = 'red',
    COMMAND = 'aqua',
    CONFIRM = 'orange',
  },
  force_inactive = {
    filetypes = {
      'alpha',
    },
    buftypes = {
      '^terminal$',
    },
    bufnames = {},
  },
})
