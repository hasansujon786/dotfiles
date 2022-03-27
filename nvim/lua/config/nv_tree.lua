local luv = vim.loop
local api = vim.api
local lib = require "nvim-tree.lib"
local log = require "nvim-tree.log"
local colors = require "nvim-tree.colors"
local renderer = require "nvim-tree.renderer"
local utils = require "nvim-tree.utils"
local change_dir = require "nvim-tree.actions.change-dir"
local legacy = require "nvim-tree.legacy"
local core = require "nvim-tree.core"
local tree = require "nvim-tree"
local view = require "nvim-tree.view"

local maps = require('hasan.utils.maps')
maps.nnoremap('<BS>',       ':lua Alternate_file()<CR>')
maps.nnoremap('-',          ':lua Vinegar()<CR>')
maps.nnoremap('<leader>op', ':NvimTreeFindFileToggle<CR>')
maps.nnoremap('<leader>ob', ':NvimTreeToggle<CR>')
maps.nnoremap('<leader>0',  ':NvimTreeFocus<CR>')
maps.nnoremap('<leader>or', ':NvimTreeRefresh<CR>')

local function cd_root()
  require "nvim-tree.lib".open(vim.loop.cwd())
  vim.cmd[[normal! gg]]
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

vim.g.nvim_tree_indent_markers = 1
tree.setup {
  disable_netrw        = true,
  hijack_netrw         = true,
  open_on_setup        = false,
  ignore_buffer_on_setup = false,
  ignore_ft_on_setup   = {},
  auto_reload_on_write = true,
  open_on_tab          = false,
  hijack_cursor        = false,
  update_cwd           = false,
  hijack_unnamed_buffer_when_opening = false,
  hijack_directories   = {
    enable = true,
    auto_open = true,
  },
  update_focused_file = {
    enable      = true,
    update_cwd  = true,
    ignore_list = {}
  },
  filters = {
    dotfiles = false,
    custom = {}
  },
  git = {
    enable = false,
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
}

local alt_file = nil
local pre_alt_file = nil

function Vinegar()
  pre_alt_file = vim.fn.expand('#')
  if view.is_visible() then
    view.close()
  end
  require('nvim-tree').open_replacing_current_buffer()
  alt_file = vim.fn.expand('#')
  vim.w.vinegar = true
end

function Alternate_file()
  if vim.o.filetype == 'NvimTree' then
    if alt_file and vim.w.vinegar then
      view.close()
      vim.cmd('e '..alt_file)
      alt_file = pre_alt_file and pre_alt_file ~= '' and pre_alt_file or nil
      return
    end

    if view.is_visible() and vim.w.vinegar == nil then
      view.close()
      return
    end
  end

  if vim.fn.expand('#') ~= '' then
    vim.fn['hasan#utils#feedkeys']('<c-^>', 'n')
    return
  end

  local found_file = alt_file and alt_file ~= vim.fn.expand('%') and alt_file or nil
  if found_file then
    vim.cmd('e '..found_file)
    return
  end

  vim.cmd([[echo 'E23: No alternate file']])
end

