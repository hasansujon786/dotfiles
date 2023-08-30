-- https://github.com/anasrar/.dotfiles/blob/671c32cbf44d828e5b5128ada4f4637b58a0b792/neovim/.config/nvim/lua/rin/DAP/languages/typescript.lua
-- https://github.com/harrisoncramer/nvim/tree/main/lua/plugins/dap
local M = {}

M.setup = function(dap)
  -- local dap_utils = require('dap.utils')
  require('dap-vscode-js').setup({
    node_path = 'node',
    debugger_path = dap_adapter_path .. '\\vscode-js-debug',
    adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
  })

  local exts = {
    'javascript',
    'typescript',
    'javascriptreact',
    'typescriptreact',
    -- using pwa-chrome
    'vue',
    'svelte',
  }

  for _, ext in ipairs(exts) do
    dap.configurations[ext] = {
      {
        type = 'pwa-chrome',
        request = 'attach',
        name = 'Attach Program (pwa-chrome)',
        program = '${file}',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        port = 9222,
        -- port = function() return vim.fn.input('Select port: ', 9222) end,
        webRoot = '${workspaceFolder}',
      },
      {
        type = 'pwa-node',
        request = 'attach',
        port = 9222,
        name = 'Attach Program (pwa-node, select pid)',
        cwd = vim.fn.getcwd(),
        -- processId = dap_utils.pick_process,
        skipFiles = { '<node_internals>/**' },
      },
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch Current File (pwa-node)',
        cwd = vim.fn.getcwd(),
        args = { '${file}' },
        sourceMaps = true,
        protocol = 'inspector',
      },
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch Current File (pwa-node with ts-node)',
        cwd = vim.fn.getcwd(),
        runtimeArgs = { '--loader', 'ts-node/esm' },
        runtimeExecutable = 'node',
        args = { '${file}' },
        sourceMaps = true,
        protocol = 'inspector',
        skipFiles = { '<node_internals>/**', 'node_modules/**' },
        resolveSourceMapLocations = {
          '${workspaceFolder}/**',
          '!**/node_modules/**',
        },
      },
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch Current File (pwa-node with deno)',
        cwd = vim.fn.getcwd(),
        runtimeArgs = { 'run', '--inspect-brk', '--allow-all', '${file}' },
        runtimeExecutable = 'deno',
        attachSimplePort = 9229,
      },
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch Test Current File (pwa-node with jest)',
        cwd = vim.fn.getcwd(),
        runtimeArgs = { '${workspaceFolder}/node_modules/.bin/jest' },
        runtimeExecutable = 'node',
        args = { '${file}', '--coverage', 'false' },
        rootPath = '${workspaceFolder}',
        sourceMaps = true,
        console = 'integratedTerminal',
        internalConsoleOptions = 'neverOpen',
        skipFiles = { '<node_internals>/**', 'node_modules/**' },
      },
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch Test Current File (pwa-node with vitest)',
        cwd = vim.fn.getcwd(),
        program = '${workspaceFolder}/node_modules/vitest/vitest.mjs',
        args = { '--inspect-brk', '--threads', 'false', 'run', '${file}' },
        autoAttachChildProcesses = true,
        smartStep = true,
        console = 'integratedTerminal',
        skipFiles = { '<node_internals>/**', 'node_modules/**' },
      },
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch Test Current File (pwa-node with deno)',
        cwd = vim.fn.getcwd(),
        runtimeArgs = { 'test', '--inspect-brk', '--allow-all', '${file}' },
        runtimeExecutable = 'deno',
        attachSimplePort = 9229,
      },
      -- {
      --   type = "node2",
      --   request = "attach",
      --   name = "Attach Program (Node2)",
      --   processId = dap_utils.pick_process,
      -- },
      -- {
      --   type = "node2",
      --   request = "attach",
      --   name = "Attach Program (Node2 with ts-node)",
      --   cwd = vim.fn.getcwd(),
      --   sourceMaps = true,
      --   skipFiles = { "<node_internals>/**" },
      --   port = 9229,
      -- },
    }
  end
end

return M
