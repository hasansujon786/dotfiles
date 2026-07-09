return {
  'folke/sidekick.nvim',
  enabled = true,
  opts = {
    cli = {
      -- add any options here
      --   mux = {
      --     backend = 'zellij',
      --     enabled = true,
      --   },
      prompts = {
        component = 'Please refactor {this} to a component',
        refactor = 'Please refactor {this} to be more maintainable',
        -- security = 'Review {file} for security vulnerabilities',
        -- custom = function(ctx)
        --   return 'Current file: ' .. ctx.buf .. ' at line ' .. ctx.row
        -- end,
      },
      tools = {
        -- Defining the custom Antigravity entry
        agy = {
          cmd = { 'agy' }, -- Launches the core antigravity-cli tool
          -- Optional: Pass custom flags or default models if needed
          -- cmd = { "agy", "--model", "ultra" },
          -- If you need to make sure your terminal passes specific options
          env = {
            -- Example: Tells agy to automatically use safe sandbox mode inside Neovim
            -- AGY_SANDBOX_MODE = "true",
          },
        },
      },
    },
  },
  keys = {
    {
      '<c-.>',
      function()
        require('sidekick.cli').focus({ filter = { installed = true } })
      end,
      desc = 'Sidekick: Focus CLI',
      mode = { 'n', 't', 'i', 'x' },
    },
    {
      '<leader>aa',
      function()
        require('sidekick.cli').toggle()
      end,
      desc = 'Sidekick: Toggle CLI',
    },
    {
      '<leader>as',
      function()
        require('sidekick.cli').select({ filter = { installed = true } })
      end,
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
  },
}
