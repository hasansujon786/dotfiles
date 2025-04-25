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

return {
  'mawkler/demicolon.nvim',
  enabled = true,
  keys = {
    { ';', mode = nxo },
    { ',', mode = nxo },
    { '[', mode = nxo },
    { ']', mode = nxo },
    { 'f', eyeliner_jump('f'), desc = 'Jump to char', mode = nxo, expr = true },
    { 'F', eyeliner_jump('F'), desc = 'Jump to char', mode = nxo, expr = true },
    { 't', eyeliner_jump('t'), desc = 'Jump to char', mode = nxo, expr = true },
    { 'T', eyeliner_jump('T'), desc = 'Jump to char', mode = nxo, expr = true },
    { 'g[', word_jump({ forward = false }), desc = 'Prev Reference', mode = nxo },
    { 'g]', word_jump({ forward = true }), desc = 'Next Reference', mode = nxo },
  },
  opts = {
    -- Create default keymaps
    keymaps = {
      horizontal_motions = false, -- Create t/T/f/F key mappings
    },
  },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    {
      'jinh0/eyeliner.nvim',
      lazy = true,
      -- keys = { { 'f', mode = nxo }, { 'F', mode = nxo }, { 't', mode = nxo }, { 'T', mode = nxo } },
      opts = {
        dim = false,
        highlight_on_key = true,
        default_keymaps = false,
      },
    },
  },
}
