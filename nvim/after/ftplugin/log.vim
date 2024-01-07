if bufname() == '__FLUTTER_DEV_LOG__'
  nnoremap <buffer>r <cmd>FlutterReload<CR><cmd>lua vim.notify("FlutterReload")<CR>
  nnoremap <buffer>R <cmd>FlutterRestart<CR><cmd>lua vim.notify("FlutterRestart", vim.log.levels.WARN)<CR>
  nnoremap <buffer><BS> <Nop>
endif
