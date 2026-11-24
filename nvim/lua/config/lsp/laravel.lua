local ft = { 'php', 'blade' }
return {
  'adalessa/laravel.nvim',
  enabled = true,
  dependencies = {
    'MunifTanjim/nui.nvim',
    'nvim-lua/plenary.nvim',
    'nvim-neotest/nvim-nio',
  },
  ft = ft,
  event = { 'BufEnter composer.json' },
  keys = {
    { '<leader>all', function() Laravel.pickers.laravel() end,              desc = 'Laravel: Picker' },
    { '<leader>ala', function() Laravel.pickers.artisan() end,              desc = 'Laravel: Artisan Picker' },
    { '<leader>alr', function() Laravel.pickers.routes() end,               desc = 'Laravel: Routes Picker' },
    { '<leader>alm', function() Laravel.pickers.make() end,                 desc = 'Laravel: Make Picker' },
    { "<leader>alo", function() Laravel.pickers.resources() end,            desc = "Laravel: Resources Picker" },
    { "<leader>alh", function() Laravel.run("artisan docs") end,            desc = "Laravel: Documentation" },
    { "<leader>alt", function() Laravel.commands.run("actions") end,        desc = "Laravel: Code Actions" },
    { "<leader>alp", function() Laravel.commands.run("command_center") end, desc = "Laravel: Command Center" },
    { '<leader>fc', function() Laravel.pickers.commands() end,              desc = 'Laravel: Custom Commands Picker', ft = ft },
    { "<leader>dd", function() Laravel.commands.run("hub") end,             desc = "Laravel: Artisan Hub", ft = ft },
    { "<c-g>",      function() Laravel.commands.run("view:finder") end,     desc = "Laravel: View Finder" },
    {
      'gf',
      function()
        if Laravel.app('gf').cursorOnResource() then
          return "<cmd>lua Laravel.commands.run('gf')<cr>"
        end
        return 'gf'
      end,
      expr = true,
      noremap = true,
      desc = 'Laravel: Go to resource',
    },
  },
  opts = {
    features = {
      pickers = {
        provider = 'snacks', -- telescope | fzf-lua | snacks | ui.select
      },
    },
  },
}
