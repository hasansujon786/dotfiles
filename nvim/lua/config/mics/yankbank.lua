local nx = { 'n', 'x' }

---@param i number
---@return { yank_text:string,reg_type:string }
local function get_entry(i)
  local BANKS = require('yankbank.persistence').get_yanks()
  return {
    yank_text = BANKS[i],
    ---@diagnostic disable-next-line: undefined-global
    reg_type = YB_REG_TYPES[i],
  }
end

return {
  'ptdewey/yankbank-nvim',
  lazy = true,
  event = 'CursorHold',
  keys = {
    { '<leader>oy', '<cmd>YankBank<CR>', mode = nx },
    {
      '<leader>ii',
      function()
        local reg_data = get_entry(1) -- local e = require('yankbank.api').get_entry(1)
        vim.fn.setreg('z', reg_data.yank_text, reg_data.reg_type)
        feedkeys('"zp')
      end,
      mode = nx,
    },
  },
  dependencies = 'kkharji/sqlite.lua',
  opts = {
    max_entries = 20,
    sep = '------',
    persist_type = 'sqlite',
    num_behavior = 'jump',
  },
}
