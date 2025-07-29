local state = require('core.state')
local btn_width = 32
local function button(key, label, icon, desc, cmd)
  local pad = btn_width - #label

  return {
    text = {
      { icon, hl = 'SnacksDashboardDesc', width = 3 },
      { desc, hl = 'SnacksDashboardDesc', width = pad },
      { '', hl = 'SnacksDashboardKeyAlt' },
      { label, hl = 'SnacksDashboardKey' },
      { '', hl = 'SnacksDashboardKeyAlt' },
      -- { label, hl = 'SnacksDashboardKey' },
    },
    action = cmd,
    key = key,
    align = 'center',
  }
end

local termWinbar = ''
-- termWinbar=%{%v:lua.require'heirline'.eval_winbar()%}

---Check if cursor is in range
---@param cursor integer[] cursor position (line, character); (1, 0)-based
---@param range lsp_range_t 0-based range
---@return boolean
local function cursor_in_range(cursor, range)
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
local lsp_symbols = function()
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

-- local group = vim.api.nvim_create_augroup('SnackHooks', { clear = true })
-- vim.api.nvim_create_autocmd({ 'User' }, {
--   pattern = 'SnacksDashboardOpened',
--   group = group,
--   callback = function()
--     vim.o.laststatus = 3
--   end,
-- })

local function get_dropdown(preview)
  return {
    preview = preview,
    layout = {
      row = preview and 0 or nil,
      height = preview and 0.7 or 0.4,
      backdrop = false,
      width = 0.4,
      min_width = 86,
      border = 'none',
      box = 'vertical',
      {
        win = 'preview',
        height = 0.45,
        border = { '🭽', '▔', '🭾', '▕', '', '', '', '▏' },
        -- border = { '🭽', '▔', '🭾', '▕', '▔', '▔', '▔', '▏' },
      },
      {
        box = 'vertical',
        border = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' },
        title = '{source} {live}',
        title_pos = 'center',
        { win = 'input', height = 1, border = 'bottom' },
        { win = 'list', border = 'none' },
      },
    },
  }
end

local function get_ivy(mini)
  return {
    layout = {
      box = 'vertical',
      backdrop = false,
      row = -1,
      width = 0,
      height = mini and 0.4 or 0.7,
      border = 'none',
      {
        win = 'input',
        height = 1,
        border = { '▔', '▔', '▔', ' ', '─', '─', '─', ' ' },
        title = ' {source} {live}',
        title_pos = 'center',
      },
      {
        box = 'horizontal',
        { win = 'list', border = 'none' },
        { win = 'preview', width = 0.6, border = 'left' },
      },
    },
  }
end

local auto_open_qflistt_or_loclist = function()
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())
  if #wininfo == 0 then
    return
  end

  local win = wininfo[1]
  vim.cmd([[cclose|lclose]])
  local list_type = win.loclist == 1 and 'loclist' or 'qflist'
  Snacks.picker[list_type]()
end

local flash_on_picker = function(picker)
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

local preview_main_win = {
  preview = {
    row = -1,
    -- wo = { winbar = '' },
  },
}

---try_change_quicklook
---@param p snacks.Picker
local function try_change_quicklook(p, action)
  if vim.b.qlook then
    vim.schedule(function()
      local cur_item = p.list:current()
      if not cur_item or cur_item._path == nil then
        return
      end

      local ok = pcall(require('hasan.utils.file').quicklook, { cur_item._path })
      if ok then
        vim.b.qlook = cur_item._path
        p:action(action)
      end
    end)
  else
    p:action(action)
  end
end

return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    enabled = true,
    lazy = false,
    -- dependencies = { },
    ---@type snacks.Config
    opts = {
      -- scroll = {
      --   animate = {
      --     easing = 'outCirc',
      --   },
      -- },
      -- zen = {
      --   on_open = function(win)
      --     wezterm_zen(nil, true, { font = 0 })
      --   end,
      --   on_close = function(win)
      --     wezterm_zen(nil, false, nil)
      --   end,
      -- },
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      words = {
        enabled = true,
        debounce = 450, -- time in ms to wait before updating
        modes = { 'n' }, -- modes to show references
      },
      explorer = { enabled = false },
      image = { enabled = false },
      input = {},
      indent = {
        ---@class snacks.indent.animate: snacks.animate.Config
        animate = { enabled = false },
        indent = { char = '│' }, -- blank = '·'
        ---@class snacks.indent.Scope.Config: snacks.scope.Config
        scope = {
          enabled = true,
          char = '│',
          underline = false, -- underline the start of the scope
          only_current = true, -- only show scope in the current window
        },
        -- filter for buffers to enable indent guides
        filter = function(buf)
          return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == ''
        end,
        priority = 200,
      },
      scope = {
        treesitter = { enabled = false },
        filter = function(buf)
          return vim.b[buf].snacks_indent_scope ~= false and vim.bo[buf].buftype == ''
        end,
        keys = {
          ---@type table<string, snacks.scope.TextObject|{desc?:string}>
          textobject = {
            ii = {
              linewise = true,
              min_size = 2, -- minimum size of the scope
              edge = false, -- inner scope
              cursor = false,
              treesitter = { blocks = { enabled = false } },
              desc = 'inner scope',
            },
            ai = {
              linewise = true,
              cursor = false,
              min_size = 2, -- minimum size of the scope
              treesitter = { blocks = { enabled = false } },
              desc = 'full scope',
            },
            iI = {
              linewise = true,
              min_size = 2, -- minimum size of the scope
              edge = false, -- inner scope
              cursor = true,
              treesitter = { blocks = { enabled = false } },
              desc = 'inner scope',
            },
            aI = {
              linewise = true,
              cursor = true,
              min_size = 2, -- minimum size of the scope
              treesitter = { blocks = { enabled = false } },
              desc = 'full scope',
            },
          },
          ---@type table<string, snacks.scope.Jump|{desc?:string}>
          jump = {
            ['[t'] = {
              min_size = 1, -- allow single line scopes
              bottom = false,
              cursor = false,
              edge = true,
              treesitter = { blocks = { enabled = false } },
              desc = 'jump to top edge of scope',
            },
            [']t'] = {
              min_size = 1, -- allow single line scopes
              bottom = true,
              cursor = false,
              edge = true,
              treesitter = { blocks = { enabled = false } },
              desc = 'jump to bottom edge of scope',
            },
          },
        },
      },
      notifier = {
        enabled = true,
        timeout = 3000, -- default timeout in ms
        margin = { top = 1, right = 1, bottom = 1 },
        padding = true, -- add 1 cell of left/right padding to the notification window
        -- sort = { 'level', 'added' }, -- sort by level and time
        icons = { error = '', warn = '', info = '', debug = '', trace = '󰠠' },
        ---@type snacks.notifier.style
        style = function(buf, notif, ctx)
          local title = vim.trim((notif.title or ''))
          if title ~= '' then
            ctx.opts.title = { { title, ctx.hl.title } }
            ctx.opts.title_pos = 'right'
          end
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(notif.msg, '\n'))
        end,
        -- 'compact'|'fancy'|'minimal'
        top_down = false, -- place notifications from top to bottom
      },
      lazygit = {
        theme = {
          inactiveBorderColor = { fg = 'NotifyBorder' },
        },
      },
      statuscolumn = {
        enabled = true,
        left = { 'sign', 'mark' }, -- priority of signs on the right (high to low)
        right = { 'fold', 'git' }, -- priority of signs on the left (high to low)
        folds = { open = false, git_hl = false },
        git = { patterns = { 'GitSign', 'MiniDiffSign' } },
        refresh = 50, -- refresh at most every 50ms
      },
      scratch = {
        ---@type table<string, snacks.win.Config>
        win_by_ft = {
          lua = {
            relative = 'editor',
            keys = {
              ['source'] = {
                '<cr>',
                function(self)
                  local name = 'scratch.' .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.buf), ':e')
                  Snacks.debug.run({ buf = self.buf, name = name })
                end,
                desc = 'Source buffer',
                mode = { 'n', 'x' },
              },
            },
          },
        },
      },
      dashboard = {
        enabled = not require('core.state').ui.session_autoload,
        -- These settings are used by some built-in sections
        preset = {
          -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
          ---@type fun(cmd:string, opts:table)|nil
          pick = nil,
        -- Used by the `keys` section to show keymaps
        ---@type snacks.dashboard.Item[]
        -- stylua: ignore
        keys = {
          button('r', 'R', ' ', 'Recent file', '<cmd>lua Snacks.dashboard.pick("recent")<CR>'),
          button('l', 'L', ' ', 'Load session', '<cmd>lua require("persisted").load()<CR>'),
          button('f', 'F', ' ', 'Search files', '<cmd>lua Snacks.dashboard.pick("files")<CR>'),
          button('s', 'S', ' ', 'Open settings', '<cmd>lua Snacks.dashboard.pick("files", {cwd = vim.fn.stdpath("config")})<CR>'),
          button('p', 'P', ' ', 'Lazy dashboard', '<cmd>Lazy<CR>'),
          button('a', 'A', ' ', 'Open org agenda', '<cmd>lua require("orgmode").action("agenda.prompt")<CR>'),
          -- { icon = ' ', label = ' n ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
          -- button('t', ' T ', '  Open terminal', ':FloatermNew --wintype=normal --height=10'),
          -- { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
        },
          -- Used by the `header` section
          header = [[
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣤⣤⣤⣤⡼⠀⢀⡀⣀⢱⡄⡀⠀⠀⠀⢲⣤⣤⣤⣤⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⣾⣿⣿⣿⣿⣿⡿⠛⠋⠁⣤⣿⣿⣿⣧⣷⠀⠀⠘⠉⠛⢻⣷⣿⣽⣿⣿⣷⣦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⢀⣴⣞⣽⣿⣿⣿⣿⣿⣿⣿⠁⠀⠀⠠⣿⣿⡟⢻⣿⣿⣇⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣟⢦⡀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣠⣿⡾⣿⣿⣿⣿⣿⠿⣻⣿⣿⡀⠀⠀⠀⢻⣿⣷⡀⠻⣧⣿⠆⠀⠀⠀⠀⣿⣿⣿⡻⣿⣿⣿⣿⣿⠿⣽⣦⡀⠀⠀⠀⠀
⠀⠀⠀⠀⣼⠟⣩⣾⣿⣿⣿⢟⣵⣾⣿⣿⣿⣧⠀⠀⠀⠈⠿⣿⣿⣷⣈⠁⠀⠀⠀⠀⣰⣿⣿⣿⣿⣮⣟⢯⣿⣿⣷⣬⡻⣷⡄⠀⠀⠀
⠀⠀⢀⡜⣡⣾⣿⢿⣿⣿⣿⣿⣿⢟⣵⣿⣿⣿⣷⣄⠀⣰⣿⣿⣿⣿⣿⣷⣄⠀⢀⣼⣿⣿⣿⣷⡹⣿⣿⣿⣿⣿⣿⢿⣿⣮⡳⡄⠀⠀
⠀⢠⢟⣿⡿⠋⣠⣾⢿⣿⣿⠟⢃⣾⢟⣿⢿⣿⣿⣿⣾⡿⠟⠻⣿⣻⣿⣏⠻⣿⣾⣿⣿⣿⣿⡛⣿⡌⠻⣿⣿⡿⣿⣦⡙⢿⣿⡝⣆⠀
⠀⢯⣿⠏⣠⠞⠋⠀⣠⡿⠋⢀⣿⠁⢸⡏⣿⠿⣿⣿⠃⢠⣴⣾⣿⣿⣿⡟⠀⠘⢹⣿⠟⣿⣾⣷⠈⣿⡄⠘⢿⣦⠀⠈⠻⣆⠙⣿⣜⠆
⢀⣿⠃⡴⠃⢀⡠⠞⠋⠀⠀⠼⠋⠀⠸⡇⠻⠀⠈⠃⠀⣧⢋⣼⣿⣿⣿⣷⣆⠀⠈⠁⠀⠟⠁⡟⠀⠈⠻⠀⠀⠉⠳⢦⡀⠈⢣⠈⢿⡄
⣸⠇⢠⣷⠞⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠻⠿⠿⠋⠀⢻⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⢾⣆⠈⣷
⡟⠀⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣶⣤⡀⢸⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡄⢹
⡇⠀⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠈⣿⣼⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠃⢸
⢡⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⠶⣶⡟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡼
⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡾⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡁⢠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣼⣀⣠⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
        },
        sections = {
          { section = 'header' },
          { section = 'keys', gap = 1, padding = 2 },
          -- { section = 'startup' },
          {
            function()
              local v = vim.version()
              local patch = v.patch
              if v.prerelease then
                patch = patch .. '-' .. v.prerelease
              end
              return {
                align = 'center',
                width = 30,
                text = {
                  { '██', hl = 'SnacksDashboardFooterAlt' },
                  { string.format([[v%s.%s.%s]], v.major, v.minor, patch), hl = 'SnacksDashboardFooter' },
                  { '██', hl = 'SnacksDashboardFooterAlt' },
                },
              }
            end,
          },
          -- { pane = 2, section = 'recent_files', padding = { 2, 10 }, title = 'Recent files' },
          -- { pane = 2, section = 'projects', title = 'Projects' },
          -- projects = <function 8>,
          -- recent_files = <function 9>,
          -- session = <function 10>,
          -- startup = <function 11>,
          -- terminal = <function 12>
        },
      },
      picker = {
        prompt = '   ',
        exclude = state.picker.exclude,
        sources = {
          buffers = { layout = 'dropdown', current = false },
          files = { layout = 'ivy' },
          commands = { layout = 'vscode' },
          keymaps = { layout = 'vscode' },
          git_files = { layout = 'dropdown' },
          recent = { layout = 'ivy' },
          treesitter = {
            layout = { preset = 'dropdown', preview = 'main' },
            win = preview_main_win,
            filter = {
              default = {
                'Class',
                'Enum',
                'Field',
                'Function',
                'Method',
                'Module',
                'Namespace',
                'Struct',
                'Trait',
                'identifier',

                'Variable',
                'Field',
                'TypeParameter',
                'Constant',
                'Interface',
                'Property',
              },
              markdown = true,
              help = true,
            },
          },
          lsp_symbols = { layout = 'dropdown' },
          smart = { layout = 'dropdown' },
          grep = { layout = 'dropdown_preview' },
          grep_word = { layout = 'dropdown_preview' },
          grep_buffers = { layout = 'dropdown_preview' },
          lines = {
            layout = { preset = 'ivy_mini', preview = 'main' },
            win = { preview = { row = -1 } },
          },

          zoxide = { layout = 'dropdown' },
          marks = { layout = 'dropdown_preview' },
          colorschemes = { layout = 'dropdown_preview' },
          highlights = { layout = 'dropdown_preview' },

          qflist = { layout = 'dropdown_preview' },
          loclist = { layout = 'dropdown_preview' },

          ---@type snacks.picker.file_browser.Config
          file_browser = {
            layout = 'ivy',
            -- prompt_prefix = false,
            -- title = 'asdfasdfsd',
          },

          explorer = {
            tree = true,
            watch = false,
            diagnostics = false,
            diagnostics_open = false,
            follow_file = true,
            focus = 'list',
            auto_close = false,
            win = {
              input = {
                keys = {
                  ['<tab>'] = { 'toggle_focus', mode = { 'i', 'n' } },
                },
              },
              list = {
                keys = {
                  ['<tab>'] = { 'toggle_focus', mode = { 'i', 'n' } },
                  ['o'] = 'confirm',
                  ['O'] = 'explorer_open', -- open with system application
                  ['x'] = 'explorer_close', -- close directory
                },
              },
            },
          },

          project_files = { -- https://github.com/folke/snacks.nvim/issues/532#issuecomment-2609303872
            layout = { preset = 'vscode', preview = 'main' },
            multi = { 'files', 'lsp_symbols' },
            -- finder = 'files',
            matcher = {
              cwd_bonus = true, -- boost cwd matches
              frecency = true, -- use frecency boosting
              sort_empty = true, -- sort even when the filter is empty
            },
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
                local symbol_pattern = filter.pattern:match('^.-@(.*)$')
                local line_nr_pattern = filter.pattern:match('^.-:(%d*)$')
                local search_pattern = filter.pattern:match('^.-#(.*)$')
                local pattern = symbol_pattern or line_nr_pattern or search_pattern

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
                  filter.current_buf = filter.meta.buf
                  filter.source_id = 2
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
          },

          buffers_with_symbols = {
            title = 'Buffers',
            multi = { 'buffers', 'lsp_symbols' },
            layout = { preset = 'dropdown', preview = 'main' },
            win = preview_main_win,
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
          },
        },

        formatters = {
          file = {
            filename_first = true, -- display filename before the file path
          },
        },

        actions = {
          flash = flash_on_picker,
          fedit = function(picker, item)
            picker:close()
            if not item or item.file == nil then
              return
            end

            -- FIXME: do not kill buffer if it is opend before
            require('hasan.float').fedit(item.file)
          end,
          my_list_up = function(p)
            try_change_quicklook(p, 'list_up')
          end,
          my_list_down = function(p)
            try_change_quicklook(p, 'list_down')
          end,
          quicklook = function(_, item)
            if not item or item._path == nil then
              return
            end
            local ok = pcall(require('hasan.utils.file').quicklook, { item._path })
            if not ok then
              return
            end

            if vim.b.qlook and vim.b.qlook == item._path then
              vim.b.qlook = nil
            else
              vim.b.qlook = item._path
            end
          end,
          system_reveal = function(picker, item)
            picker:close()
            if not item or item._path == nil then
              return
            end

            require('hasan.utils.file').system_open(item._path, { reveal = true })
          end,
          system_open = function(picker, item)
            picker:close()
            if not item or item._path == nil then
              return
            end

            require('hasan.utils.file').system_open(item._path)
          end,
          focus_file_tree = function(picker, item)
            picker:close()
            if not item or item._path == nil then
              return
            end

            require('neo-tree.command').execute({
              action = 'focus', -- OPTIONAL, this is the default value
              source = 'filesystem', -- OPTIONAL, this is the default value
              reveal_file = item._path, -- path to file or folder to reveal
              reveal_force_cwd = true, -- change cwd without asking if needed
            })
          end,
          insert_relative_path = function(p, item, action)
            local buf_name = vim.api.nvim_buf_get_name(p.finder.filter['current_buf'])
            buf_name = vim.fs.normalize(buf_name)
            local text = require('hasan.utils.file').get_relative_path(buf_name, item._path)

            p:close()
            if text then
              vim.api.nvim_put({ text }, 'c', true, true)
            end
          end,
        },

        icons = {
          kinds = require('hasan.utils.ui.icons').kind,
        },

        win = {
          input = {
            keys = {
              ['<c-u>'] = false,
              ['<Esc>'] = { 'close', mode = { 'i', 'n' } },

              ['<F3>'] = { 'toggle_preview', mode = { 'i', 'n' } },
              ['<a-u>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
              ['<a-d>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
              ['<c-b>'] = { 'list_scroll_up', mode = { 'i', 'n' } },
              ['<c-f>'] = { 'list_scroll_down', mode = { 'i', 'n' } },

              ['<s-tab>'] = { 'my_list_up', mode = { 'i', 'n' } },
              ['<tab>'] = { 'my_list_down', mode = { 'i', 'n' } },
              ['<c-i>'] = { 'select_and_prev', mode = { 'i', 'n' } },
              ['<c-y>'] = { 'select_and_next', mode = { 'i', 'n' } },
              ['<A-y>'] = { 'select_and_next', mode = { 'i', 'n' } },

              ['<a-p>'] = { 'list_up', mode = { 'i', 'n' } },
              ['<a-n>'] = { 'list_down', mode = { 'i', 'n' } },
              ['<a-k>'] = { 'list_up', mode = { 'i', 'n' } },
              ['<a-j>'] = { 'list_down', mode = { 'i', 'n' } },

              -- ['<c-a>'] = { 'select_all', mode = { 'n', 'i' } },
              -- ['<a-f>'] = { 'toggle_follow', mode = { 'i', 'n' } },
              -- ['<a-h>'] = { 'toggle_hidden', mode = { 'i', 'n' } },
              -- ['<a-i>'] = { 'toggle_ignored', mode = { 'i', 'n' } },
              -- ['<a-i>'] = { 'toggle_ignored', mode = { 'i', 'n' } },
              -- ['<a-h>'] = { 'toggle_hidden', mode = { 'i', 'n' } },
              -- ['<a-f>'] = { 'toggle_follow', mode = { 'i', 'n' } },

              ['<c-r><c-r>'] = { 'insert_relative_path', mode = { 'i', 'n' } },
              ['<a-l>'] = { 'inspect', mode = { 'i', 'n' } },

              ['<a-t>'] = { 'focus_file_tree', mode = { 'i', 'n' } },
              ['<a-s>'] = { 'flash', mode = { 'n', 'i' } },
              ['s'] = { 'flash' },

              ['<a-i>'] = { 'quicklook', mode = { 'i', 'n' } },
              ['<a-r>'] = { 'system_reveal', mode = { 'i', 'n' } },
              ['R'] = { 'system_reveal', mode = { 'n' } },
              ['<a-o>'] = { 'system_open', mode = { 'i', 'n' } },
              ['O'] = { 'system_open', mode = { 'n' } },
              -- ['<S-CR>'] = { 'fedit', mode = { 'i', 'n' } },
            },
          },
        },

        layouts = {
          dropdown = get_dropdown(false),
          dropdown_preview = get_dropdown(true),
          ivy = get_ivy(false),
          ivy_mini = get_ivy(true),
          select = {
            preview = false,
            layout = {
              backdrop = false,
              width = 0.5,
              min_width = 80,
              height = 0.4,
              min_height = 3,
              box = 'vertical',
              border = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' },
              title = '{title}',
              title_pos = 'center',
              { win = 'input', height = 1, border = 'bottom' },
              { win = 'list', border = 'none' },
              { win = 'preview', title = '{preview}', height = 0.4, border = { '', '▔', '', '', '', '', '', '' } },
            },
          },
        },
      },
      styles = {
        notification = {
          border = {
            ' ',
            ' ', -- up
            '▐',
            '▐',
            '▐',
            ' ', -- bottom
            ' ',
            ' ',
          },
          relative = 'editor',
          wo = { wrap = true, winblend = 0 },
        },
        terminal = { relative = 'editor', border = 'rounded', wo = { winhighlight = '' } },
        notification_history = {
          relative = 'editor',
          keys = { q = 'close' },
          zindex = 100,
          wo = {
            number = false,
            relativenumber = false,
            signcolumn = 'no',
            winhighlight = 'Normal:SnacksNotifierHistory',
          },
        },
        dashboard = {
          relative = 'editor',
          zindex = 10,
          height = 0,
          width = 0,
          -- wo = { winhighlight = 'Normal:SidebarDark,NormalFloat:SidebarDark' },
        },
        lazygit = {
          relative = 'editor',
          height = 0,
          width = 0,
          border = 'none',
        },
        input = {
          backdrop = false,
          position = 'float',
          border = 'rounded',
          title_pos = 'center',
          height = 1,
          width = 60,
          relative = 'editor',
          row = 2,
          wo = {
            winhighlight = 'Normal:SidebarDark,NormalFloat:SnacksInputNormal,FloatBorder:SnacksInputBorder,FloatTitle:SnacksInputTitle',
          },
          -- keys = { },
        },
        input_cursor = { relative = 'cursor', row = 1, col = 0, width = 30 },
        scratch = {
          relative = 'editor',
          width = 100,
          height = 30,
          bo = { buftype = '', buflisted = false, bufhidden = 'hide', swapfile = false },
          minimal = false,
          noautocmd = false,
          zindex = 20,
          wo = { winhighlight = 'NormalFloat:Normal', winbar = '' },
          border = 'rounded',
          title_pos = 'center',
          footer_pos = 'center',
        },
        zen = {
          relative = 'editor',
          enter = true,
          fixbuf = false,
          minimal = false,
          width = 120,
          height = 0,
          backdrop = { transparent = false, blend = 96 },
          keys = { q = false },
          wo = { winhighlight = 'NormalFloat:Normal', winbar = '' },
        },
      },
    },
  -- stylua: ignore
  keys = {
    -- { 'g]',         function() Snacks.words.jump(vim.v.count1) end, desc = 'Next Reference', mode = { 'n', 't' } },
    -- { 'g[',         function() Snacks.words.jump(-vim.v.count1) end, desc = 'Prev Reference', mode = { 'n', 't' } },
    { '<leader>vo', function() Snacks.notifier.hide() end, desc = 'Dismiss All Notifications' },
    { '<leader>vn', function() Snacks.notifier.show_history() end, desc = 'Notification History' },
    { '<leader>bd', function() Snacks.bufdelete() end, desc = 'Kill this buffer' },
    { '<leader>bo', function() Snacks.bufdelete.other() end, desc = 'Kill this buffer' },
    { '<leader>go', function() Snacks.gitbrowse() end, desc = 'Open git repo' , mode = { 'n', 'v' } },
    { '<leader>gO', function() Snacks.gitbrowse({ open = function(url) vim.fn.setreg("+", url) end, notify = false }) end,  desc = "Git Browse (copy)", mode = {"n", "x" } },
    { '<leader>fr', function() Snacks.rename.rename_file() end, desc = 'Lsp: Rename file' },
    { '<leader>pd', function () Snacks.dashboard.open() end, desc = 'Open dashboard' },
    { '<leader>z',  function() Snacks.zen() end, desc = 'Toggle Zen Mode' },
    { '<leader>u',  function() Snacks.zen() end, desc = 'Toggle Zen Mode' },
    { '<leader>w.',  function() Snacks.zen.zoom() end, desc = 'Toggle Zoom' },
    { '<leader>x', function() Snacks.scratch() end, desc = 'Toggle Scratch Buffer' },
    { '<leader>/x', function() Snacks.scratch.select() end, desc = 'Select Scratch Buffer' },
    {
      '<leader>N',
      desc = 'Neovim News',
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1],
          width = 0.6,
          height = 0.6,
          wo = { spell = false, wrap = false, signcolumn = 'yes', statuscolumn = ' ', conceallevel = 3 },
        })
      end,
    },
    -- Terminal
    { '<M-m>', function() Snacks.terminal(nil, { shell = 'bash', win = { position = 'float' } }) end, desc = 'Terminal'  },
    { '<leader>ot', function() Snacks.terminal(nil, { shell = 'bash', win = { wo = { winbar = termWinbar } } }) end, desc = 'Terminal'  },
    { '<leader>of', function() Snacks.terminal('yazi', { shell = 'bash', win = { style = 'lazygit' } }) end, desc = 'Open File Manager' },
    { '<leader>gl', function() Snacks.lazygit() end, desc = 'Open lazygit' },

    -- FIND FILES
    { '<C-p>', function() Snacks.picker.project_files() end, desc = 'Find project files' },
    { '<leader><space>', function() Snacks.picker.project_files() end, desc = 'Find project files' },
    -- { '<leader><space>', function() Snacks.picker.smart() end, desc = 'Find project files' },
    -- { '<leader><space>', function() Snacks.picker.git_files() end, desc = 'Find Git Files' },
    -- { '<leader>.', function() Snacks.picker.files({layout='ivy', cwd=vim.fn.expand('%:h')}) end, desc = 'Browse cur directory' },
    { '<leader>ff', function() Snacks.picker.files() end, desc = 'Find Files' },
    { '<leader>fg', function() Snacks.picker.git_files() end, desc = 'Find Git Files' },
    { '<leader>fr', function() Snacks.picker.recent() end, desc = 'Recent' },
    { '<leader>fc', function() Snacks.picker.files({cwd=vim.fn.stdpath('config')}) end, desc = 'Find Config File' },
    { '<leader>fe', function() Snacks.explorer() end, desc = 'File Explorer' },

    -- FIND BUFFERS
    { 'g.', function() Snacks.picker.buffers_with_symbols() end, desc = 'which_key_ignore' },
    { '<leader>bb', function() Snacks.picker.buffers_with_symbols() end, desc = 'Buffers' },

    -- LSP
    { 'go', lsp_symbols, desc = 'LSP Symbols' },
    { 'g/', function() Snacks.picker.treesitter() end, desc = 'Treesitter Symbols' },

    -- GIT
    { '<leader>g/', function() Snacks.picker.git_status() end, desc = 'Git Status' },
    { '<leader>gc', function() Snacks.picker.git_log() end, desc = 'Git Log' },

    -- GREP
    { '<leader>//', function() Snacks.picker.grep() end, desc = 'Grep' },
    { '<leader>/b', function() Snacks.picker.grep_buffers() end, desc = 'Grep Open Buffers' },
    { '//', function() Snacks.picker.lines() end, desc = 'which_key_ignore' },
    { '<A-/>', function() Snacks.picker.grep_word() end, desc = 'Visual selection or word', mode = { "n", "x" } },

    -- SEARCH
    { '<leader>/.', function() Snacks.picker.resume() end, desc = 'Resume' },
    { '<leader>/f', function() Snacks.picker.files() end, desc = 'Find Files' },
    { '<leader>/k', function() Snacks.picker.keymaps() end, desc = 'Keymaps' },
    { '<leader>/q', function() Snacks.picker.qflist() end, desc = 'Quickfix List' },
    { '<leader>/l', function() Snacks.picker.loclist() end, desc = 'Location List' },
    { '<leader>/H', function() Snacks.picker.highlights() end, desc = 'Highlights' },
    { '<leader>/c', function() Snacks.picker.command_history() end, desc = 'Command History' },
    { 'cy', function() require('config.navigation.snacks.custom').keymaps() end, desc = 'Commands' },
    { '<F1>', function() Snacks.picker.commands() end, desc = 'Commands' },
    { '//', auto_open_qflistt_or_loclist, ft = 'qf', desc = 'which_key_ignore' },

    -- PROJECT
    { '<leader>pr', function() Snacks.picker.recent({cwd = vim.uv.cwd()}) end, desc = 'Find recent files' },
    { '<leader>pe', function() Snacks.picker.zoxide() end, desc = 'Find zoxide list' },
    { '<leader>pp', function() require('hasan.picker.persisted').persisted() end, desc = 'Switch project' },
    { '<leader>/t', function() require('config.navigation.snacks.custom').search_project_todos() end, desc = 'Search project todos' },

    -- VIM Builtins
    { '<leader>v/', function() Snacks.picker.help() end, desc = 'Help Pages' },
    { '<leader>vm', function() Snacks.picker.marks() end, desc = 'Marks' },
    { '<leader>vc', function() Snacks.picker.colorschemes() end, desc = 'Colorschemes' },

    -- ORGMODE
    { '<leader>ng', function() Snacks.picker.grep({cwd=org_root_path}) end, desc = 'Grep org text' },
    { '<leader>w/', function() Snacks.picker.files({cwd=org_root_path}) end, desc = 'Find org files' },
  },
    init = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          _G.log = function(...)
            Snacks.debug.log(...)
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          Snacks.toggle.line_number():map('<leader>tn')
          Snacks.toggle.option('cursorcolumn', { name = 'Cursorcolumn' }):map('<leader>tC')
          Snacks.toggle.option('cursorline', { name = 'Cursorline' }):map('<leader>tL')
          Snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>ts')
          Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>tw')
          Snacks.toggle
            .option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map('<leader>to')
          Snacks.toggle.inlay_hints():map('<leader>th')
          Snacks.toggle.treesitter({ name = 'Treesitter' }):map('<leader>tT')
          Snacks.toggle.indent():map('<leader>ti')
          Snacks.toggle.dim():map('<leader>tm')
          Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map('<leader>tB')
          Snacks.toggle.diagnostics():map('<leader>td')
          Snacks.toggle({
            name = 'Diagnostic Lines',
            get = function()
              return vim.diagnostic.config().virtual_text
            end,
            set = function(st)
              return vim.diagnostic.config({ virtual_text = st })
            end,
          }):map('<leader>tl')

          Snacks.toggle({
            name = 'Transparency',
            get = function()
              return require('core.state').theme.transparency
            end,
            set = function(_)
              require('hasan.utils.color').toggle_transparency(false)
            end,
          }):map('<leader>tb')

          Snacks.toggle({
            name = 'Highlight same words',
            get = function()
              return type(vim.w.auto_highlight_id) == 'number'
            end,
            set = function(state)
              vim.fn['autohl#_AutoHighlightToggle']()
            end,
          }):map('<leader>tW')

          vim.api.nvim_create_autocmd('FileType', {
            pattern = { 'org' },
            callback = function(info)
              -- vim.b[info.buf]['snacks_indent'] = false
              vim.b[info.buf]['snacks_indent_scope'] = false
            end,
          })
        end, -- VeryLazy Callback
      })
    end,
  },
  {
    'hasansujon786/snacks-file-browser.nvim',
    lazy = true,
    dev = true,
    -- stylua: ignore start
    keys = {
      { '<leader>.', function() require('snacks-file-browser').browse({ cwd = vim.fn.expand('%:h') }) end, desc = 'Browse cur directory' },
      { '<leader>f.', function() require('snacks-file-browser').browse() end, desc = 'Browser Project' },
      { '<leader>fb', function() require('snacks-file-browser').select_dir() end, desc = 'Browser Project' },
    },
  },
}
