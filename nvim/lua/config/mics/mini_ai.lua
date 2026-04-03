return {
  'nvim-mini/mini.ai',
  version = false,
  config = function()
    local function ai_buffer(ai_type)
      local start_line, end_line = 1, vim.fn.line('$')
      if ai_type == 'i' then
        -- Skip first and last blank lines for `i` textobject
        local first_nonblank, last_nonblank = vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
        -- Do nothing for buffer with all blanks
        if first_nonblank == 0 or last_nonblank == 0 then
          return { from = { line = start_line, col = 1 } }
        end
        start_line, end_line = first_nonblank, last_nonblank
      end

      local to_col = math.max(vim.fn.getline(end_line):len(), 1)
      return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
    end
    -- local spec_treesitter = require('mini.ai').gen_spec.treesitter
    -- vim.b.miniai_config = {
    --   custom_textobjects = {
    --     t = spec_treesitter({ a = '@function.outer', i = '@function.inner' }),
    --   },
    -- }

    -- NOTE: with default config, built-in LSP mappings |v_an| and |v_in| on Neovim>=0.12
    -- are overridden. Either use different `around_next` / `inside_next` keys or
    -- map manually using |vim.lsp.buf.selection_range()|. For example: >lua
    --
    --   local map_lsp_selection = function(lhs, desc)
    --     local s = vim.startswith(desc, 'Increase') and 1 or -1
    --     local rhs = function() vim.lsp.buf.selection_range(s * vim.v.count1) end
    --     vim.keymap.set('x', lhs, rhs, { desc = desc })
    --   end
    --   map_lsp_selection('<Leader>ls', 'Increase selection')
    --   map_lsp_selection('<Leader>lS', 'Decrease selection')

    local gen_spec = require('mini.ai').gen_spec
    require('mini.ai').setup({
      n_lines = 500,
      custom_textobjects = {
        o = gen_spec.treesitter({ -- code block
          a = { '@block.outer', '@conditional.outer', '@loop.outer' },
          i = { '@block.inner', '@conditional.inner', '@loop.inner' },
        }),
        f = gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
        c = gen_spec.function_call(),
        C = gen_spec.function_call({ name_pattern = '[%w_]' }), -- Without dot in function name
        m = gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }),
        ['='] = gen_spec.treesitter({ a = '@attribute.outer', i = '@attribute.inner' }),
        P = gen_spec.treesitter({ a = '@_pair.outer', i = '@_pair.inner' }),
        v = gen_spec.treesitter({ a = '@assignment.outer', i = '@assignment.rhs' }),
        V = gen_spec.treesitter({ a = '@assignment.outer', i = '@assignment.lhs' }),

        -- ['*'] = gen_spec.pair('*', '*', { type = 'greedy' }),
        -- ['_'] = gen_spec.pair('_', '_', { type = 'greedy' }),

        t = false,
        -- t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- tags
        r = { { '%b[]' }, '^.().*().$' },
        k = { { '^().*()$' }, { '^%s*().-()%s*$', '^().*()$' } },
        d = { '%f[%d]%d+' }, -- digits
        e = { -- Word with case
          { '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]' },
          '^().*()$',
        },
        g = ai_buffer, -- buffer
      },
    })
  end,
}
