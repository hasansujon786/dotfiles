local dap = require('dap')

return {
  setup = function()
    dap.adapters.node2 = {
      type = 'executable',
      command = 'node',
      args = { dap_adapter_path .. '\\vscode-node-debug2\\out\\src\\nodeDebug.js' }, -- C:\Users\hasan\AppData\Local\nvim-data/dap_adapters/vscode-node-debug2\\out\\src\\nodeDebug.js'
    }
    dap.adapters.chrome = {
      type = 'executable',
      command = 'node',
      args = { dap_adapter_path .. '\\vscode-chrome-debug\\out\\src\\chromeDebug.js' }, -- C:\Users\hasan\AppData\Local\nvim-data/dap_adapters/vscode-chrome-debug/out/src/chromeDebug.js
    }

    dap.configurations.javascript = {
      {
        name = 'Launch javascript/node2',
        type = 'node2',
        request = 'launch',
        program = '${file}',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'inspector',
        console = 'integratedTerminal',
      },
      {
        name = 'Attach to javascript/node2',
        type = 'node2',
        request = 'attach',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        skipFiles = { '<node_internals>/**/*.js' },
        protocol = 'inspector',
      },
      -- {
      --   -- For this to work you need to make sure the node process is started with the `--inspect` flag.
      --   name = 'Attach to process with javascript/node2',
      --   type = 'node2',
      --   request = 'attach',
      --   processId = require('dap.utils').pick_process,
      -- },
      {
        name = 'Attach to javascript/chrome',
        type = 'chrome',
        request = 'attach',
        program = '${file}',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'inspector',
        port = 9222,
        webRoot = '${workspaceFolder}',
      },
    }

    dap.configurations.javascriptreact = { -- change this to javascript if needed
      {
        name = 'Launch javascriptreact/chrome',
        type = 'chrome',
        request = 'attach',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        program = '${file}',
        protocol = 'inspector',
        port = 9222,
        webRoot = '${workspaceFolder}',
        skipFiles = { '<node_internals>/**/*.js' },
      },
    }

    dap.configurations.typescriptreact = { -- change to typescript if needed
      {
        name = 'Launch typescriptreact/chrome',
        type = 'chrome',
        request = 'attach',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'inspector',
        webRoot = '${workspaceFolder}',
        program = '${file}',
        port = 9222,
        skipFiles = { '<node_internals>/**/*.js' },
      },
    }
  end,
}
