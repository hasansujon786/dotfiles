return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  lazy = true,
  module = 'harpoon',
  keys = {
    { '<leader>M', desc = 'Harpoon: Add file' },
    { '<leader><tab>', desc = 'Harpoon: Toggle menu' },
    { '[<tab>', desc = 'Harpoon: Prev item' },
    { ']<tab>', desc = 'Harpoon: Next item' },
  },
  init = function()
    local harpoon_ls, win_ls, win_rs = '<leader>%s', '<leader>w%s', '%s<C-w>w'
    local opts = { desc = 'which_key_ignore' }

    for i = 0, 9 do
      keymap('n', win_ls:format(i), win_rs:format(i), opts)

      keymap('n', harpoon_ls:format(i), function()
        require('harpoon'):list():select(i)
      end, opts)
    end
  end,
  config = function()
    local harpoon = require('harpoon')

    -- REQUIRED
    harpoon:setup({
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
        -- key = function()
        --   return vim.loop.cwd()
        -- end,
      },
    })
    local maps = {
      ['<leader>M'] = function()
        harpoon:list():append()
        local index = harpoon:list():append():length()
        notify('File added at index ' .. index, vim.log.levels.INFO, { title = 'harpoon' })
      end,
      ['<leader><tab>'] = function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      ['[<tab>'] = function()
        harpoon:list():prev()
      end,
      [']<tab>'] = function()
        harpoon:list():next()
      end,
    }

    for key, value in pairs(maps) do
      keymap('n', key, value)
    end
  end,
}
