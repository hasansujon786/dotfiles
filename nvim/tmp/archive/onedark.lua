return {
  'navarasu/onedark.nvim',
  enabled = false,
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    require('onedark').setup({
      style = 'cool',
      transparent = state.theme.bg_tranparent,
      term_colors = false,
      toggle_style_key = '<leader>tB',
      toggle_style_list = { 'light', 'cool', 'deep', 'dark', 'darker' },
      -- colors = {},
      highlights = {
        -- Ex: ["@function"] = {fg = '#cyan', sp = '$blue', fmt = 'underline,italic,bold'},

        ['@constant'] = { fg = '$yellow' },
        ['@constant.builtin'] = { fg = '$yellow' },
        ['@constant.macro'] = { fg = '$yellow' },
        ['@variable.builtin'] = { fg = '$yellow' },

        ['@field'] = { fg = '$red' },
        ['@variable'] = { fg = '$red' },
        ['@property'] = { fg = '$red' },

        ['@punctuation.special'] = { fg = '$purple' },

        ['OrgDone'] = { fg = '$green' },

        ['@tag'] = { fg = '$red' },
        ['@tag.delimiter'] = { fg = '$fg' },
        ['@tag.attribute'] = { fg = '$orange' },
        ['@text.title'] = { fg = '$fg' },

        -- custom extends highlights
        ['@css.class'] = { fg = '$orange' },
        ['@css.id'] = { fg = '$blue' },
        ['@css.pseudo_element'] = { fg = '$purple' },

        -- UI:
        ['GitSignsAdd'] = { fg = '#109868' },
        ['GitSignsDelete'] = { fg = '#9A353D' },
        ['GitSignsChange'] = { fg = '$yellow' },
      },
      -- Options are italic, bold, underline, none
      code_style = {
        comments = 'italic',
        keywords = 'italic',
        functions = 'italic',
        strings = 'none',
        variables = 'none',
      },
      -- Plugins Config --
      diagnostics = {
        darker = true,
        undercurl = true,
        background = true,
      },
    })

    require('onedark').load()
  end,
}
