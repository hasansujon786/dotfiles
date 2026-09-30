local nx, nxo = { 'n', 'x' }, { 'n', 'x', 'o' }

---@param option { forward:boolean }
local function word_jump(option)
  return function()
    require('demicolon.jump').repeatably_do(function(opts)
      if vim.g.vscode then
        local action = opts.forward and 'editor.action.wordHighlight.next' or 'editor.action.wordHighlight.prev'
        require('vscode').action(action)
      else
        Snacks.words.jump(opts.forward and vim.v.count1 or -vim.v.count1, true)
      end
    end, option)
  end
end

local function eyeliner_jump(key)
  local forward = vim.list_contains({ 't', 'f' }, key)
  return function()
    require('eyeliner').highlight({ forward = forward })
    return require('demicolon.jump').horizontal_jump(key)()
  end
end

local function diagnostic_jump(count, severity)
  return function()
    if vim.g.vscode then
      require('demicolon.jump').repeatably_do(function(opts)
        local action = opts.forward and 'editor.action.marker.next' or 'editor.action.marker.prev'
        require('vscode').action(action)
      end, { forward = count > 0 })
      return
    end
    vim.diagnostic.jump({ count = count, severity = severity, float = false })
  end
end

-- https://www.naseraleisa.com/posts/diff#file-1
local function hunk_jump(forward)
  return function()
    if vim.g.vscode then
      require('demicolon.jump').repeatably_do(function(opts)
        local action = opts.forward and 'workbench.action.editor.nextChange' or 'workbench.action.editor.previousChange'
        require('vscode').action(action)
      end, { forward = forward })
      return '<Ignore>'
    end
    if vim.wo.diff then
      return forward and ']c' or '[c'
    end
    vim.schedule(function()
      package.loaded.gitsigns.nav_hunk(forward and 'next' or 'prev')
    end)
    return '<Ignore>'
  end
end

local function staged_hunk_jump(forward)
  return function()
    if vim.g.vscode then
      require('demicolon.jump').repeatably_do(function(opts)
        local action = opts.forward and 'editor.action.dirtydiff.next' or 'editor.action.dirtydiff.prev'
        require('vscode').action(action)
      end, { forward = forward })
      return
    end
    require('demicolon.jump').repeatably_do(function(opts)
      vim.cmd('Gitsigns nav_hunk ' .. (opts.forward and 'next' or 'prev') .. ' target=staged')
    end, { forward = forward })
  end
end

return {
  'mawkler/demicolon.nvim',
  keys = {
    { ';', mode = nxo },
    { ',', mode = nxo },

    -- Quickfix list
    { '[l', '<cmd>lprev<CR>', mode = nxo },
    { ']l', '<cmd>lnext<CR>', mode = nxo },
    { '[q', '<cmd>cprev<CR>', mode = nxo },
    { ']q', '<cmd>cnext<CR>', mode = nxo },
    { '[Q', '<cmd>cfirst<CR>', mode = nxo },
    { ']Q', '<cmd>clast<CR>', mode = nxo },

    -- Git
    { ']c', hunk_jump(true), expr = true, desc = 'Git: Jump to hunk', mode = nxo },
    { '[c', hunk_jump(false), expr = true, desc = 'Git: Jump to hunk', mode = nxo },
    { ']x', staged_hunk_jump(true), desc = 'Git: Jump to staged hunk', mode = nxo },
    { '[x', staged_hunk_jump(false), desc = 'Git: Jump to staged hunk', mode = nxo },

    -- Jump
    { 'f', eyeliner_jump('f'), desc = 'Jump to char', mode = nxo, expr = true },
    { 'F', eyeliner_jump('F'), desc = 'Jump to char', mode = nxo, expr = true },
    { 't', eyeliner_jump('t'), desc = 'Jump to char', mode = nxo, expr = true },
    { 'T', eyeliner_jump('T'), desc = 'Jump to char', mode = nxo, expr = true },

    -- LSP
    { 'g[', word_jump({ forward = false }), desc = 'Prev Reference', mode = nxo },
    { 'g]', word_jump({ forward = true }), desc = 'Next Reference', mode = nxo },
    { '[g', word_jump({ forward = false }), desc = 'Prev Reference', mode = nxo },
    { ']g', word_jump({ forward = true }), desc = 'Next Reference', mode = nxo },
    { '[[', word_jump({ forward = false }), desc = 'Prev Reference', mode = nxo },
    { ']]', word_jump({ forward = true }), desc = 'Next Reference', mode = nxo },

    -- DAP
    { '[v', '<cmd>lua require("dap").step_out()<cr>', desc = 'Debug: Step Out', mode = nxo },
    { ']v', '<cmd>lua require("dap").step_into()<cr>', desc = 'Debug: Step Into', mode = nxo },

    -- Diagnostic
    { '[e', diagnostic_jump(-1, vim.diagnostic.severity.ERROR), desc = 'Previous error', mode = nxo },
    { ']e', diagnostic_jump(1, vim.diagnostic.severity.ERROR), desc = 'Next error', mode = nxo },
    { '[d', diagnostic_jump(-1), desc = 'Previous diagnostic', mode = nxo },
    { ']d', diagnostic_jump(1), desc = 'Next diagnostic', mode = nxo },

    -- Text-objects
    -- { '[[', '<Plug>(ts-jump-prev-s-func)zz', desc = 'Jump prev func', mode = nx },
    -- { ']]', '<Plug>(ts-jump-next-s-func)zz', desc = 'Jump next func', mode = nx },
    {
      '[f',
      '<cmd>lua require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")<CR>',
      desc = 'Jump next func',
      mode = nx,
    },
    {
      ']f',
      '<cmd>lua require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")<CR>',
      desc = 'Jump prev func',
      mode = nx,
    },
    {
      '[m',
      '<cmd>lua require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")<CR>',
      desc = 'Jump next func',
      mode = nx,
    },
    {
      ']m',
      '<cmd>lua require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")<CR>',
      desc = 'Jump prev func',
      mode = nx,
    },

    -- Cycle through Yanklist items
    { '[r', '<Plug>(yanklist-cycle-forward)', desc = 'Yanklist forward' },
    { ']r', '<Plug>(yanklist-cycle-backward)', desc = 'Yanklist backward' },

    -- stylua: ignore start
    { '[a', '<cmd>lua require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")<CR>', desc = 'Swap parameter prev' },
    { ']a', '<cmd>lua require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")<CR>', desc = 'Swap parameter next' },
    -- stylua: ignore end
  },
  opts = {
    -- Create default keymaps
    keymaps = {
      horizontal_motions = false, -- Create t/T/f/F key mappings
    },
  },
  dependencies = {
    {
      'jinh0/eyeliner.nvim',
      lazy = true,
      opts = {
        dim = false,
        highlight_on_key = true,
        default_keymaps = false,
      },
    },
    'neovim-treesitter/nvim-treesitter',
  },
}
