return {
  follow_current_file = {
    enabled = true, -- This will find and focus the file in the active buffer every time
    --              -- the current file is changed while the tree is open.
    leave_dirs_open = true, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
  },
  group_empty_dirs = true, -- when true, empty folders will be grouped together
  show_unloaded = true,
  window = {
    mappings = {
      ['.'] = 'set_root',
      ['d'] = 'buffer_delete',
      ['D'] = 'buffer_delete',
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
}
