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
        breadcrumb = '»',
        separator = '➜',
        group = '+',
        ellipsis = '…',
        --- See `lua/which-key/icons.lua` for more details
        --- Set to `false` to disable keymap icons
        ---@type wk.IconRule[]|false
        rules = false,
        colors = true, -- When `false`, it will use `WhichKeyIcon` instead
      },
      plugins = {
        marks = false,
        harpoon = { enabled = true },
      },
      show_help = false,
      show_keys = false, -- Show the currently pressed key and its label as a message in the command line
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
      { 'ga', group = 'text-case' },
      { 'gm', group = 'visual-multi' },
      { 'gp', group = 'peek' },

      -- SEARCH
      { '<leader>/', group = 'search' },

      -- LSP
      { '<leader>a', group = 'lsp' },

      -- BUFFER
      { '<leader>b', group = 'buffer' },
      { '<leader>bk', '<cmd>:bd<cr>', desc = 'Delete Buffer and Window' },
      { '<leader>bK', '<cmd>call hasan#utils#buffer#_clear_all()<CR>', desc = 'Kill all buffers' },
      { '<leader>bw', '<cmd>wa<CR>', desc = 'Write all buffer' },
      { '<leader>X', '<cmd>call hasan#utils#buffer#_open_scratch_buffer()<CR>', desc = 'Open scratch buffer' },

      -- CHANGE
      { '<leader>c', group = 'change' },


      -- DEBUG
      { '<leader>d', group = 'debug' },

      -- FILE
      { '<leader>f', group = 'file' },
      { '<leader>fw', '<Plug>(fix-current-world)', desc = 'Fix current world' },
      { '<leader>fy', "<cmd>lua require('config.navigation.neo_tree.util').copy_path(vim.fn.expand('%:t'))<CR>", desc = 'Copy current node' },
      { '<leader>fY', "<cmd>lua require('config.navigation.neo_tree.util').copy_path(vim.fn.expand('%:p'))<CR>", desc = 'Copy absolute node' },

      { '<leader>fx', group = 'remove' },
      { '<leader>fx/', '<cmd>lua require("hasan.utils.file").delete_lines_with("comment")<CR>', desc = 'Delete all comments' },
      { '<leader>fxx', '<cmd>call hasan#autocmd#trimWhitespace()<CR>', desc = 'Remove white space' },

      -- GIT
      { '<leader>g', group = 'git' },
      { '<leader>g.', '<cmd>silent !git add %<CR>', desc = 'Git: Stage file' },
      { '<leader>gw', '<cmd>lua require("hasan.utils.git").auto_commit("~/my_vault")<CR>', desc = 'Git: Auto push ~/my_vault' },

      -- INSERT
      { '<leader>i', group = 'insert' },
      { '<leader>if', '<cmd>lua insert(vim.fn.expand("%:t:r"))<CR>', desc = 'Current file name' },
      { '<leader>iF', '<cmd>lua insert(vim.fn.expand("%:t"))<CR>', desc = 'Current file name' },

      { '<leader>id', '<cmd>lua insert(vim.fn.strftime("%e %B, %Y"))<CR>', desc = 'Current date' },
      { '<leader>it', '<cmd>lua insert(vim.fn.strftime("%H:%M"))<CR>', desc = 'Current time' },

      { '<leader>il', group = 'link' },
      { '<leader>ill', '<cmd>lua insert("https://picsum.photos/seed/picsum/300/200")<CR>', desc = 'Image link' },
      { '<leader>ild', '<cmd>lua insert("http://dummyimage.com/300x200/000000/555555")<CR>', desc = 'dummy image' },

      { '<leader>n', group = 'org-roam' },

      -- OPEN
      { '<leader>o', group = 'open' },
      { '<leader>ol', '<cmd>lwindow<CR>', desc = 'Open Local list' },
      { '<leader>oq', '<cmd>botright cwindow<CR>', desc = 'Open Quickfix list' },

      -- PROJECT
      { '<leader>p', group = 'project' },
      { '<leader>pt', '<cmd>lua require("hasan.utils.ui.qf").search_todos_to_quickfix()<CR>', desc = 'Search project todos (quickfix)' },

      -- TOGGLE
      { '<leader>t', group = 'toggle' },

      -- VIM
      { '<leader>v', group = 'vim' },
      { '<leader>v.', '<cmd>echo "Not a Vim file"<CR>', desc = 'Source this file' },
      { '<leader>vp', '<cmd>Lazy home<CR>', desc = 'Plugin status' },
      { '<leader>vs', '<cmd>lua require("hasan.utils.file").open_settings()<CR>', desc = 'Open settings' },
      { '<leader>ve', '<cmd>lua require("hasan.widgets.register_editor").open_editor()<CR>', desc = 'Open register editor' },
      { '<leader>vR', '<cmd>silent write | edit | TSBufEnable highlight<CR>', desc = 'Reload hightlight' },
      { '<leader>vL', '<cmd>call logevents#LogEvents_Toggle()<CR>', desc = 'Toggle LogEvents' },
      { '<leader>vl', '<cmd>lua require("hasan.utils.logger").view()<CR>', desc = 'Open log file' },
      { '<leader>vh', '<cmd>lua require("hasan.utils.file").quicklook_toggle()<CR>', desc = 'Toggle quickLook' },

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
      { '<leader>wJ', '<cmd>wincmd J<CR>', desc = 'Move window far bottom' },
      { '<leader>wK', '<cmd>wincmd K<CR>', desc = 'Move window far top' },
      { '<leader>wL', '<cmd>wincmd L<CR>', desc = 'Move window far right' },
      { '<leader>wr', '<cmd>wincmd r<CR>', desc = 'Rotate window cw' },
      { '<leader>wR', '<cmd>wincmd R<CR>', desc = 'Rotate window ccw' },
    })
  end,
}
