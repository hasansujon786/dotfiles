return {
  'olimorris/onedarkpro.nvim',
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    require('onedarkpro').setup({
      -- stylua: ignore
      colors = {
        onedark_vivid = {
          red       = '#ef5f6b',
          green     = '#97ca72',
          orange    = '#d99a5e',
          cyan      = '#4dbdcb',
          blue      = '#5ab0f6',
          purple    = '#ca72e4',
          yellow    = '#ebc275',
          bg        = '#242b38', -- '#282c34'
          fg        = '#abb2bf', --
          gray      = '#546178', --
          highlight = '#f0d197',
          black     = '#282c34', --
          comment   = '#546178',  -- #7f848e
          none      = 'NONE',
        },
        -- custom colors
        light_grey = '#7d899f',
        bg1        = '#2d3343',
        -- bg2        = '#343e4f',
        bg3        = '#363c51',
        bg_d       = '#1e242e',
        -- black      = '#151820',
      },
      highlights = {
        -- "/// Neovim Builin ///"
        ['Cursor'] = { bg = '${blue}' },
        ['CursorLineNr'] = { fg = '${fg}' },
        ['DiagnosticSignInfo'] = { fg = '${cyan}' },
        ['Cursorline'] = { bg = '${bg1}' },
        ['Visual'] = { bg = '${bg3}' },
        ['WinSeparator'] = { fg = '${bg1}' },
        ['StatusLine'] = { fg = '${fg}', bg = '${bg1}' },
        ['IncSearch'] = { fg = '${bg}', bg = '#e86671' },
        ['Search'] = { fg = '${bg}', bg = '${highlight}' },
        ['SidebarDark'] = { fg = '${fg}', bg = '${bg_d}' },
        ['RedText'] = { fg = '#ff0000' },
        ['ZenBorder'] = { fg = '#1c212c' },
        ['MutedText'] = { fg = '${light_grey}' },
        ['CursorLineDap'] = { bg = '#173F1E', underline = false },

        -- global treesitter
        ['@field.lua'] = { link = '@property' },
        ['@constant'] = { fg = '${yellow}' },
        ['@constant.builtin'] = { fg = '${orange}' },
        ['@parameter.lua'] = { link = '@parameter' },

        ['@tag.attribute'] = { fg = '${orange}', italic = true },
        ['@punctuation.special'] = { fg = '${purple}' },
        ['@odp'] = { fg = '${purple}' }, -- fat_arrow

        ['@punctuation.bracket'] = { fg = '${light_grey}' },
        ['@tag.delimiter'] = { link = '@punctuation.bracket' },
        ['@punctuation.bracket.tsx'] = { link = '@punctuation.bracket' },
        ['@punctuation.bracket.typescript'] = { link = '@punctuation.bracket' },
        ['@punctuation.bracket.lua'] = { link = '@punctuation.bracket' },
        -- global treesitter

        -- ts,js
        ['@tag.attribute.tsx'] = { link = '@tag.attribute' },

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
        transparency = state.theme.bg_tranparent,
        terminal_colors = true,
        highlight_inactive_windows = false,
      },
    })

    augroup('THEME_AUGROUP')(function(autocmd)
      autocmd('ColorScheme', function()
        require('hasan.utils.ui.palette').set_custom_highlights()
        vim.defer_fn(require('hasan.nebulous').my_nebulous_setup, 300)
      end)

      autocmd('BufWritePost', function()
        vim.defer_fn(function()
          R('hasan.utils.ui.palette', nil)
          require('hasan.utils.ui.palette').set_custom_highlights()
        end, 300)
      end, { pattern = { 'palette.lua' } })
    end)

    vim.cmd.colorscheme('onedark_vivid')
  end,
}
