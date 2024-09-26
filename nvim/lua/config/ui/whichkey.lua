local nx = { 'n', 'x' }
return {
  'folke/which-key.nvim',
  -- commit = 'af4ded85542d40e190014c732fa051bdbf88be3d',
  lazy = true,
  event = 'VeryLazy',
  config = function()
    local wk = require('which-key')
    wk.setup({
      icons = {
        breadcrumb = '»', -- symbol used in the command line area that shows your active key combo
        separator = '➜', -- symbol used between a key and it's label
        group = '+', -- symbol prepended to a group
        ellipsis = '…',
        --- See `lua/which-key/icons.lua` for more details
        --- Set to `false` to disable keymap icons
        ---@type wk.IconRule[]|false
        rules = false,
        -- use the highlights from mini.icons
        -- When `false`, it will use `WhichKeyIcon` instead
        colors = true,
        -- used by key format
        keys = {
          Up = '',
          Down = '',
          Left = '',
          Right = '',
          C = '󰘴 ',
          M = '󰘵 ',
          S = '󰘶 ',
          CR = '󰌑 ',
          Esc = '󱊷 ',
          ScrollWheelDown = '󱕐 ',
          ScrollWheelUp = '󱕑 ',
          NL = '󰌑 ',
          BS = '⌫',
          Space = '󱁐 ',
          Tab = ' ',
          -- ['.'] = '•',
        },
      },
      show_help = false,
      show_keys = false, -- show the currently pressed key and its label as a message in the command line
      win = {
        -- width = 1,
        -- height = { min = 4, max = 25 },
        -- col = 0,
        row = -1,
        border = { ' ', ' ', ' ', ' ', '▁', '▁', '▁', ' ' },
        padding = { 1, 8 }, -- extra window padding [top/bottom, right/left]
        title = false,
        footer_pos = 'center',
        footer = true,
        zindex = 1000,
        -- bo = {},
        -- wo = {},
      },
      layout = {
        width = { min = 20 }, -- min and max width of the columns
        spacing = 4, -- spacing between columns
        align = 'left', -- align columns left, center or right
      },
    })

    wk.add({
      {
        '<leader>.',
        '<cmd>lua require("hasan.telescope.custom").file_browser("cur_dir")<cr>',
        desc = 'Browse cur directory',
      },
      { '<leader>x', '<cmd>call hasan#utils#buffer#_open_scratch_buffer()<CR>', desc = 'Scratch buffer' },

      -- SEARCH
      { '<leader>/', group = 'search' },
      { '<leader>/.', '<cmd>Telescope resume<cr>', desc = 'Telescope resume' },
      { '<leader>//', '<cmd>Telescope live_grep<CR>', desc = 'Live grep' },
      { '<leader>/b', '<cmd>lua require("hasan.telescope.custom").buffers(true)<CR>', desc = 'Switch buffers' },
      { '<leader>/f', '<cmd>lua require("hasan.telescope.custom").my_find_files()<cr>', desc = 'Find file' },
      {
        '<leader>/g',
        '<cmd>lua require("hasan.telescope.custom").live_grep_in_folder()<cr>',
        desc = 'Live grep in folder',
      },
      { '<leader>/k', '<cmd>Telescope keymaps<CR>', desc = 'Look up keymaps' },
      -- { '<leader>/r', '<cmd>Telescope oldfiles<CR>', desc = 'Recent files' },
      { '<leader>/t', '<cmd>Telescope filetypes theme=get_dropdown<CR>', desc = 'Change filetypes' },

      -- LSP
      { '<leader>a', group = 'lsp' },

      -- BUFFER
      { '<leader>b', group = 'buffer' },
      { '<leader>bK', '<cmd>call hasan#utils#buffer#_clear_all()<CR>', desc = 'Kill all buffers' },
      { '<leader>bM', '<cmd>call hasan#fzf#edit_bookmark()<CR>', desc = 'Delete bookmark' },
      { '<leader>bS', '<cmd>wa<CR>', desc = 'Save all buffer' },
      { '<leader>bb', '<cmd>lua require("hasan.telescope.custom").buffers(false)<CR>', desc = 'Switch all buffers' },
      { '<leader>bf', '<cmd>bfirst<CR>', desc = 'First buffer' },
      { '<leader>bk', '<cmd>call hasan#utils#buffer#_clear()<CR>', desc = 'Kill this buffer' },
      { '<leader>bl', '<cmd>blast<CR>', desc = 'Last buffer' },
      { '<leader>bm', '<cmd>call hasan#fzf#set_bookmark()<CR>', desc = 'Set bookmark' },
      { '<leader>bn', '<cmd>bnext<CR>', desc = 'Next buffer' },
      { '<leader>bo', '<cmd>call hasan#utils#buffer#_clear_other()<CR>', desc = 'Kill other buffers' },
      { '<leader>bp', '<cmd>bprevious<CR>', desc = 'Previous buffer' },
      { '<leader>bs', '<cmd>w<CR>', desc = 'Save buffer' },
      { '<leader>b.', '<cmd>lua require("hasan.telescope.custom").buffers(true)<CR>', desc = 'Switch buffers' },
      { '<leader>m', '<cmd>lua require("hasan.telescope.custom").buffers(true)<CR>', desc = 'Switch buffers' },

      -- CHANGE
      { '<leader>c', group = 'change' },

      -- { '<leader>cm', group = 'hightlight-hints' },
      -- { '<leader>cmb', '<cmd>call hiiw#HiInterestingWord(3)<cr>', desc = 'Mark hint 3' },
      -- { '<leader>cmg', '<cmd>call hiiw#HiInterestingWord(2)<cr>', desc = 'Mark hint 2' },
      -- { '<leader>cmp', '<cmd>call hiiw#HiInterestingWord(5)<cr>', desc = 'Mark hint 5' },
      -- { '<leader>cmr', '<cmd>call hiiw#HiInterestingWord(6)<cr>', desc = 'Mark hint 6' },
      -- { '<leader>cmw', '<cmd>call hiiw#HiInterestingWord(4)<cr>', desc = 'Mark hint 4' },
      -- { '<leader>cmx', '<cmd>call hiiw#ClearInterestingWord()<cr>', desc = 'Clear hints' },
      -- { '<leader>cmy', '<cmd>call hiiw#HiInterestingWord(1)<cr>', desc = 'Mark hint 1' },

      -- DEBUG
      { '<leader>d', group = 'debug' },

      -- FILE
      { '<leader>f', group = 'file' },
      {
        '<leader>f.',
        '<cmd>lua require("hasan.telescope.custom").file_browser("cur_dir")<cr>',
        desc = 'Browse cur directory',
      },
      {
        '<leader>fF',
        '<cmd>lua require("hasan.telescope.custom").my_find_files("cur_dir")<cr>',
        desc = 'Find file from here',
      },
      { '<leader>fR', '<cmd>lua require("hasan.widgets.inputs").rename_current_file()<CR>', desc = 'Rename file' },
      { '<leader>fb', '<cmd>lua require("hasan.telescope.custom").file_browser()<cr>', desc = 'Browser project files' },
      { '<leader>ff', '<cmd>lua require("hasan.telescope.custom").my_find_files()<cr>', desc = 'Find file' },
      { '<leader>fp', '<cmd>lua require("hasan.telescope.custom").project_files()<cr>', desc = 'Find project file' },

      { '<leader>fu', group = 'update-permission' },
      { '<leader>fuW', '<cmd>Chmod -w<CR>', desc = 'Remove write permission' },
      { '<leader>fuX', '<cmd>Chmod -x<CR>', desc = 'Remove executable' },
      { '<leader>fuw', '<cmd>Chmod +w<CR>', desc = 'Add write permission' },
      { '<leader>fux', '<cmd>Chmod +x<CR>', desc = 'Make this file executable' },
      { '<leader>fw', '<Plug>(fix-current-world)', desc = 'Fix current world' },

      { '<leader>fx', group = 'remove' },
      {
        '<leader>fx/',
        '<cmd>lua require("hasan.utils.file").delete_lines_with("comment")<CR>',
        desc = 'Delete all comments',
      },
      { '<leader>fxx', '<cmd>call hasan#autocmd#trimWhitespace()<CR>', desc = 'Remove white space' },

      -- GIT
      { '<leader>g', group = 'git' },
      { '<leader>g.', '<cmd>silent !git add %<CR>', desc = 'Git: Stage file' },
      { '<leader>g/', '<cmd>Telescope git_status<CR>', desc = 'Find git files*' },
      { '<leader>gC', '<cmd>Telescope git_bcommits<CR>', desc = 'Look up buffer commits' },
      {
        '<leader>gO',
        '<cmd>lua require("hasan.utils.init").open_git_remote(false)<CR>',
        desc = 'Open git repo with file',
      },
      { '<leader>gb', '<cmd>Telescope git_branches<CR>', desc = 'Checkout git branch' },
      { '<leader>gc', '<cmd>Telescope git_commits<CR>', desc = 'Look up commits' },
      { '<leader>go', '<cmd>lua require("hasan.utils.init").open_git_remote(true)<CR>', desc = 'Open git repo' },

      -- INSERT
      { '<leader>i', group = 'insert' },
      { '<leader>iF', '<cmd>call _#Insertion(expand("%:t"))<CR>', desc = 'Current file name' },
      { '<leader>ic', '<cmd>lua require("hasan.telescope.custom").colors()<CR>', desc = 'Insert colors' },
      { '<leader>id', '<cmd>call _#Insertion(strftime("%e %B %Y"))<CR>', desc = 'Current date' },
      { '<leader>ie', '<cmd>lua require("hasan.telescope.custom").emojis()<CR>', desc = 'Insert emoji' },
      { '<leader>if', '<cmd>call _#Insertion(expand("%:~"))<CR>', desc = 'Current file path' },
      { '<leader>it', '<cmd>call _#Insertion(strftime("%H:%M"))<CR>', desc = 'Current time' },
      { '<leader>ilk', '<cmd>call _#Insertion("https://placekitten.com/g/50/50")<CR>', desc = 'Sample image link' },
      {
        '<leader>ilt',
        '<cmd>call _#Insertion(hasan#utils#placeholderImgTag("300x200"))<CR>',
        desc = 'Placeholder image tag',
      },

      { '<leader>n', group = 'org-roam' },

      -- OPEN
      { '<leader>o', group = 'open' },
      { '<leader>ol', '<cmd>call hasan#window#toggle_quickfix(0)<CR>', desc = 'Open Local list' },
      { '<leader>oq', '<cmd>call hasan#window#toggle_quickfix(1)<CR>', desc = 'Open Quickfix list' },

      -- PROJECT
      { '<leader>p', group = 'project' },
      {
        '<leader>pb',
        '<cmd>lua require("hasan.telescope.custom").project_browser()<CR>',
        desc = 'Browse other projects',
      },
      {
        '<leader>pc',
        '<cmd>lua require("telescope._extensions").manager.project_commands.commands()<CR>',
        desc = 'Run project commands',
      },
      {
        '<leader>pr',
        '<cmd>lua require("telescope.builtin").oldfiles({cwd_only = true})<CR>',
        desc = 'Find recent files',
      },
      {
        '<leader>pt',
        '<cmd>lua require("hasan.telescope.custom").search_project_todos()<CR>',
        desc = 'Search project todos',
      },

      -- TOGGLE
      { '<leader>t', group = 'toggle' },
      { '<leader>tB', desc = 'Toggle Onedark' },
      { '<leader>tL', '<cmd>lua require("hasan.utils.logger").toggle("cursorline")<CR>', desc = 'Toggle cursorline' },
      { '<leader>tW', '<cmd>call autohl#_AutoHighlightToggle()<CR>', desc = 'Highlight same words' },
      {
        '<leader>tb',
        '<cmd>lua require("hasan.utils.color").toggle_bg_tranparent(false)<CR>',
        desc = 'Toggle transparency',
      },
      {
        '<leader>tl',
        '<cmd>lua require("hasan.utils.logger").toggle("cursorcolumn")<CR>',
        desc = 'Toggle cursorcolumn',
      },
      {
        '<leader>to',
        '<cmd>lua require("hasan.utils.logger").toggle("conceallevel", { 0, 2 })<CR>',
        desc = 'Toggle conceallevel',
      },
      {
        '<leader>tc',
        '<cmd>lua require("hasan.utils.logger").toggle("concealcursor", { "nc", "" })<CR>',
        desc = 'Toggle concealcursor',
      },
      { '<leader>ts', '<cmd>lua require("hasan.utils.logger").toggle("spell")<CR>', desc = 'Toggle spell' },
      { '<leader>tw', '<cmd>lua require("hasan.utils.logger").toggle("wrap")<CR>', desc = 'Toggle wrap' },

      -- VIM
      { '<leader>v', group = 'vim' },
      { '<leader>v.', '<cmd>echo "Not a Vim file"<CR>', desc = 'Source this file' },
      { '<leader>v/', '<cmd>Telescope help_tags<CR>', desc = 'Search Vim help' },
      { '<leader>vH', '<cmd>silent write | edit | TSBufEnable highlight<CR>', desc = 'Reload hightlight' },
      { '<leader>vP', '<cmd>lua require("hasan.telescope.custom").search_plugins()<CR>', desc = 'Search plugin files' },
      { '<leader>vR', '<cmd>ReloadConfig<CR>', desc = 'Reload neovim' },
      { '<leader>vd', '<cmd>lua require("hasan.telescope.custom").search_nvim_data()<CR>', desc = 'Search nvim data' },
      { '<leader>vl', '<cmd>call logevents#LogEvents_Toggle()<CR>', desc = 'Toggle LogEvents' },
      { '<leader>vp', '<cmd>Lazy home<CR>', desc = 'Plugin status' },
      { '<leader>vs', '<cmd>lua require("hasan.utils.file").open_settings()<CR>', desc = 'Open settings' },
      { '<leader>ve', '<cmd>lua require("hasan.widgets.register_editor").open()<CR>', desc = 'Open register editor' },

      -- WINDOW
      { '<leader>w', group = 'window' },
      { '<leader>wH', '<cmd>lua handle_win_cmd("wincmd H")<CR>', desc = 'Move window left' },
      { '<leader>wJ', '<cmd>lua handle_win_cmd("wincmd J")<CR>', desc = 'Move window bottom' },
      { '<leader>wK', '<cmd>lua handle_win_cmd("wincmd K")<CR>', desc = 'Move window top' },
      { '<leader>wL', '<cmd>lua handle_win_cmd("wincmd L")<CR>', desc = 'Move window right' },
      { '<leader>wO', '<cmd>tabonly<CR>', desc = 'Keep only tab' },
      { '<leader>wR', '<cmd>lua handle_win_cmd("wincmd R")<CR>', desc = 'Window rotate-' },
      { '<leader>wW', '<cmd>lua handle_win_cmd("wincmd W")<CR>', desc = 'Window previous' },
      { '<leader>wc', '<cmd>lua handle_win_cmd("wincmd c")<CR>', desc = 'Close windows' },
      { '<leader>wh', '<cmd>lua handle_win_cmd("wincmd h")<CR>', desc = 'Window left' },
      { '<leader>wj', '<cmd>lua handle_win_cmd("wincmd j")<CR>', desc = 'Window down' },
      { '<leader>wk', '<cmd>lua handle_win_cmd("wincmd k")<CR>', desc = 'Window up' },
      { '<leader>wl', '<cmd>lua handle_win_cmd("wincmd l")<CR>', desc = 'Window right' },
      { '<leader>wo', '<cmd>lua handle_win_cmd("wincmd o")<CR>', desc = 'Keep only windwo' },
      { '<leader>wp', '<cmd>lua handle_win_cmd("wincmd p")<CR>', desc = 'Window previous' },
      { '<leader>wq', '<cmd>tabclose<CR>', desc = 'Close tab' },
      { '<leader>wr', '<cmd>lua handle_win_cmd("wincmd r")<CR>', desc = 'Window rotate+' },
      { '<leader>ws', '<cmd>lua handle_win_cmd("wincmd s")<CR>', desc = 'Window split' },
      { '<leader>wt', '<cmd>-tab split<CR>', desc = 'Edit to new tab' },
      { '<leader>wv', '<cmd>lua handle_win_cmd("wincmd v")<CR>', desc = 'Windwo vsplit' },
      { '<leader>ww', '<cmd>lua handle_win_cmd("wincmd w")<CR>', desc = 'Window next' },
    })
  end,
}
