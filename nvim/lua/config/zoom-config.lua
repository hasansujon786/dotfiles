
function ZoomPost()
  vim.defer_fn(function ()
    local this_win = vim.api.nvim_get_current_win()
    for _,  win_id in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if this_win ~= win_id then
        vim.api.nvim_win_set_option(win_id, 'cursorline', false)
      end
    end
  end, 50)
end

