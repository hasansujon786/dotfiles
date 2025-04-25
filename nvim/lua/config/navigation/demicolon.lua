local nx, nxo = { 'n', 'x' }, { 'n', 'x', 'o' }

return {
  'mawkler/demicolon.nvim',
  enabled = true,
  keys = {
    { ';', mode = nxo },
    { ',', mode = nxo },
    { 'f', mode = nxo },
    { 'F', mode = nxo },
    { 't', mode = nxo },
    { 'T', mode = nxo },
    { '[', mode = nxo },
    { ']', mode = nxo },
  },
  opts = {
    -- Create default keymaps
    keymaps = {
      horizontal_motions = false, -- Create t/T/f/F key mappings
    },
  },
  config = function(_, opts)
    require('demicolon').setup(opts)

    local function eyeliner_jump(key)
      local forward = vim.list_contains({ 't', 'f' }, key)
      return function()
        require('eyeliner').highlight({ forward = forward })
        return require('demicolon.jump').horizontal_jump(key)()
      end
    end

    require('which-key').add({
      { 'f', eyeliner_jump('f'), desc = 'Jump to char', mode = nxo, expr = true },
      { 'F', eyeliner_jump('F'), desc = 'Jump to char', mode = nxo, expr = true },
      { 't', eyeliner_jump('t'), desc = 'Jump to char', mode = nxo, expr = true },
      { 'T', eyeliner_jump('T'), desc = 'Jump to char', mode = nxo, expr = true },
    })
  end,
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
