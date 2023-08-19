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
  cyan = '#4dbdcb',
  cyan_dark = '#2C4855',
  app_bg = '#242B38',
  bg_dark = '#1E242E',
  bg_darker = '#1c212c',
  darkest = '#151820',
  olive = '#75A899',
}

local hl_sections = {
  light_text = { fg = 'fg' },
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
  local buf_clients = vim.lsp.buf_get_clients(0)
  if next(buf_clients) == nil then
    return 'LSP Inactive'
  end

  local clients = {}
  for _, client in pairs(buf_clients) do
    clients[#clients + 1] = client.name
  end
  return table.concat(clients, ',')
end

local c = {
  empty = {
    provider = function()
      return ''
    end,
  },
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
    enabled = function()
      return vim.o.columns > 80
    end,
    provider = {
      name = 'file_info',
      opts = {
        type = 'relative-short',
        file_modified_icon = '',
        file_readonly_icon = '',
        path_sep = '/',
      },
    },
    short_provider = {
      name = 'file_info',
      opts = {
        file_modified_icon = '',
        file_readonly_icon = '',
      },
    },
    hl = hl_sections.layer1,
    left_sep = 'block',
    right_sep = { separators.block, separators.right_rounded },
  },
  file_name_mini = {
    enabled = function()
      return vim.o.columns <= 80
    end,
    provider = {
      name = 'file_info',
      opts = {
        file_modified_icon = '',
        file_readonly_icon = '',
      },
    },
    short_provider = ' ',
    hl = hl_sections.layer1,
    left_sep = 'block',
    right_sep = { separators.block, separators.right_rounded },
  },
  scroll_bar = {
    provider = function()
      local chars = setmetatable({ ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', }, { __index = function() return ' ' end, })
      local lines = vim.api.nvim_buf_line_count(0)
      local curr_line = vim.api.nvim_win_get_cursor(0)[1]
      local line_ratio = curr_line / lines

      if curr_line == 1 then
        return ' TOP'
      elseif curr_line == lines then
        return ' Bot'
      else
        local icon = chars[math.floor(line_ratio * #chars)]
        return string.format('%s%2d%%%%', icon, math.ceil(line_ratio * 99))
      end
    end,
    hl = function()
      local position = math.floor(vim.api.nvim_win_get_cursor(0)[1] / vim.api.nvim_buf_line_count(0) * 100)
      local fg = 'purple'

      if position <= 5 then
        fg = 'aqua'
      elseif position >= 95 then
        fg = 'red'
      end
      return { fg = fg, bg = 'bg1' }
    end,
    right_sep = 'block',
    left_sep = { separators.left_rounded, separators.block },
  },
  lsp_status = {
    enabled = function()
      return vim.o.columns > 85
    end,
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
    short_provider = '',
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
  branch = {
    provider = { name = 'git_branch' },
    hl = hl_sections.muted_text,
    left_sep = ' ',
    right_sep = ' ',
  },
  search = {
    provider = function()
      local search = require('noice').api.status.search
      return search.has() and search.get() or ''
    end,
    hl = { fg = 'cyan', bg = 'cyan_dark' },
    left_sep = 'left_rounded',
    right_sep = 'right_rounded',
  },
  record = {
    provider = function()
      local recording_register = vim.fn.reg_recording()
      if recording_register == '' then
        return ''
      else
        return '@' .. recording_register
      end
    end,
    hl = { fg = 'bg', bg = 'red' },
    left_sep = 'left_rounded',
    right_sep = 'right_rounded',
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
    enabled = function()
      return vim.o.columns > 85
    end,
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
  diagnostic_errors = { provider = 'diagnostic_errors', hl = { fg = 'red' }, short_provider = '' },
  diagnostic_warnings = { provider = 'diagnostic_warnings', hl = { fg = 'yellow' }, short_provider = '' },
  diagnostic_hints = { provider = 'diagnostic_hints', hl = { fg = 'aqua' }, short_provider = '' },
  diagnostic_info = { provider = 'diagnostic_info', short_provider = '' },
}

local left = {
  c.vim_mode,
  c.tabs,
  c.file_name,
  c.file_name_mini,
}
local middle = {
  c.search,
  c.diagnostic_errors,
  c.diagnostic_warnings,
  c.diagnostic_hints,
  c.diagnostic_info,
}
local right = {
  c.record,
  c.harpoon,
  c.lsp_status,
  c.branch,
  c.space_info,
  c.scroll_bar,
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
    filetypes = {},
    buftypes = { '^terminal$' },
    bufnames = {},
  },
})

require('config.feline-winbar')
