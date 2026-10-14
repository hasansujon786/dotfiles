-- Overseer template for Swift SPM projects: manual `swift run` in a new tab.
-- Usage: :OverseerRun -> "Swift run (SPM, tab)".
-- No restart_on_save: runs only when you trigger it. Output opens in a tab
-- (reused on re-run, no tab spam) with focus so you land in the TUI.
return {
  name = 'Swift run (SPM, tab)',
  builder = function(params)
    params = params or {}
    local file = vim.fn.expand('%:p')
    local start_dir = file ~= '' and vim.fs.dirname(file) or vim.fn.getcwd()
    -- Find SPM package root (Package.swift) upward from current file, else cwd.
    local pkg_file = vim.fs.find('Package.swift', { upward = true, path = start_dir })[1]
    local root = pkg_file and vim.fs.dirname(pkg_file) or vim.fn.getcwd()

    local cmd
    if pkg_file then
      -- SPM project: `swift run` (interactive TUI needs a terminal, not quickfix).
      cmd = { 'swift', 'run' }
      if params.product and params.product ~= '' then
        vim.list_extend(cmd, { '--product', params.product })
      end
      if params.configuration and params.configuration ~= '' then
        vim.list_extend(cmd, { '-c', params.configuration })
      end
      if params.args and params.args ~= '' then
        -- allow extra args as a plain string, e.g. "--verbose"
        vim.list_extend(cmd, vim.split(params.args, '%s+', { trimempty = true }))
      end
    else
      -- Fallback: standalone single-file script outside a package.
      cmd = { 'swift', file }
    end

    return {
      name = 'swift run (tab)',
      cwd = root,
      cmd = cmd,
      components = {
        -- No `on_output_quickfix` on purpose (breaks TUI rendering/input).
        -- custom.open_output_once reuses the tab on re-run instead of
        -- opening a new tab each time like builtin open_output would.
        { 'custom.open_output_once', direction = 'tab', focus = true, close_on_exit = true },
        { 'on_exit_set_status' },
        { 'on_complete_notify' },
        { 'unique', soft = false },
      },
    }
  end,
  params = {
    product = {
      desc = 'SPM product/executable to run (empty = default)',
      type = 'string',
      optional = true,
      default = '',
    },
    configuration = {
      desc = 'Build configuration',
      type = 'enum',
      choices = { '', 'debug', 'release' },
      optional = true,
      default = '',
    },
    args = {
      desc = 'Extra args appended to `swift run` (as one string)',
      type = 'string',
      optional = true,
      default = '',
    },
  },
  condition = {
    filetype = { 'swift' },
  },
}
