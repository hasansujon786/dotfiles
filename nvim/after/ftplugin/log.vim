if bufname() == '__FLUTTER_DEV_LOG__'
  nnoremap <nowait><buffer>r <cmd>FlutterReload<CR><cmd>lua vim.notify("FlutterReload")<CR>
  nnoremap <nowait><buffer>R <cmd>FlutterRestart<CR><cmd>lua vim.notify("FlutterRestart", vim.log.levels.WARN)<CR>
  "nnoremap <nowait><buffer>q <cmd>lua require("flutter-tools.commands").quit()<CR>
  "nnoremap <nowait><buffer>d <cmd>lua require("flutter-tools.commands").detach()<CR>

  "nnoremap <nowait><buffer>p <cmd>lua require("flutter-tools.commands").visual_debug()<CR>
  "nnoremap <nowait><buffer>P <cmd>lua require("flutter-tools.commands").performance_overlay()<CR>
  "nnoremap <nowait><buffer>S <cmd>lua require('config.lsp.servers.dartls.flutter_screenshot').screenshot()<CR>
  "nnoremap <nowait><buffer>i <cmd>lua require("flutter-tools.commands").inspect_widget()<CR>
  "nnoremap <nowait><buffer>g <cmd>lua require("flutter-tools.commands").generate()<CR>
  "nnoremap <nowait><buffer>v <cmd>lua require("flutter-tools.dev_tools").open_dev_tools()<CR>
  nnoremap <nowait><buffer>c <cmd>FlutterLogClear<CR>

  nnoremap <buffer><BS> <Nop>
endif
setlocal number norelativenumber signcolumn=no winfixheight
