local first_init = true
local utils = require('hasan.utils')
if vim.fn.exists('g:hasan_telescope_buffers') == 0 then
  vim.g.hasan_telescope_buffers = { ['0'] = 0 } -- used in hasan#utils#_buflisted_sorted()
end

utils.augroup('MY_AUGROUP')(function(autocmd)
  autocmd('CmdwinEnter', 'nnoremap <buffer><CR> <CR>')
  autocmd('ColorScheme', function()
    require('hasan.utils.ui.palette').set_custom_highlights()

    if first_init then
      vim.defer_fn(function()
        require('config.ui.nebulous').my_nebulous_setup()
      end, 500)
    else
      require('config.ui.nebulous').my_nebulous_setup()
    end
    first_init = false
  end)

  autocmd('FileType', 'setl foldlevel=0', { pattern = 'vim' })
  autocmd('FileType', 'setl foldmethod=marker', { pattern = { 'vim', 'css', 'scss', 'json' } })
  autocmd('FileType', 'setl foldmarker={,}', { pattern = { 'css', 'scss', 'json' } })
  autocmd('FileType', 'setl foldmarker={,}', { pattern = { 'css', 'scss', 'json' } })
  autocmd({ 'BufNewFile', 'BufRead' }, 'setl filetype=jsonc', { pattern = { '*.json', 'tsconfig.json' } })
  autocmd({ 'BufWinEnter', 'WinEnter' }, function()
    vim.defer_fn(function()
      vim.wo.winhighlight = 'Normal:Normal,FloatBorder:ZenBorder,Folded:OrgHeadlineLevel1'
    end, 1)
  end, { pattern = '*.org' })

  autocmd('BufLeave', 'normal! mK', { pattern = '*.txt' })
  autocmd('TermOpen', 'setfiletype terminal | set bufhidden=hide')
  autocmd('BufWritePre', vim.fn['hasan#autocmd#trimWhitespace'], { pattern = { '*.vim', '*.lua', '*.org', '*.ahk' } })
  autocmd('FileType', 'setlocal nonumber norelativenumber signcolumn=no', { pattern = 'log' })
  autocmd({ 'BufWinEnter', 'WinEnter' }, 'normal Gzz', { pattern = '__FLUTTER_DEV_LOG__' })
  autocmd({ 'FocusGained', 'BufEnter', 'CursorHold' }, ':silent! checktime')
  autocmd('BufReadPost', function()
    require('hasan.utils.win').restore_cussor_pos()
  end)
  autocmd('BufWritePost', function()
    R('hasan.core.state', 'Config reloaded')
    vim.defer_fn(function()
      require('hasan.utils.reload').reload_app_state()
    end, 300)
  end, { pattern = 'state.lua' })

  autocmd('BufDelete', 'silent! call remove(g:hasan_telescope_buffers, expand("<abuf>"))')
  autocmd({ 'BufWinEnter', 'WinEnter' }, 'let g:hasan_telescope_buffers[bufnr()] = reltimefloat(reltime())')

  -- autocmd('VimResized', 'wincmd =') -- Vim/tmux layout rebalancing
  -- {'FocusLost,WinLeave,BufLeave * :silent! noautocmd w'}, -- auto save
  -- {'WinEnter,BufWinEnter *.vim,*.js,*.lua call hasan#boot#highligt_ruler(1)'},
  -- autocmd('VimEnter', 'runtime! autoload/netrw.vim', { once = true })
end)
