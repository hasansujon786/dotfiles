if vim.fn.exists('g:hasan_telescope_buffers') == 0 then
  vim.g.hasan_telescope_buffers = { ['0'] = 0 } -- used in hasan#utils#_buflisted_sorted()
end

augroup('MY_AUGROUP')(function(autocmd)
  autocmd('CmdwinEnter', 'nnoremap <buffer><CR> <CR>')

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
  autocmd({ 'FocusGained', 'BufEnter', 'TermClose', 'TermLeave' }, ':silent! checktime')
  autocmd('BufReadPost', function()
    require('hasan.utils.win').restore_cussor_pos()
  end)
  autocmd('BufWritePost', function()
    R('core.state', 'Config reloaded')
    vim.defer_fn(function()
      require('hasan.utils.reload').reload_app_state()
    end, 300)
  end, { pattern = 'state.lua' })

  autocmd('BufDelete', 'silent! call remove(g:hasan_telescope_buffers, expand("<abuf>"))')
  autocmd({ 'BufWinEnter', 'WinEnter' }, 'let g:hasan_telescope_buffers[bufnr()] = reltimefloat(reltime())')

  autocmd('LspAttach', function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    require('config.lsp.util.extras').get_setup_opts().onLspAttach(client, args.buf)
  end)

  -- autocmd('VimResized', 'wincmd =') -- Vim/tmux layout rebalancing
  -- {'FocusLost,WinLeave,BufLeave * :silent! noautocmd w'}, -- auto save
  -- {'WinEnter,BufWinEnter *.vim,*.js,*.lua call hasan#boot#highligt_ruler(1)'},
  -- autocmd('VimEnter', 'runtime! autoload/netrw.vim', { once = true })
end)
-- local view_group = augroup("auto_view", { clear = true })
-- autocmd({ "BufWinLeave", "BufWritePost", "WinLeave" }, {
--   desc = "Save view with mkview for real files",
--   group = view_group,
--   callback = function(args)
--     if vim.b[args.buf].view_activated then vim.cmd.mkview { mods = { emsg_silent = true } } end
--   end,
-- })
-- autocmd("BufWinEnter", {
--   desc = "Try to load file view if available and enable view saving for real files",
--   group = view_group,
--   callback = function(args)
--     if not vim.b[args.buf].view_activated then
--       local filetype = vim.api.nvim_get_option_value("filetype", { buf = args.buf })
--       local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })
--       local ignore_filetypes = { "gitcommit", "gitrebase", "svg", "hgcommit" }
--       if buftype == "" and filetype and filetype ~= "" and not vim.tbl_contains(ignore_filetypes, filetype) then
--         vim.b[args.buf].view_activated = true
--         vim.cmd.loadview { mods = { emsg_silent = true } }
--       end
--     end
--   end,
-- })
