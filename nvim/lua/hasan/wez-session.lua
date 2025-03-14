local state_path = vim.fs.normalize(vim.fn.expand('~')) .. '/dotfiles/gui/wezterm/wezterm-session-manager/state'
-- local path = 'C:/Users/hasan/dotfiles/gui/wezterm/wezterm-session-manager/state/klark-app.json'

local M = {}

local function write_state(file_path, data)
  -- Write JSON string to a file
  local file = io.open(file_path, 'w') -- Open file in write mode
  if file then
    local json_string = vim.fn.json_encode(data)
    file:write(json_string) -- Write the JSON string to the file
    file:close() -- Close the file
  end
end

local function list_files(directory)
  local files = {}
  local handle = vim.uv.fs_scandir(directory)
  if handle then
    while true do
      local name, type = vim.uv.fs_scandir_next(handle)
      if not name then
        break
      end
      if type == 'file' then
        table.insert(files, name)
      end
    end
  end
  return files
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

---@param wezterm_state WezTermAppState
---@return WezTermAppState
local function update_state(wezterm_state)
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
end

local function create_floating_win(state_file)
  ---@type WezTermAppState
  local wezterm_state = vim.fn.json_decode(vim.fn.readfile(state_file))
  local buf = vim.api.nvim_create_buf(false, true) -- Create a new scratch buffer

  local width = 80
  local height = math.min(#wezterm_state.tabs * 6, 20) -- Adjust height dynamically

  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = 'minimal',
    border = 'rounded',
  }

  local win = vim.api.nvim_open_win(buf, true, opts)

  keymap('n', '<leader>s', function()
    write_state(state_file, update_state(wezterm_state))
  end, { noremap = true, silent = true, buffer = buf })
  keymap('n', 'q', function()
    vim.api.nvim_win_close(win, true)
  end, { noremap = true, silent = true, buffer = buf })

  -- Build content
  local lines = {}

  for tab_index, tab in ipairs(wezterm_state.tabs) do
    local tab_label = string.format('Tab: %s (%s:%d)', tab_index, tab.is_active and 'Active' or '', tab.tab_id)
    table.insert(lines, tab_label)
    table.insert(lines, string.rep('-', width))

    for pane_index, pane in ipairs(tab.panes) do
      table.insert(lines, string.format('  [%s]%s', pane_index, pane.is_active and '*' or ''))
      table.insert(lines, string.format('   ID: %s', pane.pane_id))
      table.insert(lines, string.format('   Dir: %s', pane.cwd:gsub('file:///', '')))
      table.insert(lines, string.format('   Size: %dx%d', pane.width, pane.height))
      table.insert(lines, string.format('   Action: %s', pane.action))
      table.insert(lines, '')
    end
  end

  -- Set text in buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  return win
end

function M.select_file()
  local files = list_files(state_path)
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

--- @class Size
--- @field cols number
--- @field dpi number
--- @field pixel_height number
--- @field pixel_width number
--- @field rows number

--- @class Pane
--- @field action string
--- @field cwd string
--- @field height number
--- @field index number
--- @field is_active boolean
--- @field is_zoomed boolean
--- @field left number
--- @field pane_id string
--- @field pixel_height number
--- @field pixel_width number
--- @field top number
--- @field tty string
--- @field width number

--- @class Tab
--- @field is_active boolean
--- @field panes Pane[]
--- @field tab_id string

--- @class WezTermAppState
--- @field name string
--- @field size Size
--- @field tabs Tab[]

--- @class WezTermAppStateParsed
--- @field tabs TabParsed[]

--- @class TabParsed
--- @field is_active boolean
--- @field panes PaneParsed[]
--- @field tab_id string

--- @class PaneParsed
--- @field action string
--- @field cwd string
--- @field pane_id string
--- @field is_active boolean
-- --- @field height number
-- --- @field index number
-- --- @field is_zoomed boolean
-- --- @field left number
-- --- @field pixel_height number
-- --- @field pixel_width number
-- --- @field top number
-- --- @field tty string
-- --- @field width number

return M
