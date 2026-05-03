return {
  name = 'C++ build & run',
  builder = function()
    local file = vim.fn.expand('%:p')
    local output = vim.fn.expand('%:p:r') -- file without extension

    return {
      cmd = {
        'bash',
        '-c',
        string.format("g++ -std=c++17 -Wall -O2 '%s' -o '%s' && '%s'", file, output, output),
      },
      components = {
        { 'on_output_quickfix', open = true },
        {
          'restart_on_save',
          paths = {
            file,
            -- vim.uv.cwd(),
          },
        },
        'default',
      },
    }
  end,
  condition = {
    filetype = { 'cpp' },
  },
}
