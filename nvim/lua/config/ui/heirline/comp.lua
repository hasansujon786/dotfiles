local conditions = require('heirline.conditions')
local utils = require('heirline.utils')
local icons = require('hasan.utils.ui.icons')

local mutedText = { fg = 'muted', bg = 'bg1' }
local layerBlock = { fg = 'light_grey', bg = 'layer' }
local layerBlockAlt = { fg = 'layer', bg = 'bg1' }
local modeBlock = function(self)
  return { bg = self.color, fg = 'bg1' }
end
local modeBlockAlt = function(self)
  return { bg = 'bg1', fg = self.color }
end
local modeBlockLayerAlt = function(self)
  return { bg = 'layer', fg = self.color }
end

return {
  Fill = { provider = '%=' },
  Space = { provider = ' ' },
  LSPActive = {
    condition = conditions.lsp_attached,
    update = {
      'LspAttach',
      'LspDetach',
      -- 'User',
      -- pattern = { 'LspProgressUpdate', 'LspRequest' }, -- 'LspProgress'
    },
    hl = mutedText,
    { provider = '  ' },
    {
      provider = function()
        -- -- lsp progress
        -- local progress_message = vim.lsp.util.get_progress_messages()
        -- if #progress_message > 0 then
        --   local status = {}
        --   for _, msg in pairs(progress_message) do
        --     table.insert(status, (msg.percentage or 0) .. '%% ' .. (msg.title or ''))
        --   end
        --   return status[#status]
        -- end

        -- lsp name
        local names = {}
        for _, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
          table.insert(names, server.name)
        end
        return table.concat(names, ',')
      end,
    },
    on_click = {
      callback = function()
        vim.defer_fn(function()
          vim.cmd('LspInfo')
        end, 100)
      end,
      name = 'heirline_LSP',
    },
  },
  FileLastModified = {
    provider = function()
      local ftime = vim.fn.getftime(vim.api.nvim_buf_get_name(0))
      return (ftime > 0) and os.date('%c', ftime)
    end,
  },
  FileTypeWithIcon = {
    init = function(self)
      self.filetype = vim.bo.filetype
      self.icon = require('nvim-web-devicons').get_icon_by_filetype(self.filetype, { default = true })
      if self.filetype == '' then
        self.filetype = 'Plain Text'
      end
    end,
    hl = mutedText,
    update = { 'BufReadPost', 'BufEnter', 'BufLeave' },
    { provider = '  ' },
    {
      provider = function(self)
        return self.icon .. ' ' .. self.filetype
      end,
    },
    on_click = {
      callback = function()
        vim.defer_fn(function()
          vim.cmd('Telescope filetypes theme=get_dropdown')
        end, 100)
      end,
      name = 'heirline_Filetype',
    },
  },
  ShowCmd = {
    condition = function()
      return vim.o.cmdheight == 0
    end,
    provider = '%3.5(%S%)',
  },
  ScrollBar = {
    static = {
      sbar = { '█', '▇', '▆', '▅', '▄', '▃', '▂', '▁' },
      -- sbar = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' },
    },
    provider = function(self)
      local curr_line = vim.api.nvim_win_get_cursor(0)[1]
      local lines = vim.api.nvim_buf_line_count(0)
      local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
      return string.rep(self.sbar[i], 2)
    end,
    hl = { fg = 'bg2', bg = 'blue' },
  },
  ScrollPercentageBall = {
    hl = function()
      local position = math.floor(vim.api.nvim_win_get_cursor(0)[1] / vim.api.nvim_buf_line_count(0) * 100)
      local fg = 'purple'

      if position <= 5 then
        fg = 'aqua'
      elseif position >= 95 then
        fg = 'red'
      end
      return { fg = fg, bg = 'layer' }
    end,
    { provider = ' █', hl = layerBlockAlt },
    {
      provider = function()
      -- stylua: ignore
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
    },
    { provider = '█', hl = layerBlockAlt },
  },
  Harpoon = {
    condition = function()
      local ok, harpoon_mark = pcall(require, 'harpoon.mark')
      if ok then
        return harpoon_mark.status() ~= ''
      end
      return false
    end,
    provider = function()
      local _, harpoon_mark = pcall(require, 'harpoon.mark')
      return '  H:' .. harpoon_mark.status()
    end,
    hl = mutedText,
  },
  ScrollPercentage = {
    provider = '%3P',
    hl = mutedText,
  },
  SpaceInfo = {
    hl = mutedText,
    { provider = '  ' },
    { provider = "%{&expandtab?'Spc:'.&shiftwidth:'Tab:'.&shiftwidth}" },
  },
  Location = {
    -- %l = current line number
    -- %L = number of lines in the buffer
    -- %c = column number
    -- %P = percentage through file of displayed window
    -- provider = '%7(%l/%3L%):%2c %P',
    init = function(self)
      self.color = self:mode_color()
    end,
    { provider = '', hl = modeBlockLayerAlt },
    { provider = '%4l:%-2v' },
    { provider = '', hl = modeBlockAlt },
    hl = modeBlock,
  },
  ViMode = {
    init = function(self)
      self.mode = vim.fn.mode(1)
      self.color = self:mode_color()
    end,
    static = {
      mode_names = {
        n = 'NORMAL ',
        no = 'NORMAL ',
        nov = 'NORMAL ',
        noV = 'NORMAL ',
        ['no\22'] = 'NORMAL ',
        niI = 'Ni',
        niR = 'Nr',
        niV = 'Nv',
        nt = 'Nt',
        v = 'VISUAL ',
        vs = 'Vs',
        V = 'V_LINE ',
        Vs = 'Vs',
        ['\22'] = 'VBLOCK ',
        ['\22s'] = 'VBLOCK ',
        s = 'S',
        S = 'S_',
        ['\19'] = '^S',
        i = 'INSERT ',
        ic = 'Ic',
        ix = 'Ix',
        R = 'REPLACE',
        Rc = 'REPLACE',
        Rx = 'REPLACE',
        Rv = 'REPLACE',
        Rvc = 'REPLACE',
        Rvx = 'REPLACE',
        c = 'COMMAND',
        cv = 'EXMODE ',
        r = '...',
        rm = 'M',
        ['r?'] = '?',
        ['!'] = '!',
        t = 'TERMINAL',
      },
    },
    { provider = '█', hl = modeBlockAlt },
    {
      provider = function(self)
        return '%2(' .. self.mode_names[self.mode] .. '%)'
      end,
    },
    { provider = '', hl = modeBlockLayerAlt },
    hl = modeBlock,
    update = {
      'ModeChanged',
      pattern = '*:*',
      callback = vim.schedule_wrap(function()
        vim.cmd('redrawstatus')
      end),
    },
  },
  GitBranch = {
    condition = conditions.is_git_repo,
    init = function(self)
      self.status_dict = vim.b['gitsigns_status_dict']
    end,
    update = { 'BufReadPost', 'BufEnter', 'BufWinEnter', 'BufWinLeave' },
    {
      provider = function(self)
        return '  ' .. self.status_dict.head
      end,
      hl = layerBlock,
    },
    { provider = '█', hl = layerBlockAlt },
    on_click = {
      callback = function()
        vim.defer_fn(function()
          vim.cmd('Telescope git_branches')
        end, 100)
      end,
      name = 'heirline_git_branches',
    },
  },
  layerEndleft = { provider = ' ', hl = layerBlockAlt },
  DAPMessages = {
    condition = function()
      local ok, dap = pcall(require, 'dap')
      if not ok then
        return false
      end

      local session = dap.session()
      return session ~= nil
    end,
    provider = function()
      return ' ' .. require('dap').status()
    end,
    hl = 'red',
  },
  Diagnostics = {
    condition = function()
      if vim.v.hlsearch ~= 0 then
        return false
      end
      return conditions.has_diagnostics()
    end,
    static = icons.diagnostics,
    init = function(self)
      self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
      self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
      self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
      self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    end,
    on_click = {
      callback = function()
        vim.diagnostic.setloclist()
      end,
      name = 'heirline_diagnostics',
    },
    update = { 'DiagnosticChanged', 'BufEnter' },
    {
      provider = function(self)
        return self.errors > 0 and (self.Error .. ' ' .. self.errors .. ' ')
      end,
      hl = { fg = 'dark_red', bg = 'bg1' },
    },
    {
      provider = function(self)
        return self.warnings > 0 and (self.Warn .. ' ' .. self.warnings .. ' ')
      end,
      hl = { fg = 'dark_yellow', bg = 'bg1' },
    },
    {
      provider = function(self)
        return self.info > 0 and (self.Info .. ' ' .. self.info .. ' ')
      end,
      hl = { fg = 'dark_cyan', bg = 'bg1' },
    },
    {
      provider = function(self)
        return self.hints > 0 and (self.Hint .. ' ' .. self.hints)
      end,
      hl = { fg = 'dark_cyan', bg = 'bg1' },
    },
  },
  SearchCount = {
    condition = function()
      return vim.v.hlsearch ~= 0
    end,
    init = function(self)
      local ok, search = pcall(vim.fn.searchcount)
      if ok and search.total then
        self.search = search
      end
    end,
    provider = function(self)
      local search = self.search
      return string.format('[%d/%d]', search.current, math.min(search.total, search.maxcount))
    end,
  },
  MacroRec = {
    condition = function()
      return vim.fn.reg_recording() ~= '' and vim.o.cmdheight == 0
    end,
    provider = ' ',
    hl = { fg = 'orange' },
    utils.surround({ '[', ']' }, nil, {
      provider = function()
        return vim.fn.reg_recording()
      end,
      hl = { fg = 'green', bold = true },
    }),
    update = { 'RecordingEnter', 'RecordingLeave' },
  },
}
