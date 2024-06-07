local nx, nxo = { 'n', 'x' }, { 'n', 'x', 'o' }
return {
  'folke/flash.nvim',
  opts = {
    labels = ';asdfghjklwertyuiopxcvbnm',
    label = {
      current = true,
      rainbow = { enabled = false, shade = 5 },
    },
    modes = { char = { enabled = false } },
    search = {
      exclude = {
        'notify',
        'cmp_menu',
        'noice',
        'flash_prompt',
        'cmp_docs',
        function(win)
          local conf, buf = vim.api.nvim_win_get_config(win), vim.api.nvim_win_get_buf(win)
          local ft = vim.api.nvim_get_option_value('filetype', { buf = buf })

          -- filter cmp wildmenu
          if conf.height == 1 and ft == '' and conf.relative ~= '' then
            return true
          end

          return not conf.focusable
        end,
      },
    },
    prompt = { enabled = true, prefix = { { ' ⚡', 'FlashPromptIcon' } } },
  },
  -- stylua: ignore
  keys = {
    { 's', mode = nx, function() require('flash').jump() end, desc = 'Flash' },
    { 'z', mode = 'o', function() require('flash').jump() end, desc = 'Flash' },
    { 'S', mode = nxo, function() require('flash').treesitter() end, desc = 'Flash Treesitter' },
    { 'r', mode = 'o', function() require('flash').remote() end, desc = 'Remote Flash' },
    { 'R', mode = { 'o', 'x' }, function() require('flash').treesitter_search() end, desc = 'Treesitter Search' },
    { '<c-s>', mode = { 'c' }, function() require('flash').toggle() end, desc = 'Toggle Flash Search' },
    { 'gs', mode = nxo, function() require('flash').jump({ continue = true }) end, desc = 'Flash' },
  },
}
