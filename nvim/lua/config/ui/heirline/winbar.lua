local utils = require('heirline.utils')
local tab_max_length = 22 -- +6
local Icon = require('hasan.utils.ui.icons')

local FnameProvider = {
  init = function(self)
    local path = vim.api.nvim_buf_get_name(0)
    self.filename = (path == '' and '[No Name]') or path:match('([^/\\]+)[/\\]*$')
    self.left_pad = 0
    self.right_pad = 0

    -- self.label = vim.api.nvim_win_get_number(0)
    if #self.filename < tab_max_length then
      local rest_ln = tab_max_length - #self.filename
      self.left_pad = math.floor(rest_ln / 2)
      self.right_pad = rest_ln - self.left_pad
    end
  end,
  on_click = {
    minwid = function()
      return vim.api.nvim_get_current_win()
    end,
    callback = function(_, minwid, _, button)
      if button == 'm' then -- close on mouse middle click
        vim.schedule(function()
          vim.api.nvim_win_close(minwid, true)
        end)
      else
        vim.api.nvim_set_current_win(minwid)
      end
    end,
    name = 'heirline_winbar_active_tab_button',
  },
}

local function FnameIconProvider(left_pad)
  return {
    init = function(self)
      local filename = self.filename
      local extension = vim.fn.fnamemodify(filename, ':e')
      self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color(filename, extension, { default = true })
    end,
    provider = function(self)
      if left_pad and self.left_pad > 0 then
        return self.icon and (string.rep(' ', self.left_pad) .. self.icon .. ' ')
      end
      return self.icon and (self.icon .. ' ')
    end,
    hl = function(self)
      return { fg = self.icon_color }
    end,
  }
end

local FileName = {
  provider = function(self)
    local filename = self.filename
    if #filename > tab_max_length then
      return filename:sub(1, tab_max_length - 1) .. '…'
    end
    if #filename < tab_max_length then
      return filename .. string.rep(' ', self.right_pad)
    end
    return filename
  end,
  hl = 'WinbarTabContent',
}

local FileNameBlock = function(left_pad)
  return utils.insert(
    FnameProvider,
    FnameIconProvider(left_pad),
    FileName,
    { provider = '%<' } -- This means that the statusline is cut here when there's not enough space
  )
end

local CloseButton = {
  on_click = {
    name = 'heirline_winbar_close_button',
    minwid = function()
      return vim.api.nvim_get_current_win()
    end,
    callback = function(_, minwid)
      vim.api.nvim_win_close(minwid, true)
    end,
  },
  {
    condition = function()
      return vim.bo.modified
    end,
    provider = ' ',
  },
  {
    condition = function()
      return not vim.bo.modified
    end,
    provider = ' ' .. Icon.ui.Close,
  },
  hl = 'WinbarTabContent',
}

local c = {
  Space = { provider = ' ' },
  FileNameBlock = FileNameBlock,
  WinBarFileName = { FileNameBlock(true), CloseButton },
  BarStart = { provider = '▎', hl = 'WinbarTabEdgeLeft' },
  BarEnd = { provider = '▕', hl = 'WinbarTabEdgeRight' },
  Rest = { hl = 'WinbarTabEmpty', provider = '%=' },
}

local conditions = require('heirline.conditions')
local dapui_filetypes = { 'dapui_scopes', 'dapui_breakpoints', 'dapui_stacks', 'dapui_watches' }

local function get_winbar(active)
  local hl = not active and { fg = 'muted', force = true }

  return {
    active and c.BarStart or c.Space,
    { c.WinBarFileName, hl = hl },
    c.BarEnd,
    c.Rest,
  }
end

return {
  Winbar = {
    fallthrough = false,
    { -- DapUI sidebar
      fallthrough = false,
      condition = function()
        return conditions.buffer_matches({ filetype = dapui_filetypes })
      end,
      { c.Space, c.FileNameBlock(), c.Rest },
    },
    {
      fallthrough = false,
      { -- Default inactive winbar for regular files
        condition = function()
          return conditions.is_not_active()
        end,
        get_winbar(false),
      },
      -- Default active winbar for regular files
      get_winbar(true),
    },
  },
  disable_winbar_cb = function(args)
    if conditions.buffer_matches({ filetype = dapui_filetypes }, args.buf) then
      return false
    end
    return conditions.buffer_matches({
      buftype = { 'nofile', 'prompt', 'help', 'quickfix' },
      filetype = {
        '^git.*',
        'fzf',
        'fugitive',
        'Trouble',
        'dashboard',
        'harpoon',
        'floaterm',
        'terminal',
        'blink-cmp-menu',
        'blink-cmp-signature',
        'blink-cmp-documentation',
        'superkanban_task',
        'superkanban_list',
        'superkanban_board',
      },
    }, args.buf)
  end,
}
