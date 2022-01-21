local utils = require('hasan.utils')
local treesitter_foldtext_filetypes = 'javascript,typescript,typescript.tsx,typescriptreact,json,lua,vue'
if vim.fn.exists('g:hasan_telescope_buffers') == 0 then
  vim.g.hasan_telescope_buffers = {['0']=0} -- hasan#utils#_buflisted_sorted()
end

local autocmds = {
  vimrcEx = {
    {'InsertEnter * norm zz'}, -- center document
    {'VimResized * :wincmd ='}, -- Vim/tmux layout rebalancing
    {'FocusGained,BufEnter,CursorHold * :silent checktime'}, -- auto read when a file is changed from the outside
    -- {'FocusLost,WinLeave,BufLeave * :silent! noautocmd w'}, -- auto save
    {'BufWritePre *.vim,*.lua call hasan#autocmd#trimWhitespace()'},
    {'BufWinEnter,WinEnter __FLUTTER_DEV_LOG__ normal Gzz'},
    {'BufReadPost * call hasan#autocmd#restore_position()'},
    {'TermOpen * setfiletype terminal | set bufhidden=hide'},
    {'ColorScheme * call hasan#highlight#load_custom_highlight()'},

    {'VimEnter * ++once runtime! autoload/netrw.vim'},

    -- {'WinEnter,BufWinEnter *.vim,*.js,*.lua call hasan#boot#highligt_ruler(1)'},
  },
  FileMarks = {
    {'BufLeave *.html normal! mH'},
    {'BufLeave *.js   normal! mJ'},
    {'BufLeave *.ts   normal! mT'},
    {'BufLeave *.vim  normal! mV'},
    {'BufLeave *.css  normal! mC'},
    {'BufLeave *.txt  normal! mK'},
  },
  Fold = {
    {'FileType vim setlocal foldlevel=0'},
    {'FileType vim,css,scss,json setlocal foldmethod=marker'},
    {'FileType css,scss,json setlocal foldmarker={,}'},
    {'FileType', treesitter_foldtext_filetypes, 'setl foldmethod=expr'},
    {'FileType', treesitter_foldtext_filetypes, 'call timer_start(10, function("hasan#utils#treesitter_fold"))'}
  },
  Telescope = {
    {'BufWinEnter,WinEnter * let g:hasan_telescope_buffers[bufnr()] = reltimefloat(reltime())'},
    {'BufDelete * silent! call remove(g:hasan_telescope_buffers, expand("<abuf>"))'}
  },
  Nebulous = {}
  -- {"BufEnter term://* setlocal nonumber norelativenumber"};
}

if not vim.g.bg_tranparent then
  table.insert(autocmds.Nebulous, {{'CursorHold * ++once lua require("nebulous").active()'}})
end

utils.create_augroups(autocmds)

