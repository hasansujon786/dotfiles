-- Built-in actions
local transform_mod = require('telescope.actions.mt').transform_mod
local action_state = require('telescope.actions.state')
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

local local_action = transform_mod({
  fedit = function(prompt_bufnr)
    edit_buffer(prompt_bufnr, 'Fedit')
  end,
  quicklook = function(_)
    local entry = action_state.get_selected_entry()
    if entry == nil then
      return no_item_found()
    end

    require('hasan.utils.file').quickLook({ string.format('%s/%s', entry.cwd, entry[1]) })
  end,
  fb_actions_open = function(prompt_bufnr)
    local selections = require('telescope._extensions.file_browser.utils').get_selected_files(prompt_bufnr, true)
    if vim.tbl_isempty(selections) then
      return no_item_found()
    end

    local cmd = vim.fn.has('win32') == 1 and 'explorer.exe' or vim.fn.has('mac') == 1 and 'open' or 'xdg-open'
    for _, selection in ipairs(selections) do
      require('plenary.job')
        :new({
          command = cmd,
          args = { selection:absolute() },
        })
        :start()
    end
    require('telescope.actions').close(prompt_bufnr)
  end,
  clear_prompt_or_goto_parent_dir = function(prompt_bufnr)
    local current_picker = action_state.get_current_picker(prompt_bufnr)

    if current_picker:_get_prompt() == '' then
      fb_actions.goto_parent_dir(prompt_bufnr, false)
    else
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-u>', true, false, true), 'tn', false)
    end
  end,
  clear_prompt_or_goto_cwd = function(prompt_bufnr)
    local current_picker = action_state.get_current_picker(prompt_bufnr)

    if current_picker:_get_prompt() == '' then
      fb_actions.goto_cwd(prompt_bufnr)
    else
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-u>', true, false, true), 'tn', false)
    end
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
      position = 'left', -- OPTIONAL, this is the default value
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
})

return local_action
