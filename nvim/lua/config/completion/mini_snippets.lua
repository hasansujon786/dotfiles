return {
  'echasnovski/mini.snippets',
  lazy = true,
  config = function()
    local gen_loader = require('mini.snippets').gen_loader

    keymap({ 'n' }, '<esc>', function()
      vim.cmd('noh')
      while MiniSnippets and MiniSnippets.session.get() do
        MiniSnippets.session.stop()
      end
      return '<esc>'
    end, { expr = true, desc = 'Escape and Clear hlsearch' })

    local lang_patterns = {
      tsx = {
        '**/react-ts.json',
        '**/react-es7.json',
        '**/react-native-ts.json',
        '**/typescript.json',
        -- '**/next-ts.json',
        -- '**/tsdoc.json',
      },
      dart = {
        '**/flutter.json',
      },
      -- jsx = {
      --   'javascript.json',
      --   'jsdoc.json',
      --   'next.json',
      --   'react-native.json',
      --   'react.json',
      -- },
    }

    require('mini.snippets').setup({
      snippets = {
        -- gen_loader.from_lang(),
        gen_loader.from_lang({ lang_patterns = lang_patterns }),
        gen_loader.from_file(config_path .. '/snippets/global.json'),
      },
    })
  end,
}
