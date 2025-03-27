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
      -- jsx = {
      --   'javascript.json',
      --   'jsdoc.json',
      --   'next.json',
      --   'react-native.json',
      --   'react.json',
      -- },
      tsx = {
        '**/javascript/tsx.json',
        '**/javascript/react-ts.json',
        '**/javascript/react-es7.json',
        '**/javascript/react-native-ts.json',
        '**/javascript/typescript.json',
        '**/javascript/javascript_typescript.json',
        -- '**/next-ts.json',
        -- '**/tsdoc.json',
      },
      typescript = {
        '**/javascript_typescript.json',
      },
      javascript = {
        '**/javascript_typescript.json',
      },
      -- typescript = {
      --   '**/javascript_typescript.json',
      -- },
      -- javascript = {
      --   '**/javascript_typescript.json',
      -- },
      dart = {
        '**/flutter.json',
      },
    }

    require('mini.snippets').setup({
      snippets = {
        -- gen_loader.from_lang(),
        gen_loader.from_lang({ lang_patterns = lang_patterns }),
        gen_loader.from_file(config_path .. '/snippets/global.json'),
      },
      mappings = {
        expand = '<C-c><C-j>',
        stop = '<C-c><C-e>',
        jump_next = '',
        jump_prev = '',
      },
    })
  end,
}
