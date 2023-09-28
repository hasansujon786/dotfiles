return {
  'simrat39/symbols-outline.nvim',
  lazy = true,
  cmd = { 'SymbolsOutline', 'SymbolsOutlineOpen' },
  keys = {
    {
      '<leader>oo',
      function()
        require('hasan.nebulous').mark_as_alternate_win()
        vim.cmd([[SymbolsOutline]])
      end,
      desc = 'Toggle SymbolsOutline',
    },
  },
  config = function()
    local icon = require('hasan.utils.ui.icons')
    local k = icon.kind
    local t = icon.type

    require('symbols-outline').setup({
      show_numbers = false,
      show_relative_numbers = false,
      highlight_hovered_item = true,
      show_guides = true,
      auto_preview = false,
      position = 'right',
      relative_width = true,
      width = 20,
      auto_close = false,
      show_symbol_details = true,
      preview_bg_highlight = 'Normal',
      autofold_depth = nil,
      auto_unfold_hover = true,
      fold_markers = { '', '' },
      wrap = false,
      keymaps = { -- These keymaps can be a string or a table for multiple keys
        close = { '<Esc>', 'q' },
        goto_location = { '<Cr>', 'o' },
        focus_location = 'i',
        hover_symbol = 'K',
        toggle_preview = '<C-q>', -- <C-space>
        rename_symbol = 'r',
        code_actions = 'a',
        fold = { 'h', 'x' },
        unfold = 'l',
        fold_all = 'W',
        unfold_all = 'E',
        fold_reset = 'R',
      },
      lsp_blacklist = {},
      symbol_blacklist = {},
      symbols = {
        File = { icon = k.File, hl = '@text.uri' },
        Module = { icon = k.Module, hl = '@namespace' },
        Namespace = { icon = '', hl = '@namespace' },
        Package = { icon = icon.ui.Package, hl = '@namespace' },
        Class = { icon = k.Class, hl = '@type' },
        Method = { icon = '', hl = '@method' },
        Property = { icon = k.Property, hl = '@method' },
        Field = { icon = k.Field, hl = '@field' },
        Constructor = { icon = k.Constructor, hl = '@constructor' },
        Enum = { icon = k.Enum, hl = '@type' },
        Interface = { icon = k.Interface, hl = '@type' },
        Function = { icon = 'ƒ', hl = '@method' },
        Variable = { icon = k.Variable, hl = '@constant' },
        Constant = { icon = k.Constant, hl = '@constant' },
        String = { icon = t.String, hl = '@string' },
        Number = { icon = t.Number, hl = '@number' },
        Boolean = { icon = t.Boolean, hl = '@boolean' },
        Array = { icon = '', hl = '@constant' },
        Object = { icon = t.Object, hl = '@type' },
        Key = { icon = k.Keyword, hl = '@type' },
        Null = { icon = 'N', hl = '@type' },
        EnumMember = { icon = k.EnumMember, hl = '@field' },
        Struct = { icon = k.Struct, hl = '@type' },
        Event = { icon = k.Event, hl = '@type' },
        Operator = { icon = k.Operator, hl = '@operator' },
        Component = { icon = '', hl = '@function' },
        Fragment = { icon = '', hl = '@constant' },
        TypeParameter = { icon = k.TypeParameter, hl = '@parameter' },
      },
    })
  end,
}
