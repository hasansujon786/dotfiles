command! -bang Delview call hasan#utils#delete_view(<q-bang>)
command! -bang Quit call hasan#utils#confirmQuit(<q-bang>)
command! ClearRegister call hasan#utils#clear_register()
command! LspLogPath lua vim.cmd('edit '..vim.lsp.get_log_path())
command! LspInstallEssentials lua require('config.module.lspconfig.util').install_essential_servers()
command! LuaSnipEdit lua require("luasnip.loaders").edit_snippet_files()
command! ProjectCommands lua require("telescope._extensions").manager.project_commands.commands()
command! Messages NoiceHistory
nmap <silent> <Plug>(fix-current-world) :call hasan#repeat#fix_word()<CR>
" File
command! ReloadConfig lua require('hasan.utils.file').reload()
command! CodeOpenFile lua require('hasan.utils.file').openInCode(true)
command! CodeOpenCwd lua require('hasan.utils.file').openInCode(false)
command! -bang -nargs=1 -complete=file Fedit lua require("hasan.float").fedit(<f-args>)

