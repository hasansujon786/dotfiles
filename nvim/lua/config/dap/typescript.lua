-- Dap configs:
-- https://github.com/dreamsofcode-io/neovim-nodejs/blob/main/configs/dap.lua
-- https://github.com/perrin4869/dotfiles/blob/305f3abdebd49013368ca1b6c98db7abb9aa0849/home/.config/nvim/plugin/dap.lua
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
      -- Debug web applications (client side)
      {
        type = 'pwa-chrome',
        request = 'launch',
        name = 'Launch & Debug Chrome',
        -- port = 9222,
        url = function()
          local co = coroutine.running()
          return coroutine.create(function()
            vim.ui.input({
              prompt = 'Enter URL: ',
              default = 'http://localhost:3000',
            }, function(url)
              if url == nil or url == '' then
                return
              else
                coroutine.resume(co, url)
              end
            end)
          end)
        end,
        webRoot = '${workspaceFolder}', -- vim.fn.getcwd(),
        protocol = 'inspector',
        sourceMaps = true,
        userDataDir = false,
        -- runtimeArgs = { '--restore-last-session', '--remote-debugging-port=9222' },
        -- userDataDir = false,
        -- userDataDir = '${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir',
      },
      -- Debug web applications (run chrome with --remote-debugging-port=9222)
      {
        type = 'pwa-chrome',
        request = 'attach',
        name = 'Attach Chrome',
        program = '${file}',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        port = 9222,
        -- port = function() return vim.fn.input('Select port: ', 9222) end,
        webRoot = '${workspaceFolder}',
      },
      -- Debug express.js applications (run node with --inspect)
      {
        type = 'pwa-node',
        request = 'attach',
        name = 'Attach Node/Express',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'inspector',
        skipFiles = { '<node_internals>/**' },
      },
    }
  end
end

return M
