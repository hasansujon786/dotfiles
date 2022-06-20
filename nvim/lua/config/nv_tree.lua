keymap('n', '<leader>0', ':NvimTreeFocus<CR>')
keymap('n', '<leader>ob', ':NvimTreeToggle<CR>')
keymap('n', '<leader>op', '<cmd>lua require("hasan.utils.vinegar").toggle_sidebar()<CR>')
keymap('n', '-', '<cmd>lua require("hasan.utils.vinegar").vinegar()<CR>')
keymap('n', '<BS>', '<cmd>lua require("hasan.utils.vinegar").alternate_file()<CR>')

local function cd_root()
  require('nvim-tree.lib').open(vim.loop.cwd())
  feedkeys('gg', '')
end
local function system_reveal()
  local node = require('nvim-tree.lib').get_node_at_cursor()
  vim.cmd('silent !explorer.exe /select,"' .. node.absolute_path .. '"')
end

local function vinegar_dir_up()
  local node = require('nvim-tree.lib').get_node_at_cursor()
  local cwd = vim.fn.fnamemodify(node.absolute_path, ":h")
  local parent_cwd = vim.fn.fnamemodify(cwd, ":h")

  require('nvim-tree.lib').open(parent_cwd)
  require('nvim-tree.actions.find-file').fn(cwd)
end

local function vinegar_edit_or_cd()
  local action = 'edit'
  local node = require('nvim-tree.lib').get_node_at_cursor()

  if node.link_to and not node.nodes then -- TODO: chec what is node.link_to
    require('nvim-tree.actions.open-file').fn(action, node.link_to)
    require('nvim-tree.view').close()
  elseif node.nodes ~= nil then
    require("nvim-tree.actions.change-dir").fn(require('nvim-tree.lib').get_last_group_node(node).absolute_path)
    feedkeys('ggj', '')
  else
    require('nvim-tree.actions.open-file').fn(action, node.absolute_path)
    require('nvim-tree.view').close()
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
  { key = 'R',                           action = 'system_reveal', action_cb = system_reveal },

  { key = {'h'},                         action = 'dir_up' },
  { key = {'-'},                         action = 'vinegar_dir_up', action_cb = vinegar_dir_up },
  { key = {'<RightMouse>', 'l'},         action = 'vinegar_edit_or_cd', action_cb = vinegar_edit_or_cd },
  -- { key = {'h'},                         action = 'dir_up', },
  -- { key = 'K',                           action = 'prev_sibling' },
  -- { key = 'J',                           action = 'next_sibling' },
  { key = 'u',                           action = 'parent_node' },
  { key = '<Tab>',                       action = 'preview' },
  { key = '[c',                          action = 'prev_git_item' },
  { key = ']c',                          action = 'next_git_item' },
  -- { key = 'H',                            action = 'first_sibling' },
  -- { key = 'L',                            action = 'last_sibling' },
  -- { key = 'l',                            action = 'edit', action_cb = edit_or_open },
  -- { key = 'L',                            action = 'vsplit_preview', action_cb = vsplit_preview },
  -- { key = 'h',                            action = 'close_node' },

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

require('nvim-tree').setup({
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
    enable = true,
    ignore = true,
    timeout = 500,
  },
  renderer = {
    indent_markers = { enable = true },
    icons = { git_placement = 'signcolumn' },
  },
  view = {
    width = 26,
    height = 30,
    hide_root_folder = false,
    side = 'left',
    preserve_window_proportions = false,
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

-- vim.g.nvim_tree_icons = {
--   default =        "",
--   symlink =        "",
--   git = {
--     unstaged =     "✗",
--     staged =       "✓",
--     unmerged =     "",
--     renamed =      "➜",
--     untracked =    "★",
--     deleted =      "",
--   },
--   folder = {
--     arrow_open =   "",
--     arrow_closed = "",
--     default =      "",
--     open =         "",
--     empty =        "",
--     empty_open =   "",
--     symlink =      "",
--     symlink_open = "",
--   },
--   lsp = {
--     hint = "",
--     info = "",
--     warning = "",
--     error = "",
--   }
-- }

