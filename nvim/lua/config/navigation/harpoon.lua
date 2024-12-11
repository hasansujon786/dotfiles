local keys = {
  { '<leader>M', desc = 'Harpoon: Add file' },
  { '<leader><tab>', desc = 'Harpoon: Toggle menu' },
  { '[<tab>', desc = 'Harpoon: Prev item' },
  { ']<tab>', desc = 'Harpoon: Next item' },
}

return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  lazy = true,
  module = 'harpoon',
  keys = keys,
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
    local Extensions = require('harpoon.extensions')
    local Logger = require('harpoon.logger')

    -- REQUIRED
    harpoon:setup({
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

          local bufnr = vim.fn.bufnr(list_item.value)
          local set_position = false
          if bufnr == -1 then
            set_position = true
            bufnr = vim.fn.bufnr(list_item.value, true)
          end
          if not vim.api.nvim_buf_is_loaded(bufnr) then
            vim.fn.bufload(bufnr)
            vim.api.nvim_set_option_value('buflisted', true, {
              buf = bufnr,
            })
          end

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
            require('hasan.utils.win').restore_cussor_pos()
          end

          Extensions.extensions:emit(Extensions.event_names.NAVIGATE, { buffer = bufnr })
        end,
      },
    })
    local maps = {
      ['<leader>M'] = function()
        local list = harpoon:list():add()

        local displayed = list:display()
        local name = require('hasan.utils.file').get_buf_name_relative(0)
        local index = require('hasan.utils').index_of(displayed, name)

        vim.notify('File added at index ' .. index, vim.log.levels.INFO, { title = 'harpoon' })
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

    for _, item in ipairs(keys) do
      local key = item[1]
      keymap('n', key, maps[key], { desc = item.desc })
    end

    vim.g.harpoon_loaded = true
  end,
}
