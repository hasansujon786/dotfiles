-- Built-in actions
local transform_mod = require('telescope.actions.mt').transform_mod
local action_state = require('telescope.actions.state')
local action_utils = require('telescope.actions.utils')
local fb_actions = require('telescope._extensions.file_browser.actions')

local function no_item_found()
  vim.notify('No selection to be opened!', vim.log.levels.INFO)
end

-- or create your custom action
local edit_buffer = function(prompt_bufnr, command)
  local entry = action_state.get_selected_entry()
  if entry == nil then
    return no_item_found()
  end
  require('telescope.actions').close(prompt_bufnr)
  vim.cmd(string.format('%s %s', command, entry[1]))
end

local get_file_from_entry = function(entry)
  if entry == nil then
    return no_item_found()
  end

  local file = vim.fs.joinpath(entry.cwd, entry[1])
  return file:gsub('/', '\\')
end

local system_open_cmd = vim.fn.has('win32') == 1 and 'explorer.exe' or vim.fn.has('mac') == 1 and 'open' or 'xdg-open'

local _system_open = function(prompt_bufnr, get_file)
  local file = type(get_file) == 'function' and get_file() or get_file
  if file == nil then
    return no_item_found()
  end

  require('plenary.job'):new({ command = system_open_cmd, args = { file } }):start()
end

local local_action = transform_mod({
  fedit = function(prompt_bufnr)
    edit_buffer(prompt_bufnr, 'Fedit')
  end,
  ---@param is_path_absolute boolean Some picker gives absolute path. Such as file_browser
  quicklook = function(is_path_absolute)
    return function(_)
      local entry = action_state.get_selected_entry()
      if entry == nil then
        return no_item_found()
      end
      local file_path = is_path_absolute and entry[1] or get_file_from_entry(entry)
      require('hasan.utils.file').quickLook({ file_path })
    end
  end,
  system_open = function(prompt_bufnr)
    local current_picker = action_state.get_current_picker(prompt_bufnr)
    local has_multi_selection = (next(current_picker:get_multi_selection()) ~= nil)

    if has_multi_selection then
      action_utils.map_selections(prompt_bufnr, function(entry)
        _system_open(prompt_bufnr, get_file_from_entry(entry))
      end)

      require('telescope.pickers').on_close_prompt(prompt_bufnr)
      return
    end

    -- if does not have multi selection, open single file
    _system_open(prompt_bufnr, get_file_from_entry(action_state.get_selected_entry()))
    require('telescope.pickers').on_close_prompt(prompt_bufnr)
  end,
  focus_file_tree = function(prompt_bufnr)
    local entry = action_state.get_selected_entry()
    if entry == nil then
      return no_item_found()
    end
    require('telescope.actions').close(prompt_bufnr)

    local os_sep = require('plenary.path').path.sep
    local reveal_file = nil

    if entry.Path and entry.Path._absolute then
      reveal_file = entry.Path._absolute
    else
      local file_path = entry[1]
      if os_sep == '\\' then
        file_path = file_path:gsub('/', '\\') -- handle my custom project file hack
      end
      reveal_file = require('plenary.path'):new(entry.cwd, file_path).filename
    end

    require('neo-tree.command').execute({
      action = 'focus', -- OPTIONAL, this is the default value
      source = 'filesystem', -- OPTIONAL, this is the default value
      reveal_file = reveal_file, -- path to file or folder to reveal
      reveal_force_cwd = true, -- change cwd without asking if needed
    })
  end,
  put_emoji = function(prompt_bufnr, symbol, after)
    require('telescope.actions').close(prompt_bufnr)
    vim.schedule(function()
      vim.api.nvim_put({ symbol }, '', after, true)
    end)
  end,
  fb_system_open = function(prompt_bufnr)
    local selections = require('telescope._extensions.file_browser.utils').get_selected_files(prompt_bufnr, true)
    if vim.tbl_isempty(selections) then
      return no_item_found()
    end

    for _, selection in ipairs(selections) do
      _system_open(prompt_bufnr, selection:absolute())
    end
    require('telescope.pickers').on_close_prompt(prompt_bufnr)
  end,
  fb_clear_prompt_or_goto_parent_dir = function(prompt_bufnr)
    local current_picker = action_state.get_current_picker(prompt_bufnr)

    if current_picker:_get_prompt() == '' then
      fb_actions.goto_parent_dir(prompt_bufnr, false)
    else
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-u>', true, false, true), 'tn', false)
    end
  end,
  fb_clear_prompt_or_goto_cwd = function(prompt_bufnr)
    local current_picker = action_state.get_current_picker(prompt_bufnr)

    if current_picker:_get_prompt() == '' then
      fb_actions.goto_cwd(prompt_bufnr)
    else
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-u>', true, false, true), 'tn', false)
    end
  end,
})

return local_action
