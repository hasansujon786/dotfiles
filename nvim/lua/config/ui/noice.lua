return {
  'folke/noice.nvim',
  lazy = true,
  event = 'CursorHold',
  config = function()
    local hover = require('core.state').ui.hover
    local ok, noice = pcall(require, 'noice')
    if not ok then
      return
    end

    noice.setup({
      presets = {
        command_palette = true, -- position the cmdline and popupmenu together
        lsp_doc_border = true, -- add a border to hover docs and signature help
        bottom_search = false, -- use a classic bottom cmdline for search
        -- long_message_to_split = true, -- long messages will be sent to a split
        -- inc_rename = false, -- enables an input dialog for inc-rename.nvim
      },
      lsp = {
        progress = { enabled = false },
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
        -- defaults for hover and signature help
        documentation = {
          view = 'hover',
          opts = {
            lang = 'markdown',
            replace = true,
            render = 'plain',
            format = { '{message}' },
            win_options = { concealcursor = 'n', conceallevel = 3 },
          },
        },
        hover = {
          enabled = true,
          view = 'hover', -- when nil, use defaults from documentation
          opts = {
            anchor = 'SW',
            zindex = 1010,
            -- size = { width = 50 },
            position = { row = 1, col = 3 },
            border = { style = hover.border, padding = { 0, 1 } },
            win_options = { winhighlight = hover.winhighlight, showbreak = 'NONE' },
          },
        },
        signature = {
          enabled = true,
          view = 'hover', -- when nil, use defaults from documentation
          opts = {
            anchor = 'SW',
            zindex = 1010,
            -- size = { width = 50 },
            position = { row = 1, col = 3 },
            border = { style = hover.border, padding = { 0, 1 } },
            win_options = { winhighlight = hover.winhighlight, showbreak = 'NONE' },
          },
          auto_open = {
            enabled = false,
            trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
            luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
            throttle = 50, -- Debounce lsp signature help request by 50ms
          },
        },
        message = {
          -- Messages shown by lsp servers
          enabled = true,
          view = 'notify',
          opts = {},
        },
      },
      messages = {
        enabled = true, -- enables the Noice messages UI
        view = 'notify', -- default view for messages
        view_error = 'notify', -- view for errors
        view_warn = 'notify', -- view for warnings
        view_history = 'messages', -- view for :messages
        view_search = false, -- view for search count messages. Set to `false` to disable
      },
      views = {
        ---@type nui_popup_options
        mini = { win_options = { winblend = 0 } },
        ---@type nui_popup_options
        confirm = {
          position = { row = '48%', col = '50%' },
        },
      },
    })

    -- Redirect cmdline result to a popup
    keymap('n', '<leader><cr>', '<cmd>Noice last<CR>', { desc = 'Noice Last Message' })
    keymap('c', '<S-CR>', function()
      require('noice').redirect(vim.fn.getcmdline())
      vim.defer_fn(function()
        feedkeys('<C-c>')
      end, 10)
    end, { desc = 'Redirect Cmdline' })

    -- hover & signature widow scrooll
    keymap({ 'i', 's' }, '<A-d>', function()
      if not require('noice.lsp').scroll(4) then
        return '<A-d>'
      end
    end, { silent = true, expr = true })
    keymap({ 'i', 's' }, '<A-u>', function()
      if not require('noice.lsp').scroll(-4) then
        return '<A-u>'
      end
    end, { silent = true, expr = true })
  end,
}
