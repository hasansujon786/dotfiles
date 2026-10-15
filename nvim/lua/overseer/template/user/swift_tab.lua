-- Overseer template for Swift SPM projects: manual `swift run` in Snacks.terminal.
-- Usage: :OverseerRun -> "Swift run (SPM, snacks)" (or :SwiftRunTab).
-- No restart_on_save: runs only when you trigger it. The real process runs in
-- a Snacks terminal (bottom split, no winbar), same style as M.terminal() in
-- nvim/lua/config/navigation/neo_tree/util.lua.
return {
  name = 'Swift run (SPM, snacks)',
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

    -- Run it in Snacks.terminal, same style as M.terminal() in
    -- nvim/lua/config/navigation/neo_tree/util.lua (no winbar).
    -- NOTE: `position = 'bottom'` is explicit because Snacks defaults to
    -- 'float' when a cmd is given (M.terminal passes nil, which defaults to
    -- 'bottom'). Snacks toggles by cmd: re-running focuses/hides this same
    -- terminal instead of spawning a duplicate.
    local cmd_str = table.concat(vim.tbl_map(vim.fn.shellescape, cmd), ' ')
    Snacks.terminal(cmd_str, {
      cwd = root,
      win = { position = 'float', wo = { winbar = '' } },
    })

    -- Placeholder task: completes instantly. The real process lives in the
    -- Snacks terminal above, so do NOT put the swift cmd here or the app
    -- would run twice. A builder must still return a task definition
    -- (returning nil errors inside Overseer).
    return {
      name = 'swift run (snacks)',
      cmd = { 'true' },
      cwd = root,
      components = {
        -- No output component on purpose: nothing to show, job is in Snacks.
        -- No `on_complete_notify` either: it would spam success for `true`.
        { 'unique', soft = false },
        { 'on_exit_set_status' },
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
