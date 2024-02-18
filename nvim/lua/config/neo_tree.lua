local util = {}
-- function Foo()
--   P('alt=' .. vim.w.alt_file .. '| prealt=' .. vim.w.pre_alt_file)
-- end
util.isEmpty = function(s)
  return s == nil or s == ''
end
util.isNeoTreeWindow = function(name)
  return string.match(name, 'neo%-tree filesystem') ~= nil
    or string.match(name, 'neo%-tree buffers') ~= nil
    or string.match(name, 'neo%-tree git_status') ~= nil
end
util.save_altfile = function()
  vim.g.cwd = vim.loop.cwd()
  local alt = vim.fn.expand('%:p')
  local pre_alt = vim.fn.expand('#:p')
  if not util.isNeoTreeWindow(alt) then
    vim.w.alt_file = alt
  end
  if not util.isNeoTreeWindow(pre_alt) then
    vim.w.pre_alt_file = pre_alt
  end
end

util.copy_path = function(state, is_absolute)
  local os_sep = require('plenary.path').path.sep
  local node = state.tree:get_node()
  local f = is_absolute == true and node.path or vim.fn.fnamemodify(node.path, ':.')
  if os_sep == '\\' then
    f = f:gsub('\\', '/')
  end
  vim.notify(f, vim.log.levels.INFO)
  vim.cmd(string.format('let @%s="%s"', '+', f))
end

local function vinegar_dir_up(state)
  local Path = require('plenary.path')
  -- local node = state.tree:get_node()
  -- P(node.is_last_child)

  local cur_dir = state.path
  local parent_dir = Path:new(cur_dir):parent()
  require('neo-tree.sources.filesystem').navigate(state, parent_dir.filename, cur_dir)
end

local function open_vinegar()
  util.save_altfile()

  local readonly = vim.api.nvim_buf_get_option(0, 'readonly')
  local modifiable = vim.api.nvim_buf_get_option(0, 'modifiable')

  if readonly or not modifiable then
    vim.cmd([[Neotree filesystem position=current]])
  else
    vim.cmd([[Neotree filesystem position=current dir=%:p:h reveal_file=%:p]])
  end
end

local function edit_alternate_file()
  if vim.o.filetype == 'neo-tree' then
    if vim.b['neo_tree_position'] == 'current' then
      return feedkeys('<c-^>')
    end
    return feedkeys('q')
  end

  local alt_file = vim.w.alt_file
  local pre_alt_file = vim.w.pre_alt_file
  -- store curret native values
  local current_file = vim.fn.expand('%:p')
  local current_alt_file = vim.fn.expand('#:p')

  if not util.isEmpty(current_alt_file) and not util.isNeoTreeWindow(current_alt_file) then
    return feedkeys('<c-^>')
  end

  -- if alt is neo-tree
  if util.isNeoTreeWindow(current_alt_file) then
    if current_file == alt_file and not util.isEmpty(pre_alt_file) then
      return vim.cmd.edit(pre_alt_file)
    elseif current_file ~= alt_file and not util.isEmpty(alt_file) then
      return vim.cmd.edit(alt_file)
    else
      return vim.notify('E23: No alternate file', vim.log.levels.ERROR)
    end
  else
    if current_file == alt_file and not util.isEmpty(pre_alt_file) then
      return vim.cmd.edit(pre_alt_file)
    end
  end

  feedkeys('<c-^>')
end

-- if vim.fn.filereadable(path) == 0 then
return {
  'nvim-neo-tree/neo-tree.nvim',
  lazy = true,
  -- event = 'CursorHold',
  cmd = { 'Neotree' },
  branch = 'v3.x',
  vinegar_helper = util,
  keys = {
    {
      '<leader>op',
      function()
        vim.g.cwd = vim.loop.cwd()
        require('hasan.nebulous').mark_as_alternate_win()
        local readonly = vim.api.nvim_buf_get_option(0, 'readonly')
        local modifiable = vim.api.nvim_buf_get_option(0, 'modifiable')
        local filetype = vim.api.nvim_buf_get_option(0, 'filetype')

        if filetype == 'neo-tree' then
          vim.cmd([[Neotree close]])
        elseif readonly or not modifiable then
          vim.cmd([[Neotree filesystem left]])
        else
          vim.cmd([[Neotree filesystem left reveal_file=%:p]])
        end
      end,
      desc = 'NeoTree: Toggle sidebar',
    },
    { '-', open_vinegar, desc = 'NeoTree: Open vinegar' },
  },
  config = function(_, opts)
    keymap('n', '<bs>', edit_alternate_file, { desc = 'Edit alternate file' })

    -- If you want icons for diagnostic errors, you'll need to define them somewhere:
    -- vim.fn.sign_define('DiagnosticSignError', { text = ' ', texthl = 'DiagnosticSignError' })
    -- vim.fn.sign_define('DiagnosticSignWarn', { text = ' ', texthl = 'DiagnosticSignWarn' })
    -- vim.fn.sign_define('DiagnosticSignInfo', { text = ' ', texthl = 'DiagnosticSignInfo' })
    -- vim.fn.sign_define('DiagnosticSignHint', { text = '󰌵', texthl = 'DiagnosticSignHint' })

    local highlights = require('neo-tree.ui.highlights')
    local comp = require('neo-tree.sources.common.components')

    opts.filesystem.components = {
      icon = function(config, node, state)
        local icon = config.default or ' '
        local highlight = config.highlight or highlights.FILE_ICON
        if node.type == 'directory' then
          highlight = highlights.DIRECTORY_ICON
          if node:get_depth() == 1 then -- my logic
            icon = ''
          elseif node.loaded and not node:has_children() then
            icon = not node.empty_expanded and config.folder_empty or config.folder_empty_open
          elseif node:is_expanded() then
            icon = config.folder_open or '-'
          else
            icon = config.folder_closed or '+'
          end
        elseif node.type == 'file' or node.type == 'terminal' then
          local success, web_devicons = pcall(require, 'nvim-web-devicons')
          if success then
            local devicon, hl = web_devicons.get_icon(node.name)
            icon = devicon or icon
            highlight = hl or highlight
          end
        end

        local filtered_by = comp.filtered_by(config, node, state)

        return {
          text = icon .. ' ',
          highlight = filtered_by.highlight or highlight,
        }
      end,
    }

    -- Alternate source_selector_style
    if require('core.state').ui.neotree.source_selector_style == 'minimal' then
      opts.source_selector.sources = {
        {
          source = 'filesystem', -- string
          display_name = '  ', -- string | nil
        },
        {
          source = 'buffers', -- string
          display_name = ' ﬘ ', -- string | nil
        },
        {
          source = 'git_status', -- string
          display_name = '  ', -- string | nil
        },
      }
      opts.source_selector.content_layout = 'start'
      opts.source_selector.tabs_layout = false
      opts.source_selector.separator = { left = '', right = ' ' }
      opts.source_selector.padding = 1
    end

    require('neo-tree').setup(opts)
  end,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  opts = {
    source_selector = {
      winbar = true, -- toggle to show selector on winbar
      statusline = false, -- toggle to show selector on statusline
      show_scrolled_off_parent_node = false, -- boolean
      sources = { -- table
        {
          source = 'filesystem', -- string
          display_name = '  Files', -- string | nil
        },
        {
          source = 'buffers', -- string
          display_name = ' ﬘ Bufs ', -- string | nil
        },
        {
          source = 'git_status', -- string
          display_name = '  Git ', -- string | nil
        },
      },
      content_layout = 'center', -- string
      tabs_layout = 'equal', -- string
      truncation_character = '…', -- string
      tabs_min_width = nil, -- int | nil
      tabs_max_width = nil, -- int | nil
      padding = 0, -- int | { left: int, right: int }
      separator = { left = '▏', right = '▕' }, -- string | { left: string, right: string, override: string | nil }
      separator_active = nil, -- string | { left: string, right: string, override: string | nil } | nil
      show_separator_on_edge = false, -- boolean
    },
    close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
    popup_border_style = require('core.state').ui.hover.border,
    enable_git_status = true,
    enable_diagnostics = false,
    enable_normal_mode_for_inputs = false, -- Enable normal mode for input dialogs.
    open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' }, -- when opening files, do not use windows containing these filetypes or buftypes
    sort_case_insensitive = false, -- used when sorting files and directories in the tree
    sort_function = nil, -- use a custom function for sorting files and directories in the tree
    -- sort_function = function (a,b)
    --       if a.type == b.type then
    --           return a.path > b.path
    --       else
    --           return a.type > b.type
    --       end
    --   end , -- this sorts files and directories descendantly
    default_component_configs = {
      container = {
        enable_character_fade = true,
      },
      indent = {
        indent_size = 1,
        padding = 0, -- extra padding on left hand side
        -- indent guides
        with_markers = true,
        indent_marker = '│',
        last_indent_marker = '└',
        highlight = 'NeoTreeIndentMarker',
        -- expander config, needed for nesting files
        with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
        expander_collapsed = '',
        expander_expanded = '',
        expander_highlight = 'NeoTreeExpander',
      },
      icon = {
        folder_closed = '',
        folder_open = '',
        folder_empty = '',
        -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
        -- then these will never be used.
        default = '',
        highlight = 'NeoTreeFileIcon',
      },
      modified = {
        symbol = '•',
        highlight = 'NeoTreeModified',
      },
      name = {
        trailing_slash = false,
        use_git_status_colors = true,
        highlight = 'NeoTreeFileName',
      },
      git_status = {
        symbols = {
          -- Change type
          added = 'A', -- or "✚", but this is redundant info if you use git_status_colors on the name
          modified = 'M', -- or "", but this is redundant info if you use git_status_colors on the name
          deleted = 'D', -- this can only be used in the git_status source
          renamed = 'R', -- this can only be used in the git_status source
          -- Status type
          untracked = 'U',
          conflict = '',
          ignored = '◌',
          unstaged = '',
          staged = '',
        },
      },
      -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
      file_size = { enabled = false, required_width = 64 },
      type = { enabled = false, required_width = 122 },
      last_modified = { enabled = false, required_width = 88 },
      created = { enabled = false, required_width = 110 },
      symlink_target = { enabled = false },
    },
    -- A list of functions, each representing a global custom command
    -- that will be available in all sources (if not overridden in `opts[source_name].commands`)
    -- see `:h neo-tree-custom-commands-global`
    commands = {},
    window = {
      position = 'left',
      width = 30,
      mapping_options = { noremap = true, nowait = true },
      mappings = {
        ['<space>'] = 'none',
        ['l'] = 'open',
        ['o'] = 'open', -- open_drop
        ['<cr>'] = 'open',
        ['<2-LeftMouse>'] = 'open',
        ['s'] = 'open_split',
        ['v'] = 'open_vsplit',
        ['t'] = 'open_tabnew', -- open_tab_drop
        -- ['w'] = 'open_with_window_picker',
        ['P'] = { 'toggle_preview', config = { use_float = true } },
        -- ["S"] = "split_with_window_picker",
        -- ["s"] = "vsplit_with_window_picker",
        ['<esc>'] = 'cancel', -- close preview or floating neo-tree window
        ['x'] = 'close_node',
        ['X'] = 'close_all_nodes',
        ['zr'] = 'expand_all_nodes',
        ['zR'] = 'expand_all_nodes',
        ['zc'] = 'close_all_nodes',
        ['zC'] = 'close_all_nodes',
        ['Z'] = 'close_all_subnodes',
        ['z'] = 'none',
        -- ['zc'] = 'close_all_subnodes',

        -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
        ['a'] = { 'add', config = { show_path = 'none' } }, -- "none", "relative", "absolute"
        ['A'] = 'add_directory', -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
        ['d'] = 'cut_to_clipboard',
        ['y'] = 'copy_to_clipboard',
        ['p'] = 'paste_from_clipboard',
        ['D'] = 'delete',
        ['<f2>'] = 'rename',
        ['<C-x>'] = 'cut_to_clipboard',
        ['<C-c>'] = 'copy_to_clipboard',
        ['<C-v>'] = 'paste_from_clipboard',
        ['<delete>'] = 'delete',
        ['c'] = 'none',
        ['m'] = 'none',
        -- ['c'] = 'copy', -- takes text input for destination, also accepts the optional config.show_path option like "add":
        -- ['c'] = { 'copy', config = { show_path = 'none' } }, -- "none", "relative", "absolute"
        -- ['m'] = 'move', -- takes text input for destination, also accepts the optional config.show_path option like "add".
        ['r'] = 'refresh',
        ['q'] = 'close_window',
        ['?'] = 'show_help',
        ['K'] = 'show_file_details',
        ['gy'] = {
          function(state)
            util.copy_path(state, false)
          end,
          desc = 'Copy current path',
        },
        ['gY'] = {
          function(state)
            util.copy_path(state, true)
          end,
          desc = 'Copy absolute path',
        },

        ['b'] = 'prev_source',
        ['w'] = 'next_source',
        ['e'] = 'next_source',
        ['[['] = 'prev_source',
        [']]'] = 'next_source',
        ['{'] = 'prev_source',
        ['}'] = 'next_source',
      },
    },
    nesting_rules = {},
    filesystem = {
      -- bind_to_cwd = true, -- true creates a 2-way binding between vim's cwd and neo-tree's root
      -- cwd_target = {
      --   sidebar = 'window', -- sidebar is when position = left or right
      --   current = 'window', -- current is when position = current
      -- },
      filtered_items = {
        visible = false, -- when true, they will just be displayed differently than normal items
        hide_dotfiles = false,
        hide_gitignored = true,
        hide_hidden = true, -- only works on Windows for hidden files/directories
        hide_by_name = {
          --"node_modules"
        },
        hide_by_pattern = { -- uses glob style patterns
          --"*.meta",
          --"*/src/*/tsconfig.json",
        },
        always_show = { -- remains visible even if other settings would normally hide it
          --".gitignored",
        },
        never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
          --".DS_Store",
          --"thumbs.db"
        },
        never_show_by_pattern = { -- uses glob style patterns
          --".null-ls_*",
        },
      },
      follow_current_file = {
        enabled = true, -- This will find and focus the file in the active buffer every time
        --               -- the current file is changed while the tree is open.
        leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
      },
      group_empty_dirs = false, -- when true, empty folders will be grouped together
      hijack_netrw_behavior = 'open_default', -- netrw disabled, opening a directory opens neo-tree
      -- in whatever position is specified in window.position
      -- "open_current",  -- netrw disabled, opening a directory opens within the
      -- window like netrw would, regardless of window.position
      -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
      use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
      -- instead of relying on nvim autocmd events.
      window = {
        mappings = {
          ['<bs>'] = 'none',
          ['.'] = 'set_root',
          ['-'] = function(state)
            vinegar_dir_up(state)
          end,
          ['h'] = function(state)
            vinegar_dir_up(state)

            -- local node = state.tree:get_node()
            -- if node.type == 'directory' and node:is_expanded() then
            --   require('neo-tree.sources.filesystem').toggle_directory(state, node)
            -- else
            --   require('neo-tree.ui.renderer').focus_node(state, node:get_parent_id())
            -- end
          end,
          ['l'] = function(state)
            local node = state.tree:get_node()
            if node.type == 'directory' then
              state.commands['set_root'](state)
              vim.defer_fn(function()
                feedkeys('j')
              end, 80)

              -- if not node:is_expanded() then
              --   require('neo-tree.sources.filesystem').toggle_directory(state, node)
              -- elseif node:has_children() then
              --   require('neo-tree.ui.renderer').focus_node(state, node:get_child_ids()[1])
              -- end
            else
              state.commands['open'](state)
            end
          end,
          ['W'] = function(state)
            state.commands['close_all_nodes'](state)
            if state.path ~= vim.g.cwd then
              require('neo-tree.sources.filesystem').navigate(state, vim.g.cwd)
            end
            feedkeys('ggj')
          end,
          ['i'] = function(state)
            local node = state.tree:get_node()
            require('hasan.utils.file').quickLook({ node:get_id() })
          end,
          ['R'] = function(state)
            local node = state.tree:get_node()
            vim.cmd('silent !explorer.exe /select,"' .. node:get_id() .. '"')
          end,
          ['O'] = function(state)
            local node = state.tree:get_node()
            vim.cmd('silent !explorer.exe "' .. node:get_id() .. '"')
          end,
          ['H'] = 'toggle_hidden',
          ['/'] = 'fuzzy_finder',
          -- ['D'] = 'fuzzy_finder_directory',
          ['#'] = 'fuzzy_sorter', -- fuzzy sorting using the fzy algorithm
          -- ["D"] = "fuzzy_sorter_directory",
          ['f'] = 'filter_on_submit',
          -- ['<c-x>'] = 'clear_filter',
          ['[c'] = 'prev_git_modified',
          [']c'] = 'next_git_modified',
          -- ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
          -- ['oc'] = { 'order_by_created', nowait = false },
          -- ['od'] = { 'order_by_diagnostics', nowait = false },
          -- ['og'] = { 'order_by_git_status', nowait = false },
          -- ['om'] = { 'order_by_modified', nowait = false },
          -- ['on'] = { 'order_by_name', nowait = false },
          -- ['os'] = { 'order_by_size', nowait = false },
          -- ['ot'] = { 'order_by_type', nowait = false },
          ['oc'] = 'none',
          ['od'] = 'none',
          ['og'] = 'none',
          ['om'] = 'none',
          ['on'] = 'none',
          ['os'] = 'none',
          ['ot'] = 'none',
        },
        fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
          ['<down>'] = 'move_cursor_down',
          ['<C-n>'] = 'move_cursor_down',
          ['<up>'] = 'move_cursor_up',
          ['<C-p>'] = 'move_cursor_up',
        },
      },

      commands = {}, -- Add a custom command or override a global one using the same function name
    },
    buffers = {
      follow_current_file = {
        enabled = true, -- This will find and focus the file in the active buffer every time
        --              -- the current file is changed while the tree is open.
        leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
      },
      group_empty_dirs = true, -- when true, empty folders will be grouped together
      show_unloaded = true,
      window = {
        mappings = {
          ['bd'] = 'buffer_delete',
          ['<bs>'] = 'navigate_up',
          ['.'] = 'set_root',
          -- ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
          -- ['oc'] = { 'order_by_created', nowait = false },
          -- ['od'] = { 'order_by_diagnostics', nowait = false },
          -- ['om'] = { 'order_by_modified', nowait = false },
          -- ['on'] = { 'order_by_name', nowait = false },
          -- ['os'] = { 'order_by_size', nowait = false },
          -- ['ot'] = { 'order_by_type', nowait = false },
          ['oc'] = 'none',
          ['od'] = 'none',
          ['om'] = 'none',
          ['on'] = 'none',
          ['os'] = 'none',
          ['ot'] = 'none',
        },
      },
    },
    git_status = {
      window = {
        position = 'float',
        mappings = {
          ['A'] = 'git_add_all',
          ['gu'] = 'git_unstage_file',
          ['ga'] = 'git_add_file',
          ['gr'] = 'git_revert_file',
          ['gc'] = 'git_commit',
          ['gp'] = 'git_push',
          ['gg'] = 'git_commit_and_push',
          -- ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
          -- ['oc'] = { 'order_by_created', nowait = false },
          -- ['od'] = { 'order_by_diagnostics', nowait = false },
          -- ['om'] = { 'order_by_modified', nowait = false },
          -- ['on'] = { 'order_by_name', nowait = false },
          -- ['os'] = { 'order_by_size', nowait = false },
          -- ['ot'] = { 'order_by_type', nowait = false },
          ['oc'] = 'none',
          ['od'] = 'none',
          ['om'] = 'none',
          ['on'] = 'none',
          ['os'] = 'none',
          ['ot'] = 'none',
        },
      },
    },
  },
}
