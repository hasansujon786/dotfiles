local mingw_gpp = vim.fn.expand('$USERPROFILE') .. '/scoop/apps/mingw/current/bin/g++.exe'

-- # file: C:/Users/hasan/AppData/Local/clangd/config.yaml
-- CompileFlags:
--   Compiler: C:/Users/hasan/scoop/apps/mingw/current/bin/g++.exe

-- cmake -S . -B build -G "MinGW Makefiles" -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
-- ln -s build/compile_commands.json compile_commands.json

---@module "vim.lsp.client"
---@class vim.lsp.ClientConfig
return {
  cmd = {
    'clangd',
    '--query-driver=' .. mingw_gpp,
    '--clang-tidy',
  },
}
