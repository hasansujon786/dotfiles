local tree = require('nvim-tree')

local maps = require('hasan.utils.maps')
maps.nnoremap('<leader>op', ':NvimTreeFindFileToggle<CR>')
maps.nnoremap('<leader>ob', ':NvimTreeToggle<CR>')
maps.nnoremap('<leader>0', ':NvimTreeFocus<CR>')
maps.nnoremap('<leader>or', ':NvimTreeRefresh<CR>')
maps.nnoremap('-', ':lua require("hasan.utils.vinegar").vinegar()<CR>')
maps.nnoremap('<BS>', ':lua require("hasan.utils.vinegar").alternate_file()<CR>')

local function cd_root()
  require('nvim-tree.lib').open(vim.loop.cwd())
  vim.cmd([[normal! gg]])
end

-- init.lua
local list = {
  { key = {'<CR>', 'o', '<2-LeftMouse>'},action = 'edit' },
  { key = 'e',                           action = 'edit_in_place' },
  { key = 'E',                           action = 'edit_no_picker' },
  { key = 's',                           action = 'split' },
  { key = 'v',                           action = 'vsplit' },
  { key = 't',                           action = 'tabnew' },
  { key = 'O',                           action = 'system_open' },
  { key = 'f',                           action = 'search_node' },

  { key = {'<2-RightMouse>', 'l'},       action = 'cd' },
  { key = {'-', 'h'},                    action = 'dir_up' },
  -- { key = 'K',                           action = 'prev_sibling' },
  -- { key = 'J',                           action = 'next_sibling' },
  { key = 'p',                           action = 'parent_node' },
  { key = '<Tab>',                       action = 'preview' },
  { key = '[c',                          action = 'prev_git_item' },
  { key = ']c',                          action = 'next_git_item' },
  -- { key = 'H',                            action = 'first_sibling' },
  -- { key = 'L',                            action = 'last_sibling' },
  -- { key = 'l',                            action = 'edit', action_cb = edit_or_open },
  -- { key = 'L',                            action = 'vsplit_preview', action_cb = vsplit_preview },
  -- { key = 'h',                            action = 'close_node' },

  { key = 'I',                           action = 'toggle_ignored' },
  { key = 'i',                           action = 'toggle_dotfiles' },
  { key = {'R', 'r'},                    action = 'refresh' },
  { key = 'q',                           action = 'close' },
  { key = 'g?',                          action = 'toggle_help' },
  { key = 'K',                           action = 'toggle_file_info' },
  { key = 'X',                           action = 'collapse_all' },
  { key = 'W',                           action = 'cd_root', action_cb = cd_root },
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
  -- { key = 'D',                            action = 'trash' },
}

tree.setup({
  disable_netrw = true,
  hijack_netrw = true,
  open_on_setup = false,
  ignore_buffer_on_setup = false,
  ignore_ft_on_setup = {},
  auto_reload_on_write = true,
  open_on_tab = false,
  hijack_cursor = false,
  update_cwd = false,
  hijack_unnamed_buffer_when_opening = false,
  hijack_directories = {
    enable = true,
    auto_open = true,
  },
  update_focused_file = {
    enable = true,
    update_cwd = true,
    ignore_list = {},
  },
  filters = {
    dotfiles = false,
    custom = { '*.git', 'node_modules' },
  },
  git = {
    enable = false,
    ignore = true,
    timeout = 500,
  },
  renderer = {
    indent_markers = {
      enable = true,
    },
  },
  view = {
    width = 26,
    height = 30,
    hide_root_folder = false,
    side = 'left',
    preserve_window_proportions = false,
    mappings = {
      custom_only = true,
      list = list,
    },
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
      window_picker = {
        enable = true,
        chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890',
        exclude = {
          filetype = { 'notify', 'packer', 'qf', 'diff', 'fugitive', 'fugitiveblame' },
          buftype = { 'nofile', 'terminal', 'help' },
        },
      },
    },
  },
})

