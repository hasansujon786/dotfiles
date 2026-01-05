return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  lazy = true,
  module = 'harpoon',
  keys = {
    {
      '<leader>M',
      function()
        local list = require('harpoon'):list():add()

        local displayed = list:display()
        local name = require('hasan.utils.file').get_buf_name_relative(0)
        local index = require('hasan.utils').index_of(displayed, name)

        vim.notify('File added at index ' .. index, vim.log.levels.INFO, { title = 'harpoon' })
        fire_user_cmds('HarpoonAdded')
      end,
      desc = 'Harpoon: Add file',
    },
    {
      "'<tab>",
      function()
        local harpoon = require('harpoon')
        harpoon.ui:toggle_quick_menu(harpoon:list(), {
          title = ' Harpoon ',
          border = 'rounded',
          title_pos = 'center',
          height_in_lines = 12,
          ui_max_width = 90,
        })
      end,
      desc = 'Harpoon: Toggle menu',
    },
    {
      '[<tab>',
      function()
        require('harpoon'):list():prev()
      end,
      desc = 'Harpoon: Prev item',
    },
    {
      ']<tab>',
      function()
        require('harpoon'):list():next()
      end,
      desc = 'Harpoon: Next item',
    },
    -- { '<leader>/e', desc = 'Find harpoon files' },
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
    local Extensions = require('harpoon.extensions')
    local Logger = require('harpoon.logger')

    -- REQUIRED
    require('harpoon').setup({
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
        -- key = function()
        --   return vim.loop.cwd()
        -- end,
      },
      default = {
        select = function(list_item, list, options)
          Logger:log('config_default#select', list_item, list.name, options)
          options = options or {}
          if list_item == nil then
            return
          end

          local bufnr, set_position = require('hasan.utils.buffer').add_file_to_buflist(list_item.value)

          if options.vsplit then
            vim.cmd('vsplit')
          elseif options.split then
            vim.cmd('split')
          elseif options.tabedit then
            vim.cmd('tabedit')
          end

          vim.api.nvim_set_current_buf(bufnr)

          if set_position then
            -- vim.api.nvim_win_set_cursor(0, { list_item.context.row or 1, list_item.context.col or 0, })
            require('hasan.utils.win').restore_cussor_pos({ buf = bufnr })
          end

          Extensions.extensions:emit(Extensions.event_names.NAVIGATE, { buffer = bufnr })
        end,
      },
    })

    vim.g.harpoon_loaded = true
  end,
}
