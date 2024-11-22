local tree_util = require('config.navigation.neo_tree.util')

local function show_more_options(state)
  local options = {
    {
      label = 'Copy current node',
      key = 'y',
      action = function()
        tree_util.copy_path(state, ':t')
      end,
    },
    {
      label = 'Copy absolute node',
      key = 'Y',
      action = function()
        tree_util.copy_path(state)
      end,
    },
    {
      label = 'Copy relative node',
      key = 'r',
      action = function()
        tree_util.copy_path(state, ':.')
      end,
    },
  }

  require('hasan.widgets').get_select(options, function(item)
    if item.action then
      item.action()
    end
  end, {
    prompt = 'Neotree menu',
    relative = 'cursor',
    kind = 'get_char',
    min_width = 30,
  })
end

return {
  position = 'left',
  width = 30,
  mapping_options = { noremap = true, nowait = true },
  mappings = {
    ['K'] = 'show_file_details',
    ['r'] = 'refresh',
    ['q'] = 'close_window',
    ['?'] = 'show_help',
    ['<esc>'] = 'cancel', -- close preview or floating neo-tree window

    ['l'] = 'open',
    ['o'] = 'open', -- open_drop
    ['<cr>'] = 'open',
    ['<2-LeftMouse>'] = 'open',
    ['S'] = 'open_split',
    ['v'] = 'open_vsplit',
    ['t'] = 'open_tabnew', -- open_tab_drop
    -- ['w'] = 'open_with_window_picker', 'split_with_window_picker', 'vsplit_with_window_picker',
    ['s'] = function()
      require('flash').jump()
    end,
    ['P'] = { 'toggle_preview', config = { use_float = true } },
    ['x'] = 'close_node',
    ['X'] = 'close_all_nodes',
    ['W'] = 'close_all_nodes',
    ['zr'] = 'expand_all_nodes',
    ['zR'] = 'expand_all_nodes',
    ['zc'] = 'close_all_nodes',
    ['zC'] = 'close_all_nodes',
    ['zm'] = 'close_all_nodes',
    ['zM'] = 'close_all_nodes',
    ['Z'] = 'close_all_subnodes',
    -- ['zc'] = 'close_all_subnodes',

    -- File Management
    ['a'] = { 'add', config = { show_path = 'none' } }, -- "none", "relative", "absolute"
    ['A'] = 'add_directory', -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
    ['D'] = 'delete',
    ['<f2>'] = 'rename',
    ['<delete>'] = 'delete',
    ['<C-x>'] = 'cut_to_clipboard',
    ['<C-c>'] = 'copy_to_clipboard',
    ['<C-v>'] = 'paste_from_clipboard',
    ['d'] = 'cut_to_clipboard',
    ['y'] = 'copy_to_clipboard',
    ['p'] = 'paste_from_clipboard',
    -- ['c'] = 'copy', -- takes text input for destination, also accepts the optional config.show_path option like "add":
    -- ['c'] = { 'copy', config = { show_path = 'none' } }, -- "none", "relative", "absolute"
    -- ['m'] = 'move', -- takes text input for destination, also accepts the optional config.show_path option like "add".

    ['m'] = { show_more_options, desc = 'Show more options' },
    ['Y'] = {
      function(state)
        tree_util.copy_path(state)
      end,
      desc = 'Copy current node',
    },

    ['b'] = 'prev_source',
    ['w'] = 'next_source',
    ['e'] = 'next_source',
    ['[['] = 'prev_source',
    [']]'] = 'next_source',

    ['<space>'] = 'none',
    ['<bs>'] = 'none',
    ['z'] = 'none',
    ['c'] = 'none',
  },
}
