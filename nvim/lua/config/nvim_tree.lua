local sort_current = 1
local SORT_METHODS = {
  'name',
  'modification_time',
  'extension',
  -- 'case_sensitive',
}
local sort_by = function()
  return SORT_METHODS[sort_current]
end

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

local function on_attach(bufnr)
  local api = require('nvim-tree.api')
  local vngr = require('hasan.utils.vinegar')
  local vopen = vngr.actions.open_or_edit_in_place
  local vclose = vngr.actions.open_n_close
  local custom = {}
  -- mark operation
  custom.mark_move_j = function()
    api.marks.toggle()
    vim.cmd('norm j')
  end
  custom.mark_move_k = function()
    api.marks.toggle()
    vim.cmd('norm k')
  end
  -- marked files operation
  custom.mark_trash = function()
    local marks = api.marks.list()
    if #marks == 0 then
      table.insert(marks, api.tree.get_node_under_cursor())
    end
    vim.ui.input({ prompt = string.format('Trash %s files? [y/n] ', #marks) }, function(input)
      if input == 'y' then
        for _, node in ipairs(marks) do
          api.fs.trash(node)
        end
        api.marks.clear()
        api.tree.reload()
      end
    end)
  end
  custom.mark_remove = function()
    local marks = api.marks.list()
    if #marks == 0 then
      table.insert(marks, api.tree.get_node_under_cursor())
    end
    vim.ui.input({ prompt = string.format('Permanently delete %s files? [y/n] ', #marks) }, function(input)
      if input == 'y' then
        for _, node in ipairs(marks) do
          api.fs.remove(node)
        end
        api.marks.clear()
        api.tree.reload()
      end
    end)
  end
  custom.mark_copy = function()
    local marks = api.marks.list()
    if #marks == 0 then
      table.insert(marks, api.tree.get_node_under_cursor())
    end
    for _, node in pairs(marks) do
      api.fs.copy.node(node)
    end
    api.marks.clear()
    api.tree.reload()
  end
  custom.mark_cut = function()
    local marks = api.marks.list()
    if #marks == 0 then
      table.insert(marks, api.tree.get_node_under_cursor())
    end
    for _, node in pairs(marks) do
      api.fs.cut(node)
    end
    api.marks.clear()
    api.tree.reload()
  end
  custom.toggle_sort = function()
    if sort_current >= #SORT_METHODS then
      sort_current = 1
    else
      sort_current = sort_current + 1
    end
    api.tree.reload()
    print(SORT_METHODS[sort_current])
  end

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- Navigation
  vim.keymap.set('n', 'u',     api.node.navigate.parent,              opts('Parent directory'))
  vim.keymap.set('n', '>',     api.node.navigate.sibling.next,        opts('Next sibling'))
  vim.keymap.set('n', '<',     api.node.navigate.sibling.prev,        opts('Previous sibling'))
  vim.keymap.set('n', 'H',     api.node.navigate.sibling.first,       opts('First sibling'))
  vim.keymap.set('n', 'L',     api.node.navigate.sibling.last,        opts('Last sibling'))
  vim.keymap.set('n', '[c',    api.node.navigate.git.prev,            opts('Prev git'))
  vim.keymap.set('n', ']c',    api.node.navigate.git.next,            opts('Next git'))
  vim.keymap.set('n', ']d',    api.node.navigate.diagnostics.next,    opts('Next diagnostic'))
  vim.keymap.set('n', '[d',    api.node.navigate.diagnostics.prev,    opts('Prev diagnostic'))

  -- vinegar
  vim.keymap.set('n', 'h',     vngr.actions.vinegar_dir_up,           opts('Vinegar left'))
  vim.keymap.set('n', 'l',     vngr.actions.vinegar_edit_or_cd,       opts('Vinegar right'))
  vim.keymap.set('n', '-',     vngr.actions.vinegar_dir_up,           opts('Vinegar up'))
  vim.keymap.set('n', '<BS>',  vngr.actions.vinegar_dir_up,           opts('Vinegar up'))

  -- Search & filter
  vim.keymap.set('n', 'f',     find_directory_and_focus,              opts('Find directory'))
  vim.keymap.set('n', 'B',     api.tree.toggle_no_buffer_filter,      opts('Toggle no buffer'))
  vim.keymap.set('n', 'c',     api.tree.toggle_custom_filter,         opts('Toggle hidden'))
  vim.keymap.set('n', 'C',     api.tree.toggle_git_clean_filter,      opts('Toggle git clean'))
  -- vim.keymap.set('n', 'F',     api.live_filter.clear,                 opts('Clean Filter'))
  -- vim.keymap.set('n', 'f',     api.live_filter.start,                 opts('Filter'))
  -- vim.keymap.set('n', 'S',     api.tree.search_node,                  opts('Search'))
  vim.keymap.set('n', 'gi',    api.tree.toggle_hidden_filter,         opts('Toggle dotfiles'))
  vim.keymap.set('n', 'gI',    api.tree.toggle_gitignore_filter,      opts('Toggle git ignore'))

  -- Controll folder & View
  vim.keymap.set('n', 'w',     api.tree.change_root_to_parent,        opts('Jump to parent'))
  vim.keymap.set('n', 'W',     vngr.actions.jump_to_root,             opts('Jump to root'))
  vim.keymap.set('n', 'q',     api.tree.close,                        opts('Close'))
  vim.keymap.set('n', 'U',     api.tree.reload,                       opts('Refresh'))
  vim.keymap.set('n', 'x',     api.node.navigate.parent_close,        opts('Close directory'))
  vim.keymap.set('n', 'X',     api.tree.collapse_all,                 opts('Collapse'))
  vim.keymap.set('n', 'E',     api.tree.expand_all,                   opts('Expand all'))
  vim.keymap.set('n', 'K',     api.node.show_info_popup,              opts('Info'))
  vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))
  vim.keymap.set('n', '.',     api.node.run.cmd,                      opts('Run command'))
  vim.keymap.set('n', 'g.',    custom.toggle_sort,                    opts('Cycle sort'))
  vim.keymap.set('n', '<leader>gs',vngr.actions.git_add,              opts('Git: Toggle hunk'))
  vim.keymap.set('n', '<leader>gu',vngr.actions.git_add,              opts('Git: Toggle hunk'))

  -- OPEN COMMAND
  vim.keymap.set('n', 'o',     vopen(api.node.open.edit),             opts('Open'))
  vim.keymap.set('n', 'e',     vopen(api.node.open.no_window_picker), opts('Open: In place'))
  vim.keymap.set('n', 'go',    api.node.open.preview,                 opts('Open preview'))
  vim.keymap.set('n', '<CR>',  vclose(api.node.open.edit),            opts('Open'))
  vim.keymap.set('n', '<2-LeftMouse>',  vopen(api.node.open.edit),    opts('Open'))
  vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
  vim.keymap.set('n', 'v',     api.node.open.vertical,                opts('Open: Vertical split'))
  vim.keymap.set('n', 's',     api.node.open.horizontal,              opts('Open: Horizontal split'))
  vim.keymap.set('n', 't', function()
    local node = api.tree.get_node_under_cursor()
    vim.cmd('wincmd l')
    api.node.open.tab(node)
  end, opts('Open: New Tab'))
  -- System open
  vim.keymap.set('n', 'i',     vngr.actions.quickLook,                opts('Reveal In System'))
  vim.keymap.set('n', 'O',     api.node.run.system,                   opts('Run System'))
  vim.keymap.set('n', 'R',     vngr.actions.system_reveal,            opts('Reveal In System'))

  -- FILE MANAGEMENT
  vim.keymap.set('n', 'gy',    api.fs.copy.absolute_path,             opts('Copy Absolute Path'))
  vim.keymap.set('n', 'Y',     api.fs.copy.relative_path,             opts('Copy Relative Path'))
  vim.keymap.set('n', 'y',     api.fs.copy.filename,                  opts('Copy Name'))
  vim.keymap.set('n', 'm',     api.marks.toggle,                      opts('Toggle Bookmark'))
  vim.keymap.set('n', 'M',     api.marks.bulk.move,                   opts('Move Bookmarked'))
  vim.keymap.set('n', 'a',     api.fs.create,                         opts('Create'))
  vim.keymap.set('n', 'r',     api.fs.rename_basename,                opts('Rename: Basename'))
  vim.keymap.set('n', '<f2>',  api.fs.rename,                         opts('Rename'))
  vim.keymap.set('n', '<C-r>', api.fs.rename_sub,                     opts('Rename: Omit Filename'))
  vim.keymap.set('n', '<tab>', custom.mark_move_j,                    opts('Toggle Bookmark Down'))
  vim.keymap.set('n', '<S-tab>',custom.mark_move_k,                   opts('Toggle Bookmark Up'))
  vim.keymap.set('n', '<C-v>', api.fs.paste,                          opts('Paste'))
  -- vim.keymap.set('n', '<C-x>', api.fs.cut,                            opts('Cut'))
  -- vim.keymap.set('n', '<C-c>', api.fs.copy.node,                      opts('Copy'))
  -- vim.keymap.set('n', '<Delete>',api.fs.trash,                        opts('Trash'))
  -- vim.keymap.set('n', '<S-Delete>',api.fs.remove,                     opts('Delete'))
  vim.keymap.set('n', '<C-x>', custom.mark_cut,                       opts('Cut File(s)'))
  vim.keymap.set('n', '<C-c>', custom.mark_copy,                      opts('Copy File(s)'))
  vim.keymap.set('n', '<Delete>',custom.mark_trash,                   opts('Trash File(s)'))
  vim.keymap.set('n', '<S-Delete>',custom.mark_remove,                opts('Remove File(s)'))
  -- vim.keymap.set('n', 'mv', api.marks.bulk.move, opts('Move Bookmarked'))
end

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

return {
  'kyazdani42/nvim-tree.lua',
  enabled = false,
  lazy = true,
  event = 'CursorHold',
  commit = '0074120',
  init = function ()
    keymap('n', '-', '<cmd>lua require("hasan.utils.vinegar").vinegar()<CR>', { desc = 'Vinegar' })
    keymap('n', '<BS>', '<cmd>lua require("hasan.utils.vinegar").alternate_file()<CR>', { desc = 'Alternate file' })
    keymap('n', '<leader>ob', ':NvimTreeToggle<CR>', { desc = 'Toggle explorer' })
    keymap('n', '<leader>op', '<cmd>lua require("hasan.utils.vinegar").toggle_sidebar()<CR>', { desc = 'Open explorer' })
    keymap('n', '<leader>/e', '<cmd>lua require("nvim-tree.marks.navigation").select()<cr>', { desc = 'Search tree marks' })
    -- keymap('n', '[e', '<cmd>lua require("nvim-tree.marks.navigation").prev()<cr>', {desc = 'Previous tree mark'})
    -- keymap('n', ']e', '<cmd>lua require("nvim-tree.marks.navigation").next()<cr>', {desc = 'Next tree mark'})
  end,
  opts = {
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
          bookmark = '▶',
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
  },
  dependencies = { 'freddiehaddad/feline.nvim' },
}
