local vinegar = require('config.navigation.neo_tree.util')

local function focus_first_child(state, node)
  if node:has_children() then
    require('neo-tree.ui.renderer').focus_node(state, node:get_child_ids()[1])
  end
end

return {
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
      ['/'] = 'none',
      ['f'] = 'none',
      ['.'] = 'set_root',
      ['I'] = 'toggle_hidden',
      -- ['/'] = 'fuzzy_finder',
      ['#'] = 'fuzzy_sorter', -- fuzzy sorting using the fzy algorithm
      -- ['D'] = 'fuzzy_finder_directory',
      -- ["D"] = "fuzzy_sorter_directory",
      -- ['f'] = 'filter_on_submit',
      -- ['<c-x>'] = 'clear_filter',

      ['-'] = function(state)
        vinegar.vinegar_dir_up(state)
      end,
      ['h'] = function(state)
        if vim.b['neo_tree_position'] == 'current' then
          vinegar.vinegar_dir_up(state)
        else
          state.commands['close_node'](state)
        end
      end,
      ['l'] = function(state)
        local node = state.tree:get_node()
        if node.type == 'directory' then
          if vim.b['neo_tree_position'] == 'current' then
            state.commands['set_root'](state)
            vim.defer_fn(function()
              pcall(vim.api.nvim_win_set_cursor, 0, { 2, 1 })
            end, 100)
          else
            if not node:is_expanded() then
              local file = require('neo-tree.sources.filesystem')
              file.toggle_directory(state, node, node:get_child_ids()[1], nil, nil, function()
                focus_first_child(state, node)
              end)
            else
              focus_first_child(state, node)
            end
          end
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
        local file = node:get_id()
        require('hasan.utils.file').system_open(file, { reveal = true })
      end,
      ['O'] = function(state)
        local node = state.tree:get_node()
        local file = node:get_id()
        require('hasan.utils.file').system_open(file, { reveal = false })
      end,

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
  -- commands = {}, -- Add a custom command or override a global one using the same function name
}

-- local highlights = require('neo-tree.ui.highlights')
-- local comp = require('neo-tree.sources.common.components')
-- components = {
--   icon = function(config, node, state)
--     local icon = config.default or ' '
--     local highlight = config.highlight or highlights.FILE_ICON
--     if node.type == 'directory' then
--       highlight = highlights.DIRECTORY_ICON
--       if node:get_depth() == 1 then -- my logic
--         icon = ''
--       elseif node.loaded and not node:has_children() then
--         icon = not node.empty_expanded and config.folder_empty or config.folder_empty_open
--       elseif node:is_expanded() then
--         icon = config.folder_open or '-'
--       else
--         icon = config.folder_closed or '+'
--       end
--     elseif node.type == 'file' or node.type == 'terminal' then
--       local success, web_devicons = pcall(require, 'nvim-web-devicons')
--       if success then
--         local devicon, hl = web_devicons.get_icon(node.name)
--         icon = devicon or icon
--         highlight = hl or highlight
--       end
--     end

--     local filtered_by = comp.filtered_by(config, node, state)

--     return {
--       text = icon .. ' ',
--       highlight = filtered_by.highlight or highlight,
--     }
--   end,
-- }
