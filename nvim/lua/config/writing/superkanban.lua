local reload_on_call = false

local function update_should_reload()
  vim.schedule(function()
    reload_on_call = vim.uv.cwd():find('super%-kanban') and true or false
  end)
end
local function get_kanban(reload)
  return reload and R('super-kanban') or require('super-kanban')
end

augroup('MY_SUPER_KANBAN_AUGROUP')(function(autocmd)
  autocmd('User', update_should_reload, { pattern = 'VeryLazy', once = true })
  autocmd('User', update_should_reload, { pattern = 'PersistedPickerLoadPost' })
end)

local function pick_window(callback)
  require('flash').jump({
    highlight = {
      backdrop = true,
      groups = {
        current = 'FlashLabel',
        label = 'FlashLabel',
      },
    },
    label = { after = { 0, 0 } },
    search = {
      mode = 'search',
      max_length = 0,
      multi_window = true,
      exclude = {
        function(win)
          local kanban_ft = { superkanban_list = true, superkanban_card = true }
          return not kanban_ft[vim.bo[vim.api.nvim_win_get_buf(win)].filetype]
        end,
      },
    },
    action = callback,
    matcher = function(win)
      return { { pos = { 1, 0 }, end_pos = { 1, 0 } } }
    end,
  })
end

local opts = {
  icons = {
    list_edge_left = '║',
    list_edge_right = '║',
    bubble_edge_left = '',
    bubble_edge_right = '',

    -- list_edge_left = '',
    -- list_edge_right = '',
    -- bubble_edge_left = '',
    -- bubble_edge_right = '',
  },
  mappings = {
    ['s'] = {
      callback = function()
        pick_window()
      end,
      desc = 'Flash',
    },
    ['/'] = {
      callback = function(...)
        require('super-kanban.actions').search_card(...)
      end,
      nowait = true,
    },
    ['<leader>k'] = 'jump_up',
    ['<leader>j'] = 'jump_down',
    ['<leader>h'] = 'jump_left',
    ['<leader>l'] = 'jump_right',
    ['g<cr>'] = 'open_note',
    ['?'] = 'help',
    ['g?'] = false,
    ['<cr>'] = false,
  },
}

return {
  {
    'hasansujon786/super-kanban.nvim',
    cmd = { 'SuperKanban' },
    dependencies = {
      'nvim-orgmode/orgmode',
    },
    lazy = true,
    dev = require('core.state').dev.enabled,
    keys = {
      {
        '<space>m',
        function()
          vim.cmd([[wa]])
          local kanban = get_kanban(reload_on_call)
          if reload_on_call then
            kanban.setup(opts)
          end
          kanban.open('test.md')
        end,
      },
    },
    opts = opts,
  },
}
