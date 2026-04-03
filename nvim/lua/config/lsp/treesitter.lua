-- main branch config
-- https://github.com/den-is/nvim/blob/master/lua/plugins/treesitter.lua
-- https://www.reddit.com/r/neovim/comments/1ppa4ag/comment/nungaa0/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  event = { 'VeryLazy' },
  cmd = { 'TSUpdate', 'TSUpdateSync', 'TSInstall', 'TSInstallSync' },
  branch = 'main',
  init = function()
    vim.env.CC = 'gcc'
    vim.g.no_plugin_maps = true

    local state = require('core.state')
    local filetypes = vim.iter(vim.tbl_values(state.treesitter.parsers_by_ft)):flatten():totable()
    vim.api.nvim_create_autocmd('FileType', {
      pattern = filetypes,
      callback = function()
        pcall(vim.treesitter.start)

        vim.wo.foldmethod = 'expr'
        vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })

    -- keymap('n', '[a', '<Plug>(ts-swap-parameter-prev)<cmd>call repeat#set("\\<Plug>(ts-swap-parameter-prev)")<CR>', { desc = 'Swap parameter prev' })
    -- keymap('n', ']a', '<Plug>(ts-swap-parameter-next)<cmd>call repeat#set("\\<Plug>(ts-swap-parameter-next)")<CR>', { desc = 'Swap parameter next' })
  end,
  opts = {},
  -- config = function()
  --   require("nvim-treesitter").setup({
  --     install_dir = vim.fn.stdpath('data') .. '/site'
  --   })
  -- end,
  dependencies = {
    -- { 'hasansujon786/nvim-treesitter-textobjects', dev = false },
    { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
    { 'windwp/nvim-ts-autotag', opts = {} },
    {
      'catgoose/nvim-colorizer.lua',
      opts = {
        options = {
          parsers = {
            css = true, -- preset: enables names, hex, rgb, hsl, oklch
            tailwind = { enable = true, lsp = true },
            hex = {
              enable = true,
              rgb = true, --       #RGB (3-digit)
              rgba = false, --     #RGBA (4-digit)
              rrggbb = true, --    #RRGGBB (6-digit)
              rrggbbaa = true, --  #RRGGBBAA (8-digit)
              aarrggbb = true, --  0xAARRGGBB
            },
            names = false,
          },
          display = { mode = 'background' },
        },
        buftypes = { '!prompt', '!popup' },
        -- filetypes = {
        --   '*', -- Highlight all files, but customize some others.
        --   dart = { AARRGGBB = true, names = false },
        --   css = { css = true },
        -- },
      },
    },
    {
      'nvim-treesitter/nvim-treesitter-context',
      -- commit = -- 4976d8b 2bcf700 8fd989b
      keys = {
        {
          'g<CR>',
          function()
            require('treesitter-context').go_to_context(vim.v.count1)
          end,
          mode = 'n',
          desc = 'Move cursor to context',
        },
        {
          '<CR>',
          function()
            require('treesitter-context').go_to_context(vim.v.count1)
          end,
          mode = { 'x', 'o' },
          desc = 'Move cursor to context',
        },
      },
      opts = function(a, b, c)
        return {
          enable = require('core.state').treesitter.enabled_context, -- Enable this plugin (Can be enabled/disabled later via commands)
          max_lines = 5, -- How many lines the window should span. Values <= 0 mean no limit.
          min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
          line_numbers = true,
          multiline_threshold = 20, -- Maximum number of lines to show for a single context
          trim_scope = 'inner', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
          mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
          -- Separator between context and content. Should be a single character string, like '-'.
          -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
          separator = nil,
          zindex = 20, -- The Z-index of the context window
          on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
        }
      end,
    },
  },
}
