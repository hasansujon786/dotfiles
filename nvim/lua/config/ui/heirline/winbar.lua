local conditions = require('heirline.conditions')
local utils = require('heirline.utils')

local FileName = {
  provider = function(self)
    -- first, trim the pattern relative to the current directory. For other
    -- options, see :h filename-modifers
    local filename = vim.fn.fnamemodify(self.filename, ':.')
    if filename == '' then
      return '[No Name]'
    end
    -- now, if the filename would occupy more than 1/4th of the available
    -- space, we trim the file path to its initials
    -- See Flexible Components section below for dynamic truncation
    if not conditions.width_percent_below(#filename, 0.25) then
      filename = vim.fn.pathshorten(filename)
    end
    return filename
  end,
  hl = { fg = 'white' },
}

local FileControlls = {
  {
    condition = function()
      return vim.bo.modified
    end,
    provider = ' ●',
    hl = { fg = 'green' },
  },
  {
    condition = function()
      return not vim.bo.modified
    end,
    provider = ' ',
    hl = { fg = 'gray' },
  },
}

local FileIcon = {
  init = function(self)
    local filename = self.filename
    local extension = vim.fn.fnamemodify(filename, ':e')
    self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color(filename, extension, { default = true })
  end,
  provider = function(self)
    return self.icon and (self.icon .. ' ')
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end,
}

local FnameProvider = {
  -- let's first set up some attributes needed by this component and it's children
  init = function(self)
    local path = vim.api.nvim_buf_get_name(0)
    self.filename = (path == '' and 'Empty ') or path:match('([^/\\]+)[/\\]*$')
  end,
}

local FileNameModifer = {
  hl = function()
    if vim.bo.modified then
      -- use `force` because we need to override the child's hl foreground
      return { fg = 'cyan', force = true }
    end
  end,
}

FileNameBlock = utils.insert(
  FnameProvider,
  FileIcon,
  utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
  { provider = '%<' } -- this means that the statusline is cut here when there's not enough space
)

return {
  FileControlls = FileControlls,
  FileNameBlock = FileNameBlock,
  BarStart = {
    provider = '▎',
    hl = { fg = 'aqua' },
  },
  BarEnd = {
    provider = '▕',
    hl = { fg = 'black' },
  },
  Rest = { hl = { bg = 'bg_d', fg = 'light_grey' }, provider = '%=' },
}
