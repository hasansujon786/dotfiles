local util = require('config.neo_tree.util')

return {
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
    ['c'] = 'none',
    ['m'] = 'none',
    ['a'] = { 'add', config = { show_path = 'none' } }, -- "none", "relative", "absolute"
    ['A'] = 'add_directory', -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
    ['<f2>'] = 'rename',
    ['D'] = 'delete',
    ['<delete>'] = 'delete',
    ['d'] = 'cut_to_clipboard',
    ['y'] = 'copy_to_clipboard',
    ['p'] = 'paste_from_clipboard',
    ['<C-x>'] = 'cut_to_clipboard',
    ['<C-c>'] = 'copy_to_clipboard',
    ['<C-v>'] = 'paste_from_clipboard',
    -- ['c'] = 'copy', -- takes text input for destination, also accepts the optional config.show_path option like "add":
    -- ['c'] = { 'copy', config = { show_path = 'none' } }, -- "none", "relative", "absolute"
    -- ['m'] = 'move', -- takes text input for destination, also accepts the optional config.show_path option like "add".
    ['r'] = 'refresh',
    ['q'] = 'close_window',
    ['?'] = 'show_help',
    ['K'] = 'show_file_details',
    ['Y'] = {
      function(state)
        util.copy_path(state, ':t')
      end,
      desc = 'Copy current node',
    },
    ['gf'] = {
      function(state)
        util.copy_path(state)
      end,
      desc = 'Copy absolute node',
    },
    ['gy'] = {
      function(state)
        util.copy_path(state, ':.')
      end,
      desc = 'Copy relative node',
    },
    ['b'] = 'prev_source',
    ['w'] = 'next_source',
    ['e'] = 'next_source',
    ['[['] = 'prev_source',
    [']]'] = 'next_source',
    ['{'] = 'prev_source',
    ['}'] = 'next_source',
  },
}
