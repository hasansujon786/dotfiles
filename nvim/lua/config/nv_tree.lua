keymap('n', '<leader>ob', ':NvimTreeToggle<CR>', {desc = 'Toggle explorer'})
keymap('n', '<leader>op', '<cmd>lua require("hasan.utils.vinegar").toggle_sidebar()<CR>', {desc = 'Open explorer'})
keymap('n', '-', '<cmd>lua require("hasan.utils.vinegar").vinegar()<CR>', {desc = 'Vinegar'})
keymap('n', '<BS>', '<cmd>lua require("hasan.utils.vinegar").alternate_file()<CR>', {desc = 'Alternate file'})
keymap('n', '[e', '<cmd>lua require("nvim-tree.marks.navigation").prev()<cr>', {desc = 'Previous tree mark'})
keymap('n', ']e', '<cmd>lua require("nvim-tree.marks.navigation").next()<cr>', {desc = 'Next tree mark'})
keymap('n', '<leader>/e', '<cmd> lua require("nvim-tree.marks.navigation").select()<cr>', {desc = 'Search tree marks'})
-- bulk_move = require("nvim-tree.marks.bulk-move").bulk_move,
local v = require('hasan.utils.vinegar')

-- init.lua
local list = {
  { key = 'zo',                          action = 'edit' },
  { key = 'e',                           action = 'edit_in_place' },
  { key = 'E',                           action = 'edit_no_picker' },
  { key = 's',                           action = 'split' },
  { key = 'v',                           action = 'vsplit' },
  { key = 't',                           action = 'tabnew' },
  { key = 'O',                           action = 'system_open' },
  { key = 'R',                           action = 'system_reveal', action_cb = v.actions.system_reveal },
  { key = {'h'},                         action = 'vinegar_dir_up_or_dir_up', action_cb = v.actions.vinegar_dir_up_or_dir_up },
  { key = {'-'},                         action = 'vinegar_dir_up', action_cb = v.actions.vinegar_dir_up },
  { key = {'<RightMouse>', 'l'},         action = 'vinegar_edit_or_cd', action_cb = v.actions.vinegar_edit_or_cd },
  -- { key = 'K',                           action = 'prev_sibling' },
  -- { key = 'J',                           action = 'next_sibling' },
  { key = 'u',                           action = 'dir_up' },
  { key = 'p',                           action = 'parent_node' },
  { key = '<Tab>',                       action = 'preview' },
  { key = '[c',                          action = 'prev_git_item' },
  { key = ']c',                          action = 'next_git_item' },
  -- { key = 'H',                            action = 'first_sibling' },
  -- { key = 'L',                            action = 'last_sibling' },
  -- { key = 'l',                            action = 'edit', action_cb = edit_or_open },
  -- { key = 'L',                            action = 'vsplit_preview', action_cb = vsplit_preview },
  -- { key = 'h',                            action = 'close_node' },

  { key = 'm',                           action = 'toggle_mark' },
  { key = 'f',                           action = 'live_filter' },
  { key = 'c',                           action = 'clear_live_filter' },
  { key = 'S',                           action = 'search_node' },
  { key = 'I',                           action = 'toggle_git_ignored' },
  { key = 'i',                           action = 'toggle_dotfiles' },
  { key = 'r',                           action = 'refresh' },
  { key = 'q',                           action = 'close' },
  { key = 'g?',                          action = 'toggle_help' },
  { key = 'K',                           action = 'toggle_file_info' },
  { key = 'X',                           action = 'collapse_all' },
  { key = 'W',                           action = 'cd_root', action_cb = v.actions.cd_root },
  { key = 'x',                           action = 'close_node' },

  { key = '.',                           action = 'run_file_command' },
  { key = 'y',                           action = 'copy_name' },
  { key = 'Y',                           action = 'copy_path' },
  { key = 'gy',                          action = 'copy_absolute_path' },
  { key = '<C-x>',                       action = 'cut' },
  { key = '<C-c>',                       action = 'copy' },
  { key = '<C-v>',                       action = 'paste' },
  { key = {'a','A'},                     action = 'create' },
  { key = '<f2>',                        action = 'rename' },
  { key = '<C-r>',                       action = 'full_rename' },
  { key = '<Delete>',                    action = 'remove' },
  { key = 'B',                           action = 'bulk_move' }
  -- { key = 'D',                            action = 'trash' },
}

require('nvim-tree').setup({
  disable_netrw = true,
  hijack_netrw = true,
  ignore_buffer_on_setup = false,
  ignore_ft_on_setup = {},
  auto_reload_on_write = true,
  open_on_tab = false,
  hijack_cursor = false,
  sync_root_with_cwd = true,
  hijack_unnamed_buffer_when_opening = false,
  hijack_directories = {
    enable = true,
    auto_open = true,
  },
  update_focused_file = {
    enable = true,
    update_root = false,
    ignore_list = {},
  },
  filters = {
    dotfiles = false,
    custom = { '^.git$', 'node_modules' }, -- '*.git'
    -- exclude = {},
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 500,
  },
  renderer = {
    indent_width = 1,
    indent_markers = { enable = true },
    icons = {
      git_placement = 'signcolumn',
      show = { folder_arrow = false },
      -- glyphs = {
      --   git = {
      --     unstaged = '✗',
      --     staged = '✓',
      --     unmerged = '',
      --     renamed = '➜',
      --     untracked = '★',
      --     deleted = '',
      --     ignored = '◌',
      --   },
      -- },
    },
  },
  view = {
    width = 27,
    hide_root_folder = false,
    side = 'left',
    preserve_window_proportions = true,
    mappings = { custom_only = true, list = list },
    number = false,
    relativenumber = false,
    signcolumn = 'yes',
  },
  actions = {
    change_dir = {
      enable = false,
      global = false,
    },
    open_file = {
      quit_on_open = false,
      resize_window = false,
    },
  },
})
-- width = function()
--   local winwidth = vim.fn.winwidth(0)
--   if winwidth <= 100 then
--     return 30
--   elseif winwidth <= 200 then
--     return 40
--   else
--     return 50
--   end
-- end,
