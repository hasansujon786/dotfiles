local dev_Mode = true
local reload_on_call = true

if dev_Mode == false then
  reload_on_call = false
end
vim.api.nvim_create_user_command('NavbuddyDevMode', function()
  reload_on_call = not reload_on_call
end, { nargs = 0, desc = 'NavbuddyDevMode' })

vim.g.navbuddy_taransparent = true

local buildDoc = function()
  vim.cmd([[wa]])
  local minidoc = require('mini.doc')

  if _G.MiniDoc == nil then
    minidoc.setup()
  end

  local hooks = vim.deepcopy(MiniDoc.default_hooks)

  hooks.write_pre = function(lines)
    -- Remove first two lines with `======` and `------` delimiters to comply
    -- with `:h local-additions` template
    table.remove(lines, 1)
    table.remove(lines, 1)
    return lines
  end

  MiniDoc.generate({
    'lua/nvim-navbuddy/init.lua',
    'lua/nvim-navbuddy/actions.lua',
    'lua/nvim-navbuddy/ui.lua',
  }, 'doc/navbuddy.txt', { hooks = hooks })
end

vim.api.nvim_create_user_command('NavbuddyGenDoc', buildDoc, { nargs = 0, desc = 'Navbuddy GenDoc' })

---@type Navbuddy.config
local opts = {
  custom_hl_group = 'Visual',
  lsp = { auto_attach = true },
  -- source_buffer = {
  --   follow_node = true,
  --   highlight = true,
  --   reorient = 'smart',
  --   scrolloff = nil,
  -- },
  window = {
    winblend = 20,
    -- border = 'single',
    size = '60%',
    position = '50%',
    scrolloff = nil,
    sections = {
      left = {
        -- border = 'double',
        --   style = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' },
        -- border = {
        --   -- style = 'single',
        --   style = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' },
        --   text = {
        --     top = 'xxxxxxxxx',
        --     top_align = 'center',
        --   },
        -- },
        size = '20%',
        win_options = {
          -- winbar = 'xxx',
          -- number = true,
        },
      },
      mid = {
        -- number = false,
        size = '40%',
        win_options = {
          -- winbar = 'xxx',
          number = true,
          relativenumber = true,
        },
        -- buf_options = {
        --   filetype = 'xxxxxxxx',
        -- },
      },
      right = {
        number = true,
        win_options = {
          winbar = '',
          -- number = false,
        },
        preview = 'leaf',
      },
    },
  },
}

local function getNavbuddy()
  if reload_on_call then
    vim.cmd([[wa]])
    local buddy = R('nvim-navbuddy')
    buddy.setup(opts)
    return buddy
  end

  return require('nvim-navbuddy')
end

return {
  'hasansujon786/nvim-navbuddy',
  dev = dev_Mode,
  cmd = { 'Navbuddy' },
  keys = {
    {
      'zo',
      function()
        local buddy = getNavbuddy()

        if reload_on_call then
          vim.defer_fn(function()
            buddy.open()
          end, 1000)
        else
          buddy.open()
        end
      end,
      desc = 'Show Navbuddy',
    },
    {
      'zi',
      function()
        local open_opts = { root = true }
        local buddy = getNavbuddy()

        if reload_on_call then
          vim.defer_fn(function()
            buddy.open(open_opts)
          end, 1000)
        else
          buddy.open(open_opts)
        end
      end,
      desc = 'Show Navbuddy',
    },
  },
  opts = opts,
  dependencies = {
    { 'hasansujon786/nvim-navic', dev = true },
    'MunifTanjim/nui.nvim',
    'numToStr/Comment.nvim', -- Optional
    -- 'nvim-telescope/telescope.nvim',
  },
}
