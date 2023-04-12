-- checkhealth noice
require('noice').setup({
  -- views = {
  -- cmdline_popup = {
  --   position = {
  --     row = '35%',
  --     col = '50%',
  --   },
  --   border = {
  --     style = 'none',
  --     padding = { 2, 3 },
  --     filter_options = {},
  --   },
  --   win_options = {
  --     winhighlight = {
  --       Normal = 'NormalFloatFlat',
  --     },
  --   },
  -- },
  -- },
  messages = {
    enabled = true, -- enables the Noice messages UI
    view = 'notify', -- default view for messages
    view_error = 'notify', -- view for errors
    view_warn = 'notify', -- view for warnings
    view_history = 'messages', -- view for :messages
    view_search = 'virtualtext', -- view for search count messages. Set to `false` to disable
  },
  lsp = {
    progress = {
      enabled = false,
    },
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
      ['cmp.entry.get_documentation'] = true,
    },
    hover = { enabled = true },
    signature = {
      enabled = true,
      auto_open = {
        enabled = false,
        trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
        luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
        throttle = 50, -- Debounce lsp signature help request by 50ms
      },
      view = 'hover', -- when nil, use defaults from documentation
      opts = {
        position = { row = 2, col = 0 },
        border = { style = 'none', padding = { 1, 1 } },
        win_options = { winhighlight = { Normal = 'NormalFloatFlat' } },
      },
    },
    message = {
      -- Messages shown by lsp servers
      enabled = true,
      view = 'notify',
      opts = {},
    },
    -- defaults for hover and signature help
    documentation = {
      view = 'hover',
      ---@type NoiceViewOptions
      opts = {
        lang = 'markdown',
        replace = true,
        render = 'plain',
        format = { '{message}' },
        win_options = { concealcursor = 'n', conceallevel = 3 },
      },
    },
  },
  presets = {
    command_palette = true, -- position the cmdline and popupmenu together
    lsp_doc_border = true, -- add a border to hover docs and signature help
    -- bottom_search = true, -- use a classic bottom cmdline for search
    -- long_message_to_split = true, -- long messages will be sent to a split
    -- inc_rename = false, -- enables an input dialog for inc-rename.nvim
  },
})
-- -- redirect ":hi"
-- require("noice").redirect("hi")
-- -- redirect some function
-- require("noice").redirect(function()
--   print("test")
-- end)

keymap('c', '<S-CR>', function()
  require('noice').redirect(vim.fn.getcmdline())
  vim.defer_fn(function()
    feedkeys('<C-c>')
  end, 10)
end, { desc = 'Redirect Cmdline' })

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

-- (field) NoiceView._view_opts: NoiceNotifyOptions|NoiceViewBaseOptions|NuiPopupOptions|NuiSplitOptions|{ type: "popup"|"split" } {
--     align?: "center"|"left"|"line-center"|"line-left"|"line-right"...(+4),
--     anchor?: "NE"|"NW"|"SE"|"SW"|"auto",
--     backend: string,
--     border?: 'double'|'none'|'rounded'|'shadow'|'single'...(+2),
--     buf_options?: table<string, any>|vim.bo,
--     close?: { events: string[], keys: string[] },
--     enter?: boolean,
--     fallback: string,
--     focusable: boolean,
--     format?: string|(string|table)[],
--     lang?: string,
--     level?: string|number,
--     max_size?: number,
--     merge: boolean,
--     min_size?: number,
--     position: string|number|"bottom"|"left"|"right"...(+2),
--     relative: 'cursor'|'editor'|'win'|NuiRelative,
--     render?: string|fun(buf: buffer, notif: Notification, hl: NotifyBufHighlights, config: notify.Config),
--     replace: boolean,
--     size: string|number|{ row: string|number, col: string|number },
--     timeout?: number,
--     title: string,
--     type: "popup"|"split",
--     view: string,
--     win_options?: vim.wo,
--     zindex?: number,
-- }
