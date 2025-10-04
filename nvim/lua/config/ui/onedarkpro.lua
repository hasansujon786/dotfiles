return {
  'olimorris/onedarkpro.nvim',
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    require('onedarkpro').setup({
      -- stylua: ignore
      colors = {
        onedark_vivid = {
          bg        = '#242b38', -- '#282c34'
          fg        = '#abb2bf', --
          red       = '#ef5f6b',
          green     = '#97ca72',
          orange    = '#d99a5e',
          cyan      = '#4dbdcb',
          blue      = '#5ab0f6',
          purple    = '#ca72e4',
          yellow    = '#ebc275',
          gray      = '#546178', --
          highlight = '#f0d197',
          comment   = '#546178',  -- #7f848e
          black     = '#282c34',
          white     = "#abb2bf",
          none      = 'NONE',
        },
        -- custom colors
        light_grey = '#7d899f',
        bg1        = '#2d3343',
      },
      -- stylua: ignore
      highlights = {
        -- "/// Neovim Builin ///"
        -- ['FloatBorder'] = { fg = '${cyan}' },
        ['Cursor'] = { bg = '${blue}', fg = '${bg}' },
        ['CursorLineNr'] = { fg = '${fg}' },
        ['DiagnosticSignInfo'] = { fg = '${cyan}' },
        -- ['StatusLine'] = { fg = '${fg}', bg = '${bg1}' },
        ['IncSearch'] = { fg = '${bg}', bg = '${red}' },
        ['Search'] = { fg = '${bg}', bg = '${highlight}' },
        ['RedText'] = { fg = '#ff0000' },
        ['MutedText'] = { fg = '${light_grey}' },
        ['DapCursorLine'] = { bg = '#173F1E', underline = false },

        -- global treesitter
        ['@field.lua'] = { link = '@property' },
        ['@constant'] = { fg = '${yellow}' },
        ['@constant.builtin'] = { fg = '${orange}' },
        ['@parameter.lua'] = { link = '@parameter' },
        ['@keyword.operator.lua'] = { link = '@keyword' },
        ['@variable.member'] = { link = '@variable' },

        ['@tag.attribute'] = { fg = '${orange}', italic = true },
        ['@punctuation.special'] = { fg = '${purple}' },
        ['@odp'] = { fg = '${purple}' }, -- fat_arrow

        ['@punctuation.bracket'] = { fg = '${light_grey}' },
        ['@tag.delimiter'] = { link = '@punctuation.bracket' },
        ['@punctuation.bracket.tsx'] = { link = '@punctuation.bracket' },
        ['@punctuation.bracket.typescript'] = { link = '@punctuation.bracket' },
        ['@odp.statement.punctuation.bracket.javascript'] = { link = '@punctuation.bracket' },
        ['@punctuation.bracket.lua'] = { link = '@punctuation.bracket' },
        -- global treesitter

        -- ts,js
        ['@tag.attribute.tsx'] = { link = '@tag.attribute' },
        ['@tag.tsx'] = { link = '@type' },
        ['@tag.javascript'] = { link = '@tag.tsx' },

        -- css
        ['@css'] = { fg = '${orange}' },
        ['@css.class'] = { fg = '${orange}' },
        ['@css.id'] = { fg = '${blue}' },
        ['@css.pseudo_element'] = { fg = '${purple}' },
        ['@property.css'] = { fg = '${fg}' },
        ['@type.css'] = { fg = '${red}' },
        ['@string.css'] = { fg = '${red}' },
        ['@type.definition.css'] = { fg = '${red}' },
      },
      styles = {
        -- types = 'NONE',
        -- methods = 'NONE',
        -- numbers = 'NONE',
        -- strings = 'NONE',
        comments = 'italic',
        -- keywords = 'bold,italic',
        -- constants = 'NONE',
        -- functions = 'italic',
        -- operators = 'NONE',
        -- variables = 'NONE',
        parameters = 'italic',
        -- conditionals = 'italic',
        -- virtual_text = 'NONE',
      },
      options = {
        cursorline = true,
        transparency = require('core.state').theme.transparency,
        terminal_colors = false,
        highlight_inactive_windows = false,
      },
      plugins = { -- Enable/disable specific plugins
        aerial = false,
        barbar = false,
        blink_cmp = false,
        codecompanion = false,
        copilot = false,
        dashboard = false,
        hop = false,
        indentline = false,
        leap = false,
        lsp_saga = false,
        lsp_semantic_tokens = false,
        marks = false,
        mini_diff = false,
        mini_icons = false,
        nvim_hlslens = false,
        nvim_lsp = false,
        nvim_navic = false,
        nvim_notify = false,
        nvim_tree = false,
        nvim_ts_rainbow = false,
        nvim_ts_rainbow2 = false,
        op_nvim = false,
        packer = false,
        mini_indentscope = false,
        neotest = false,
        polygot = false,
        rainbow_delimiters = false,
        render_markdown = false,
        startify = false,
        toggleterm = false,
        trouble = false,
        vim_ultest = false,
        -- diffview = true,
        -- flash_nvim = true,
        -- gitsigns = true,
        -- mason = true,
        -- neo_tree = true,
        -- nvim_cmp = true,
        -- nvim_bqf = true,
        -- nvim_dap = true,
        -- nvim_dap_ui = true,
        -- persisted = true,
        -- snacks = true,
        -- telescope = true,
        -- treesitter = true,
        -- which_key = true,
        -- vim_dadbod_ui = true,
      },
    })

    local function set_highlights()
      require('hasan.utils.ui.palette').set_custom_highlights()
    end
    augroup('THEME_AUGROUP')(function(autocmd)
      autocmd('ColorScheme', set_highlights)

      autocmd('BufWritePost', function()
        R('hasan.utils.ui.palette', 'reloaded custom highlights')
        set_highlights()
      end, { pattern = { 'palette.lua' } })
    end)

    vim.cmd.colorscheme('onedark_vivid')
  end,
}
