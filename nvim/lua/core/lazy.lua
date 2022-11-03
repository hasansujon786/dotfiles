local utils = require('hasan.utils')

utils.augroup('MY_LAZY_AUGROUP')(function(autocmd)
  -- autocmd('VimResized', 'wincmd =') -- Vim/tmux layout rebalancing
  autocmd('BufReadPost', vim.fn['hasan#autocmd#restore_position'])
  autocmd('BufWritePost', 'source <afile> | PackerCompile ', { pattern = 'plugins.lua' })
  autocmd('WinLeave', require('hasan.utils.color').my_nebulous_setup, { once = true })

  autocmd('User', function()
    require('hasan.utils.ui.palatte').set_custom_highlights()
    vim.notify('Packer configuration recompiled')
  end, { pattern = 'PackerCompileDone' })

  autocmd({ 'FocusGained', 'BufEnter', 'CursorHold' }, ':silent! checktime')
  autocmd('TermOpen', 'setfiletype terminal | set bufhidden=hide')
  autocmd('BufLeave', 'normal! mK', { pattern = '*.txt' })
  autocmd('BufWritePre', vim.fn['hasan#autocmd#trimWhitespace'], { pattern = { '*.vim', '*.lua', '*.org', '*.ahk' } })
  autocmd('BufWritePost', 'source <afile> | PackerCompile ', { pattern = 'plugins.lua' })
  autocmd({ 'BufWinEnter', 'WinEnter' }, 'normal Gzz', { pattern = '__FLUTTER_DEV_LOG__' })
  autocmd('FileType', 'setlocal nonumber norelativenumber signcolumn=no', { pattern = 'log' })

  -- {'FocusLost,WinLeave,BufLeave * :silent! noautocmd w'}, -- auto save
  -- {'WinEnter,BufWinEnter *.vim,*.js,*.lua call hasan#boot#highligt_ruler(1)'},
  -- autocmd('VimEnter', 'runtime! autoload/netrw.vim', { once = true })
end)
