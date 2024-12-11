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

return {
  'hasansujon786/snacks.nvim',
  priority = 1000,
  enabled = true,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = false },
    quickfile = { enabled = true },
    words = { enabled = true },
    input = {},
    indent = {
      indent = {
        char = '│',
        -- blank = '·',
      },
      ---@class snacks.indent.Scope.Config: snacks.scope.Config
      scope = {
        enabled = true,
        ---@type snacks.animate.Config|{enabled?: boolean}
        animate = { enabled = false },
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
      filter = function(buf)
        return vim.b[buf].snacks_indent_scope ~= false and vim.bo[buf].buftype == ''
      end,
      treesitter = { enabled = false },
    },
    notifier = {
      enabled = true,
      timeout = 3000, -- default timeout in ms
      margin = { top = 1, right = 0, bottom = 0 },
      padding = true, -- add 1 cell of left/right padding to the notification window
      -- sort = { 'level', 'added' }, -- sort by level and time
      icons = {
        error = ' ',
        warn = ' ',
        info = ' ',
        debug = ' ',
        trace = '󰠠 ',
      },
      ---@type snacks.notifier.style
      style = 'compact', -- "compact"|"fancy"|"minimal"
      top_down = false, -- place notifications from top to bottom
    },
    statuscolumn = {
      enabled = true,
      left = { 'sign', 'mark' }, -- priority of signs on the right (high to low)
      right = { 'fold', 'git' }, -- priority of signs on the left (high to low)
      folds = { open = false, git_hl = false },
      git = { patterns = { 'GitSign', 'MiniDiffSign' } },
      refresh = 50, -- refresh at most every 50ms
    },
    dashboard = {
      enabled = true,
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
    styles = {
      notification = {
        wo = { wrap = true, winblend = 0 }, -- Wrap notifications
      },
      dashboard = {
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
        keys = {
          i_esc = { '<esc>', { 'cmp_close', 'cancel' }, mode = { 'i', 'n' } },
          i_cr = { '<cr>', { 'cmp_accept', 'confirm' }, mode = { 'i', 'n' } },
          i_tab = { '<tab>', { 'cmp_select_next', 'cmp' }, mode = 'i' },
          q = 'cancel',
        },
      },
    },
  },
  -- stylua: ignore
  keys = {
    { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference" },
    { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference" },
    { "<leader>vv", function() Snacks.notifier.hide() end, desc = "which_key_ignore" },
    { "<leader>vo", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
    { "<leader>bk", function() Snacks.bufdelete() end, desc = "Kill this buffer" },
    { "<leader>go", function() Snacks.gitbrowse() end, desc = "Open git repo" },
    { "<leader>aR", function() Snacks.rename.rename_file() end, desc = "Lsp: Rename file" },
    { "<leader>pd", function () Snacks.dashboard.open() end, desc = 'Open dashboard' },

    -- { "<A-m>",      function() Snacks.terminal() end, desc = "Toggle Terminal", mode = {'n', 'i', 't'} },
    {
      "<leader>N",
      desc = "Neovim News",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    }
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
        Snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>ts')
        Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>tw')
        Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<leader>tt')
        Snacks.toggle.line_number():map('<leader>tl')
        Snacks.toggle.option('cursorcolumn', { name = 'Cursorcolumn' }):map('<leader>tC')
        Snacks.toggle.option('cursorline', { name = 'Cursorline' }):map('<leader>tL')
        Snacks.toggle
          .option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
          :map('<leader>to')
        Snacks.toggle.diagnostics():map('<leader>td')
        Snacks.toggle.inlay_hints():map('<leader>th')
        Snacks.toggle.treesitter({ name = 'Treesitter' }):map('<leader>tT')

        -- Snacks.toggle.optio('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map('<leader>ub')

        vim.api.nvim_create_autocmd('FileType', {
          pattern = { 'org' },
          callback = function(info)
            -- vim.b[info.buf]['snacks_indent'] = false
            vim.b[info.buf]['snacks_indent_scope'] = false
          end,
        })
      end,
    })
  end,
}
