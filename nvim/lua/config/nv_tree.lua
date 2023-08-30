keymap('n', '-', '<cmd>lua require("hasan.utils.vinegar").vinegar()<CR>', { desc = 'Vinegar' })
keymap('n', '<BS>', '<cmd>lua require("hasan.utils.vinegar").alternate_file()<CR>', { desc = 'Alternate file' })
keymap('n', '<leader>ob', ':NvimTreeToggle<CR>', { desc = 'Toggle explorer' })
keymap('n', '<leader>op', '<cmd>lua require("hasan.utils.vinegar").toggle_sidebar()<CR>', { desc = 'Open explorer' })
keymap('n', '<leader>/e', '<cmd> lua require("nvim-tree.marks.navigation").select()<cr>', { desc = 'Search tree marks' })
-- keymap('n', '[e', '<cmd>lua require("nvim-tree.marks.navigation").prev()<cr>', {desc = 'Previous tree mark'})
-- keymap('n', ']e', '<cmd>lua require("nvim-tree.marks.navigation").next()<cr>', {desc = 'Next tree mark'})
local vngr = require('hasan.utils.vinegar')
local vopen = vngr.actions.open_or_edit_in_place
local vclose = vngr.actions.open_n_close

local function find_directory_and_focus()
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')

  require('telescope.builtin').find_files({
    find_command = { 'fd', '--type', 'directory', '--hidden', '--exclude', '.git/*' },
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        local api = require('nvim-tree.api')

        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        api.tree.open()
        api.tree.find_file(selection.cwd .. '/' .. selection.value)
      end)
      return true
    end,
  })
end

local SORT_METHODS = {
  'name',
  'modification_time',
  'extension',
  -- 'case_sensitive',
}
local sort_current = 1
local sort_by = function()
  return SORT_METHODS[sort_current]
end

local function on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- BEGIN_DEFAULT_ON_ATTACH
  vim.keymap.set('n', 'w',     api.tree.change_root_to_parent,        opts('Up'))
  vim.keymap.set('n', 'W',     vngr.actions.jump_to_root,             opts('CD'))
  vim.keymap.set('n', 'p',     api.node.navigate.parent,              opts('Parent Directory'))
  vim.keymap.set('n', '>',     api.node.navigate.sibling.next,        opts('Next Sibling'))
  vim.keymap.set('n', '<',     api.node.navigate.sibling.prev,        opts('Previous Sibling'))
  vim.keymap.set('n', 'H',     api.node.navigate.sibling.first,       opts('First Sibling'))
  vim.keymap.set('n', 'L',     api.node.navigate.sibling.last,        opts('Last Sibling'))
  vim.keymap.set('n', '[c',    api.node.navigate.git.prev,            opts('Prev Git'))
  vim.keymap.set('n', ']c',    api.node.navigate.git.next,            opts('Next Git'))
  vim.keymap.set('n', ']e',    api.node.navigate.diagnostics.next,    opts('Next Diagnostic'))
  vim.keymap.set('n', '[e',    api.node.navigate.diagnostics.prev,    opts('Prev Diagnostic'))

  -- CONFIG
  vim.keymap.set('n', 'B',     api.tree.toggle_no_buffer_filter,      opts('Toggle No Buffer'))
  vim.keymap.set('n', 'c',     api.tree.toggle_custom_filter,         opts('Toggle Hidden'))
  vim.keymap.set('n', 'C',     api.tree.toggle_git_clean_filter,      opts('Toggle Git Clean'))
  -- vim.keymap.set('n', 'F',     api.live_filter.clear,                 opts('Clean Filter'))
  -- vim.keymap.set('n', 'f',     api.live_filter.start,                 opts('Filter'))
  vim.keymap.set('n', 'i',     api.tree.toggle_hidden_filter,         opts('Toggle Dotfiles'))
  vim.keymap.set('n', 'I',     api.tree.toggle_gitignore_filter,      opts('Toggle Git Ignore'))
  vim.keymap.set('n', 'm',     api.marks.toggle,                      opts('Toggle Bookmark'))
  vim.keymap.set('n', 'q',     api.tree.close,                        opts('Close'))
  vim.keymap.set('n', 'U',     api.tree.reload,                       opts('Refresh'))
  vim.keymap.set('n', 'x',     api.node.navigate.parent_close,        opts('Close Directory'))
  vim.keymap.set('n', 'X',     api.tree.collapse_all,                 opts('Collapse'))
  vim.keymap.set('n', 'E',     api.tree.expand_all,                   opts('Expand All'))
  vim.keymap.set('n', 'K',     api.node.show_info_popup,              opts('Info'))
  vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))
  vim.keymap.set('n', 'gs',    vngr.actions.git_add,                  opts('Git Add'))
  vim.keymap.set('n', 'gu',    vngr.actions.git_add,                  opts('Git Add'))
  -- vim.keymap.set('n', 'S',     api.tree.search_node,                  opts('Search'))

  -- vinegar
  vim.keymap.set('n', '-',     vngr.actions.vinegar_dir_up,           opts('Up'))
  vim.keymap.set('n', 'h',     vngr.actions.vinegar_dir_up,           opts('Up'))
  vim.keymap.set('n', 'l',     vngr.actions.vinegar_edit_or_cd,       opts('Up'))

  -- OPEN COMMAND
  vim.keymap.set('n', 'o',     vopen(api.node.open.edit),             opts('Open'))
  vim.keymap.set('n', 'e',     vopen(api.node.open.no_window_picker), opts('Open: In Place'))
  vim.keymap.set('n', 'O',     api.node.run.system,                   opts('Run System'))
  vim.keymap.set('n', 'R',     vngr.actions.system_reveal,            opts('Reveal In System'))
  vim.keymap.set('n', 'i',     vngr.actions.quickLook,                opts('Reveal In System'))
  vim.keymap.set('n', '<CR>',  vclose(api.node.open.edit),            opts('Open'))
  vim.keymap.set('n', '<Tab>', api.node.open.preview,                 opts('Open Preview'))
  vim.keymap.set('n', '<2-LeftMouse>',  api.node.open.edit,           opts('Open'))
  vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
  vim.keymap.set('n', 'v',     api.node.open.vertical,                opts('Open: Vertical Split'))
  vim.keymap.set('n', 's',     api.node.open.horizontal,              opts('Open: Horizontal Split'))
  vim.keymap.set('n', 't', function()
    local node = api.tree.get_node_under_cursor()
    vim.cmd('wincmd l')
    api.node.open.tab(node)
  end, opts('Open: New Tab'))

  -- FILE MANAGEMENT
  vim.keymap.set('n', 'fd',    find_directory_and_focus,              opts('Find directory'))
  vim.keymap.set('n', '.',     api.node.run.cmd,                      opts('Run Command'))
  vim.keymap.set('n', 'a',     api.fs.create,                         opts('Create'))
  vim.keymap.set('n', 'M',     api.marks.bulk.move,                   opts('Move Bookmarked'))
  vim.keymap.set('n', '<C-x>', api.fs.cut,                            opts('Cut'))
  vim.keymap.set('n', '<C-c>', api.fs.copy.node,                      opts('Copy'))
  vim.keymap.set('n', '<C-v>', api.fs.paste,                          opts('Paste'))
  vim.keymap.set('n', 'r',     api.fs.rename_basename,                opts('Rename: Basename'))
  vim.keymap.set('n', '<f2>',  api.fs.rename,                         opts('Rename'))
  vim.keymap.set('n', '<C-r>', api.fs.rename_sub,                     opts('Rename: Omit Filename'))
  vim.keymap.set('n', '<Delete>',api.fs.remove,                       opts('Delete'))
  vim.keymap.set('n', 'D',     api.fs.trash,                          opts('Trash'))
  vim.keymap.set('n', 'y',     api.fs.copy.filename,                  opts('Copy Name'))
  vim.keymap.set('n', 'Y',     api.fs.copy.relative_path,             opts('Copy Relative Path'))
  vim.keymap.set('n', 'gy',    api.fs.copy.absolute_path,             opts('Copy Absolute Path'))
  vim.keymap.set('n', 'g.', function()
    if sort_current >= #SORT_METHODS then
      sort_current = 1
    else
      sort_current = sort_current + 1
    end
    api.tree.reload()
    print(SORT_METHODS[sort_current])
  end, opts('Cycle Sort'))


  -- -- You might tidy things by removing these along with their default mapping.
  -- vim.keymap.set('n', 'O', '', { buffer = bufnr })
  -- vim.keymap.del('n', 'O', { buffer = bufnr })
  -- vim.keymap.set('n', '<2-RightMouse>', '', { buffer = bufnr })
  -- vim.keymap.del('n', '<2-RightMouse>', { buffer = bufnr })
  -- vim.keymap.set('n', 'D', '', { buffer = bufnr })
  -- vim.keymap.del('n', 'D', { buffer = bufnr })
  -- vim.keymap.set('n', 'E', '', { buffer = bufnr })
  -- vim.keymap.del('n', 'E', { buffer = bufnr })
end

require('nvim-tree').setup({
  on_attach = on_attach,
  sort_by = sort_by,
  disable_netrw = true,
  hijack_netrw = true,
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
  tab = {
    sync = {
      open = true,
      close = true,
      ignore = { 'NeogitStatus' },
    },
  },
  renderer = {
    -- root_folder_label = ":~:s?$?/..?",
    root_folder_label = ':~:s?$?\\\\..?',
    indent_width = 1,
    indent_markers = { enable = true },
    icons = {
      git_placement = 'signcolumn',
      show = { folder_arrow = false },
      padding = ' ',
      glyphs = {
        default = '',
        symlink = '',
        bookmark = '',
        modified = '●',
        folder = {
          arrow_closed = '',
          arrow_open = '',
          default = '', -- 
          open = '', -- 
          empty = '',
          empty_open = '',
          symlink = '',
          symlink_open = '',
        },
        -- git = {
        --   unstaged = '✗',
        --   staged = '✓',
        --   unmerged = '',
        --   renamed = '➜',
        --   untracked = '★',
        --   deleted = '',
        --   ignored = '◌',
        -- },
      },
    },
  },
  view = {
    width = 27,
    hide_root_folder = false,
    side = 'left',
    preserve_window_proportions = true,
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
      eject = true,
    },
  },
})

-- create_nvim_tree_autocmd("BufWipeout", {
--   pattern = "NvimTree_*",
--   callback = function()
-- -      if utils.is_nvim_tree_buf(0) and opts.actions.open_file.eject then
-- +      if not utils.is_nvim_tree_buf(0) then
-- +        return
-- +      end
-- +      if opts.actions.open_file.eject then
--       view._prevent_buffer_override()
-- +      else
-- +        view.abandon_current_window()
--     end
--   end,
-- })
