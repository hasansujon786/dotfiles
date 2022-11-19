local M = {}

M.default = {
  init_wb_with_disabled = false,
  on_focus = nil,
  on_blur = nil,
  nb_is_disabled = true,
  is_win_blur_disabled = true,
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
  },
  nb_blur_hls = {
    'LineNr:Nebulous',
    'LineNrAbove:Nebulous',
    'LineNrBelow:Nebulous',
    -- 'Normal:Nebulous',
    -- 'NormalNC:Nebulous',
  },
}

M.options = M.default

M.updateConfigs = function(opts)
  M.options = opts
end

return M
-- local nb_pre_exist_hls = {
--   floaterm = {'Normal:Floaterm', 'NormalNC:FloatermNC' }
-- }
