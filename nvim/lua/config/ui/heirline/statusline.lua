local conditions = require('heirline.conditions')
local Icons = require('hasan.utils.ui.icons')

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
local divider_right = { provider = '▕', hl = { fg = 'bg_d', bg = 'layer' } }
local tabIcon = { active = Icons.Other.circleBg, inactive = Icons.Other.circleOutline }
local function withHl(text, hl)
  return string.format('%%#%s#%s', hl, text)
end

-- vim.api.nvim_create_autocmd('LspProgress', {
--   callback = function(args)
--     if string.find(args.match, 'end') then
--       vim.cmd('redrawstatus')
--     end
--     vim.cmd('redrawstatus')
--   end,
-- })

return {
  Fill = { provider = '%=' },
  Space = { provider = ' ' },
  LSPActive = {
    condition = conditions.lsp_attached,
    update = {
      'LspAttach',
      'LspDetach',
      'BufWinEnter',
      -- 'User',
      -- pattern = { 'LspProgressUpdate', 'LspRequest' }, -- 'LspProgress'
    },
    hl = mutedText,
    { provider = '   ' },
    {
      provider = function()
        -- lsp progress
        -- local progress_message = vim.lsp.status()
        -- if #progress_message > 0 then
        --   return progress_message
        -- end

        -- lsp name
        local names = {}
        for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
          table.insert(names, server.name)
        end
        return table.concat(names, ',')
      end,
    },
    on_click = {
      callback = function()
        vim.schedule(function()
          vim.cmd('LspInfo')
        end)
      end,
      name = 'heirline_LSP',
    },
  },
  Tabs = {
    condition = function()
      return vim.fn.tabpagenr('$') > 1
    end,
    update = {
      'TabEnter',
      'TabLeave',
      'TabNew',
      'TabNewEntered',
      'TabClosed',
    },
    hl = mutedText,
    { provider = '█', hl = layerBlockAlt },
    {
      hl = layerBlock,
      provider = function()
        local last_tab_nr = vim.fn.tabpagenr('$')
        if last_tab_nr == 1 then
          return ''
        end

        local list = {}
        local cur_tab_nr = vim.fn.tabpagenr()

        for i = 1, last_tab_nr do
          if i == cur_tab_nr then
            -- table.insert(list, '-')
            table.insert(list, withHl(tabIcon.active, 'HeirlineTabActive'))
          else
            table.insert(list, withHl(tabIcon.inactive, 'HeirlineTabInactive'))
          end
        end
        return table.concat(list, ' ')
      end,
    },
    divider_right,
    -- { provider = '█', hl = layerBlockAlt },
    -- on_click = {
    --   callback = function()
    --     vim.defer_fn(function()
    --       vim.cmd('LspInfo')
    --     end, 100)
    --   end,
    --   name = 'heirline_tab_indicator',
    -- },
    -- left_sep = { str = ' ', hl = { bg = 'bg_hidden' } },
    -- right_sep = { str = '▕', hl = { fg = '#2c3545', bg = 'bg_hidden' } },
  },
  FileLastModified = {
    provider = function()
      local ftime = vim.fn.getftime(vim.api.nvim_buf_get_name(0))
      return (ftime > 0) and os.date('%c', ftime)
    end,
  },
  FileType = {
    init = function(self)
      self.filetype = vim.bo.filetype == '' and 'Plain Text' or vim.bo.filetype
    end,
    hl = mutedText,
    update = { 'BufReadPost', 'BufEnter', 'BufLeave' },
    { provider = '  ' },
    {
      provider = function(self)
        return self.filetype
      end,
    },
  },
  FileFormat = {
    init = function(self)
      self.fileformat = vim.bo.fileformat == 'dos' and 'CRLF' or 'LF'
    end,
    hl = mutedText,
    update = { 'BufReadPost', 'BufEnter', 'BufLeave' },
    { provider = '  ' },
    {
      provider = function(self)
        return self.fileformat
      end,
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
        fg = 'bg_blue'
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
    update = { 'WinEnter', 'WinLeave', 'BufReadPost', 'BufEnter', 'BufWinEnter', 'User', pattern = 'HarpoonAdded' },
    condition = function()
      return vim.g.harpoon_loaded
    end,
    init = function(self)
      local ok, harpoon = pcall(require, 'harpoon')
      if ok then
        local displayed = harpoon:list():display()
        local name = require('hasan.utils.file').get_buf_name_relative(0)
        self.index = require('hasan.utils').index_of(displayed, name)
      end
    end,
    { provider = '  ' },
    {
      provider = function(self)
        if self.index and self.index > 0 then
          return 'H:' .. self.index
        end
        return ''
      end,
    },
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
        n = ' NORMAL ',
        no = ' NORMAL ',
        nt = ' NORMAL ',
        nov = ' NORMAL ',
        noV = ' NORMAL ',
        niI = ' NORMAL ',
        niR = ' NORMAL ',
        niV = ' NORMAL ',
        ['no\22'] = ' NORMAL ',
        v = ' VISUAL ',
        V = ' V_LINE ',
        vs = 'v-SELECT',
        Vs = 'V-SELECT',
        ['\22'] = ' VBLOCK ',
        ['\22s'] = ' VBLOCK ',
        s = ' SELECT ',
        S = ' S_LINE ',
        ['\19'] = ' SBLOCK ',
        i = ' INSERT ',
        ix = 'I-EXPAND',
        ic = '   Ic   ',
        R = ' REPLACE',
        Rc = ' REPLACE',
        Rx = ' REPLACE',
        Rv = ' REPLACE',
        Rvc = ' REPLACE',
        Rvx = ' REPLACE',
        t = '  TERM  ',
        r = '  ...   ',
        rm = 'M',
        c = ' COMMAND',
        cv = ' EXMODE ',
        ['r?'] = ' CONFIRM',
        ['!'] = '!',
      },
    },
    { provider = '', hl = modeBlockAlt },
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
    condition = function()
      return conditions.is_git_repo()
    end,
    init = function(self)
      self.status_dict = vim.b['gitsigns_status_dict']
    end,
    update = { 'BufReadPost', 'BufEnter', 'BufWinEnter', 'BufWinLeave' },
    provider = function(self)
      return '  ' .. self.status_dict.head
    end,
    hl = layerBlock,
    on_click = {
      callback = function()
        Snacks.picker.git_branches()
      end,
      name = 'heirline_git_branches',
    },
  },
  GitBranchAlt = {
    condition = function()
      return not conditions.is_git_repo()
    end,
    update = { 'BufReadPost', 'BufEnter', 'BufWinEnter', 'BufWinLeave' },
    provider = '  Branch',
    hl = layerBlock,
  },
  layerEndleft = { provider = '█ ', hl = layerBlockAlt },
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
      -- if vim.v.hlsearch ~= 0 then
      --   return false
      -- end
      return conditions.has_diagnostics()
    end,
    static = Icons.diagnostics,
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
      hl = { fg = 'red', bg = 'bg1' },
    },
    {
      provider = function(self)
        return self.warnings > 0 and (self.Warn .. ' ' .. self.warnings .. ' ')
      end,
      hl = { fg = 'yellow', bg = 'bg1' },
    },
    {
      provider = function(self)
        return self.info > 0 and (self.Info .. ' ' .. self.info .. ' ')
      end,
      hl = { fg = 'cyan', bg = 'bg1' },
    },
    {
      provider = function(self)
        return self.hints > 0 and (self.Hint .. ' ' .. self.hints)
      end,
      hl = { fg = 'cyan', bg = 'bg1' },
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
    hl = { fg = 'red', bg = 'bg1' },
    { provider = '' },
    { provider = ' REC', hl = { fg = 'white', bg = 'red' } },
    { provider = ' ', hl = { bg = 'layer' } },
    {
      provider = function()
        return vim.fn.reg_recording()
      end,
      hl = { fg = 'red', bg = 'layer' },
    },
    { provider = ' ', hl = { fg = 'layer', bg = 'bg1' } },
    update = { 'RecordingEnter', 'RecordingLeave' },
  },
}
