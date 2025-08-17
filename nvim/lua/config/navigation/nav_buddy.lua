vim.g.navbuddy_taransparent = true

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

_G.reload_on_call = nil
local function update_should_reload()
  vim.defer_fn(function()
    _G.reload_on_call = vim.uv.cwd():find('nvim%-navbuddy') and true or false
  end, 300)
end

augroup('MY_BUDDY_AUGROUP')(function(autocmd)
  autocmd('User', update_should_reload, { pattern = 'VeryLazy', once = true })
  autocmd('User', update_should_reload, { pattern = 'PersistedPickerLoadPost' })
end)

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
  dev = true,
  cmd = { 'Navbuddy' },
  keys = {
    {
      'zo',
      function()
        local buddy = getNavbuddy()

        if reload_on_call then
          vim.defer_fn(function()
            buddy.open()
          end, 300)
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
          end, 300)
        else
          buddy.open(open_opts)
        end
      end,
      desc = 'Show Navbuddy',
    },
  },
  opts = opts,
  dependencies = {
    'SmiteshP/nvim-navic',
    'MunifTanjim/nui.nvim',
    -- 'numToStr/Comment.nvim', -- Optional
  },
}
