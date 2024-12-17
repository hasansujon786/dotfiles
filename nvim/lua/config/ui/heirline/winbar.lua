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

local FileNameModifer = {
  hl = function()
    if vim.bo.modified then
      -- use `force` because we need to override the child's hl foreground
      return { fg = 'cyan', force = true }
    end
  end,
}

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
  hl = { fg = 'white' },
}

local FileNameBlock = function(left_pad)
  return utils.insert(
    FnameProvider,
    {
      init = function(self)
        local filename = self.filename
        local extension = vim.fn.fnamemodify(filename, ':e')
        self.icon, self.icon_color =
          require('nvim-web-devicons').get_icon_color(filename, extension, { default = true })
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
    },
    utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
    { provider = '%<' } -- this means that the statusline is cut here when there's not enough space
  )
end

local CloseButton = {
  on_click = {
    minwid = function()
      return vim.api.nvim_get_current_win()
    end,
    callback = function(_, minwid)
      vim.api.nvim_win_close(minwid, true)
    end,
    name = 'heirline_winbar_close_button',
  },
  {
    condition = function()
      return vim.bo.modified
    end,
    provider = ' ' .. Icon.Other.circleBg,
    hl = { fg = 'green' },
  },
  {
    condition = function()
      return not vim.bo.modified
    end,
    provider = ' ' .. Icon.ui.Close,
    hl = { fg = 'gray' },
  },
}

return {
  FileNameBlock = FileNameBlock,
  WinBarFileName = { FileNameBlock(true), CloseButton },
  BarStart = { provider = '▎', hl = { fg = 'bg_blue' } },
  BarEnd = { provider = '▕', hl = { fg = 'black' } },
  Rest = { hl = { bg = 'bg_d', fg = 'light_grey' }, provider = '%=' },
}
