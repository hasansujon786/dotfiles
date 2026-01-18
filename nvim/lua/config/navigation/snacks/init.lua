return {
  {
    'folke/snacks.nvim',
    enabled = true,
    lazy = false,
    event = 'UIEnter',
    config = function()
      require('config.navigation.snacks.setup')
    end,
    -- stylua: ignore
    keys = {
      -- { 'g]',         function() Snacks.words.jump(vim.v.count1) end, desc = 'Next Reference', mode = { 'n', 't' } },
      -- { 'g[',         function() Snacks.words.jump(-vim.v.count1) end, desc = 'Prev Reference', mode = { 'n', 't' } },
      { '<leader>vo', function() Snacks.notifier.hide() end, desc = 'Dismiss All Notifications' },
      { '<leader>vn', function() Snacks.notifier.show_history() end, desc = 'Notification History' },
      -- { '<leader>bd', function() Snacks.bufdelete() end, desc = 'Kill this buffer' },
      { '<leader>bo', function() Snacks.bufdelete.other() end, desc = 'Kill this buffer' },
      { '<leader>go', function() Snacks.gitbrowse() end, desc = 'Open git repo' , mode = { 'n', 'v' } },
      { '<leader>gO', function() Snacks.gitbrowse({ open = function(url) vim.fn.setreg("+", url) end, notify = false }) end,  desc = "Git Browse (copy url)", mode = {"n", "x" } },
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
      { '<M-m>', function() require('config.navigation.snacks.terminal').toggle() end, desc = 'Terminal'  },
      { '[t', function() require('config.navigation.snacks.terminal').prev() end, desc = 'Next Terminal'  },
      { ']t', function() require('config.navigation.snacks.terminal').next() end, desc = 'Prev Terminal'  },
      { '<leader>ot', function() Snacks.terminal(nil, { shell = 'bash', win = { wo = { winbar = '' } } }) end, desc = 'Terminal'  },
      { '<leader>of', function()
        local cmd = { 'yazi' }
          if vim.bo.modifiable and not vim.bo.readonly then
            local buf = vim.api.nvim_buf_get_name(0)
            table.insert(cmd, '"' .. buf .. '"')
          end
        Snacks.terminal(table.concat(cmd, ' '), { shell = 'bash', win = { style = 'lazygit' } })
      end, desc = 'Open File Manager' },

      { '<leader>gl', function() Snacks.lazygit() end, desc = 'Open lazygit' },

      -- FIND FILES
      { '<C-p>', function() require('config.navigation.snacks.custom').project_files() end, desc = 'Find project files' },
      { '<leader><space>', function() require('config.navigation.snacks.custom').project_files() end, desc = 'Find project files' },
      -- { '<leader><space>', function() Snacks.picker.smart() end, desc = 'Find project files' },
      -- { '<leader><space>', function() Snacks.picker.git_files() end, desc = 'Find Git Files' },
      -- { '<leader>.', function() Snacks.picker.files({layout='ivy', cwd=vim.fn.expand('%:h')}) end, desc = 'Browse cur directory' },
      { '<leader>ff', function() Snacks.picker.files() end, desc = 'Find Files' },
      { '<leader>fg', function() Snacks.picker.git_files() end, desc = 'Find Git Files' },
      { '<leader>fr', function() Snacks.picker.recent() end, desc = 'Recent' },
      { '<leader>fc', function() Snacks.picker.files({cwd=vim.fn.stdpath('config')}) end, desc = 'Find Config File' },
      { '<leader>fe', function() Snacks.explorer() end, desc = 'File Explorer' },
      { '<leader>op', function() Snacks.explorer() end, desc = 'File Explorer' },

      -- FIND BUFFERS
      { "<leader>.", function() require('config.navigation.snacks.custom').buffers_with_symbols() end, desc = 'which_key_ignore' },
      { '<leader>bb', function() require('config.navigation.snacks.custom').buffers_with_symbols() end, desc = 'Buffers' },

      -- LSP
      { 'go', function () require('config.navigation.snacks.custom').lsp_symbols() end, desc = 'LSP Symbols' },
      { 'go', function () require('hasan.org.picker').pick_heading() end, desc = 'LSP Symbols', ft = 'org' },
      { 'g/', function() Snacks.picker.treesitter() end, desc = 'Treesitter Symbols' },

      -- GIT
      { '<leader>g/', function() Snacks.picker.git_status() end, desc = 'Git Status' },
      { '<leader>gc', function() Snacks.picker.git_log() end, desc = 'Git Log' },

      -- GREP
      { '<leader>//', function() Snacks.picker.grep() end, desc = 'Grep' },
      { '<leader>b/', function() Snacks.picker.grep_buffers() end, desc = 'Grep Open Buffers' },
      { '//', function() Snacks.picker.lines() end, desc = 'which_key_ignore' },
      { '<A-/>', function() Snacks.picker.grep_word() end, desc = 'Visual selection or word', mode = { "n", "x" } },

      -- SEARCH
      { '<leader>ou', function() Snacks.picker.undo() end, desc = 'Show undo history' },
      { '<leader>/.', function() Snacks.picker.resume() end, desc = 'Resume' },
      { '<leader>/f', function() Snacks.picker.files() end, desc = 'Find Files' },
      { '<leader>/k', function() require('config.navigation.snacks.custom').keymaps() end, desc = 'Commands', mode = { "n", "x" } },
      { '<leader>/q', function() Snacks.picker.qflist() end, desc = 'Quickfix List' },
      { '<leader>/l', function() Snacks.picker.loclist() end, desc = 'Location List' },
      { '<leader>/H', function() Snacks.picker.highlights() end, desc = 'Highlights' },
      { '<leader>/c', function() Snacks.picker.command_history() end, desc = 'Command History' },
      { '<F1>', function() Snacks.picker.commands() end, desc = 'Commands' },
      { '//', function() require('config.navigation.snacks.custom').open_qflist_or_loclist() end, ft = 'qf', desc = 'which_key_ignore' },

      -- PROJECT
      { '<leader>pr', function() Snacks.picker.recent({cwd = vim.uv.cwd()}) end, desc = 'Find recent files' },
      { '<leader>pe', function() Snacks.picker.zoxide() end, desc = 'Find zoxide list' },
      { '<leader>/t', function() require('config.navigation.snacks.custom').search_project_todos() end, desc = 'Search project todos' },

      -- VIM Builtin
      { '<leader>v/', function() Snacks.picker.help() end, desc = 'Help Pages' },
      { '<leader>vm', function() Snacks.picker.marks() end, desc = 'Marks' },
      { '<leader>vc', function() Snacks.picker.colorschemes() end, desc = 'Colorschemes' },

      -- ORG MODE
      { '<leader>ng', function() Snacks.picker.grep({cwd=org_root_path}) end, desc = 'Grep org text' },
      { '<leader>w/', function() Snacks.picker.files({cwd=org_root_path}) end, desc = 'Find org files' },
    },
    init = function()
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

      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
          require('config.navigation.snacks.toggles')
        end,
      })
    end,
  },
  {
    'hasansujon786/snacks-file-browser.nvim',
    lazy = true,
    dev = require('core.state').dev.enabled,
    -- stylua: ignore start
    keys = {
      { '<leader>,', function() require('snacks-file-browser').browse({ cwd = vim.fn.expand('%:h') }) end, desc = 'Browse cur directory' },
      { '<leader>f.', function() require('snacks-file-browser').browse() end, desc = 'Browser Project' },
      { '<leader>fb', function() require('snacks-file-browser').select_dir() end, desc = 'Browser Project' },
    },
  },
}
