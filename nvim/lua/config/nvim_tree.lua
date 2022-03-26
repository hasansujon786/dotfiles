local lib = require('nvim-tree.lib')
local view = require('nvim-tree.view')

vim.g.nvim_tree_indent_markers = 1

-- NvimTreeWindowPicker
function Toggle_replace()
  local _view = require('nvim-tree.view')
  if _view.is_visible() then
    _view.close()
  else
    require('nvim-tree').open_replacing_current_buffer()
  end
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
  { key = 's',                           action = 'search_node' },

  { key = {'<2-RightMouse>', 'l'},       action = 'cd' },
  { key = {'-', 'h'},                    action = 'dir_up' },
  { key = 'K',                           action = 'prev_sibling' },
  { key = 'J',                           action = 'next_sibling' },
  { key = 'p',                           action = 'parent_node' },
  { key = '<Tab>',                       action = 'preview' },
  { key = '[c',                          action = 'prev_git_item' },
  { key = ']c',                          action = 'next_git_item' },
  -- { key = 'H',                            action = 'first_sibling' },
  -- { key = 'L',                            action = 'last_sibling' },
  -- { key = 'l',                            action = 'edit', action_cb = edit_or_open },
  -- { key = 'L',                            action = 'vsplit_preview', action_cb = vsplit_preview },
  -- { key = 'h',                            action = 'close_node' },

  { key = 'I',                            action = 'toggle_ignored' },
  { key = 'i',                            action = 'toggle_dotfiles' },
  { key = {'R', 'r'},                     action = 'refresh' },
  { key = 'q',                            action = 'close' },
  { key = 'g?',                           action = 'toggle_help' },
  { key = '<C-k>',                        action = 'toggle_file_info' },
  { key = {'W', 'X'},                     action = 'collapse_all' },
  { key = {'x', '<BS>'},                  action = 'close_node' },

  { key = '.',                            action = 'run_file_command' },
  { key = 'y',                            action = 'copy_name' },
  { key = 'Y',                            action = 'copy_path' },
  { key = 'gy',                           action = 'copy_absolute_path' },
  { key = '<C-x>',                        action = 'cut' },
  { key = '<C-c>',                        action = 'copy' },
  { key = '<C-v>',                        action = 'paste' },
  { key = {'a','A'},                      action = 'create' },
  { key = '<f2>',                         action = 'rename' },
  { key = '<C-r>',                        action = 'full_rename' },
  { key = '<Delete>',                     action = 'remove' },
  -- { key = 'D',                            action = 'trash' },
}

require'nvim-tree'.setup {
  disable_netrw        = true,
  hijack_netrw         = true,
  open_on_setup        = false,
  ignore_buffer_on_setup = false,
  ignore_ft_on_setup   = {},
  auto_close           = false,
  auto_reload_on_write = true,
  open_on_tab          = false,
  hijack_cursor        = false,
  update_cwd           = true,
  hijack_unnamed_buffer_when_opening = false,
  hijack_directories   = {
    enable = true,
    auto_open = true,
  },
  diagnostics = {
    enable = false,
    icons = {
      hint = '',
      info = '',
      warning = '',
      error = '',
    }
  },
  update_focused_file = {
    enable      = true,
    update_cwd  = false,
    ignore_list = {}
  },
  system_open = {
    cmd  = nil,
    args = {}
  },
  filters = {
    dotfiles = false,
    custom = {}
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 500,
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
    signcolumn = 'yes'
  },
  trash = {
    cmd = 'trash',
    require_confirm = true
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
          filetype = { 'notify', 'packer', 'qf', 'diff', 'fugitive', 'fugitiveblame', },
          buftype  = { 'nofile', 'terminal', 'help', },
        }
      }
    }
  },
  log = {
    enable = false,
    types = {
      all = false,
      config = false,
      git = false,
    },
  },
}

local maps = require('hasan.utils.maps')
maps.nnoremap('<BS>',       '<c-^>')
maps.nnoremap('-',          ':lua Toggle_replace()<CR>')
maps.nnoremap('<leader>op', ':NvimTreeFindFileToggle<CR>')
maps.nnoremap('<leader>ob', ':NvimTreeFocus<CR>')
maps.nnoremap('<leader>0',  ':NvimTreeFocus<CR>')
maps.nnoremap('<leader>or', ':NvimTreeRefresh<CR>')
