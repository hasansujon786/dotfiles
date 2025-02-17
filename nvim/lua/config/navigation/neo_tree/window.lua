local function show_copy_options(state)
  local tree_util = require('config.navigation.neo_tree.util')
  local options = {
    {
      key = 'c',
      label = 'Copy file path',
      action = function()
        tree_util.copy_path(state)
      end,
    },
    {
      key = 'f',
      label = 'Copy filename',
      action = function()
        tree_util.copy_path(state, ':t')
      end,
    },
    {
      key = 'r',
      label = 'Copy relative path',
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
    prompt = ' Neotree menu ',
    relative = 'cursor',
    kind = 'get_char',
    min_width = 30,
  })
end

local function show_more(state)
  local bloc = require('config.lsp.servers.dartls.bloc')
  local fs = require('neo-tree.sources.filesystem')

  -- local tree_util = require('config.navigation.neo_tree.util')
  local options = {
    {
      key = 'b',
      label = 'New Block',
      action = function()
        local node = state.tree:get_node()
        local destination = bloc.create_new_bloc(node.path, node.type)
        if destination then
          fs.show_new_children(state, destination)
        end
      end,
    },
    {
      key = 'f',
      label = 'New Feature',
      action = function()
        local node = state.tree:get_node()
        local destination = bloc.create_new_feature(node.path, node.type)
        if destination then
          fs.show_new_children(state, destination)
        end
      end,
    },
  }

  require('hasan.widgets').get_select(options, function(item)
    if item.action then
      item.action()
    end
  end, {
    prompt = ' Neotree menu ',
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
    ['t'] = 'open_tabnew', -- open_tab_drop
    ['v'] = 'open_vsplit',
    ['S'] = 'open_split',
    -- ['w'] = 'open_with_window_picker', 'split_with_window_picker', 'vsplit_with_window_picker',
    ['P'] = { 'toggle_preview', config = { use_float = true } },
    ['h'] = 'close_node',
    ['H'] = 'close_all_nodes',
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
    ['<f2>'] = 'rename',
    ['<C-x>'] = 'cut_to_clipboard',
    ['<C-c>'] = 'copy_to_clipboard',
    ['<C-v>'] = 'paste_from_clipboard',
    ['x'] = 'cut_to_clipboard',
    ['y'] = 'copy_to_clipboard',
    ['p'] = 'paste_from_clipboard',
    ['d'] = 'delete',
    ['D'] = 'delete',
    ['<delete>'] = 'delete',
    -- ['c'] = { 'copy', config = { show_path = 'none' } }, -- "none", "relative", "absolute"
    -- ['m'] = 'move', -- takes text input for destination, also accepts the optional config.show_path option like "add".
    ['c'] = { show_copy_options, desc = 'Copy filepath to clipboard' },
    ['m'] = { show_more, desc = 'Show more options' },
    ['Y'] = {
      function(state)
        require('config.navigation.neo_tree.util').copy_path(state, ':t')
      end,
      desc = 'Copy filename',
    },

    ['[['] = 'prev_source',
    [']]'] = 'next_source',
    ['<s-tab>'] = 'prev_source',
    ['<tab>'] = 'next_source',

    ['<space>'] = 'none',
    ['<bs>'] = 'none',
    ['z'] = 'none',
    ['C'] = 'none',
    ['s'] = 'none',
  },
}
