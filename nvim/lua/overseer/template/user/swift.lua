return {
  name = 'Swift run: file',
  builder = function()
    local file = vim.fn.expand('%:p')
    local output = vim.fn.expand('%:p:r') -- file without extension

    return {
      cmd = {
        'swift',
        file,
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
    filetype = { 'swift' },
  },
}
