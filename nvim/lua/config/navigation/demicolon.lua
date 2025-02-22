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
    { '[d', mode = nxo },
    { ']d', mode = nxo },
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

    local function gitsigns_jump(options)
      return function()
        require('demicolon.jump').repeatably_do(function(kopts)
          if vim.wo.diff then -- If we're in a diff
            local direction_key = (kopts.forward == nil or kopts.forward) and ']' or '['
            vim.cmd.normal({ vim.v.count1 .. direction_key .. 'c', bang = true })
          else
            local exists, gitsigns = pcall(require, 'gitsigns')
            if not exists then
              vim.notify('diagnostic.nvim: gitsigns.nvim is not installed', vim.log.levels.WARN)
              return
            end

            local direction = (kopts.forward == nil or kopts.forward) and 'next' or 'prev'
            gitsigns.nav_hunk(direction, { target = kopts.target })
          end
        end, options)
      end
    end

    require('which-key').add({
      { 'f', eyeliner_jump('f'), desc = 'Jump to char', mode = nxo, expr = true },
      { 'F', eyeliner_jump('F'), desc = 'Jump to char', mode = nxo, expr = true },
      { 't', eyeliner_jump('t'), desc = 'Jump to char', mode = nxo, expr = true },
      { 'T', eyeliner_jump('T'), desc = 'Jump to char', mode = nxo, expr = true },
      { ']c', gitsigns_jump({ forward = true, target = 'unstaged' }), desc = 'Next hunk', mode = nxo },
      { '[c', gitsigns_jump({ forward = false, target = 'unstaged' }), desc = 'Previous hunk', mode = nxo },
      { ']x', gitsigns_jump({ forward = true, target = 'staged' }), desc = 'Next staged hunk', mode = nxo },
      { '[x', gitsigns_jump({ forward = false, target = 'staged' }), desc = 'Previous staged hunk', mode = nxo },
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
  opts = {
    -- Create default keymaps
    keymaps = {
      repeat_motions = true, -- Create ; and , key mappings
      horizontal_motions = false, -- Create t/T/f/F key mappings
      diagnostic_motions = true, -- Create ]d/[d, etc. key mappings to jump to diganostics. See demicolon.keymaps.create_default_diagnostic_keymaps
      list_motions = true, -- ]q/[q/]<C-q>/[<C-q> and ]l/[l/]<C-l>/[<C-l> quickfix and location list
      spell_motions = true, -- ]s/[s
      fold_motions = true, -- ]z/[z key mappings for jumping to folds
    },
    integrations = {
      gitsigns = { enabled = false },
      neotest = { enabled = false },
    },
  },
}
