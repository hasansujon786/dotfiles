return {
  'hedyhli/outline.nvim',
  lazy = true,
  cmd = { 'Outline', 'OutlineOpen' },
  keys = {
    {
      '<leader>oo',
      function()
        if vim.bo.filetype ~= 'Outline' then
          require('hasan.nebulous').mark_as_alternate_win()
        end
        if require('outline').is_open() then
          require('outline').focus_toggle()
        else
          require('outline').open_outline()
        end
      end,
      desc = 'Toggle Outline',
    },
  },
  config = function()
    local icon = require('hasan.utils.ui.icons')
    local k = icon.kind
    local t = icon.type

    require('outline').setup({
      outline_window = {
        -- winhl = 'Normal:SidebarDark',
        position = 'right',
        width = 20,
        -- Auto close the outline window if goto_location is triggered
        auto_close = false,
        show_cursorline = true,
      },
      outline_items = {
        show_symbol_details = false,
        show_symbol_lineno = false,
        highlight_hovered_item = true, -- Show parents
      },
      symbol_folding = {
        -- autofold_depth = nil,
        -- auto_unfold = { hovered = true, only = true },
        markers = { '', '' },
      },
      preview_window = {
        border = 'rounded',
        -- winhl = 'NormalFloat:',
        -- winblend = 0,
      },
      keymaps = {
        close = { '<Esc>', 'q' },
        goto_location = { '<Cr>', 'o' },
        peek_location = { 'i', 'e' },
        hover_symbol = 'K',
        toggle_preview = 'p',
        rename_symbol = 'r',
        code_actions = { 'a', '<C-q>' }, -- <C-space>
        fold_reset = { 'R', 'zr' },
        down_and_jump = { '<C-j>', '<down>', '<tab>' },
        up_and_jump = { '<C-k>', '<up>', '<s-tab>' },
        fold = { 'h', 'x' },
        unfold = { 'l', 'zo' },
        fold_all = { 'W', 'zm' },
        unfold_all = 'E',
        fold_toggle = 'za',
        fold_toggle_all = 'zA',
      },
      symbols = {
        -- filter = { 'String', 'Constant', exclude = true }
        -- filter = { 'Package', 'Module', 'Function' },
        -- filter = nil,
        icons = {
          File = { icon = k.File, hl = '@text.uri' },
          Module = { icon = k.Module, hl = '@namespace' },
          Namespace = { icon = t.Array, hl = '@namespace' },
          Package = { icon = icon.ui.Package, hl = '@namespace' },
          Class = { icon = k.Class, hl = '@type' },
          -- Method = { icon = '', hl = '@method' },
          Method = { icon = k.Method, hl = '@method' },
          Property = { icon = k.Property, hl = '@method' },
          Field = { icon = k.Field, hl = '@field' },
          Constructor = { icon = k.Constructor, hl = '@constructor' },
          Enum = { icon = k.Enum, hl = '@type' },
          Interface = { icon = k.Interface, hl = '@type' },
          -- Function = { icon = 'ƒ', hl = '@method' },
          Function = { icon = k.Function, hl = '@method' },
          Variable = { icon = k.Variable, hl = '@constant' },
          Constant = { icon = k.Constant, hl = '@constant' },
          String = { icon = t.String, hl = '@string' },
          Number = { icon = t.Number, hl = '@number' },
          Boolean = { icon = t.Boolean, hl = '@boolean' },
          Array = { icon = t.Array, hl = '@constant' },
          Object = { icon = t.Object, hl = '@type' },
          Key = { icon = k.Keyword, hl = '@type' },
          Null = { icon = 'N', hl = '@type' },
          EnumMember = { icon = k.EnumMember, hl = '@field' },
          Struct = { icon = k.Struct, hl = '@type' },
          Event = { icon = k.Event, hl = '@type' },
          Operator = { icon = k.Operator, hl = '@operator' },
          Component = { icon = '󰅴', hl = '@function' },
          Fragment = { icon = '󰅴', hl = '@constant' },
          TypeParameter = { icon = k.TypeParameter, hl = '@parameter' },
          TypeAlias = { icon = ' ', hl = 'Type' },
          Parameter = { icon = ' ', hl = 'Identifier' },
          StaticMethod = { icon = ' ', hl = 'Function' },
          Macro = { icon = ' ', hl = 'Function' },
        },
      },
    })
  end,
}
