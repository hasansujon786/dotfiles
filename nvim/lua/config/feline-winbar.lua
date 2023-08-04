--xxxxxxxxxxxxxxxxxxxxxxx
local fileProvider = require('feline.providers.file')
local api = vim.api
local bo = vim.bo

local function clicable(text, lua_fn_name, arg)
  arg = arg and arg or 0
  return string.format('%%%s@v:lua.%s@%s%%X', arg, lua_fn_name, text)
end
local function withHl(text, hl)
  return string.format('%%#%s#%s', hl, text)
end

local icon = {
  bar = '▎',
  barEnd = '▕',
}

--@return: playground.lua, { hl = { fg = '#51a0cf' }, str = '' }
local function generateWinTab(isActive)
  local win = api.nvim_get_current_win()
  local dot = withHl(' ●', isActive and 'WinbarTabGreen' or 'WinbarTabMuted')
  local close = withHl(' ', 'WinbarTabItem')
  local f_name, f_icon = fileProvider.file_info({}, {
    file_modified_icon = '',
    file_readonly_icon = '',
    path_sep = '/',
  })
  local right_pad = '     '
  local left_pad = '     '

  -- Setup file
  local file = string.format(
    '%s%s',
    clicable(f_name .. right_pad, 'kissline_focus_win', win),
    clicable(bo.modified and dot or close, 'close_win', win)
  )

  -- Setup icon
  f_icon.str = clicable(left_pad .. f_icon.str, 'kissline_focus_win', win)
  if not isActive then
    f_icon.hl = {}
  end

  return file, f_icon
end

local hl_sections = {
  light_text = { fg = 'fg' },
  muted_text = { fg = 'muted' },
  muted_app_bg = { fg = 'olive', bg = 'app_bg' },
}

local w = {
  wintabProvider = function(isActive)
    return {
      provider = function()
        return generateWinTab(isActive)
      end,
      short_provider = ' ',
      hl = { bg = 'app_bg', fg = isActive and 'White' or 'muted', style = 'NONE' },
      left_sep = { str = icon.bar, hl = { bg = 'app_bg', fg = isActive and 'aqua' or 'app_bg' } },
      right_sep = { str = icon.barEnd, hl = { bg = 'app_bg', fg = 'darkest' } },
    }
  end,
  empty = {
    provider = '',
    short_provider = '',
    hl = { bg = 'bg_dark', fg = 'bg_dark' },
  },
  harpoon = {
    provider = function()
      local ok, harpoon_mark = pcall(require, 'harpoon.mark')

      if ok and harpoon_mark.status() ~= '' then
        return ok and 'H:' .. harpoon_mark.status()
      end
      return ''
    end,
    hl = hl_sections.muted_text,
    left_sep = ' ',
    right_sep = ' ',
  },
  NvimTree = {
    provider = '▎ EXPLORER',
    hl = hl_sections.muted_app_bg,
    left_sep = '',
    right_sep = { str = '', hl = hl_sections.muted_app_bg },
  },
  NvimTreeTools = {
    provider = function()
      return string.format(
        '%s %s %s %s',
        clicable(' ', 'explorer_new'),
        clicable(' ', 'explorer_refesh'),
        clicable(' ', 'explorer_collasp_all'),
        clicable(' ', 'explorer_menu', 3)
      )
    end,
    hl = hl_sections.muted_app_bg,
    left_sep = '',
    right_sep = { str = '', hl = hl_sections.muted_app_bg },
  },
}

require('feline').winbar.setup({
  components = {
    active = {
      {
        w.wintabProvider(true),
        w.empty,
      },
      {
        w.harpoon,
      },
    },
    inactive = {
      {
        w.wintabProvider(false),
        w.empty,
      },
    },
  },
  conditional_components = {
    {
      condition = function()
        return bo.filetype == 'NvimTree'
      end,
      active = {
        {
          w.NvimTree,
        },
        {
          w.NvimTreeTools,
        },
      },
      inactive = {
        {
          w.NvimTree,
        },
        {
          w.NvimTreeTools,
        },
      },
    },
    {
      condition = function()
        return bo.filetype == 'alpha'
      end,
      active = {},
      inactive = {},
    },
  },
})

_G.close_win = function(win, _, button, _)
  if button ~= 'l' then
    return
  end
  local ok_close = pcall(api.nvim_win_close, win, true)
  if not ok_close then
    local ok_quit = pcall(vim.cmd, 'quit')
    if not ok_quit then
      vim.notify('E37: Some file has not been saved since last change', vim.log.levels.WARN)
    end
  end
end
_G.kissline_focus_win = function(win, count, button, _)
  -- local rename = configs.options.actions.rename
  -- if button == 'l' and count == 2 and rename.eneble and utils.is_fn(rename.fn) then
  --   rename.fn(win)
  --   return
  -- end
  if button == 'l' and count == 1 then
    api.nvim_set_current_win(win)
  end
end
_G.explorer_new = function()
  require('nvim-tree.api').fs.create()
end
_G.explorer_refesh = function()
  require('nvim-tree.api').tree.reload()
end
_G.explorer_collasp_all = function()
  vim.cmd([[NvimTreeOpen]])
  require('hasan.utils.vinegar').actions.jump_to_root()
end
_G.explorer_menu = function(val)
  P('explorer_menu', val)
end
