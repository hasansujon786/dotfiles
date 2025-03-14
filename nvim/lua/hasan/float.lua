local M = {}

M.fedit = function(fname)
  if vim.fn.filereadable(fname) == 0 then
    vim.notify('Not a valid file', vim.log.levels.WARN, { title = 'Fedit' })
    return 0
  end

  local float_win = Snacks.win({
    file = fname,
    width = 0.6,
    height = 0.6,
    border = 'rounded',
    wo = {
      wrap = true,
      signcolumn = 'yes',
      winhighlight = 'FloatTitle:FloatBorderTitle,Normal:SnacksNormal,NormalNC:SnacksNormalNC,WinBar:SnacksWinBar,WinBarNC:SnacksWinBarNC',
    },
    footer = string.format(' %s ', vim.fn.fnamemodify(fname, ':t')),
    footer_pos = 'center',
    bo = { modifiable = true },
  })

  vim.api.nvim_create_autocmd('WinClosed', {
    buffer = float_win.buf,
    group = float_win.augroup,
    callback = function()
      Snacks.bufdelete.delete(float_win.buf)
    end,
  })
end

return M
