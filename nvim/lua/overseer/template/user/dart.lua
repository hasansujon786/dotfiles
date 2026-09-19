local function is_fvm(root)
  return vim.uv.fs_stat(vim.fs.joinpath(root, '.fvm')) ~= nil
end

return {
  name = 'Dart run: file',
  builder = function()
    local file = vim.fn.expand('%:p')
    local root = vim.fs.dirname(vim.fs.find('pubspec.yaml', { upward = true })[1] or file)

    local cmd = {}
    if is_fvm(root) then
      cmd[#cmd + 1] = 'fvm'
    end
    vim.list_extend(cmd, { 'dart', 'run', file })

    return {
      cwd = root,
      cmd = cmd,
      components = {
        { 'on_output_quickfix', open = true },
        -- {
        --   'restart_on_save',
        --   paths = {
        --     file,
        --   },
        -- },
        'default',
      },
    }
  end,
  condition = {
    filetype = { 'dart' },
  },
}
