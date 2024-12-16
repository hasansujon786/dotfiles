" Editor
command! -bang Delview call hasan#utils#delete_view(<q-bang>)
command! -bang Quit call hasan#utils#confirmQuit(<q-bang>)
command! ClearRegister call hasan#utils#clear_register()
command! ProjectCommands lua require("telescope._extensions").manager.project_commands.commands()
command! Messages NoiceHistory
" File
command! ReloadConfig lua require('hasan.utils.file').reload()
command! CodeOpenFile lua require('hasan.utils.file').openInCode(true)
command! CodeOpenCwd lua require('hasan.utils.file').openInCode(false)
command! -bang -nargs=1 -complete=file Fedit lua require("hasan.float").fedit(<f-args>)
command! LuaSnipEdit lua require("luasnip.loaders").edit_snippet_files()
command! Log edit $NVIM_LOG_FILE
" Lsp
command! LspInstallEssentials lua require('config.lsp.util.extras').install_essential_servers()
command! SkipAutoFormatSave silent noa write

" Move VISUAL LINE selection within buffer.
command! -range MoveUp call v:lua.require('hasan.utils.buffer').move_up(<line1>)
command! -range MoveDown call v:lua.require('hasan.utils.buffer').move_down(<line2>)

" fix-current-world
nmap <silent> <Plug>(fix-current-world) :call hasan#repeat#fix_word()<CR>
" exchange-operator
nnoremap <silent><Plug>(exchange-operator)  :set opfunc=exchange_operator#_opfunc<CR>g@
vnoremap <silent><Plug>(exchange-operator)  :<C-U>call exchange_operator#_opfunc(visualmode())<CR>
" dial
nmap  <C-a>  <Plug>(dial-increment)
nmap  <C-x>  <Plug>(dial-decrement)
vmap  <C-a>  <Plug>(dial-increment)
vmap  <C-x>  <Plug>(dial-decrement)
nmap g<C-a> g<Plug>(dial-increment)
nmap g<C-x> g<Plug>(dial-decrement)
vmap g<C-a> g<Plug>(dial-increment)
vmap g<C-x> g<Plug>(dial-decrement)
