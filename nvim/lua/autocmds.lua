local utils = require('hasan.utils')
if vim.fn.exists('g:hasan_telescope_buffers') == 0 then
  vim.g.hasan_telescope_buffers = { ['0'] = 0 } -- hasan#utils#_buflisted_sorted()
end

local autocmds = {
  Telescope = {
    { 'BufWinEnter,WinEnter * let g:hasan_telescope_buffers[bufnr()] = reltimefloat(reltime())' },
    { 'BufDelete * silent! call remove(g:hasan_telescope_buffers, expand("<abuf>"))' },
  },
}

utils.create_augroups(autocmds)

local MY_AUGROUP = utils.augroup('MY_AUGROUP')
MY_AUGROUP(function(autocmd)
  autocmd('VimResized', 'wincmd =') -- Vim/tmux layout rebalancing
  autocmd('InsertEnter', 'norm zz')
  autocmd('CmdwinEnter', 'nnoremap <buffer><CR> <CR>')
  autocmd('TermOpen', 'setfiletype terminal | set bufhidden=hide')
  autocmd('VimEnter', 'runtime! autoload/netrw.vim', { once = true })
  autocmd('BufReadPost', vim.fn['hasan#autocmd#restore_position'])
  autocmd('BufWritePre', vim.fn['hasan#autocmd#trimWhitespace'], { pattern = { '*.vim', '*.lua', '*.org' } })
  autocmd('BufWritePost', 'source <afile> | PackerCompile ', { pattern = 'plugins.lua' })
  autocmd('CursorHold', require('hasan.utils.color').my_nebulous_setup, { once = true })
  autocmd('BufLeave', 'normal! mK', { pattern = '*.txt' })
  autocmd({ 'FocusGained', 'BufEnter', 'CursorHold' }, ':silent! checktime') -- Vim/tmux layout rebalancing
  -- -- {'FocusLost,WinLeave,BufLeave * :silent! noautocmd w'}, -- auto save
  -- {'WinEnter,BufWinEnter *.vim,*.js,*.lua call hasan#boot#highligt_ruler(1)'},

  autocmd('FileType', 'foldlevel=0', { pattern = 'vim ' })
  autocmd('FileType', 'setlocal foldmethod=marker', { pattern = { 'vim', 'css', 'scss', 'json' } })
  autocmd('FileType', 'setlocal foldmarker={,}', { pattern = { 'css', 'scss', 'json' } })
  autocmd('FileType', 'setlocal commentstring=//\\ %s', { pattern = 'dart' })
  autocmd({ 'BufWinEnter', 'WinEnter' }, 'normal Gzz', { pattern = '__FLUTTER_DEV_LOG__' })

  autocmd('User', 'lua ZoomPost()', { pattern = 'ZoomPost' })
  autocmd('User', 'lua vim.notify("Packer configuration recompiled")', { pattern = 'PackerCompileDone' })
  autocmd('User', vim.fn['hasan#highlight#load_custom_highlight'], { pattern = 'PackerCompileDone' })
  autocmd('ColorScheme', vim.fn['hasan#highlight#load_custom_highlight'])

  -- autocmd('BufDelete ', 'silent! call remove(g:hasan_telescope_buffers, expand("<abuf>"))')
  -- autocmd({ 'BufWinEnter', 'WinEnter' }, 'let g:hasan_telescope_buffers[bufnr()] = reltimefloat(reltime())')
end)
