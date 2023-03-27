local M = {}

M.default = {
  init_wb_with_disabled = false,
  nb_is_disabled = false,
  is_win_blur_disabled = false,
  on_focus = nil,
  on_blur = nil,
  nb_blacklist_filetypes = {
    fern = true,
    NvimTree = true,
    fzf = true,
    floating = true,
    qf = true,
    scratchpad = true,
    NeogitStatus = true,
    NeogitPopup = true,
    log = true,
    flutterToolsOutline = true,
    packer = true,
    Outline = true,
    dashboard = true,
    alpha = true,
    floaterm = true,
    -- dap-float
    dapui_scopes = true,
    dapui_breakpoints = true,
    dapui_stacks = true,
    dapui_watches = true,
    dapui_console = true,
    ['dap-repl'] = true,
  },
  nb_blur_hls = {
    'LineNr:Nebulous',
    'LineNrAbove:Nebulous',
    'LineNrBelow:Nebulous',
    'Conceal:Nebulous',
    'IndentBlanklineChar:NebulousDarker',
    'GitGutterAdd:NebulousInvisibe',
    'GitGutterChange:NebulousInvisibe',
    'GitGutterDelete:NebulousInvisibe',
  },
  dynamic_rules = {
    active = nil,
    deactive = nil,
  },
}

M.options = M.default

M.updateConfigs = function(opts)
  M.options = opts
end

M.resume = function()
  M.options.is_win_blur_disabled = false
end

M.pause = function(time)
  M.options.is_win_blur_disabled = true

  if time ~= nil and time > 1 then
    vim.defer_fn(function()
      M.resume()
    end, time)
  end
end

return M
-- local nb_pre_exist_hls = {
--   floaterm = {'Normal:Floaterm', 'NormalNC:FloatermNC' }
-- }
