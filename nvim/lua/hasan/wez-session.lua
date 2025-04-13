local Popup = require('nui.popup')
local NuiLine = require('nui.line')
local NuiText = require('nui.text')
local state_path = vim.fs.normalize(vim.fn.expand('~')) .. '/dotfiles/gui/wezterm/wezterm-session-manager/state'
-- local path = 'C:/Users/hasan/dotfiles/gui/wezterm/wezterm-session-manager/state/klark-app.json'

---@class lsp.ServerConfig
---@field float? NuiPopup
---@field render_positons? Render_positons[]
local M = {
  render_positons = {},
}

---@param texts NuiText[]
---@param bufnr number
---@param ns_id number
---@param line_start number
---@return number
local render_line = function(texts, bufnr, ns_id, line_start)
  local line = NuiLine(texts)
  line:render(bufnr, ns_id, line_start)
  return line_start + 1
end

local function parse_pane_data()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false) -- Read all buffer lines

  ---@type WezTermAppStateParsed
  local wezterm_form_state = { tabs = {} }
  ---@type TabParsed
  local current_tab = nil

  for line_index, line in ipairs(lines) do
    -- Tab: 4 (Active:6)
    local tab_index = line:match('Tab:%s+(%d+)')

    if tab_index then
      local is_active = line:find('%(Active:') ~= nil
      local tab_id = line:match(':(%d+)%)')
      current_tab = {
        tab_id = tab_id,
        is_active = is_active,
        panes = {},
      }
      table.insert(wezterm_form_state.tabs, current_tab)
      goto continue -- Skip
    end

    -- Match "Id:" pane lines
    local pane_id = line:match('ID:%s*(%d+)')
    if pane_id and current_tab then
      local has_asterisk = lines[line_index - 1]:match('%[.-%]%*') ~= nil -- [1]*
      table.insert(current_tab.panes, { pane_id = pane_id, is_active = has_asterisk })
      goto continue -- Skip
    end

    -- Match "Dir:" pane lines
    local cwd = line:match('Dir:%s*(.-)%s*$')
    if cwd and current_tab then
      cwd = 'file:///' .. vim.fs.normalize(cwd) -- Convert Windows path to file URI format
      current_tab.panes[#current_tab.panes].cwd = cwd
      goto continue -- Skip
    end

    -- -- Match "Size:" lines
    -- local width, height = line:match('Size:%s*(%d+)x(%d+)')
    -- if width and height and current_tab then
    --   current_tab.panes[#current_tab.panes].width = tonumber(width)
    --   current_tab.panes[#current_tab.panes].height = tonumber(height)
    -- end

    -- Match "Action:" lines
    local action = line:match('Action:%s*(.-)%s*$')
    if action and current_tab then
      current_tab.panes[#current_tab.panes].action = action
      goto continue -- Skip
    end

    ::continue:: -- Label to jump here
  end

  return wezterm_form_state
end

local utils = {
  ---@param line string
  ---@return boolean
  is_cursor_on_tab = function(line)
    return line:match('Tab:') == 'Tab:'
  end,
  ---@return number
  get_current_tab_index = function()
    local cursor_line = vim.api.nvim_win_get_cursor(M.float.winid)[1]
    if M.render_positons == nil then
      return 0
    end

    local current_tab_idx = 1
    for tab_idx, tab in ipairs(M.render_positons) do
      if cursor_line >= tab.line_nr then
        current_tab_idx = tab_idx
      end
    end

    return current_tab_idx
  end,
  toggle_tab_active = function(text, line_nr)
    local is_active = text:find('%(Active:')
    local new_status = is_active and text:gsub('%(Active:', '(:') or text:gsub('%(:', '(Active:')

    render_line({ NuiText(new_status, 'WezTab') }, 0, -1, line_nr)
  end,
  toggle_pane_active = function(line, line_nr)
    local is_active = line:match('%[%d+%]%*') ~= nil
    local updated_line = is_active and line:gsub('%]%*', ']') or line:gsub('%]', ']*')

    render_line({ NuiText(updated_line) }, 0, -1, line_nr)
  end,
  list_files = function(directory)
    local files = {}
    local handle = vim.uv.fs_scandir(directory)
    if handle then
      while true do
        local name, type = vim.uv.fs_scandir_next(handle)
        if not name then
          break
        end
        if type == 'file' and name ~= '.gitkeep' then
          table.insert(files, name)
        end
      end
    end
    return files
  end,

  ---@param wezterm_state WezTermAppState
  ---@return WezTermAppState
  update_state = function(wezterm_state)
    local parsed_data = parse_pane_data()

    ---@type WezTermAppState
    local new_state = {
      name = wezterm_state.name,
      size = wezterm_state.size,
      tabs = {},
    }

    for tab_index, tab_parsed in ipairs(parsed_data.tabs) do
      if tab_parsed.tab_id == wezterm_state.tabs[tab_index].tab_id then
        local updated_tab = wezterm_state.tabs[tab_index]
        updated_tab.is_active = tab_parsed.is_active

        for pane_index, pane_parsed in ipairs(tab_parsed.panes) do
          if vim.trim(pane_parsed.action) ~= '' then
            -- update pane action,cwd
            updated_tab.panes[pane_index].action = pane_parsed.action
            updated_tab.panes[pane_index].cwd = pane_parsed.cwd
            updated_tab.panes[pane_index].is_active = pane_parsed.is_active
          end
        end
        new_state.tabs[tab_index] = updated_tab
      end
    end

    return new_state
  end,
}

local actions = {
  write_state = function(file_path, data)
    -- Write JSON string to a file
    local file = io.open(file_path, 'w') -- Open file in write mode
    if file then
      local json_string = vim.fn.json_encode(data)
      file:write(json_string) -- Write the JSON string to the file
      file:close() -- Close the file
    end
  end,
  close_win = function()
    M.float:unmount()
    M.render_positons = {}
  end,
  jump_next_tab = function()
    local positions = M.render_positons
    if positions == nil then
      return
    end

    local current_tab_idx = utils.get_current_tab_index()

    local next_tab = positions[current_tab_idx + 1] and positions[current_tab_idx + 1] or positions[1]
    vim.api.nvim_win_set_cursor(M.float.winid, { next_tab.line_nr, 0 })
    feedkeys('zt', 'n')
  end,
  jump_prev_tab = function()
    local positions = M.render_positons
    if positions == nil then
      return
    end

    local current_tab_idx = utils.get_current_tab_index()

    local next_tab = positions[current_tab_idx - 1] and positions[current_tab_idx - 1] or positions[#positions]
    vim.api.nvim_win_set_cursor(M.float.winid, { next_tab.line_nr, 0 })
    feedkeys('zt', 'n')
  end,
  jump_to_pane = function(pane_idx)
    local current_tab_idx = utils.get_current_tab_index()
    local pane = M.render_positons[current_tab_idx].panes[pane_idx]
    if pane and type(pane.line_nr) == 'number' then
      vim.api.nvim_win_set_cursor(M.float.winid, { pane.line_nr, 0 })
    end
  end,
  toggle_action_status = function()
    local line = vim.api.nvim_get_current_line()
    local cursor = vim.api.nvim_win_get_cursor(0)

    local cursor_on_tab = utils.is_cursor_on_tab(line)
    if cursor_on_tab then
      return utils.toggle_tab_active(line, cursor[1])
    end

    local cursor_on_pane = line:match('%[%d+%]') ~= nil
    if cursor_on_pane then
      return utils.toggle_pane_active(line, cursor[1])
    end
  end,
}

local function create_floating_win(state_file)
  ---@type WezTermAppState
  local wezterm_state = vim.fn.json_decode(vim.fn.readfile(state_file))

  local float = Popup({
    enter = true,
    focusable = true,
    border = { padding = { 0, 2 } },
    win_options = { winhighlight = 'Normal:LazyNormal' },
    position = '50%',
    size = { width = 0.6, height = 0.6 },
  })

  local width = float.win_config.width
  local bufnr, ns_id, linenr_start = float.bufnr, -1, 1

  for tab_index, tab in ipairs(wezterm_state.tabs) do
    local tab_label = string.format(' Tab: %s (%s:%d)', tab_index, tab.is_active and 'Active' or '', tab.tab_id)

    ---@type Render_positons
    local record_position = { is_active = false, line_nr = 0, panes = {} }

    linenr_start = render_line({ NuiText(string.rep('▁', width), 'WezTabBorder') }, bufnr, ns_id, linenr_start)
    local tab_sp = NuiText(string.rep(' ', width), 'WezTab')
    linenr_start = render_line({ NuiText(tab_label, 'WezTab'), tab_sp }, bufnr, ns_id, linenr_start)
    record_position.line_nr = linenr_start - 1
    record_position.is_active = tab.is_active
    linenr_start = render_line({ NuiText(string.rep('▔', width), 'WezTabBorder') }, bufnr, ns_id, linenr_start)


    -- stylua: ignore
    for pane_index, pane in ipairs(tab.panes) do
      linenr_start = render_line({ NuiText(string.format(' [%s]', pane_index)), NuiText(pane.is_active and '*' or '', 'Constant'), }, bufnr, ns_id, linenr_start)
      record_position.panes[pane_index] = { line_nr = linenr_start - 1, is_active =pane.is_active }
      linenr_start = render_line({ NuiText(string.format('   ID: %s', pane.pane_id)) }, bufnr, ns_id, linenr_start)
      linenr_start = render_line({ NuiText(string.format('   Dir: %s', pane.cwd:gsub('file:///', ''))) }, bufnr, ns_id, linenr_start)
      linenr_start = render_line({ NuiText(string.format('   Size: %dx%d', pane.width, pane.height)) }, bufnr, ns_id, linenr_start)
      linenr_start = render_line({ NuiText(string.format('   Action: %s', pane.action)) }, bufnr, ns_id, linenr_start)

      linenr_start = render_line({ NuiText('') }, bufnr, ns_id, linenr_start)
    end

    M.render_positons[tab_index] = record_position
  end

  float:show()
  vim.api.nvim_win_set_cursor(float.winid, { 2, 0 })

  local kopt = { noremap = true, silent = true, buffer = bufnr }
  keymap('n', 'q', actions.close_win, kopt)
  keymap('n', 't', actions.toggle_action_status, kopt)
  keymap('n', '<tab>', actions.jump_next_tab, kopt)
  keymap('n', '<s-tab>', actions.jump_prev_tab, kopt)
  keymap('n', '<leader>s', function()
    actions.write_state(state_file, utils.update_state(wezterm_state))
  end, kopt)

  for key_num = 1, 4, 1 do
    keymap('n', tostring(key_num), function()
      actions.jump_to_pane(key_num)
    end, kopt)
  end

  M.float = float
end

function M.select_file()
  local files = utils.list_files(state_path)
  if #files == 0 then
    vim.notify('No files found in ' .. state_path, vim.log.levels.WARN)
    return
  end

  vim.ui.select(files, { prompt = 'Select a file:' }, function(choice)
    if choice then
      -- dd(state_path .. '/' .. choice)
      create_floating_win(state_path .. '/' .. choice)
    end
  end)
end

-- M.select_file()
-- create_floating_win('C:/Users/hasan/dotfiles/gui/wezterm/wezterm-session-manager/state/klark-app.json')

---@class Size
---@field cols number
---@field dpi number
---@field pixel_height number
---@field pixel_width number
---@field rows number

---@class Pane
---@field action string
---@field cwd string
---@field height number
---@field index number
---@field is_active boolean
---@field is_zoomed boolean
---@field left number
---@field pane_id string
---@field pixel_height number
---@field pixel_width number
---@field top number
---@field tty string
---@field width number

---@class Tab
---@field is_active boolean
---@field panes Pane[]
---@field tab_id string

---@class WezTermAppState
---@field name string
---@field size Size
---@field tabs Tab[]

---@class WezTermAppStateParsed
---@field tabs TabParsed[]

---@class TabParsed
---@field is_active boolean
---@field panes PaneParsed[]
---@field tab_id string

---@class PaneParsed
---@field action string
---@field cwd string
---@field pane_id string
---@field is_active boolean
-- --- @field height number
-- --- @field index number
-- --- @field is_zoomed boolean
-- --- @field left number
-- --- @field pixel_height number
-- --- @field pixel_width number
-- --- @field top number
-- --- @field tty string
-- --- @field width number

---@class Render_positons
---@field line_nr number
---@field is_active boolean
---@field panes {line_nr:number,is_active:boolean}[]

return M
