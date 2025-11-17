local M = {}

local preview_main = {
  show_winbar = {
    row = -1,
  },
  hidden_winbar = {
    row = -1,
    -- wo = { winbar = '%#SidebarDark#' },
  },
}

function M.keymaps()
  Snacks.picker.keymaps({
    format = function(item, picker)
      local ret = {} ---@type snacks.picker.Highlight[]
      ---@type vim.api.keyset.get_keymap
      local k = item.item
      local a = Snacks.picker.util.align

      if package.loaded['which-key'] then
        local Icons = require('which-key.icons')
        local icon, hl = Icons.get({ keymap = k, desc = k.desc })
        if icon then
          ret[#ret + 1] = { a(icon, 3), hl }
        else
          ret[#ret + 1] = { '   ' }
        end
      end
      local lhs = Snacks.util.normkey(k.lhs)
      ret[#ret + 1] = { k.mode, 'SnacksPickerKeymapMode' }
      ret[#ret + 1] = { ' ' }
      ret[#ret + 1] = { a(lhs, 12), 'SnacksPickerKeymapLhs' }
      ret[#ret + 1] = { ' ' }

      ret[#ret + 1] = { ' ' }
      ret[#ret + 1] = { a(k.desc or '', 45) }

      local icon_nowait = picker.opts.icons.keymaps.nowait
      if k.nowait == 1 then
        ret[#ret + 1] = { icon_nowait, 'SnacksPickerKeymapNowait' }
      else
        ret[#ret + 1] = { (' '):rep(vim.api.nvim_strwidth(icon_nowait)) }
      end
      ret[#ret + 1] = { ' ' }

      if k.buffer and k.buffer > 0 then
        ret[#ret + 1] = { a('buf:' .. k.buffer, 6), 'SnacksPickerBufNr' }
      else
        ret[#ret + 1] = { a('', 6) }
      end

      return ret
    end,
  })
end

function M.search_project_todos()
  Snacks.picker.grep({
    exclude = require('core.state').project.todo.exclude or {},
    show_empty = true,
    search = require('hasan.utils.ui.qf').get_todo_pattern,
    finder = 'grep',
    format = 'file',
    live = false,
    supports_live = true,
  })
end

-- Default - files
-- @ - lsp_symbols
-- $ - buffers
-- : - line number
-- # - search pattern
function M.project_files()
  Snacks.picker({ -- https://github.com/folke/snacks.nvim/issues/532#issuecomment-2609303872
    title = '',
    layout = { preset = 'vscode', preview = 'main' },
    multi = { 'files', 'lsp_symbols', 'buffers' },
    win = { preview = preview_main.hidden_winbar },
    matcher = { cwd_bonus = true, frecency = true, sort_empty = true },
    -- correctly sort lsp_symbols
    sort = function(a, b)
      local sort = require('snacks.picker.sort').default()
      sort = type(sort) == 'table' and require('snacks.picker.sort').default(sort) or sort
      ---@cast sort snacks.picker.sort
      return sort(a, b)
    end,
    -- win = {
    --   input = {
    --     keys = {
    --       -- ['<c-n>'] = { 'next_result', mode = { 'i', 'n' } },
    --       ['<esc>'] = { 'close', mode = { 'i', 'n' } },
    --     },
    --   },
    -- },
    actions = {
      close = function(p, _)
        vim.cmd('noh')
        p:close()
      end,
      next_result = function(p, _)
        if p.preview.win.buf == nil then
          return
        end

        local filter = p:filter()
        local pattern = filter.pattern
        local search_pattern = pattern:match('^.-#(.*)$')

        if search_pattern and search_pattern ~= '' then
          local item = p:current()

          vim.api.nvim_buf_call(p.preview.win.buf, function()
            vim.api.nvim_win_set_cursor(0, item and item.pos)
            local search = vim.fn.searchpos(search_pattern, 'cw')
            if search[1] > 0 then
              vim.cmd('/' .. search_pattern)

              vim.api.nvim_win_set_cursor(0, { search[1], search[2] })
              item.pos = { search[1], search[2] }
            end
          end)
          return
        end
      end,
    },
    filter = {
      ---@param p snacks.picker
      ---@param filter snacks.picker.Filter
      transform = function(p, filter)
        local buffer_pattern = filter.pattern:match('^.-$(.*)$')
        local symbol_pattern_before, symbol_pattern = filter.pattern:match('^(.-)@(.*)$')
        local line_nr_pattern = filter.pattern:match('^.-:(%d*)$')
        local search_pattern = filter.pattern:match('^.-#(.*)$')
        local pattern = symbol_pattern or line_nr_pattern or search_pattern or buffer_pattern

        if pattern then
          local item = p:current()
          if item and item.file then
            filter.meta.buf = vim.fn.bufadd(item.file)
          end
        end

        if not filter.meta.buf then
          filter.source_id = 1
          return
        end

        if symbol_pattern then
          filter.pattern = symbol_pattern
          if not (symbol_pattern_before == nil or symbol_pattern_before == '') then
            filter.current_buf = filter.meta.buf
          end
          filter.source_id = 2
          return
        end

        if buffer_pattern then
          filter.pattern = buffer_pattern
          filter.current_buf = filter.meta.buf
          filter.source_id = 3
          return
        end

        if line_nr_pattern then
          filter.pattern = filter.pattern:gsub(':%d*$', '')
          filter.current_buf = filter.meta.buf
          filter.source_id = 1
          local item = p:current()
          if item then
            item.pos = { tonumber(line_nr_pattern) or 1, 0 }
            if p.preview.win.buf ~= nil then
              p.preview:loc()
            end
          end
          return
        end

        if search_pattern then
          filter.pattern = filter.pattern:gsub('#.*$', '')
          filter.current_buf = filter.meta.buf
          filter.source_id = 1
          if search_pattern == '' then
            return
          end
          local item = p:current()

          if p.preview.win.buf ~= nil then
            vim.api.nvim_buf_call(p.preview.win.buf, function()
              vim.api.nvim_win_set_cursor(0, { 1, 0 })
              local search = vim.fn.searchpos(search_pattern, 'cw')
              if search[1] > 0 then
                vim.cmd('/' .. search_pattern)
                vim.api.nvim_win_set_cursor(0, { search[1], search[2] })
                item.pos = { search[1], search[2] }
              end
            end)
          end
          return
        end

        filter.source_id = 1
      end,
    },
  })
end

function M.buffers_with_symbols()
  Snacks.picker({
    title = 'Buffers',
    multi = { 'buffers', 'lsp_symbols' },
    layout = { preset = 'dropdown', preview = 'main' },
    -- win = { preview = preview_main.show_winbar },
    -- on_show = function(picker)
    --   vim.cmd.stopinsert()
    --   -- you can auto enable it if you want
    --   vim.schedule(function()
    --     flash_on_picker(picker)
    --   end)
    -- end,
    filter = {
      ---@param p snacks.Picker
      ---@param filter snacks.picker.Filter
      transform = function(p, filter)
        local symbol_pattern = filter.pattern:match('^.-@(.*)$')

        -- store the current file buffer
        if filter.source_id ~= 2 then
          local item = p:current()
          if item and item.file then
            filter.meta.buf = vim.fn.bufadd(item.file)
          end
        end

        if symbol_pattern and filter.meta.buf then
          filter.pattern = symbol_pattern
          filter.current_buf = filter.meta.buf
          filter.source_id = 2
        else
          filter.source_id = 1
        end
      end,
    },
  })
end

---Check if cursor is in range
---@param cursor integer[] cursor position (line, character); (1, 0)-based
---@param range lsp_range_t 0-based range
---@return boolean
local function cursor_in_range(cursor, range)
  if range == nil then
    return false
  end

  local cursor0 = { cursor[1] - 1, cursor[2] }
  -- stylua: ignore start
  return (
    cursor0[1] > range.start.line
    or (cursor0[1] == range.start.line
        and cursor0[2] >= range.start.character)
  )
    and (
      cursor0[1] < range['end'].line
      or (cursor0[1] == range['end'].line
          and cursor0[2] <= range['end'].character)
    )
  -- stylua: ignore end
end
function M.lsp_symbols()
  -- see: https://github.com/folke/snacks.nvim/issues/1057#issuecomment-2652052218
  local cursor = vim.api.nvim_win_get_cursor(0)
  local picker = Snacks.picker.lsp_symbols()
  -- focus the symbol at the cursor position
  picker.matcher.task:on(
    'done',
    vim.schedule_wrap(function()
      local symbols = picker:items()
      for i = #symbols, 1, -1 do
        if cursor_in_range(cursor, symbols[i].range) then
          picker.list:move(symbols[i].idx, true)
          return
        end
      end
    end)
  )
end

function M.open_qflist_or_loclist()
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())
  if #wininfo == 0 then
    return
  end

  local win = wininfo[1]
  vim.cmd([[cclose|lclose]])
  local list_type = win.loclist == 1 and 'loclist' or 'qflist'
  Snacks.picker[list_type]()
end

function M.flash_on_picker(picker)
  require('flash').jump({
    pattern = '^',
    label = {
      after = { 0, 0 },
      current = false,
    },
    highlight = {
      -- show a backdrop with hl FlashBackdrop
      backdrop = false,
      -- Highlight the search matches
      matches = true,
      -- extmark priority
      priority = 5000,
      groups = {
        match = 'FlashMatch',
        current = 'FlashCurrent',
        backdrop = 'FlashBackdrop',
        label = 'FlashLabel',
      },
    },
    search = {
      mode = 'search',
      exclude = {
        function(win)
          return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= 'snacks_picker_list'
        end,
      },
    },
    action = function(match)
      local idx = picker.list:row2idx(match.pos[1])
      picker.list:_move(idx, true, true)
      picker:action('confirm')
      -- you can also add auto confirm here
    end,
  })
end

return M
