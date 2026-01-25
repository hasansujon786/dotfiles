local nx, nxo = { 'n', 'x' }, { 'n', 'x', 'o' }

---@param option { forward:boolean }
local function word_jump(option)
  return function()
    require('demicolon.jump').repeatably_do(function(kcount)
      Snacks.words.jump(kcount.forward and vim.v.count1 or -vim.v.count1, true)
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
    vim.diagnostic.jump({ count = count, severity = severity, float = true })
  end
end

-- https://www.naseraleisa.com/posts/diff#file-1
local function next_hunk()
  if vim.wo.diff then
    return ']c'
  end
  vim.schedule(function()
    package.loaded.gitsigns.nav_hunk('next')
  end)
  return '<Ignore>'
end
local function prev_hunk()
  if vim.wo.diff then
    return '[c'
  end
  vim.schedule(function()
    package.loaded.gitsigns.nav_hunk('prev')
  end)
  return '<Ignore>'
end

return {
  'mawkler/demicolon.nvim',
  enabled = true,
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
    { ']c', next_hunk, expr = true, desc = 'Git: Jump to hunk' },
    { '[c', prev_hunk, expr = true, desc = 'Git: Jump to hunk' },
    { ']x', '<cmd>Gitsigns nav_hunk next target=staged<cr>', desc = 'Git: Jump to hunk' },
    { '[x', '<cmd>Gitsigns nav_hunk prev target=staged<cr>', desc = 'Git: Jump to hunk' },

    -- Jump
    { 'f', eyeliner_jump('f'), desc = 'Jump to char', mode = nxo, expr = true },
    { 'F', eyeliner_jump('F'), desc = 'Jump to char', mode = nxo, expr = true },
    { 't', eyeliner_jump('t'), desc = 'Jump to char', mode = nxo, expr = true },
    { 'T', eyeliner_jump('T'), desc = 'Jump to char', mode = nxo, expr = true },

    -- LSP
    { 'g[', word_jump({ forward = false }), desc = 'Prev Reference', mode = nxo },
    { 'g]', word_jump({ forward = true }), desc = 'Next Reference', mode = nxo },
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
    { '[f', '<Plug>(ts-jump-prev-s-func)zz', desc = 'Jump prev func', mode = nx },
    { ']f', '<Plug>(ts-jump-next-s-func)zz', desc = 'Jump next func', mode = nx },
    { '[m', '<Plug>(ts-jump-prev-s-class)zz', desc = 'Jump prev class', mode = nx },
    { ']m', '<Plug>(ts-jump-next-s-class)zz', desc = 'Jump next class', mode = nx },

    -- Cycle through Yanklist items
    { '[r', '<Plug>(yanklist-cycle-forward)', desc = 'Yanklist forward' },
    { ']r', '<Plug>(yanklist-cycle-backward)', desc = 'Yanklist backward' },
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
    'nvim-treesitter/nvim-treesitter',
  },
}
