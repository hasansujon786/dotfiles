return {
  'dnlhc/glance.nvim',
  opt = true,
  cmd = 'Glance',
  config = function()
    local glance = require('glance')
    local actions = glance.actions

    local encodding = 'utf-16'
    local last_data = {}
    local function save_last_data(results, method)
      local d = { results = results, method = method, encodding = encodding }
      table.insert(last_data, d)
    end
    keymap('n', '<leader>a.', function()
      if #last_data == 0 then
        return vim.notify('No last data', vim.log.levels.INFO, { title = 'Glance' })
      end
      glance.resume(last_data[#last_data])
    end, { desc = 'Lsp: Glance resume' })

    glance.setup({
      height = 18, -- Height of the window
      zindex = 20,
      border = {
        enable = true, -- Show window borders. Only horizontal borders allowed
        top_char = '▁',
        bottom_char = '▔',
      },
      list = {
        position = 'right', -- Position of the list window 'left'|'right'
        width = 0.33, -- 33% width relative to the active window, min 0.1, max 0.5
      },
      theme = { -- This feature might not work properly in nvim-0.7.2
        enable = false, -- Will generate colors for the plugin based on your current colorscheme
        mode = 'darken', -- 'brighten'|'darken'|'auto', 'auto' will set mode based on the brightness of your colorscheme
      },
      mappings = {
        list = {
          ['<A-n>'] = actions.next_location, -- Bring the cursor to the next location skipping groups in the list
          ['<A-p>'] = actions.previous_location, -- Bring the cursor to the previous location skipping groups in the list
          ['<BS>'] = actions.enter_win('preview'), -- Focus preview window
          ['<leader>l'] = actions.enter_win('preview'), -- Focus preview window
          ['<leader>h'] = actions.enter_win('preview'), -- Focus preview window
          ['<leader>q'] = actions.close,
          -- ['<Esc>'] = false -- disable a mapping
        },
        preview = {
          ['<A-n>'] = actions.next_location, -- Bring the cursor to the next location skipping groups in the list
          ['<A-p>'] = actions.previous_location, -- Bring the cursor to the previous location skipping groups in the list
          ['<BS>'] = actions.enter_win('list'), -- Focus list window
          ['<leader>l'] = actions.enter_win('list'), -- Focus list window
          ['<leader>h'] = actions.enter_win('list'), -- Focus list window
          ['<leader>q'] = actions.close,
        },
      },
      hooks = {
        before_open = function(results, open, jump, method)
          if #results == 1 then
            jump(results[1]) -- argument is optional
          else
            open(results) -- argument is optional
            vim.defer_fn(function()
              save_last_data(results, method)
            end, 100)
          end
        end,
      },
      folds = {
        fold_closed = '',
        fold_open = '',
        folded = true, -- Automatically fold list on startup
      },
      indent_lines = {
        enable = true,
        icon = '│',
      },
      winbar = {
        enable = true, -- Available strating from nvim-0.8+
      },
      preview_win_opts = { -- Configure preview window options
        cursorline = true,
        number = true,
        wrap = false,
      },
    })
  end,
}

-- Glance.resume = function(opts)
--   local parent_bufnr = vim.api.nvim_get_current_buf()
--   local parent_winnr = vim.api.nvim_get_current_win()
--   local params = vim.lsp.util.make_position_params()

--   create(
--     opts.results,
--     parent_bufnr,
--     parent_winnr,
--     params,
--     opts.method,
--     opts.offset_encoding
--   )
-- end
