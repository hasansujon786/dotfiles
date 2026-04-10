return {
  'folke/sidekick.nvim',
  enabled = true,
  opts = {
    -- add any options here
    -- cli = {
    --   mux = {
    --     backend = 'zellij',
    --     enabled = true,
    --   },
    -- },
    cli = {
      prompts = {
        component = 'Please refactor {this} to a component',
        refactor = 'Please refactor {this} to be more maintainable',
        -- security = 'Review {file} for security vulnerabilities',
        -- custom = function(ctx)
        --   return 'Current file: ' .. ctx.buf .. ' at line ' .. ctx.row
        -- end,
      },
    },
  },
  keys = {
    {
      '<c-.>',
      function()
        -- require('sidekick.cli').toggle()
        require('sidekick.cli').focus({ filter = { installed = true } })
      end,
      desc = 'Sidekick: Focus CLI',
      mode = { 'n', 't', 'i', 'x' },
    },
    {
      '<leader>aa',
      function()
        require('sidekick.cli').toggle({ filter = { installed = true } })
      end,
      desc = 'Sidekick: Toggle CLI',
    },
    {
      '<leader>as',
      function()
        require('sidekick.cli').select({ filter = { installed = true } })
      end,
      -- Or to select only installed tools:
      -- require("sidekick.cli").select({ filter = { installed = true } })
      desc = 'Sidekick: Select CLI',
    },
    {
      '<leader>ac',
      function()
        require('sidekick.cli').close()
      end,
      desc = 'Sidekick: Detach a CLI Session',
    },
    {
      '<leader>at',
      function()
        require('sidekick.cli').send({ msg = '{this}' })
      end,
      mode = { 'x', 'n' },
      desc = 'Sidekick: Send This',
    },
    {
      '<leader>af',
      function()
        require('sidekick.cli').send({ msg = '{file}' })
      end,
      desc = 'Sidekick: Send File',
    },
    {
      '<leader>av',
      function()
        require('sidekick.cli').send({ msg = '{selection}' })
      end,
      mode = { 'x' },
      desc = 'Sidekick: Send Visual Selection',
    },
    {
      '<leader>ap',
      function()
        require('sidekick.cli').prompt()
      end,
      mode = { 'n', 'x' },
      desc = 'Sidekick: Select Prompt',
    },
    -- Example of a keybinding to open Claude directly
    -- {
    --   '<leader>ac',
    --   function()
    --     require('sidekick.cli').toggle({ name = 'claude', focus = true })
    --   end,
    --   desc = 'Sidekick: Toggle Claude',
    -- },
  },
}
