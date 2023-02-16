local utils = require('hasan.utils')
if vim.fn.exists('g:hasan_telescope_buffers') == 0 then
  vim.g.hasan_telescope_buffers = { ['0'] = 0 } -- used in hasan#utils#_buflisted_sorted()
end

utils.augroup('MY_AUGROUP')(function(autocmd)
  autocmd('CmdwinEnter', 'nnoremap <buffer><CR> <CR>')
  autocmd('ColorScheme', function()
    require('hasan.utils.ui.palatte').set_custom_highlights()
    require('hasan.utils.color').my_nebulous_setup()
  end)

  autocmd('FileType', 'setl foldlevel=0', { pattern = 'vim' })
  autocmd('FileType', 'setl foldmethod=marker', { pattern = { 'vim', 'css', 'scss', 'json' } })
  autocmd('FileType', 'setl foldmarker={,}', { pattern = { 'css', 'scss', 'json' } })
  autocmd('FileType', 'setl foldmarker={,}', { pattern = { 'css', 'scss', 'json' } })
  autocmd({ 'BufNewFile', 'BufRead' }, 'setl filetype=jsonc', { pattern = { '*.json', 'tsconfig.json' } })
  autocmd({ 'BufWinEnter', 'WinEnter' }, function()
    vim.defer_fn(function()
      vim.wo.winhighlight = 'FloatBorder:ZenBorder,Folded:OrgHeadlineLevel1'
    end, 1)
  end, { pattern = '*.org' })

  autocmd('BufLeave', 'normal! mK', { pattern = '*.txt' })
  autocmd('BufWritePost', 'source <afile> ', { pattern = 'state.lua' })
  autocmd('TermOpen', 'setfiletype terminal | set bufhidden=hide')
  autocmd('BufWritePre', vim.fn['hasan#autocmd#trimWhitespace'], { pattern = { '*.vim', '*.lua', '*.org', '*.ahk' } })
  autocmd('FileType', 'setlocal nonumber norelativenumber signcolumn=no', { pattern = 'log' })
  autocmd({ 'BufWinEnter', 'WinEnter' }, 'normal Gzz', { pattern = '__FLUTTER_DEV_LOG__' })
  autocmd({ 'FocusGained', 'BufEnter', 'CursorHold' }, ':silent! checktime')
  autocmd('BufReadPost', function()
    require('hasan.utils.win').restore_cussor_pos()
  end)

  autocmd('BufDelete', 'silent! call remove(g:hasan_telescope_buffers, expand("<abuf>"))')
  autocmd({ 'BufWinEnter', 'WinEnter' }, 'let g:hasan_telescope_buffers[bufnr()] = reltimefloat(reltime())')

  -- autocmd('VimResized', 'wincmd =') -- Vim/tmux layout rebalancing
  -- {'FocusLost,WinLeave,BufLeave * :silent! noautocmd w'}, -- auto save
  -- {'WinEnter,BufWinEnter *.vim,*.js,*.lua call hasan#boot#highligt_ruler(1)'},
  -- autocmd('VimEnter', 'runtime! autoload/netrw.vim', { once = true })
end)
