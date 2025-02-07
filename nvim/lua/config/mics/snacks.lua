local btn_width = 36
local function button(key, label, desc, cmd)
  local pad = btn_width - #label

  return {
    text = {
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
      height = mini and 0.5 or 0.7,
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

local search_project_todos = function()
  Snacks.picker.grep_word({
    show_empty = true,
    search = function()
      return table.concat(require('core.state').project.todo_keyfaces, ':|') .. ':' -- Creates "TODO :|DONE :|INFO :|..."
    end,
    finder = 'grep',
    format = 'file',
    live = false,
    supports_live = true,
  })
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

return {
  'hasansujon786/snacks.nvim',
  priority = 1000,
  enabled = true,
  lazy = false,
  dependencies = {
    { 'hasansujon786/snacks-file-browser.nvim', dev = true },
  },
  ---@type snacks.Config
  opts = {
    -- scroll = {
    --   animate = {
    --     easing = 'outCirc',
    --   },
    -- },
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    words = { enabled = true },
    explorer = { enabled = true },
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
            min_size = 2, -- minimum size of the scope
            edge = false, -- inner scope
            cursor = true,
            treesitter = { blocks = { enabled = false } },
            desc = 'inner scope',
          },
          ai = {
            cursor = true,
            min_size = 2, -- minimum size of the scope
            treesitter = { blocks = { enabled = false } },
            desc = 'full scope',
          },
          iI = {
            min_size = 2, -- minimum size of the scope
            edge = false, -- inner scope
            cursor = false,
            treesitter = { blocks = { enabled = false } },
            desc = 'inner scope',
          },
          aI = {
            cursor = false,
            min_size = 2, -- minimum size of the scope
            treesitter = { blocks = { enabled = false } },
            desc = 'full scope',
          },
        },
        ---@type table<string, snacks.scope.Jump|{desc?:string}>
        jump = {
          ['[i'] = {
            min_size = 1, -- allow single line scopes
            bottom = false,
            cursor = false,
            edge = true,
            treesitter = { blocks = { enabled = false } },
            desc = 'jump to top edge of scope',
          },
          [']i'] = {
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
      margin = { top = 1, right = 0, bottom = 0 },
      padding = true, -- add 1 cell of left/right padding to the notification window
      -- sort = { 'level', 'added' }, -- sort by level and time
      icons = { error = ' ', warn = ' ', info = ' ', debug = ' ', trace = '󰠠 ' },
      ---@type snacks.notifier.style
      style = 'compact', -- 'compact'|'fancy'|'minimal'
      top_down = false, -- place notifications from top to bottom
    },
    statuscolumn = {
      enabled = true,
      left = { 'sign', 'mark' }, -- priority of signs on the right (high to low)
      right = { 'git' }, -- priority of signs on the left (high to low)
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
          button('r', 'R', '  Recent file', '<cmd>lua require("telescope.builtin").oldfiles({cwd_only = true})<CR>'),
          button('l', 'L', '  Load session', '<cmd>lua require("persisted").load()<CR>'),
          button('f', 'F', '  Find files', '<cmd>lua require("hasan.telescope.custom").my_find_files()<CR>'),
          button('s', 'S', '  Open settings', '<cmd>lua Snacks.dashboard.pick("files", {cwd = vim.fn.stdpath("config")})<CR>'),
          button('p', 'P', '  Lazy dashboard', '<cmd>Lazy<CR>'),
          button('a', 'A', '  Open org agenda', '<cmd>lua require("orgmode").action("agenda.prompt")<CR>'),
          -- { icon = ' ', label = ' n ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
          -- button('t', ' T ', '  Open terminal', ':FloatermNew --wintype=normal --height=10'),
          -- { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
        },
        -- Used by the `header` section
        header = [[
      ,               ,        
    ,//,              %#*,     
  ,((((//,            /###%*,  
,((((((////,          /######%.
///((((((((((,        *#######.
//////(((((((((,      *#######.
//////(/(((((((((,    *#######.
//////(. /(((((((((,  *#######.
//////(.   (((((((((*,*#######.
//////(.    ,#((((((((########.
/////((.      /#((((((##%%####.
(((((((.        .(((((#####%%#.
 /(((((.          ((((#%#%%/*  
   ,(((.            /(%%#*     
      *               *        ]],
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
      exclude = {
        -- dotfiles
        'gui/sublime_text/',
        'nvim/tmp/archive',
        '4_archive/.*',
        -- projects
        'android/.*',
        'ios/.*',
        'vendor/.*',
        'pubspec.lock',
      },
      sources = {
        buffers = { layout = 'dropdown', current = false },
        files = { layout = 'ivy' },
        git_files = { layout = 'vscode' },
        recent = { layout = 'ivy' },
        lsp_symbols = { layout = 'dropdown' },
        smart = { preset = 'vscode', preview = 'main' },

        grep = { layout = 'dropdown_preview' },
        grep_word = { layout = 'dropdown_preview' },
        grep_buffers = { layout = 'dropdown_preview' },
        lines = {
          layout = { preset = 'ivy_mini', preview = 'main' },
          win = {
            preview = {
              max_height = vim.o.lines - 2,
              wo = { winbar = '' },
            },
          },
        },

        zoxide = { layout = 'dropdown' },
        marks = { layout = 'dropdown_preview' },
        colorschemes = { layout = 'dropdown_preview' },
        highlights = { layout = 'dropdown_preview' },

        qflist = { layout = 'dropdown_preview' },
        loclist = { layout = 'dropdown_preview' },

        ---@type snacks.picker.file_browser.Config
        file_browser = {
          -- prompt_prefix = false,
          -- title = 'asdfasdfsd',
        },

        explorer = {
          win = {
            input = {
              keys = {
                ['<tab>'] = { 'toggle_focus', mode = { 'i', 'n' } },
              },
            },
            list = {
              keys = {
                ['<tab>'] = { 'toggle_focus', mode = { 'i', 'n' } },
              },
            },
          },
        },

        project_files = { -- https://github.com/folke/snacks.nvim/issues/532#issuecomment-2609303872
          layout = { preset = 'vscode' },
          multi = { 'files', 'lsp_symbols' },
          matcher = {
            cwd_bonus = true, -- boost cwd matches
            frecency = true, -- use frecency boosting
            sort_empty = true, -- sort even when the filter is empty
          },
          filter = {
            ---@param p snacks.Picker
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
                    local search = vim.fn.search(search_pattern, 'ncW')
                    if search > 0 then
                      vim.cmd('/' .. search_pattern)
                      -- if vim.fn.line('w$') < search then
                      --   vim.api.nvim_win_set_cursor(0, { math.max(1, search - 8), 0 })
                      -- end
                      item.pos = { search, 0 }
                      p.preview:loc()
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
          win = { preview = { wo = { winbar = '' } } }, -- on_show = function(picker)
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
        quicklook = function(_, item)
          if not item or item._path == nil then
            return
          end

          require('hasan.utils.file').quickLook({ item._path })
        end,
        system_open = function(picker, item)
          picker:close()
          if not item or item._path == nil then
            return
          end

          require('hasan.utils.file').system_open(item._path, { reveal = true })
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
      },

      icons = {
        kinds = require('hasan.utils.ui.icons').kind,
      },

      win = {
        input = {
          keys = {
            ['<a-q>'] = { 'toggle_preview', mode = { 'i', 'n' } },
            ['<a-u>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
            ['<a-d>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
            ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
            ['<a-n>'] = { 'list_down', mode = { 'i', 'n' } },
            ['<a-p>'] = { 'list_up', mode = { 'i', 'n' } },
            ['<tab>'] = { 'list_down', mode = { 'i', 'n' } },
            ['<s-tab>'] = { 'list_up', mode = { 'i', 'n' } },
            ['<c-u>'] = false,

            -- ['<a-i>'] = { 'toggle_ignored', mode = { 'i', 'n' } },
            -- ['<a-h>'] = { 'toggle_hidden', mode = { 'i', 'n' } },
            -- ['<a-f>'] = { 'toggle_follow', mode = { 'i', 'n' } },

            ['<a-s>'] = { 'flash', mode = { 'n', 'i' } },
            ['s'] = { 'flash' },
            ['<c-t>'] = { 'focus_file_tree', mode = { 'i', 'n' } },
            ['<a-i>'] = { 'quicklook', mode = { 'i', 'n' } },
            ['<a-o>'] = { 'system_open', mode = { 'i', 'n' } },
            -- ['<S-CR>'] = { 'fedit', mode = { 'i', 'n' } },
          },
        },
      },

      layouts = {
        dropdown = get_dropdown(false),
        dropdown_preview = get_dropdown(true),

        vscode = {
          preview = false,
          layout = {
            backdrop = false,
            row = 0,
            width = 0.4,
            min_width = 80,
            height = 0.45,
            box = 'vertical',
            border = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' },
            title = '{source} {live}',
            title_pos = 'center',
            { win = 'input', height = 1, border = 'bottom' },
            { win = 'list', border = 'none' },
            { win = 'preview', height = 0.4, border = { '', '▔', '', '', '', '', '', '' } },
          },
        },

        ivy = get_ivy(false),
        ivy_mini = get_ivy(true),
      },
    },
    styles = {
      notification = { relative = 'editor', wo = { wrap = true, winblend = 0 } },
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
    { 'g]',         function() Snacks.words.jump(vim.v.count1) end, desc = 'Next Reference', mode = { 'n', 't' } },
    { 'g[',         function() Snacks.words.jump(-vim.v.count1) end, desc = 'Prev Reference', mode = { 'n', 't' } },
    { '<leader>vv', function() Snacks.notifier.hide() end, desc = 'which_key_ignore' },
    { '<leader>vo', function() Snacks.notifier.hide() end, desc = 'Dismiss All Notifications' },
    { '<leader>bd', function() Snacks.bufdelete() end, desc = 'Kill this buffer' },
    { '<leader>go', function() Snacks.gitbrowse() end, desc = 'Open git repo' , mode = { 'n', 'v' } },
    { '<leader>aR', function() Snacks.rename.rename_file() end, desc = 'Lsp: Rename file' },
    { '<leader>pd', function () Snacks.dashboard.open() end, desc = 'Open dashboard' },

    { '<leader>z',  function() Snacks.zen() end, desc = 'Toggle Zen Mode' },
    { '<leader>u',  function() Snacks.zen.zoom() end, desc = 'Toggle Zoom' },
    { '<leader>vn', function() Snacks.notifier.show_history() end, desc = 'Notification History' },
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
    -- FIND FILES
    -- { '<leader><space>', function() Snacks.picker.smart(vscode) end, desc = 'Find Git Files' },
    -- { '<leader><space>', function() Snacks.picker.git_files(vscode) end, desc = 'Find Git Files' },
    { '<leader><space>', function() Snacks.picker.project_files() end, desc = 'Find project files' },
    -- { '<leader>.', function() Snacks.picker.files({layout='ivy', cwd=vim.fn.expand('%:h')}) end, desc = 'Browse cur directory' },
    { '<leader>.', function() require('snacks-file-browser').browse({ cwd = vim.fn.expand('%:h') }) end, desc = 'Browse cur directory' },
    { '<leader>f.', function() Snacks.picker.files({cwd=vim.fn.expand('%:h')}) end, desc = 'Browse cur directory' },
    { '<leader>ff', function() Snacks.picker.files() end, desc = 'Find Files' },
    { '<leader>fb', function() require('snacks-file-browser').browse() end, desc = 'Browser Project' },
    { '<leader>fg', function() Snacks.picker.git_files() end, desc = 'Find Git Files' },
    { '<leader>fr', function() Snacks.picker.recent() end, desc = 'Recent' },
    { '<leader>fc', function() Snacks.picker.files({cwd=vim.fn.stdpath('config')}) end, desc = 'Find Config File' },
    { '<leader>fe', function() Snacks.explorer() end, desc = 'File Explorer' },

    -- FIND BUFFERS
    { "g.", function() Snacks.picker.buffers_with_symbols() end, desc = 'which_key_ignore' },
    { '<leader>bb', function() Snacks.picker.buffers_with_symbols() end, desc = 'Buffers' },

    -- LSP
    { 'go', function() Snacks.picker.lsp_symbols() end, desc = 'LSP Symbols' },

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
    -- { '<leader>/c', function() Sdropdown_previewnacks.picker.commands() end, desc = 'Commands' },
    -- { '<leader>/C', function() Snacks.picker.command_history() end, desc = 'Command History' },
    { '//', auto_open_qflistt_or_loclist, ft = 'qf', desc = 'which_key_ignore' },

    -- PROJECT
    { '<leader>pr', function() Snacks.picker.recent() end, desc = 'Find recent files' },
    { '<leader>pt', search_project_todos, desc = 'Search project todos', mode = { "n", "x" } },
    { '<leader>pe', function() Snacks.picker.zoxide() end, desc = 'Find zoxide list' },
    { '<leader>pp', function() require('hasan.picker.persisted').persisted() end, desc = 'Switch project' },

    -- VIM Builtins
    { '<leader>v/', function() Snacks.picker.help() end, desc = 'Help Pages' },
    { '<leader>vm', function() Snacks.picker.marks() end, desc = 'Marks' },
    { '<leader>vc', function() Snacks.picker.colorschemes() end, desc = 'Colorschemes' },
    { '<leader>vH', function() Snacks.picker.highlights() end, desc = 'Highlights' },

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
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        Snacks.toggle.line_number():map('<leader>tn')
        Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<leader>tt')
        Snacks.toggle.option('cursorcolumn', { name = 'Cursorcolumn' }):map('<leader>tl')
        Snacks.toggle.option('cursorline', { name = 'Cursorline' }):map('<leader>tL')
        Snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>ts')
        Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>tw')
        Snacks.toggle
          .option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
          :map('<leader>to')
        Snacks.toggle.diagnostics():map('<leader>td')
        Snacks.toggle.inlay_hints():map('<leader>th')
        Snacks.toggle.treesitter({ name = 'Treesitter' }):map('<leader>tT')
        Snacks.toggle.indent():map('<leader>ti')
        Snacks.toggle.dim():map('<leader>tD')
        Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map('<leader>tB')

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
}
