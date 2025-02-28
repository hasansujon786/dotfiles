return {
  'yetone/avante.nvim',
  lazy = true,
  version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
  ft = { 'Avante' },
  cmd = {
    'AvanteAsk',
    'AvanteBuild',
    'AvanteChat',
    'AvanteClear',
    'AvanteEdit',
    'AvanteFocus',
    'AvanteRefresh',
    'AvanteShowRepoMap',
    'AvanteSwitchFileSelectorProvider',
    'AvanteSwitchProvider',
  },
  opts = {
    provider = 'gemini',
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  -- build = 'make',
  build = 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false', -- for windows
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    --- The below dependencies are optional,
    -- 'zbirenbaum/copilot.lua', -- for providers='copilot'
    {
      -- support for image pasting
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = { file_types = { 'markdown', 'Avante' } },
      ft = { 'markdown', 'Avante' },
    },
  },
}
