local M = {}

M.default = {
  init_wb_with_disabled = false,
  nb_is_disabled = false,
  is_win_blur_disabled = false,
  on_focus = nil,
  on_blur = nil,
  blacklist_ft = {
    'fern',
    'NvimTree',
    'neo-tree',
    'fzf',
    'floating',
    'qf',
    'scratchpad',
    'NeogitStatus',
    'NeogitPopup',
    'log',
    'flutterToolsOutline',
    'packer',
    'Outline',
    'dashboard',
    'alpha',
    'floaterm',
    'noice',
    'query',
    'dapui_scopes',
    'dapui_breakpoints',
    'dapui_stacks',
    'dapui_watches',
    'dapui_console',
    'dap-repl',
    -- dap-float
  },
  nb_blur_hls = {
    -- numbers
    'LineNr:Nebulous',
    'LineNrAbove:Nebulous',
    'LineNrBelow:Nebulous',
    -- Other highlights
    'Conceal:Nebulous',
    'NonText:Nebulous',
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
