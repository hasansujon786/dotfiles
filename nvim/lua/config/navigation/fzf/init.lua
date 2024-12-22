local themes = require('config.navigation.fzf.themes')

local default_prompt_icon = '   '

---@param ui_opt {kind?:string,prompt?:string}
---@param items {}
---@return table
local get_ui_select_opt = function(ui_opt, items)
  if ui_opt.kind and ui_opt.kind == 'codeaction' then
    return {}
  end

  return themes.dropdown_no_preview({
    title = ui_opt.prompt or 'Select',
    winopts = { width = 70 },
  })
end

return {
  'ibhagwan/fzf-lua',
  enabled = true,
  cmd = 'FzfLua',
  config = function(_, opts)
    local actions = require('fzf-lua.actions')

    require('fzf-lua').setup({
      { 'default-title' }, -- base profile
      file_icon_padding = ' ',
      winopts = {
        height = 0.75, -- window height
        zindex = 60,
        width = 1, -- window width
        row = 1, -- window row position (0=top, 1=bottom)
        border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
        title = ' Search ',
        title_pos = 'center', -- 'left', 'center' or 'right'
        fullscreen = false, -- start fullscreen?
        preview = {
          layout = 'flex', -- horizontal|vertical|flex
          flip_columns = 100, -- #cols to switch to horizontal on flex
          vertical = 'up:45%',
          horizontal = 'right:50%',
          winopts = { -- builtin previewer window options
            number = true,
            relativenumber = false,
            cursorline = true,
            cursorlineopt = 'both',
            cursorcolumn = false,
            signcolumn = 'no',
            list = false,
            foldenable = false,
            foldmethod = 'manual',
          },
        },
      },
      keymap = {
        -- Below are the default binds, setting any value in these tables will override
        -- the defaults, to inherit from the defaults change [1] from `false` to `true`
        builtin = {
          false, -- set `true` to stop inherit from defaults
          -- neovim `:tmap` mappings for the fzf win
          ['<M-Esc>'] = 'hide', -- hide fzf-lua, `:FzfLua resume` to continue
          ['<F1>'] = 'toggle-help',
          ['<F2>'] = 'toggle-fullscreen',
          -- Only valid with the 'builtin' previewer
          ['<F3>'] = 'toggle-preview-wrap',
          ['<F4>'] = 'toggle-preview',
          -- Rotate preview clockwise/counter-clockwise
          ['<F5>'] = 'toggle-preview-ccw',
          ['<F6>'] = 'toggle-preview-cw',
          -- `ts-ctx` binds require `nvim-treesitter-context`
          ['<F7>'] = 'toggle-preview-ts-ctx',
          ['<F8>'] = 'preview-ts-ctx-dec',
          ['<F9>'] = 'preview-ts-ctx-inc',
          ['<S-Left>'] = 'preview-reset',
          ['<S-down>'] = 'preview-page-down',
          ['<S-up>'] = 'preview-page-up',
          ['<M-d>'] = 'preview-down',
          ['<M-u>'] = 'preview-up',
        },
        fzf = {
          false, -- set `true` to stop inherit from defaults
          -- fzf '--bind=' options
          ['ctrl-z'] = 'abort',
          ['ctrl-u'] = 'unix-line-discard',
          ['ctrl-f'] = 'half-page-down',
          ['ctrl-b'] = 'half-page-up',
          ['ctrl-a'] = 'beginning-of-line',
          ['ctrl-e'] = 'end-of-line',
          ['alt-a'] = 'toggle-all',
          ['alt-g'] = 'first',
          ['alt-G'] = 'last',
          -- Only valid with fzf previewers (bat/cat/git/etc)
          ['f3'] = 'toggle-preview-wrap',
          ['f4'] = 'toggle-preview',
          ['shift-down'] = 'preview-page-down',
          ['shift-up'] = 'preview-page-up',
        },
      },
      -- top actions
      -- actions = {
      --   files = {
      --     false,          -- do not inherit from defaults
      --     ["alt-q"]       = actions.file_sel_to_qf,
      --     -- ["alt-Q"]       = actions.file_sel_to_ll,
      --   },
      -- },
      fzf_opts = {
        ['--margin'] = '0',
      },
      -- fzf_colors = true, Set to `true` to automatically generate an fzf's colorscheme from Neovim's current colorscheme:
      fzf_colors = {
        false, -- set `true` to stop inherit from defaults
        ['bg'] = '-1',
        ['gutter'] = '-1',
        ['separator'] = { 'fg', 'FzfLuaBorder' },
        -- ["fg"]          = { "fg", "CursorLine" },
        -- ["hl"]          = { "fg", "Comment" },
        -- ["fg+"]         = { "fg", "Normal" },
        -- ["bg+"]         = { "bg", "CursorLine" },
        -- ["hl+"]         = { "fg", "Statement" },
        -- ["info"]        = { "fg", "PreProc" },
        -- ["prompt"]      = { "fg", "Conditional" },
        -- ["pointer"]     = { "fg", "Exception" },
        -- ["marker"]      = { "fg", "Keyword" },
        -- ["spinner"]     = { "fg", "Label" },
        -- ["header"]      = { "fg", "Comment" },
      },
      previewers = {
        builtin = {
          syntax = true, -- preview syntax highlight?
          syntax_limit_l = 0, -- syntax limit (lines), 0=nolimit
          syntax_limit_b = 1024 * 1024, -- syntax limit (bytes), 0=nolimit
          limit_b = 1024 * 1024 * 10, -- preview limit (bytes), 0=nolimit
          treesitter = {
            enabled = true,
            -- disabled = { 'dart' },
            context = false, -- nvim-treesitter-context config options
          },
          toggle_behavior = 'default', -- extend
          extensions = {
            ['png'] = { 'viu', '-b' },
          },
        },
        codeaction_native = {
          diff_opts = { ctxlen = 3 },
          -- git-delta is automatically detected as pager, set `pager=false`
          -- to disable, can also be set under 'lsp.code_actions.preview_pager'
          -- recommended styling for delta
          --pager = [[delta --width=$COLUMNS --hunk-header-style="omit" --file-style="omit"]],
        },
      },
      -- PROVIDERS SETUP
      -- use `defaults` (table or function) if you wish to set "global-provider" defaults
      -- for example, using "mini.icons" globally and open the quickfix list at the top
      defaults = {
        prompt = default_prompt_icon,
        copen = 'topleft copen',
      },
      files = themes.ivy({
        git_icons = false, -- show git icons?
        file_icons = true, -- show file icons (true|"devicons"|"mini")?
        -- e.g. "fzf-lua/previewer/fzf.lua" => "fzf.lua previewer/fzf-lua"
        formatter = 'path.filename_first',
        rg_opts = [[--color=never --files --hidden --follow -g "!.git"]],
        fd_opts = [[--color=never --type f --hidden --follow --exclude .git --exclude .bin --exclude .system --exclude gui/sublime_text/theme]],
        header = false,
        cwd_header = false,
        cwd_prompt = false,
        -- actions = {
        --   ['ctrl-g'] = { actions.toggle_ignore },
        --   ['ctrl-y'] = function(selected)
        --     print(selected[1])
        --   end,
        -- },
      }),
      git = {
        files = themes.top_panel({
          cmd = 'git ls-files --exclude-standard --cached --others',
          formatter = 'path.filename_first',
        }),
        icons = {
          ['M'] = { icon = 'ᴍ', color = 'yellow' },
          ['D'] = { icon = 'ᴅ', color = 'red' },
          ['A'] = { icon = 'ᴀ', color = 'green' },
          ['R'] = { icon = 'ʀ', color = 'yellow' },
          ['C'] = { icon = '', color = 'yellow' },
          ['T'] = { icon = 'T', color = 'magenta' },
          ['?'] = { icon = 'ᴜ', color = 'magenta' },
        },
      },
      grep = themes.ivy({
        input_prompt = 'Grep String',
        prompt = default_prompt_icon,
        winopts = { preview = { hidden = 'hidden' } },
        grep_opts = '--binary-files=without-match --line-number --recursive --color=auto --perl-regexp -e',
        rg_opts = '--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e',
        actions = {
          ['ctrl-g'] = { actions.grep_lgrep },
          -- ["ctrl-r"]   = { actions.toggle_ignore }
        },
      }),
      buffers = themes.dropdown_no_preview({
        formatter = 'path.filename_first',
        sort_lastused = true, -- sort buffers() by last used
        show_unloaded = true, -- show unloaded buffers
        cwd_only = false, -- buffers for the cwd only
        cwd = nil, -- buffers list for a given dir
        actions = {
          ['ctrl-x'] = { fn = actions.buf_del, reload = true },
        },
      }),
      keymaps = themes.dropdown(),
      filetypes = themes.dropdown_no_preview(),
      lsp = {
        prompt_postfix = '❯ ', -- will be appended to the LSP label to override use 'prompt' instead
        cwd_only = true, -- LSP/diagnostics for cwd only?
        includeDeclaration = true, -- include current declaration in LSP context
        -- settings for 'lsp_{document|workspace|lsp_live_workspace}_symbols'
        symbols = themes.dropdown_no_preview({
          title = 'Symbols',
          prompt = default_prompt_icon,
          child_prefix = true,
          symbol_icons = {
            -- icons for symbol kind vim.lsp.protocol.CompletionItemKind
            -- see https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#symbolKind
            -- see https://github.com/neovim/neovim/blob/829d92eca3d72a701adc6e6aa17ccd9fe2082479/runtime/lua/vim/lsp/protocol.lua#L117
            Function = ' ',
            Method = ' ',
            Constructor = ' ',
            Variable = ' ',
            Field = ' ',
            TypeParameter = ' ',
            Constant = ' ',
            Class = ' ',
            Interface = ' ',
            Struct = ' ',
            Event = ' ',
            Operator = ' ',
            Module = ' ',
            Property = ' ',
            Value = ' ',
            Enum = ' ',
            EnumMember = ' ',
            Reference = ' ',
            Keyword = ' ',
            File = ' ',
            Folder = ' ',
            Color = ' ',
            Unit = ' ',
            Snippet = ' ',
            Text = ' ',
            Array = ' ',
            Number = ' ',
            String = ' ',
            Boolean = ' ',
            Object = ' ', -- 󰅩
            Namespace = ' ',
            Copilot = ' ',
            Package = ' ',
            Table = ' ',
          },
          symbol_fmt = function(s, opts)
            return s .. ' -'
          end,
        }),
        code_actions = themes.cursor({
          async_or_timeout = 5000,
          previewer = 'codeaction_native',
        }),
      },
      diagnostics = {
        icon_padding = ' ', -- add padding for wide diagnostics signs
        multiline = true, -- concatenate multi-line diags into a single line
        signs = {
          ['Error'] = { text = '', texthl = 'DiagnosticError' },
          ['Warn'] = { text = '', texthl = 'DiagnosticWarn' },
          ['Info'] = { text = '', texthl = 'DiagnosticInfo' },
          ['Hint'] = { text = '󰌵', texthl = 'DiagnosticHint' },
        },
      },
    })
  end,
  keys = {
    { '<c-j>', '<c-j>', ft = 'fzf', mode = 't', nowait = true },
    { '<c-k>', '<c-k>', ft = 'fzf', mode = 't', nowait = true },
    { '//', '<cmd>cclose | FzfLua quickfix<cr>', ft = 'qf', desc = 'which_key_ignore' },

    { '<leader>:', '<cmd>FzfLua command_history<cr>', desc = 'Command History' },
    { '<A-x>', '<cmd>FzfLua commands<cr>', desc = 'Commands' },

    -- FIND FILES
    { '<C-p>', '<cmd>FzfLua oldfiles<cr>', desc = 'Recent files' },
    {
      '<leader><space>',
      function()
        require('fzf-lua').files(themes.top_panel())
      end,
      desc = 'Find Files',
    },
    {
      '<leader>.',
      function()
        require('fzf-lua').files(themes.ivy({
          title = 'Files Current Dir',
          cwd = vim.fn.expand('%:p:h'),
          fd_opts = [[--color=never -d 1 --type f --hidden --follow --exclude .git]],
        }))
      end,
      desc = 'Browse cur directory',
    },
    { '<leader>ff', '<cmd>FzfLua files<cr>', desc = 'Find files' },
    { '<leader>fg', '<cmd>FzfLua git_files<cr>', desc = 'Find git files' },
    { '<leader>fr', '<cmd>FzfLua oldfiles<cr>', desc = 'Recent files' },
    -- { '<leader>.', '<cmd>lua require("hasan.telescope.custom").file_browser("cur_dir")<cr>', desc = 'Browse cur directory' },
    -- { '<leader>f.', '<cmd>lua require("hasan.telescope.custom").file_browser("cur_dir")<cr>', desc = 'Browse cur directory' },
    -- { '<leader>fb', '<cmd>lua require("hasan.telescope.custom").file_browser()<cr>', desc = 'Browser project files' },

    -- FIND BUFFERS
    { 'g.', '<cmd>FzfLua buffers cwd_only=true sort_mru=true sort_lastused=true<cr>', desc = 'Switch Buffer' },
    { "g'", '<cmd>FzfLua buffers cwd_only=true sort_mru=true sort_lastused=true<cr>', desc = 'which_key_ignore' },
    { '<leader>bb', '<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>', desc = 'Switch All Buffer' },

    -- LSP
    {
      'go',
      function()
        -- regex_filter = symbols_filter,
        require('fzf-lua').lsp_document_symbols({})
      end,
      desc = 'Lsp: Document symbols',
    },

    -- GIT
    { '<leader>g/', '<cmd>FzfLua git_status<CR>', desc = 'Find git files*' },
    { '<leader>gb', '<cmd>FzfLua git_branches<CR>', desc = 'Checkout git branch' },
    { '<leader>gc', '<cmd>FzfLua git_commits<CR>', desc = 'Look up commits' },
    { '<leader>gC', '<cmd>FzfLua git_bcommits<CR>', desc = 'Look up buffer commits' },

    -- SEARCH
    { '//', '<cmd>FzfLua blines previewer=false<cr>', desc = 'which_key_ignore' },
    { '<A-/>', '<cmd>FzfLua grep<cr>', desc = 'Grep' },
    { '<A-/>', '<cmd>FzfLua grep_visual<cr>', mode = 'v', desc = 'Grep' },

    { '<leader>/.', '<cmd>FzfLua resume<cr>', desc = 'Fzf Resume' },
    { '<leader>//', '<cmd>FzfLua live_grep<CR>', desc = 'Live grep' },
    -- { '<leader>/g', '<cmd>lua require("hasan.telescope.custom").live_grep_in_folder()<cr>', desc = 'Live grep in folder' },
    { '<leader>/f', '<cmd>FzfLua files<cr>', desc = 'Find file' },
    { '<leader>/k', '<cmd>FzfLua keymaps<CR>', desc = 'Look up keymaps' },
    { '<leader>/t', '<cmd>FzfLua filetypes<CR>', desc = 'Change filetypes' },
    { '<leader>/q', '<cmd>FzfLua quickfix<cr>', desc = 'Quickfix List' },

    { '<leader>v/', '<cmd>FzfLua help_tags<cr>', desc = 'Search Vim help' },
    { '<leader>vj', '<cmd>FzfLua jumps<cr>', desc = 'Search jumplist' },
    { '<leader>vm', '<cmd>FzfLua marks<cr>', desc = 'Jump to Mark' },

    -- PROJECT
    { '<leader>pr', '<cmd>FzfLua oldfiles cwd_only=true<cr>', desc = 'Project recent files' },
    {
      '<leader>pt',
      function()
        require('config.navigation.fzf.providers').search_todos_to_quickfix()
      end,
      desc = 'Show project todos',
    },
    {
      '<leader>pp',
      function()
        require('config.navigation.fzf.providers.persisted').persisted()
      end,
      desc = 'Show session list',
    },
    -- { '<leader>pb', '<cmd>lua require("hasan.telescope.custom").project_browser()<CR>', desc = 'Browse other projects' },
    -- { '<leader>pc', '<cmd>lua require("telescope._extensions").manager.project_commands.commands()<CR>', desc = 'Run project commands' },
    -- { '<leader>pt', '<cmd>lua require("hasan.telescope.custom").search_project_todos()<CR>', desc = 'Search project todos' },
    -- { '<leader>pm', '<cmd>lua require("hasan.telescope.custom").projects()<CR>', desc = 'Switch project' },
  },
  init = function()
    vim.ui.select = function(...)
      require('lazy').load({ plugins = { 'fzf-lua' } })
      require('fzf-lua').register_ui_select(get_ui_select_opt)
      return vim.ui.select(...)
    end
  end,
}
