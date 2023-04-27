local config = require('nebulous.configs')

local utils = {
  win_has_blacklist_ft = function(winid)
    local ft = vim.fn.getwinvar(winid, '&ft')
    return vim.tbl_contains(config.options.nb_blacklist_filetypes, ft)
  end,
  is_floating_win = function(winid)
    return vim.api.nvim_win_get_config(winid).relative ~= ''
  end,
  is_current_window = function(winid)
    return vim.api.nvim_get_current_win() == winid
  end,
  has_dynamically_deactive = function(winid)
    if type(config.options.dynamic_rules.deactive) ~= 'function' then
      return false
    end
    local deactive_rule = config.options.dynamic_rules.deactive({ win = winid })
    if deactive_rule == nil then
      return false
    end
    return deactive_rule
  end,
  setup_colors = function()
    vim.cmd([[
      " hi! link Nebulous PmenuThumb
      hi Nebulous guifg=#323c4e
      hi EndOfBuffer guibg=NONE
    ]])
  end,
  make_winhighlight = function(highlight)
    return table.concat(
      vim.tbl_map(function(key)
        return key .. ':' .. highlight[key]
      end, vim.tbl_keys(highlight)),
      ','
    )
  end,
}

-- local winhighlight = make_winhighlight({
--   Normal = "Normal",
--   FloatBorder = "SpecialChar"
-- })

return utils
