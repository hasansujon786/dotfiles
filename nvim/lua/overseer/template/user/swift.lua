-- Overseer template for Swift TUI / SPM projects (e.g. SwiftCade + SwiftTUI).
-- Usage: :OverseerRun -> "Swift run (SPM)" -> output opens in a vertical
-- terminal split, restarts automatically on :w.
return {
  name = 'Swift run (SPM)',
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

    -- Watch Sources + Package.swift so every :w restarts the TUI.
    -- NOTE: restart_on_save validates that paths exist, so filter here.
    local candidates
    if pkg_file then
      candidates = { root .. '/Sources', pkg_file }
    else
      candidates = { file }
    end
    local watch_paths = vim.tbl_filter(function(p)
      return p ~= '' and (vim.fn.filereadable(p) == 1 or vim.fn.isdirectory(p) == 1)
    end, candidates)
    if vim.tbl_isempty(watch_paths) then
      watch_paths = { root }
    end

    return {
      name = 'swift run',
      cwd = root,
      cmd = cmd,
      components = {
        -- Show result in a Neovim terminal split (interactive, TUI-friendly).
        -- No `on_output_quickfix` here on purpose: it would steal TUI output
        -- into the quickfix list and break rendering / keyboard input.
        -- NOTE: do NOT use builtin `open_output` with on_start=always here:
        -- it vsplits on every restart (core already reuses the window via
        -- replace_buffer_in_wins), which spams a new split per :w.
        { 'custom.open_output_once', direction = 'vertical', focus = false },
        { 'on_exit_set_status' },
        { 'on_complete_notify' },
        {
          'restart_on_save',
          paths = watch_paths,
          interrupt = true,
        },
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
