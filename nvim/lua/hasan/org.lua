local utils = require('hasan.utils')
local roam = require('org-roam')
local Layout = require('nui.layout')
local Popup = require('nui.popup')
-- local event = require('nui.utils.autocmd').event

local api = vim.api
if package.loaded['nvim-treesitter'] == nil then
  vim.cmd([[Lazy load nvim-treesitter]])
end

local M = {}

---------------- Org float state --------------------
local org_win_options = {
  winbar = '',
  number = true,
  relativenumber = true,
  numberwidth = 3,
  signcolumn = 'yes',
  statuscolumn = "%!v:lua.require'snacks.statuscolumn'.get()",
  winhighlight = 'Normal:Normal,FloatBorder:WinSeparator',
  winblend = 0,
  -- winhighlight = 'Normal:Normal,FloatBorder:WinSeparator,Folded:OrgHeadlineLevel1',
}
local org_home_path = org_root_path .. '/home.org'

_G.org_on_VimResized = nil
local state = {
  layout = nil,
  win_pop = nil,
  win_bufnr = nil,
}

local org_utils = {
  ---@param file string
  ---@param cmd? "split"|"vsplit"|"edit"
  open_file = function(file, cmd)
    vim.cmd({ cmd = cmd or 'edit', args = { file }, bang = true })
  end,
  add_file_to_buflist = function(filename)
    local set_position = false
    filename = vim.fn.fnameescape(filename)
    local bufnr = vim.fn.bufnr(filename)

    if bufnr == -1 then
      set_position = true
      bufnr = vim.fn.bufnr(filename, true)
    end
    if not api.nvim_buf_is_loaded(bufnr) then
      vim.fn.bufload(bufnr)
      api.nvim_set_option_value('buflisted', true, { buf = bufnr })
    end
    return bufnr, set_position
  end,
  set_winbar = function()
    vim.wo.winbar = '%{%v:lua.require("hasan.org").winbar()%}'
  end,
  is_cur_win_org_float = function()
    return utils.is_floating_win(0) and vim.bo.filetype == 'org'
  end,
  unmount_win = function()
    if state.layout then
      state.layout:unmount()
    end
    state.win_pop = nil
    state.layout = nil
    _G.org_on_VimResized = nil
    vim.cmd([[
      augroup OrgFloatWin
        au!
      augroup END
      ]])
  end,
  create_popup = function(bufnr, title)
    local pop_config = {
      side = {
        border = 'none',
        focusable = false,
        zindex = 49,
        win_options = { winhighlight = 'Normal:Normal' },
      },
      main = {
        bufnr = bufnr,
        zindex = 49,
        relative = 'editor',
        enter = true,
        focusable = true,
        border = {
          text = { top = title },
          style = { '│', ' ', '│', '│', '│', ' ', '│', '│' },
        },
        win_options = org_win_options,
        -- position = {
        --   row = '40%',
        --   col = '50%',
        -- },
        -- size = {
        --   width = '80%',
        --   height = '70%',
        -- },
        -- buf_options = { modifiable = true, readonly = false, },
      },
    }

    local pop_main = Popup(pop_config.main)
    -- if not fullscreen then
    --   return pop_main, pop_main
    -- end

    local pop_left, pop_right = Popup(pop_config.side), Popup(pop_config.side)
    local panes = Layout.Box({
      Layout.Box(pop_left, { size = '15%' }),
      Layout.Box(pop_main, { size = '70%' }),
      Layout.Box(pop_right, { size = '16%' }),
    }, { dir = 'row' })

    local layout = Layout({
      relative = 'editor',
      position = {
        row = 0,
        col = 0,
      },
      size = {
        width = '100%',
        height = vim.o.lines - 1,
      },
    }, panes)

    _G.org_on_VimResized = function()
      layout:update(Layout.Box(panes, { dir = 'row' }))
    end

    return layout, pop_main
  end,
  get_title_text = function(bufnr)
    return vim.fn.fnamemodify(api.nvim_buf_get_name(bufnr), ':t')
  end,
}

local function capture_project_file(title, config_file_exists, config_file)
  roam.api
    .capture_node({
      title = title,
      -- immediate = {
      --   template = '%?',
      --   target = 'hasan-%<%Y%m%d>-' .. title .. '.org',
      -- },
      templates = {
        p = {
          description = 'Create project',
          template = '#+category: project\n\n%?',
          target = '1_projects/%<%Y%m%d%H%M%S>-%[slug].org',
        },
      },
    })
    :next(function(id)
      if id then
        roam.database:get(id):next(function(new_node)
          if new_node then
            org_utils.open_file(new_node.file, 'vsplit')
            -- create config
            if not config_file_exists then
              config_file:touch()
            end

            local ok, result = pcall(vim.fn.writefile, { vim.json.encode({ id = id }) }, config_file.filename)
            if ok then
              vim.notify('Wrote ' .. config_file.filename, vim.log.levels.INFO, { title = 'org-roam' })
            else
              print(result)
            end
          end
        end)
      end
    end)
end

function M.open_org_home()
  org_utils.open_file(org_home_path)
end

function M.open_org_project()
  local file_util = require('hasan.utils.file')
  local cwd = vim.uv.cwd()
  local config_file_exists, config_file = file_util.path_exists('.project.json', cwd)

  if config_file_exists then
    local data = vim.fn.readfile(config_file.filename)
    local json = vim.json.decode(data[1])
    if json and json.id then
      roam.database:get(json.id):next(function(node)
        if node then
          org_utils.open_file(node.file, 'vsplit')
        elseif not node then
          vim.notify('No file found with follwing Id', vim.log.levels.ERROR, { title = 'org-roam' })
          local title = vim.fn.fnamemodify(cwd, ':t')
          capture_project_file(title, config_file_exists, config_file)
        end
      end)
    end
  end

  if not config_file_exists then
    local title = vim.fn.fnamemodify(cwd, ':t')
    capture_project_file(title, config_file_exists, config_file)
  end
end

function M.open_org_float(filename)
  org_utils.unmount_win()

  local bufnr
  if state.win_bufnr == nil then
    bufnr = require('hasan.utils.buffer').add_file_to_buflist(filename or org_home_path)
  else
    bufnr = state.win_bufnr
  end

  local layout, pop_main = org_utils.create_popup(bufnr, org_utils.get_title_text(bufnr))
  -- pop_main:map('n', '<leader>q', org_utils.unmount_win, {})

  layout._.float.win_options = { winblend = 0, winhighlight = 'Normal:Normal' }
  layout:mount()

  require('hasan.utils.win').restore_cussor_pos({ buf = bufnr })

  vim.cmd([[
    augroup OrgFloatWin
      au!
      au WinEnter,BufWinEnter,BufEnter *.org lua require('hasan.org').org_on_WinEnter()
      au WinLeave *.org lua require('hasan.org').org_on_WinLeave()
      au VimResized * lua _G.org_on_VimResized()
    augroup END
    ]])

  state = { layout = layout, win_pop = pop_main, win_bufnr = bufnr }
end

function M.toggle_org_float()
  if org_utils.is_cur_win_org_float() or state.layout ~= nil then
    org_utils.unmount_win()
  else
    M.open_org_float()
  end
end

-- keymap('n', '<leader>e', M.toggle_org_float)

function M.org_on_WinEnter()
  if org_utils.is_cur_win_org_float() and state.win_pop ~= nil then
    local bufnr = api.nvim_get_current_buf()
    state.win_pop.border:set_text('top', org_utils.get_title_text(bufnr), 'center')

    for key, value in pairs(org_win_options) do
      vim.wo[key] = value
    end
    state.win_bufnr = bufnr
  end
end

function M.org_on_WinLeave()
  vim.schedule(function()
    -- don't close for float win like Telescope, Diagnostic etc.
    if utils.is_floating_win(0) then
      return
    end
    org_utils.unmount_win()
  end)
end

-- ------------------------------------------------
-- => create org note
-- ------------------------------------------------
function M.create_link()
  local link = vim.fn.expand('<cWORD>')
  vim.cmd('normal! "_diW')

  vim.schedule(function()
    local line = string.format('[[%s][]]', link)
    api.nvim_put({ line }, 'v', true, true)

    local pos = api.nvim_win_get_cursor(0)
    pos[2] = pos[2] - 1
    api.nvim_win_set_cursor(0, pos)
    vim.cmd('startinsert')
  end)
end

function M.create_link_visual()
  local partial_link = require('hasan.utils').get_visual_selection()
  local full_link = vim.fn.expand('<cWORD>')
  vim.cmd('normal! "_diW')

  vim.schedule(function()
    local line = string.format('[[%s][%s]]', full_link, partial_link)
    api.nvim_put({ line }, 'v', true, true)
  end)
end

return M
