-- Overseer template for Swift TUI / SPM projects (e.g. SwiftCade + SwiftTUI).
-- Usage: :OverseerRun -> "Swift run (SPM, snacks, watch)" (or :SwiftRunSplit,
-- :SwiftRunSplit! for a floating window)
-- -> runs in a Snacks terminal (bottom split, no winbar), restarts
-- automatically on :w. Same style as M.terminal() in
-- nvim/lua/config/navigation/neo_tree/util.lua.
--
-- NOTE: restart_on_save can't be used here: Overseer can only restart the job
-- it owns, and the real process lives in Snacks.terminal. A BufWritePost
-- autocmd below replicates it (kill terminal buffer + reopen).
-- Closing the terminal (or :SwiftStop) stops the watch; further saves then
-- do nothing until the next manual run.
local state = { cmd = nil, root = nil, position = 'bottom' }

local function snacks_opts(root, position)
  return {
    cwd = root,
    -- Keep the window open on exit (like the old split did): you see the
    -- final output, and the next :w restarts. The Snacks default would
    -- auto-close the window on a clean exit instead.
    auto_close = false,
    -- Marker for :SwiftStop (see nvim/lua/config/testing/overseer.lua).
    env = { NVIM_SWIFT_SNACKS = 'watch' },
    -- Never steal insert mode: enter it explicitly when driving the TUI.
    auto_insert = false,
    start_insert = false,
    -- NOTE: bottom is explicit because Snacks defaults to 'float' when a
    -- cmd is given (M.terminal passes nil -> 'bottom').
    -- :SwiftRunSplit! selects 'float' via the position param.
    win = { position = position, wo = { winbar = '' } },
  }
end

---@param cmd_str string
---@param root string
---@return table|nil
local function find_term(cmd_str, root)
  if not (_G.Snacks and Snacks.terminal) then
    return nil
  end
  for _, term in ipairs(Snacks.terminal.list()) do
    local conf = term.buf and vim.b[term.buf].snacks_terminal
    if conf and conf.cmd == cmd_str and conf.cwd == root then
      return term
    end
  end
  return nil
end

local function stop_term(cmd_str, root)
  -- Loop: kill every match, so re-running (or switching position) never
  -- leaves a stale `swift run` behind. Replaces the old `unique` component.
  while true do
    local term = find_term(cmd_str, root)
    if not (term and term.buf and vim.api.nvim_buf_is_valid(term.buf)) then
      return
    end
    -- Wiping the terminal buffer kills its job.
    vim.api.nvim_buf_delete(term.buf, { force = true })
  end
end

local function open_term(cmd_str, root, position)
  -- Snacks focuses the new window; jump back so :w doesn't steal focus
  -- (the old vertical split used focus = false too).
  local cur_win = vim.api.nvim_get_current_win()
  Snacks.terminal(cmd_str, snacks_opts(root, position))
  if vim.api.nvim_win_is_valid(cur_win) then
    vim.api.nvim_set_current_win(cur_win)
  end
end

return {
  name = 'Swift run (SPM, snacks, watch)',
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

    local cmd_str = table.concat(vim.tbl_map(vim.fn.shellescape, cmd), ' ')
    local position = params.position == 'float' and 'float' or 'bottom'
    state.cmd, state.root, state.position = cmd_str, root, position

    -- Watch Sources + Package.swift so every :w restarts the TUI.
    local patterns
    if pkg_file then
      patterns = { root .. '/Sources/**', pkg_file }
    elseif file ~= '' then
      patterns = { file }
    else
      patterns = { root .. '/**' }
    end
    local group = vim.api.nvim_create_augroup('SwiftSnacksWatch', { clear = true })
    vim.api.nvim_create_autocmd('BufWritePost', {
      group = group,
      pattern = patterns,
      desc = 'Restart Swift Snacks terminal on save',
      callback = function()
        -- Guard: a later run for another project overwrites `state`.
        local saved = vim.fn.expand('<afile>:p')
        if state.root == nil or saved:sub(1, #state.root + 1) ~= state.root .. '/' then
          return
        end
        -- Only restart while the terminal is still around: closing it
        -- (or :SwiftStop) stops the watch until the next manual run.
        if find_term(state.cmd, state.root) then
          stop_term(state.cmd, state.root)
          open_term(state.cmd, state.root, state.position)
        end
      end,
    })

    -- Fresh start: kill any existing terminal for this cmd+root first, so
    -- re-running (or switching bottom/float) restarts instead of doubling.
    stop_term(cmd_str, root)
    open_term(cmd_str, root, position)

    -- Placeholder task: completes instantly. The real process lives in the
    -- Snacks terminal above, so do NOT put the swift cmd here or the app
    -- would run twice. A builder must still return a task definition
    -- (returning nil errors inside Overseer).
    return {
      name = 'swift run (snacks watch)',
      cmd = { 'true' },
      cwd = root,
      components = {
        -- No output/restart/notify components on purpose: the job is in
        -- Snacks (restart via the autocmd above), and notify would just
        -- spam success for `true`.
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
    position = {
      desc = 'Snacks terminal position (:SwiftRunSplit! selects float)',
      type = 'enum',
      choices = { 'bottom', 'float' },
      optional = true,
      default = 'bottom',
    },
  },
  condition = {
    filetype = { 'swift' },
  },
}
