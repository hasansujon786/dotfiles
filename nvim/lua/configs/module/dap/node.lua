return {
  setup = function(dap)
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

    -- INFO: For this to work you need to make sure
    -- Chrome is on port 9222 & the website is open (remote-debugging-port=9222 -- "%1")
    local chrome_attach = {
      name = 'Attach (Chrome)',
      type = 'chrome',
      request = 'attach',
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      program = '${file}',
      protocol = 'inspector',
      port = 9222,
      webRoot = '${workspaceFolder}',
      skipFiles = { '<node_internals>/**/*.js' },
    }

    local node_launch = {
      name = 'Launch (node2)',
      type = 'node2',
      request = 'launch',
      program = '${file}',
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = 'inspector',
      console = 'integratedTerminal',
    }
    -- INFO: For this to work you need to make sure
    -- the node process is started with the `--inspect` flag.
    local node_attach = {
      name = 'Attach (node2)',
      type = 'node2',
      request = 'attach',
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      skipFiles = { '<node_internals>/**/*.js' },
      protocol = 'inspector',
      --   processId = require('dap.utils').pick_process,
    }

    dap.configurations.javascript = { chrome_attach, node_launch, node_attach }
    dap.configurations.typescript = { chrome_attach, node_launch, node_attach }
    dap.configurations.javascriptreact = { chrome_attach }
    dap.configurations.typescriptreact = { chrome_attach }
  end,
}
