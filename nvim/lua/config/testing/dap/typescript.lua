local M = {}

M.setup = function()
  local dap = require('dap')

  if not dap.adapters['pwa-node'] then
    require('dap').adapters['pwa-node'] = {
      type = 'server',
      host = 'localhost',
      port = '${port}',
      executable = {
        command = 'node',
        args = {
          mason_path .. '/js-debug-adapter/js-debug/src/dapDebugServer.js',
          '${port}',
        },
      },
    }
  end

  if not dap.adapters['node'] then
    dap.adapters['node'] = function(cb, config)
      if config.type == 'node' then
        config.type = 'pwa-node'
      end
      local nativeAdapter = dap.adapters['pwa-node']
      if type(nativeAdapter) == 'function' then
        nativeAdapter(cb, config)
      else
        cb(nativeAdapter)
      end
    end
  end

  if not dap.adapters['pwa-chrome'] then
    dap.adapters['pwa-chrome'] = {
      type = 'server',
      host = 'localhost',
      port = '${port}',
      executable = {
        command = 'node',
        args = {
          mason_path .. '/js-debug-adapter/js-debug/src/dapDebugServer.js',
          '${port}',
        },
      },
    }
  end

  -- Filetypes for JavaScript/TypeScript
  local js_filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'astro' }

  -- Update VSCode extensions for pwa-chrome
  local vscode = require('dap.ext.vscode')
  vscode.type_to_filetypes['node'] = js_filetypes
  vscode.type_to_filetypes['pwa-node'] = js_filetypes
  vscode.type_to_filetypes['pwa-chrome'] = js_filetypes

  -- Add pwa-chrome configurations for Next.js
  for _, language in ipairs(js_filetypes) do
    if not dap.configurations[language] then
      dap.configurations[language] = {}
    end

    local existing_configs = dap.configurations[language]
    local new_configs = {
      {
        type = 'pwa-chrome',
        request = 'launch',
        name = 'Launch Chrome (pwa-chrome)',
        url = 'http://localhost:3000',
        webRoot = '${workspaceFolder}',
        sourceMaps = true,
        trace = true,
        runtimeExecutable = 'C:/Program Files/Google/Chrome/Application/chrome.exe', -- Adjust path if needed
        runtimeArgs = {
          '--remote-debugging-port=9222',
          '--no-first-run',
          '--no-default-browser-check',
          -- '--user-data-dir=C:/Users/hasan/chrome-debug-profile', -- Separate profile
        },
        skipFiles = { '<node_internals>/**', 'node_modules/**' },
      },
      {
        type = 'pwa-chrome',
        request = 'attach',
        name = 'Attach to Chrome (pwa-chrome | WIP)',
        url = 'http://localhost:3000',
        webRoot = '${workspaceFolder}',
        sourceMaps = true,
        port = 9222,
        timeout = 30000,
        continueOnAttach = true,
        skipFiles = { '<node_internals>/**', 'node_modules/**' },
        -- Optional: Specify WebSocket URL if needed
        -- webSocketUrl = 'ws://localhost:9222/devtools/page/...' -- Replace with actual URL from http://localhost:9222/json
      },
    }

    if language == 'javascript' or language == 'typescript' then
      --  NOTE: Debug single node.js file
      table.insert(new_configs, {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch file (pwa-node)',
        program = '${file}',
        cwd = '${workspaceFolder}',
      })

      -- NOTE: Debug node.js processes (make sure to add --inspect when you run the process)
      table.insert(new_configs, {
        type = 'pwa-node',
        request = 'attach',
        name = 'Attach (pwa-node)',
        processId = require('dap.utils').pick_process,
        cwd = '${workspaceFolder}',
      })

      table.insert(new_configs, {
        name = 'Launch single file',
        type = 'pwa-node',
        request = 'launch',
        program = '${file}',
        cwd = '${workspaceFolder}',
        sourceMaps = true,
        protocol = 'inspector',
        console = 'integratedTerminal',
      })
    end

    -- Divider for the launch.json derived configs
    table.insert(new_configs, {
      name = '----- ↓ launch.json configs ↓ -----',
      type = '',
      request = 'launch',
    })

    -- Combine existing and new configurations
    dap.configurations[language] = vim.tbl_extend('force', existing_configs, new_configs)
  end
end

return M
