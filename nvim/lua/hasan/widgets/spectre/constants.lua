local M = {}

M.hls = {
  window = {
    -- blend = 0,
    highlight = {
      -- FloatBorder = 'Normal',
      NormalFloat = 'NuiComponentsNormal',
      Cursorline = 'None',
    },
  },
  info_text_window = {
    highlight = {
      NormalFloat = 'NuiComponentsInfo',
      Cursorline = 'None',
    },
  },
}

M.popup_options = { zindex = 50 }

return M
