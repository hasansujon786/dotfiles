local config = require('nebulous.configs')

local utils = {
  win_has_blacklist_filetype = function(winid)
    local ft = vim.fn.getwinvar(winid, '&ft')
    return config.options.nb_blacklist_filetypes[ft]
  end,
  is_floting_window = function(winid)
    return vim.api.nvim_win_get_config(winid).relative ~= ''
  end,
  is_current_window = function(winid)
    return vim.api.nvim_get_current_win() == winid
  end,
  setup_colors = function()
    vim.cmd([[
      " hi! link Nebulous PmenuThumb
      hi Nebulous guifg=#323c4e
      hi EndOfBuffer guibg=NONE
    ]])
  end,
}

return utils
