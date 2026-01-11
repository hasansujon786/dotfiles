local state = require('core.state')

local btn_width = 34
local function button(key, label, icon, desc, cmd)
  local pad = btn_width - #label + 4

  return {
    text = {
      { icon, hl = 'SnacksDashboardDesc', width = 3 },
      { desc, hl = 'SnacksDashboardDesc', width = pad },
      -- { '', hl = 'SnacksDashboardKeyAlt' },
      { label, hl = 'SnacksDashboardDesc' },
      -- { '', hl = 'SnacksDashboardKeyAlt' },
      -- { label, hl = 'SnacksDashboardKey' },
    },
    action = cmd,
    key = key,
    align = 'center',
  }
end

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

local preview_main_win = {
  preview = { row = -1 },
}

---try_change_quicklook
---@param p snacks.Picker
local function try_change_quicklook(p, action)
  if vim.b.qlook then
    vim.schedule(function()
      p:action(action)

      local cur_item = p.list:current()
      if not cur_item or cur_item._path == nil then
        return
      end

      local ok = pcall(require('hasan.utils.file').quicklook, { cur_item._path })
      if ok then
        vim.b.qlook = cur_item._path
      end
    end)
  else
    p:action(action)
  end
end

----@type snacks.Config
require('snacks').setup({
  bigfile = { enabled = true },
  quickfile = { enabled = true },
  words = { enabled = true, debounce = 450, modes = { 'n' } },
  explorer = { enabled = false },
  image = { enabled = false },
  indent = {
    animate = { enabled = false },
    scope = { only_current = true },
  },
  input = {},
  scope = {
    treesitter = { enabled = false },
    keys = {
      ---@type table<string, snacks.scope.TextObject|{desc?:string}>
      textobject = {
        ii = { linewise = true },
        ai = { linewise = true },
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
        ['[u'] = {
          min_size = 1, -- allow single line scopes
          bottom = false,
          cursor = true,
          edge = true,
          treesitter = { blocks = { enabled = false } },
          desc = 'jump to top edge of scope',
        },
        [']u'] = {
          min_size = 1, -- allow single line scopes
          bottom = true,
          cursor = true,
          edge = true,
          treesitter = { blocks = { enabled = false } },
          desc = 'jump to bottom edge of scope',
        },
      },
    },
  },
  notifier = {
    enabled = true,
    margin = { top = 1, right = 1, bottom = 1 },
    ---@type snacks.notifier.style
    style = function(buf, notif, ctx)
      local title = vim.trim((notif.title or ''))
      if title ~= '' then
        ctx.opts.title = { { notif.icon }, { title, ctx.hl.title } }
        ctx.opts.title_pos = 'right'
      end
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(notif.msg, '\n'))
    end,
    top_down = false, -- Place notifications from top to bottom
  },
  lazygit = {
    theme = {
      inactiveBorderColor = { fg = 'NotifyBorder' },
    },
  },
  statuscolumn = {
    left = { 'sign', 'mark' }, -- (high to low)
    right = { 'fold', 'git' },
  },
  -- scratch = { },
  dashboard = {
    width = btn_width,
    enabled = not require('core.state').ui.session_autoload,
    -- These settings are used by some built-in sections
    preset = {
      -- Used by the `header` section
      header = [[
    ███  ███       ██████           
    ███  ██         ███  █ █        
   ████ ██          ███ █             
  ████████▀▀▀ ██▀██ ██████████
 ██ ██████■■  ██ ██ ████ █ ████
██  ███ ██▄▄▄ ██▄██ ███ ███████]],
    },
    sections = {
      { section = 'header' },
      -- { section = 'keys', gap = 1, padding = 2 },
      {
        -- stylua: ignore
        {
          gap = 0,
          padding = 1,
          { text = {{ 'Get Started', hl = 'String' }, {' ……………………………………………………………………………', hl = 'SnacksDim'}}},
          button('n', 'n', ' ', 'New File', '<cmd>ene | startinsert<CR>'),
          button('f', '<spc>ff', ' ', 'Search Files', '<cmd>lua Snacks.dashboard.pick("files")<CR>'),
          button('p', '<spc>pp', ' ', 'Open Project', '<cmd>lua require("config.navigation.snacks.persisted").persisted()<CR>'),
          button('l', '<spc>pl', '󰑓 ', 'Load Last Session', '<cmd>lua require("persisted").load()<CR>'),
          -- button('r', 'R', ' ', 'Recent file', '<cmd>lua Snacks.dashboard.pick("recent")<CR>'),
          -- button('t', '<spc>ot', ' ', 'Open Terminal', '<cmd>lua Snacks.terminal(nil,{shell="bash",win={wo={winbar=""}}})<CR>'),
          -- button('a', '<spc>oa', ' ', 'Open org agenda', '<cmd>lua require("orgmode").action("agenda.prompt")<CR>'),
        },
        -- stylua: ignore
        {
          gap = 0,
          padding = 1,
          { text = {{ 'Configure', hl = 'String' }, { ' …………………………………………………………………………………', hl = 'SnacksDim' }}},
          button('S', 'S', ' ', 'Open Settings', '<cmd>lua Snacks.dashboard.pick("files",{cwd=vim.fn.stdpath("config")})<CR>'),
          button('<leader>vp', '<spc>vp', ' ', 'Lazy Dashboard', '<cmd>Lazy<CR>'),
          { text = { { '……………………………………………………………………………………………………………', hl = 'SnacksDim' } },
          },
        },
      },
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
      -- { pane = 2, section = 'recent_files', title = 'Recent files' },
      -- { pane = 2, section = 'projects', title = 'Projects' },
    },
  },
  picker = {
    prompt = '   ',
    exclude = state.picker.exclude,
    sources = {
      buffers = { layout = 'dropdown', current = false },
      files = { layout = 'ivy', matcher = { cwd_bonus = true, frecency = true, sort_empty = true } },
      undo = { focus = 'list' },
      commands = { layout = 'vscode' },
      keymaps = { layout = 'vscode' },
      git_files = { layout = 'dropdown' },
      recent = { layout = 'ivy' },
      smart = { layout = 'dropdown' },
      grep = { layout = 'dropdown_preview' },
      grep_word = { layout = 'dropdown_preview' },
      grep_buffers = { layout = 'dropdown_preview' },
      lsp_symbols = { layout = 'dropdown' },
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
      lines = {
        layout = { preset = 'ivy_mini', preview = 'main' },
        win = preview_main_win,
      },

      zoxide = { layout = 'dropdown' },
      marks = { layout = 'dropdown_preview' },
      colorschemes = { layout = 'dropdown_preview' },
      highlights = { layout = 'dropdown_preview' },

      qflist = { layout = 'dropdown_preview' },
      loclist = { layout = 'dropdown_preview' },

      ---@type snacks.picker.file_browser.Config
      file_browser = { layout = 'ivy' },

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
    },

    formatters = {
      file = { filename_first = true }, -- Display filename before the file path
    },

    actions = {
      focus_preview = function(p, _)
        if vim.api.nvim_get_current_win() == p.preview.win.win then
          p:focus('list', { show = true })
        else
          p:focus('preview', { show = true })
        end
      end,
      flash = function(...)
        require('config.navigation.snacks.custom').flash_on_picker(...)
      end,
      fedit = function(picker, item)
        picker:close()
        if not item or item.file == nil then
          return
        end
        -- FIXME: do not kill buffer if it is opened before
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
          reveal_file = item._path, -- Path to file or folder to reveal
          reveal_force_cwd = true, -- Change cwd without asking if needed
        })
      end,
      insert_relative_path = function(p, item, action)
        local cur_buf_name = vim.api.nvim_buf_get_name(p.finder.filter['current_buf'])
        cur_buf_name = vim.fs.normalize(cur_buf_name)
        local text = require('hasan.utils.file').get_relative_path(cur_buf_name, item._path)

        p:close()
        if text then
          vim.api.nvim_put({ text }, 'c', true, true)
        end
      end,
      insert_absolute_path = function(p, item, action)
        p:close()
        if item and item.file then
          vim.api.nvim_put({ item.file }, 'c', true, true)
        end
      end,
      open_spectre = function(picker, item)
        picker:close()

        local path = item.file
        if item.cwd then
          path = vim.fs.dirname(item.file)
        end

        require('hasan.widgets.spectre').open({ search_paths = path })
      end,
    },

    icons = {
      kinds = require('hasan.utils.ui.icons').kind,
    },

    win = {
      list = {
        keys = {
          ['p'] = { 'focus_preview', mode = { 'n' } },
          ['<s-tab>'] = { 'my_list_up', mode = { 'i', 'n' } },
          ['<tab>'] = { 'my_list_down', mode = { 'i', 'n' } },
          ['<A-i>'] = { 'select_and_prev', mode = { 'i', 'n' } },
          ['<A-y>'] = { 'select_and_next', mode = { 'i', 'n' } },
          ['<C-y>'] = { 'select_and_next', mode = { 'i', 'n' } },
        },
      },
      preview = {
        keys = {
          ['p'] = { 'focus_preview', mode = { 'n' } },
          ['<s-tab>'] = { 'my_list_up', mode = { 'i', 'n' } },
          ['<tab>'] = { 'my_list_down', mode = { 'i', 'n' } },
        },
      },
      input = {
        keys = {
          ['<c-u>'] = false,
          ['<c-d>'] = false,
          ['<Esc>'] = { 'close', mode = { 'i', 'n' } },

          ['<F3>'] = { 'toggle_preview', mode = { 'i', 'n' } },
          ['<a-u>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
          ['<a-d>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
          ['<a-o>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
          ['<c-b>'] = { 'list_scroll_up', mode = { 'i', 'n' } },
          ['<c-f>'] = { 'list_scroll_down', mode = { 'i', 'n' } },

          ['<s-tab>'] = { 'my_list_up', mode = { 'i', 'n' } },
          ['<tab>'] = { 'my_list_down', mode = { 'i', 'n' } },
          ['<C-l>'] = { 'select_and_prev', mode = { 'i', 'n' } },
          ['<C-y>'] = { 'select_and_next', mode = { 'i', 'n' } },

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
          ['<c-r><c-a>'] = { 'insert_absolute_path', mode = { 'i', 'n' } },
          ['<c-r><c-g>'] = { 'inspect', mode = { 'i', 'n' } },

          ['<A-/>'] = { 'open_spectre', mode = { 'i', 'n' } },
          ['<A-t>'] = { 'focus_file_tree', mode = { 'i', 'n' } },
          ['<a-s>'] = { 'flash', mode = { 'n', 'i' } },
          ['s'] = { 'flash' },

          ['<C-i>'] = { 'quicklook', mode = { 'i', 'n' } },
          ['<a-r>'] = { 'system_reveal', mode = { 'i', 'n' } },
          ['R'] = { 'system_reveal', mode = { 'n' } },
          ['<C-o>'] = { 'system_open', mode = { 'i', 'n' } },
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
      select = { layout = { border = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' } } },
      vscode = { layout = { row = 0, width = 0.4, min_width = 70 } },
    },
  },
  styles = {
    notification = {
      --               up ---------------- bot
      border = { ' ', ' ', '▐', '▐', '▐', ' ', ' ', ' ' },
      wo = { wrap = true, winblend = 0 },
    },
    terminal = { border = 'rounded', wo = { winhighlight = '' } },
    notification_history = { wo = { number = false, relativenumber = false, signcolumn = 'no' } },
    lazygit = { height = 0, width = 0, border = 'none' },
    input_cursor = { relative = 'cursor', row = 1, col = 0, width = 30 },
    scratch = { wo = { winbar = '' } },
    zen = {
      border = { '', '', '', '│', '', '', '', '│' },
      keys = { q = false },
      backdrop = { transparent = false, blend = 98 },
      wo = { winbar = '', winhighlight = 'NormalFloat:Normal,FloatBorder:ZenBorder' },
    },
  },
})
