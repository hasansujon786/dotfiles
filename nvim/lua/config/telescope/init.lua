return {
  'nvim-telescope/telescope.nvim',
  lazy = true,
  event = 'VeryLazy',
  config = function()
    local Icons = require('hasan.utils.ui.icons')
    local actions = require('telescope.actions')
    local fb_actions = require('telescope._extensions.file_browser.actions')
    local state = require('core.state')
    local local_action = require('hasan.telescope.local_action')
    local local_theme = require('hasan.telescope.theme')

    local custom_mappings = {
      ['<M-u>'] = actions.preview_scrolling_up,
      ['<M-d>'] = actions.preview_scrolling_down,
      ['<up>'] = actions.cycle_history_prev,
      ['<down>'] = actions.cycle_history_next,

      ['<M-p>'] = actions.move_selection_previous,
      ['<M-n>'] = actions.move_selection_next,
      ['<tab>'] = actions.move_selection_next,
      ['<s-tab>'] = actions.move_selection_previous,

      ['<M-i>'] = actions.toggle_selection + actions.move_selection_worse,
      ['<C-y>'] = actions.toggle_selection + actions.move_selection_better,

      ['<S-CR>'] = local_action.fedit,
      ['<M-o>'] = local_action.quicklook,
      ['<C-s>'] = actions.select_horizontal,
      ['<M-t>'] = local_action.focus_file_tree,
      ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,

      ['<C-a>'] = actions.select_all,
      ['<C-e>'] = actions.to_fuzzy_refine,
      ['<esc>'] = actions.close,
      ['jk'] = function()
        vim.cmd('stopinsert')
      end,
      ['<M-q>'] = function(...)
        require('telescope.actions.layout').toggle_preview(...)
      end,

      ['<C-x>'] = false,
      ['<C-u>'] = false,
      ['<C-d>'] = false,
    }

    local bordercharsOpt = { borderchars = state.border_groups.edged_top }
    local get_dropdown = require('telescope.themes').get_dropdown(bordercharsOpt)
    local get_cursor = require('telescope.themes').get_cursor(bordercharsOpt)

    require('telescope').setup({
      defaults = {
        vimgrep_arguments = {
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
          '-g',
          '!/vendor',
        },
        results_title = false,
        preview_title = false,
        scroll_strategy = 'cycle',
        selection_strategy = 'reset',
        multi_icon = '▸',
        prompt_prefix = '   ',
        selection_caret = '❯ ',
        path_display = { 'filename_first' },
        -- sorting_strategy = "ascending",
        layout_config = {
          height = 0.7,
          width = 0.8,
        },
        borderchars = state.border_groups[state.ui.telescope_border_style],
        winblend = 0,
        mappings = { n = custom_mappings, i = custom_mappings },
        file_ignore_patterns = {
          '%.gitignore',
          '%.git/.*',
          '4_archive/.*',
          '%.system/.*',
          'android/.*',
          'ios/.*',
          'vendor/.*',
          'gui/sublime_text/.*',
          'lua/_glance/.*',
          'nvim/tmp/archive',
          'pubspec.lock',
        },
      },
      pickers = {
        find_files = { theme = 'ivy', layout_config = { height = 0.6 } },
        -- lsp_references = dropdown_opts,
        lsp_document_symbols = get_dropdown,
        grep_string = get_dropdown,
        live_grep = get_dropdown,
      },
      extensions = {
        fzf = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = true,
          override_file_sorter = true,
        },
        ['ui-select'] = {
          get_dropdown,
          specific_opts = {
            -- ['codeaction'] = {},
            picker_opts = {
              codeaction = get_cursor,
              cursor = get_cursor,
            },
          },
        },
        persisted = get_dropdown,
        project_commands = require('config.telescope.project_commands'),
        file_browser = {
          theme = 'ivy',
          cwd_to_path = false,
          grouped = true,
          files = true, -- false: start with all dirs
          hidden = false,
          hide_parent_dir = true,
          prompt_path = true,
          quiet = false,
          dir_icon = Icons.documents.FolderOpen,
          dir_icon_hl = 'Default',
          display_stat = { date = true, size = true },
          git_status = true,
          mappings = {
            ['i'] = {
              ['<A-c>'] = fb_actions.create,
              ['<S-CR>'] = fb_actions.create_from_prompt,
              ['<A-r>'] = fb_actions.rename,
              ['<A-m>'] = fb_actions.move,
              ['<A-y>'] = fb_actions.copy,
              ['<A-d>'] = fb_actions.remove,

              ['<C-o>'] = fb_actions.open,
              ['<C-e>'] = fb_actions.goto_home_dir,
              -- ['<C-t>'] = fb_actions.change_cwd,
              ['<C-f>'] = fb_actions.toggle_browser,
              ['<C-s>'] = fb_actions.toggle_all,
              ['<C-h>'] = fb_actions.toggle_hidden,
              ['<C-g>'] = fb_actions.goto_parent_dir,
              ['<bs>'] = fb_actions.backspace,

              ['<tab>'] = actions.select_default,
              ['<C-w>'] = local_action.delete_world_or_goto_parent_dir,
              ['<C-u>'] = local_action.hack_goto_cwd,
            },
            ['n'] = {
              ['c'] = fb_actions.create,
              ['r'] = fb_actions.rename,
              ['m'] = fb_actions.move,
              ['y'] = fb_actions.copy,
              ['d'] = fb_actions.remove,
              ['o'] = fb_actions.open,
              ['g'] = fb_actions.goto_parent_dir,
              ['e'] = fb_actions.goto_home_dir,
              ['w'] = fb_actions.goto_cwd,
              ['t'] = fb_actions.change_cwd,
              ['f'] = fb_actions.toggle_browser,
              ['h'] = fb_actions.toggle_hidden,
              ['s'] = fb_actions.toggle_all,
            },
          },
        },
      },
    })
    require('telescope').load_extension('fzf')
    require('telescope').load_extension('ui-select')
    local_theme.setup()

    -- keymaps
    local pfiles_opt = { desc = 'Find project file' }
    keymap('n', '<leader><leader>', '<cmd>lua require("hasan.telescope.custom").project_files()<cr>', pfiles_opt)
    keymap('n', '<C-p>', '<cmd>lua require("telescope.builtin").oldfiles()<CR>')
    keymap('n', '<A-x>', '<cmd>lua require("hasan.telescope.custom").commands()<CR>')
    keymap('n', '//', '<cmd>lua require("hasan.telescope.custom").curbuf()<cr>', { desc = 'which_key_ignore' })
    keymap('v', '/', '<Esc><cmd>lua require("hasan.telescope.custom").curbuf(true)<cr>', { desc = 'which_key_ignore' })
    keymap('n', '<A-/>', '<cmd>lua require("hasan.telescope.custom").grep_string()<CR>', { desc = 'Grep string' })
    keymap(
      'v',
      '<A-/>',
      '<Esc><cmd>lua require("hasan.telescope.custom").grep_string(true)<CR>',
      { desc = 'Grep string' }
    )
    command('EmojiPicker', function()
      require('hasan.telescope.custom').emojis()
    end)
  end,
  dependencies = {
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    { 'nvim-telescope/telescope-file-browser.nvim' },
    { 'hasansujon786/telescope-ui-select.nvim' },
    {
      'ahmedkhalf/project.nvim',
      main = 'project_nvim',
      keys = {
        { '<leader>pm', '<cmd>lua require("hasan.telescope.custom").projects()<CR>', desc = 'Switch project' },
      },
      opts = {
        detection_methods = { 'pattern' },
        exclude_dirs = { 'c:/Users/hasan/dotfiles/nvim/.vsnip' },
        patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'pubspec.yaml' }, -- 'package.json'
        show_hidden = false,
      },
    },
  },
}
