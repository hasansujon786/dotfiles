if vim.fn.exists('g:hasan_telescope_buffers') == 0 then
  vim.g.hasan_telescope_buffers = { ['0'] = 0 } -- used in hasan#utils#_buflisted_sorted()
end

---@param path string
---@return boolean
local function is_doc_file(path)
  return (path:match('/nvim/') ~= nil or path:match('/nvim%-data/') ~= nil) and path:match('/doc/')
end

local function set_titlestring()
  -- vim.o.titlestring = '%= Neovim%<%='
  vim.schedule(function()
    vim.o.titlestring = '%= %{fnamemodify(getcwd(), ":t")}%<%=' -- what the title of the window will be set to
  end)
end

augroup('MY_AUGROUP')(function(autocmd)
  autocmd('CmdwinEnter', 'nnoremap <buffer><CR> <CR>')

  autocmd('FileType', 'setl foldlevel=0', { pattern = 'vim' })
  autocmd('FileType', 'setl foldmethod=marker', { pattern = { 'vim', 'css', 'scss', 'json' } })
  autocmd('FileType', 'setl foldmarker={,}', { pattern = { 'css', 'scss', 'json' } })
  autocmd('FileType', 'setl foldmarker={,}', { pattern = { 'css', 'scss', 'json' } })
  autocmd({ 'BufNewFile', 'BufRead' }, 'setl filetype=jsonc', { pattern = { '*.json', 'tsconfig.json' } })
  -- HELP_FILE
  autocmd({ 'BufNewFile', 'BufRead' }, function(info)
    if is_doc_file(info.match) then
      vim.bo.filetype = 'help'
    end
  end, { pattern = { '*.txt' } })
  autocmd('BufLeave', function(info)
    if is_doc_file(info.match) then
      vim.cmd([[normal! mK]])
    end
  end, { pattern = '*.txt' })

  autocmd('TextYankPost', function()
    vim.highlight.on_yank({ on_visual = true, higroup = 'Search', timeout = 200 })
  end)
  autocmd('TermOpen', 'setfiletype terminal | set bufhidden=hide')
  -- autocmd('BufWritePre', vim.fn['hasan#autocmd#trimWhitespace'], { pattern = { '*.vim', '*.lua', '*.org', '*.ahk' } })
  autocmd({ 'FocusGained', 'BufEnter', 'TermClose', 'TermLeave' }, ':silent! checktime')
  autocmd('BufWritePost', function()
    R('core.state')
    require('hasan.utils.reload').reload_app_state()
  end, { pattern = 'state.lua' })

  autocmd('BufDelete', 'silent! call remove(g:hasan_telescope_buffers, expand("<abuf>"))')
  autocmd({ 'BufWinEnter', 'WinEnter' }, 'let g:hasan_telescope_buffers[bufnr()] = reltimefloat(reltime())')

  autocmd('LspAttach', function(args)
    require('config.lsp.util.setup').lsp_attach(args)

    vim.defer_fn(set_titlestring, 10)
  end)
  -- autocmd('BufEnter', set_titlestring)
  autocmd('InsertEnter', function()
    vim.schedule(function()
      vim.cmd('nohlsearch')
    end)
  end)

  autocmd('BufReadPost', function(...)
    require('hasan.utils.win').restore_cussor_pos(...)
  end)
  -- Persist fold
  if require('core.state').ui.fold.persists then
    autocmd({ 'BufWinLeave', 'BufWritePost', 'WinLeave' }, function(args)
      if vim.b[args.buf].view_activated then
        vim.cmd.mkview({ mods = { emsg_silent = true } })
      end
    end, { desc = 'Save view with mkview for real files' })
    autocmd('BufWinEnter', function(args)
      if not vim.b[args.buf].view_activated then
        local filetype = vim.api.nvim_get_option_value('filetype', { buf = args.buf })
        local buftype = vim.api.nvim_get_option_value('buftype', { buf = args.buf })
        local ignore_filetypes = { 'gitcommit', 'gitrebase', 'svg', 'hgcommit' }
        if buftype == '' and filetype and filetype ~= '' and not vim.tbl_contains(ignore_filetypes, filetype) then
          vim.b[args.buf].view_activated = true
          vim.cmd.loadview({ mods = { emsg_silent = true } })
        end
      end
    end, { desc = 'Try to load file view if available and enable view saving for real files' })
  end

  -- local function reloadConfig(plugin)
  --   local rootHasPlugin = type(plugin[1]) == 'string'
  --   local rootHasConfig = type(plugin.config) == 'function'

  --   if rootHasPlugin and rootHasConfig then
  --     P(plugin[1] .. ' has config')
  --     plugin.config()
  --   else
  --     P(plugin[1] .. ' noooo config')
  --   end
  -- end

  -- autocmd('User', function(args)
  --   -- { buf = 24, event = "User", file = "LazyReload", group = 7, id = 22, match = "LazyReload" }
  --   local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(args.buf), ':p:~')
  --   path = path:gsub('~\\dotfiles\\nvim\\lua\\', '')
  --   -- file = file:gsub('~/dotfiles/nvim/lua/', '')
  --   path = path:gsub('.lua', '')
  --   path = path:gsub('\\', '.')

  --   local module = require(path)
  --   local rootHasListOfPlugin = vim.islist(module)

  --   if rootHasListOfPlugin then
  --     P('list ' .. #module .. ' of plugin')
  --     vim.defer_fn(function()
  --       for _, plugin in ipairs(module) do
  --         reloadConfig(plugin)
  --       end
  --     end, 1000)
  --   else
  --     P('root plugin')
  --     vim.defer_fn(function()
  --       reloadConfig(module)
  --     end, 1000)
  --   end
  -- end, { pattern = { 'LazyReload' } })

  -- autocmd('VimResized', 'wincmd =') -- Vim/tmux layout rebalancing
  -- {'FocusLost,WinLeave,BufLeave * :silent! noautocmd w'}, -- auto save
  -- {'WinEnter,BufWinEnter *.vim,*.js,*.lua call hasan#boot#highligt_ruler(1)'},
  -- autocmd('VimEnter', 'runtime! autoload/netrw.vim', { once = true })
end)
