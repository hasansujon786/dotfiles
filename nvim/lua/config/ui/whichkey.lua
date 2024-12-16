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

    -- stylua: ignore
    wk.add({
      { 'gm', group = 'visual-multi' },
      { 'gp', group = 'peek' },
      { '<leader>.', '<cmd>lua require("hasan.telescope.custom").file_browser("cur_dir")<cr>', desc = 'Browse cur directory' },

      -- SEARCH
      { '<leader>/', group = 'search' },
      { '<leader>/.', '<cmd>Telescope resume<cr>', desc = 'Telescope resume' },
      { '<leader>//', '<cmd>Telescope live_grep<CR>', desc = 'Live grep' },
      { '<leader>/f', '<cmd>lua require("hasan.telescope.custom").my_find_files()<cr>', desc = 'Find file' },
      { '<leader>/g', '<cmd>lua require("hasan.telescope.custom").live_grep_in_folder()<cr>', desc = 'Live grep in folder' },
      { '<leader>/k', '<cmd>Telescope keymaps<CR>', desc = 'Look up keymaps' },
      { '<leader>/t', '<cmd>Telescope filetypes<CR>', desc = 'Change filetypes' },

      -- LSP
      { '<leader>a', group = 'lsp' },

      -- BUFFER
      { '<leader>b', group = 'buffer' },
      { "g'", '<cmd>lua require("hasan.telescope.custom").buffers(true)<CR>', desc = 'Switch buffers' },
      { '<leader>bb', '<cmd>lua require("hasan.telescope.custom").buffers(false)<CR>', desc = 'Switch all buffers' },
      { '<leader>bs', '<cmd>lua require("hasan.telescope.custom").buffers(true)<CR>', desc = 'Switch buffers' },
      { '<leader>bo', '<cmd>call hasan#utils#buffer#_clear_other()<CR>', desc = 'Kill other buffers' },
      { '<leader>bK', '<cmd>call hasan#utils#buffer#_clear_all()<CR>', desc = 'Kill all buffers' },
      { '<leader>bw', '<cmd>wa<CR>', desc = 'Write all buffer' },

      -- CHANGE
      { '<leader>c', group = 'change' },


      -- DEBUG
      { '<leader>d', group = 'debug' },

      -- FILE
      { '<leader>f', group = 'file' },
      { '<leader>f.', '<cmd>lua require("hasan.telescope.custom").file_browser("cur_dir")<cr>', desc = 'Browse cur directory' },
      { '<leader>fR', '<cmd>lua require("hasan.widgets.inputs").rename_current_file()<CR>', desc = 'Rename file' },
      { '<leader>fb', '<cmd>lua require("hasan.telescope.custom").file_browser()<cr>', desc = 'Browser project files' },
      { '<leader>ff', '<cmd>lua require("hasan.telescope.custom").my_find_files()<cr>', desc = 'Find file' },

      { '<leader>fw', '<Plug>(fix-current-world)', desc = 'Fix current world' },
      { '<leader>fy', "<cmd>lua require('config.navigation.neo_tree.util').copy_path(vim.fn.expand('%:t'))<CR>", desc = 'Copy current node' },
      { '<leader>fY', "<cmd>lua require('config.navigation.neo_tree.util').copy_path(vim.fn.expand('%:p'))<CR>", desc = 'Copy absolute node' },

      { '<leader>fx', group = 'remove' },
      { '<leader>fx/', '<cmd>lua require("hasan.utils.file").delete_lines_with("comment")<CR>', desc = 'Delete all comments' },
      { '<leader>fxx', '<cmd>call hasan#autocmd#trimWhitespace()<CR>', desc = 'Remove white space' },

      -- GIT
      { '<leader>g', group = 'git' },
      { '<leader>g.', '<cmd>silent !git add %<CR>', desc = 'Git: Stage file' },
      { '<leader>g/', '<cmd>Telescope git_status<CR>', desc = 'Find git files*' },
      { '<leader>gb', '<cmd>Telescope git_branches<CR>', desc = 'Checkout git branch' },
      { '<leader>gc', '<cmd>Telescope git_commits<CR>', desc = 'Look up commits' },
      { '<leader>gC', '<cmd>Telescope git_bcommits<CR>', desc = 'Look up buffer commits' },
      -- INSERT
      { '<leader>i', group = 'insert' },
      { '<leader>if', '<cmd>lua insert(vim.fn.expand("%:t:r"))<CR>', desc = 'Current file name' },
      { '<leader>iF', '<cmd>lua insert(vim.fn.expand("%:t"))<CR>', desc = 'Current file name' },

      { '<leader>id', '<cmd>lua insert(vim.fn.strftime("%e %B, %Y"))<CR>', desc = 'Current date' },
      { '<leader>it', '<cmd>lua insert(vim.fn.strftime("%H:%M"))<CR>', desc = 'Current time' },

      { '<leader>ic', '<cmd>lua require("hasan.telescope.custom").colors()<CR>', desc = 'Insert colors' },

      { '<leader>il', group = 'link' },
      { '<leader>ill', '<cmd>lua insert("https://picsum.photos/seed/picsum/300/200")<CR>', desc = 'Image link' },
      { '<leader>ild', '<cmd>lua insert("http://dummyimage.com/300x200/000000/555555")<CR>', desc = 'dummy image' },

      { '<leader>n', group = 'org-roam' },

      -- OPEN
      { '<leader>o', group = 'open' },
      { '<leader>ol', '<cmd>call hasan#window#toggle_quickfix(0)<CR>', desc = 'Open Local list' },
      { '<leader>oq', '<cmd>call hasan#window#toggle_quickfix(1)<CR>', desc = 'Open Quickfix list' },

      -- PROJECT
      { '<leader>p', group = 'project' },
      { '<leader>pb', '<cmd>lua require("hasan.telescope.custom").project_browser()<CR>', desc = 'Browse other projects' },
      { '<leader>pc', '<cmd>lua require("telescope._extensions").manager.project_commands.commands()<CR>', desc = 'Run project commands' },
      { '<leader>pr', '<cmd>lua require("telescope.builtin").oldfiles({cwd_only = true})<CR>', desc = 'Find recent files' },
      { '<leader>pt', '<cmd>lua require("hasan.telescope.custom").search_project_todos()<CR>', desc = 'Search project todos' },

      -- TOGGLE
      { '<leader>t', group = 'toggle' },
      { '<leader>tW', '<cmd>call autohl#_AutoHighlightToggle()<CR>', desc = 'Highlight same words' },
      { '<leader>tb', '<cmd>lua require("hasan.utils.color").toggle_bg_tranparent(false)<CR>', desc = 'Toggle transparency' },
      -- { '<leader>tL', '<cmd>lua require("hasan.utils.logger").toggle("cursorline")<CR>', desc = 'Toggle cursorline' },
      -- { '<leader>tl', '<cmd>lua require("hasan.utils.logger").toggle("cursorcolumn")<CR>', desc = 'Toggle cursorcolumn' },
      -- { '<leader>to', '<cmd>lua require("hasan.utils.logger").toggle("conceallevel", { 0, 2 })<CR>', desc = 'Toggle conceallevel' },
      -- { '<leader>tc', '<cmd>lua require("hasan.utils.logger").toggle("concealcursor", { "nc", "" })<CR>', desc = 'Toggle concealcursor' },
      -- { '<leader>ts', '<cmd>lua require("hasan.utils.logger").toggle("spell")<CR>', desc = 'Toggle spell' },
      -- { '<leader>tw', '<cmd>lua require("hasan.utils.logger").toggle("wrap")<CR>', desc = 'Toggle wrap' },

      -- VIM
      { '<leader>v', group = 'vim' },
      { '<leader>v.', '<cmd>echo "Not a Vim file"<CR>', desc = 'Source this file' },
      { '<leader>v/', '<cmd>Telescope help_tags<CR>', desc = 'Search Vim help' },
      { '<leader>vd', '<cmd>lua require("hasan.telescope.custom").search_nvim_data()<CR>', desc = 'Search nvim data' },
      { '<leader>vp', '<cmd>Lazy home<CR>', desc = 'Plugin status' },
      { '<leader>vs', '<cmd>lua require("hasan.utils.file").open_settings()<CR>', desc = 'Open settings' },
      { '<leader>ve', '<cmd>lua require("hasan.widgets.register_editor").open()<CR>', desc = 'Open register editor' },
      { '<leader>vH', '<cmd>silent write | edit | TSBufEnable highlight<CR>', desc = 'Reload hightlight' },
      { '<leader>vL', '<cmd>call logevents#LogEvents_Toggle()<CR>', desc = 'Toggle LogEvents' },

      -- WINDOW
      { '<leader>w', group = 'window' },
      { '<leader>wh', '<cmd>wincmd h<CR>', desc = 'Window left' },
      { '<leader>wj', '<cmd>wincmd j<CR>', desc = 'Window down' },
      { '<leader>wk', '<cmd>wincmd k<CR>', desc = 'Window up' },
      { '<leader>wl', '<cmd>wincmd l<CR>', desc = 'Window right' },
      { '<leader>ww', '<cmd>wincmd w<CR>', desc = 'Window next' },
      { '<leader>wW', '<cmd>wincmd W<CR>', desc = 'Window previous' },
      { '<leader>wp', '<cmd>wincmd p<CR>', desc = 'Window previous' },

      { '<leader>wt', '<cmd>-tab split<CR>', desc = 'Edit to new tab' },
      { '<leader>ws', '<cmd>wincmd s<CR>', desc = 'Window split' },
      { '<leader>wv', '<cmd>wincmd v<CR>', desc = 'Windwo vsplit' },

      { '<leader>wc', '<cmd>wincmd c<CR>', desc = 'Close windows' },
      { '<leader>wq', '<cmd>tabclose<CR>', desc = 'Close tab' },
      { '<leader>wo', '<cmd>wincmd o<CR>', desc = 'Keep only windwo' },
      { '<leader>wO', '<cmd>tabonly<CR><C-l>',  desc = 'Keep only tab' },

      { '<leader>wH', '<cmd>wincmd H<CR>', desc = 'Move window far left' },
      { '<leader>wJ', '<cmd>wincmd J<CR>', desc = 'Move window far fottom' },
      { '<leader>wK', '<cmd>wincmd K<CR>', desc = 'Move window far top' },
      { '<leader>wL', '<cmd>wincmd L<CR>', desc = 'Move window far right' },
      { '<leader>wr', '<cmd>wincmd r<CR>', desc = 'Rotate window cw' },
      { '<leader>wR', '<cmd>wincmd R<CR>', desc = 'Rotate window ccw' },
    })
  end,
}
