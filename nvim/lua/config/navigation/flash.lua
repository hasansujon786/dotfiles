local nx, nxo = { 'n', 'x' }, { 'n', 'x', 'o' }
return {
  'folke/flash.nvim',
  opts = {
    labels = ';asdfghjklwertyuiopxcvbnm',
    modes = { char = { enabled = false }, search = { enabled = true } },
    search = {
      exclude = {
        'notify',
        'noice',
        'flash_prompt',
        'blink-cmp-menu',
        'blink-cmp-signature',
        'blink-cmp-documentation',
      },
    },
    prompt = { enabled = true, prefix = { { ' ⚡', 'FlashPromptIcon' } } },
  },
  -- { label = { after = { 0, 2 }, style = 'overlay' }, }
  -- stylua: ignore
  keys = {
    { '/', mode = nxo, desc = 'Search forward' },
    { '?', mode = nxo, desc = 'Search backward' },
    { 's', mode = nx, function() require('flash').jump() end, desc = 'Flash' },
    { 'z', mode = 'o', function() require('flash').jump() end, desc = 'Flash' },
    { 'S', mode = nxo, function() require('flash').treesitter() end, desc = 'Flash Treesitter' },
    { 'r', mode = 'o', function() require('flash').remote() end, desc = 'Remote Flash' },
    { 'R', mode = { 'o', 'x' }, function() require('flash').treesitter_search() end, desc = 'Treesitter Search' },
    { '<c-s>', mode = { 'c' }, function() require('flash').toggle() end, desc = 'Toggle Flash Search' },
    { 'gs', mode = nxo, function() require('flash').jump({ continue = true }) end, desc = 'Flash' },
  },
}
