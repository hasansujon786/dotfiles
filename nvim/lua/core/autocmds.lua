local utils = require('hasan.utils')
if vim.fn.exists('g:hasan_telescope_buffers') == 0 then
  vim.g.hasan_telescope_buffers = { ['0'] = 0 } -- used in hasan#utils#_buflisted_sorted()
end

utils.augroup('MY_AUGROUP')(function(autocmd)
  autocmd('CmdwinEnter', 'nnoremap <buffer><CR> <CR>')
  autocmd('ColorScheme', 'lua require("hasan.utils.ui.palatte").set_custom_highlights()')

  autocmd('FileType', 'setlocal foldlevel=0', { pattern = 'vim' })
  autocmd('FileType', 'setlocal foldmethod=marker', { pattern = { 'vim', 'css', 'scss', 'json' } })
  autocmd('FileType', 'setlocal foldmarker={,}', { pattern = { 'css', 'scss', 'json' } })
  autocmd('FileType', 'setlocal foldmarker={,}', { pattern = { 'css', 'scss', 'json' } })
  autocmd({ 'BufNewFile', 'BufRead' }, 'set filetype=jsonc', { pattern = { '*.json', 'tsconfig.json' } })

  autocmd('BufDelete', 'silent! call remove(g:hasan_telescope_buffers, expand("<abuf>"))')
  autocmd({ 'BufWinEnter', 'WinEnter' }, 'let g:hasan_telescope_buffers[bufnr()] = reltimefloat(reltime())')

  autocmd('CursorHold', function()
    vim.defer_fn(function()
      require('core.lazy')
    end, 50)
  end, { once = true })
end)
