local nx = { 'n', 'x' }
return {
  'monaqa/dial.nvim',
  lazy = true,
  keys = {
    { '<Plug>(dial-increment)', mode = nx },
    { '<Plug>(dial-decrement)', mode = nx },
    { 'g<Plug>(dial-increment)', mode = nx },
    { 'g<Plug>(dial-decrement)', mode = nx },
  },
  init = function()
    keymap(nx, '<C-a>', '<Plug>(dial-increment)')
    keymap(nx, '<C-x>', '<Plug>(dial-decrement)')
    keymap(nx, 'g<C-a>', '<Plug>(dial-increment)')
    keymap(nx, 'g<C-x>', '<Plug>(dial-decrement)')
  end,
  config = function()
    local augend = require('dial.augend')
    local toggle = function(...)
      return require('dial.augend').constant.new(...)
    end

    local flutter = require('config.mics.dial.flutter').custom_augend()
    local tailwind = require('config.mics.dial.tailwind').custom_augend()
    local aug = require('config.mics.dial.augends').custom_augend()

    require('dial.config').augends:register_group({
      -- Default augends used when no group name is specified
      default = {
        augend.integer.alias.decimal, -- non-negative decimal number (0, 1, 2, 3, ...)
        augend.integer.alias.hex, -- non-negative hex number (0x01, 0x1a1f, etc.)
        augend.constant.alias.bool,
        augend.semver.alias.semver,
        augend.constant.alias.en_weekday_full,
        augend.hexcolor.new({ case = 'lower' }),
        augend.date.new({ pattern = '%Y/%m/%d', default_kind = 'day', only_valid = true, word = false }),
        toggle({ elements = { 'let', 'const' } }),
        toggle({ elements = { 'and', 'or' } }),
        toggle({ elements = { '&&', '||' }, word = false }),
        toggle({ elements = { '>', '<' }, word = false }),
        toggle({ elements = { '!==', '===' }, word = false }),
        toggle({ elements = { '!=', '==' }, word = false }),
        aug.typescript_types,
        aug.http,
        aug.todo_status,
        -- augend.paren.alias.brackets,

        tailwind.tailwind_bg_text_colors,

        flutter.font_weight,
        flutter.TextAlign.full,
        flutter.TextAlign.shorthand,
        flutter.MainAxisAlignment.full,
        flutter.MainAxisAlignment.shorthand,
        flutter.CrossAxisAlignment.full,
        flutter.CrossAxisAlignment.shorthand,
        flutter.MainAxisSize.full,
        flutter.MainAxisSize.shorthand,

        flutter.TextOverflow.full,
        flutter.TextOverflow.shorthand,
        flutter.BoxFit.full,
        flutter.BoxFit.shorthand,
        flutter.WrapAlignment.full,
        flutter.WrapAlignment.shorthand,
        flutter.WrapCrossAlignment.full,
        flutter.WrapCrossAlignment.shorthand,

        flutter.Clip.full,
        flutter.Clip.shorthand,
        flutter.BorderStyle.full,
        flutter.BorderStyle.shorthand,

        flutter.nullable_type,
      },
    })
    require('dial.config').augends:on_filetype({
      markdown = {
        augend.integer.alias.decimal,
        augend.misc.alias.markdown_header,
      },
    })
  end,
  -- dependencies = {
  --   {
  --     'hasansujon786/tailwindcss-dial.nvim',
  --     opts = {
  --       -- group = "default", -- optional, defaults to "default"
  --       ft = { 'typescript', 'typescriptreact', 'tsx', 'vue' }, -- optional
  --     },
  --   },
  -- },
}
