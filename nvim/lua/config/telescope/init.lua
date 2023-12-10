return {
  {
    'nvim-telescope/telescope.nvim',
    lazy = true,
    event = 'VeryLazy',
    config = function()
      local state = require('hasan.core.state')
      local actions = require('telescope.actions')
      local local_action = require('hasan.telescope.local_action')
      local fb_actions = require('telescope._extensions.file_browser.actions')

      local custom_mappings = {
        ['<M-u>'] = actions.preview_scrolling_up,
        ['<M-d>'] = actions.preview_scrolling_down,
        ['<C-p>'] = actions.move_selection_previous,
        ['<C-n>'] = actions.move_selection_next,
        ['<M-p>'] = actions.move_selection_previous,
        ['<M-n>'] = actions.move_selection_next,
        ['<M-k>'] = actions.move_selection_previous,
        ['<M-j>'] = actions.move_selection_next,

        ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
        ['<C-s>'] = actions.file_split,
        ['<esc>'] = actions.close,
        ['<M-q>'] = function(...)
          require('telescope.actions.layout').toggle_preview(...)
        end,

        ['<C-f>'] = local_action.fedit,
        ['<M-o>'] = local_action.quicklook,
        ['<M-t>'] = local_action.focus_file_tree,

        ['<C-x>'] = false,
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      }

      local dropdown_opts = { theme = 'dropdown', borderchars = require('hasan.core.state').border_groups.edged_top }
      require('telescope').setup({
        defaults = {
          results_title = false,
          preview_title = false,
          scroll_strategy = 'cycle',
          selection_strategy = 'reset',
          prompt_prefix = '   ',
          selection_caret = '❯ ',
          layout_config = {
            height = 0.7,
            width = 0.8,
          },
          borderchars = state.border_groups[state.ui.telescope_border_style],
          -- prompt_position = "top",
          -- sorting_strategy = "ascending",
          winblend = 0,
          mappings = { n = custom_mappings, i = custom_mappings },
          file_ignore_patterns = {
            '%.gitignore',
            '%.git/.*',
            '4_archive/.*',
            '%.system/.*',
            'android/.*',
            'ios/.*',
            'gui/sublime_text/.*',
            'pubspec.lock',
          },
        },
        pickers = {
          -- find_files = { theme = 'ivy', layout_config = { height = 0.7 } },
          lsp_document_symbols = dropdown_opts,
          lsp_references = dropdown_opts,
          grep_string = dropdown_opts,
          live_grep = dropdown_opts,
        },
        extensions = {
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true,
            override_file_sorter = true,
          },
          ['ui-select'] = {
            require('hasan.telescope.theme').get_dropdown(),
            kind = {
              codeaction = require('hasan.telescope.theme').get_cursor(),
              cursor = require('hasan.telescope.theme').get_cursor(),
            },
          },
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
            dir_icon = '',
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
      require('hasan.telescope.theme').setup()

      -- keymaps
      local project_files = '<cmd>lua require("hasan.telescope.custom").project_files()<cr>'
      keymap('n', '<leader><leader>', project_files, { desc = 'Find project file' })
      keymap('n', '<C-p>', '<cmd>lua require("telescope.builtin").oldfiles()<CR>')
      keymap('n', '<A-x>', '<cmd>lua require("hasan.telescope.custom").commands()<CR>')
      keymap('n', '//', '<cmd>lua require("hasan.telescope.custom").curbuf()<cr>', { desc = 'which_key_ignore' })
      keymap('v', '/', '<cmd>lua require("hasan.telescope.custom").curbuf()<cr>', { desc = 'which_key_ignore' })
      keymap({ 'n', 'v' }, '<A-/>', '<cmd>lua require("hasan.telescope.custom").grep_string()<CR>')
      command('EmojiPicker', require('hasan.telescope.custom').emojis)
    end,
    dependencies = {
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      { 'nvim-telescope/telescope-file-browser.nvim' },
      { 'hasansujon786/telescope-ui-select.nvim' },
      {
        'hasansujon786/telescope-yanklist.nvim',
        config = function()
          -- Yanklist
          keymap('n', 'p', '<Plug>(yanklist-auto-put)')
          keymap('v', 'p', '<Plug>(yanklist-auto-put)gvy')
          keymap('n', 'P', '<Plug>(yanklist-auto-Put)')
          keymap('n', '<leader>ii', '<Plug>(yanklist-last-item-put)', { desc = 'Paste from yanklist' })
          keymap('v', '<leader>ii', '<Plug>(yanklist-last-item-put)gvy', { desc = 'Paste from yanklist' })
          keymap('n', '<leader>iI', '<Plug>(yanklist-last-item-Put)', { desc = 'Paste from yanklist' })

          -- Cycle yanklist
          keymap('n', '[r', '<Plug>(yanklist-cycle-forward)', { desc = 'Yanklist forward' })
          keymap('n', ']r', '<Plug>(yanklist-cycle-backward)', { desc = 'Yanklist backward' })

          -- Yanklist telescope
          keymap( 'n', '<leader>oy', '<cmd>lua require("yanklist").yanklist({initial_mode="normal"})<CR>', { desc = 'Show Yank list' })
          keymap( 'v', '<leader>oy', '<cmd>lua require("yanklist").yanklist({is_visual=true,initial_mode="normal"})<CR>', { desc = 'Show Yank list' })
        end,
      },
      {
        'ahmedkhalf/project.nvim',
        main = 'project_nvim',
        opts = {
          detection_methods = { 'pattern' },
          exclude_dirs = { 'c:', 'c:/Users/hasan/dotfiles/nvim/.vsnip' },
          patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'pubspec.yaml' }, -- 'package.json'
          show_hidden = true,
        },
      },
    },
  },
  {
    'olimorris/persisted.nvim',
    lazy = true,
    module = 'persisted',
    cmd = { 'SessionLoad', 'SessionLoadLast', 'SessionSave' },
    config = function()
      require('config.telescope.persisted').setup()
    end,
  },
  {
    'hasansujon786/harpoon',
    lazy = true,
    module = 'harpoon',
    keys = {
      { '<leader>M', '<cmd>lua require("harpoon.mark").add_file()<CR>', desc = 'Harpoon: Add file' },
      { '<leader><tab>', '<cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>', desc = 'Harpoon: Toggle menu' },
      { '[<tab>', '<cmd>lua require("harpoon.ui").nav_prev()<CR>', desc = 'Harpoon: Prev item' },
      { ']<tab>', '<cmd>lua require("harpoon.ui").nav_next()<CR>', desc = 'Harpoon: Next item' },
    },
    init = function()
      local harpoon_ls, harpoon_rs = '<leader>%s', '<cmd>lua require("harpoon.ui").nav_file(%s)<CR>'
      local win_ls, win_rs = '<leader>w%s', '%s<C-w>w'
      for i = 0, 9 do
        keymap('n', harpoon_ls:format(i), harpoon_rs:format(i), { desc = 'which_key_ignore' })
        keymap('n', win_ls:format(i), win_rs:format(i), { desc = 'which_key_ignore' })
      end
    end,
    opts = {
      menu = { width = 80 },
    },
  },
}
