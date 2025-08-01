return {
  'nvim-treesitter/nvim-treesitter-context',
  commit = '4976d8b', -- 2bcf700 -- 8fd989b
  enabled = true,
  lazy = true,
  event = 'CursorHold',
  keys = {
    {
      'z-',
      function()
        require('treesitter-context').go_to_context(vim.v.count1)
      end,
      mode = 'n',
      desc = 'Move cursor to context',
    },
    {
      '-',
      function()
        require('treesitter-context').go_to_context(vim.v.count1)
      end,
      mode = { 'x', 'o' },
      desc = 'Move cursor to context',
    },
  },
  opts = function()
    local tsc = require('treesitter-context')
    Snacks.toggle({
      name = 'TSContext',
      get = tsc.enabled,
      set = function(state)
        if state then
          tsc.enable()
        else
          tsc.disable()
        end
      end,
    }):map('<leader>t-')

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
}
