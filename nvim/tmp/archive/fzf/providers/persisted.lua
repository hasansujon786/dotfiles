local fzf_lua = require('fzf-lua')
local themes = require('config.navigation.fzf.themes')

local persisted = require('persisted')
local p_config = require('persisted.config')

local sep = require('persisted.utils').dir_pattern()
local icons = p_config.telescope.icons

---Fire an event
---@param event string
local function fire(event)
  vim.api.nvim_exec_autocmds('User', { pattern = 'Persisted' .. event })
end

local function load_session(session)
  fire('TelescopeLoadPre')
  vim.schedule(function()
    persisted.load({ session = session.file_path })
  end)
  fire('TelescopeLoadPost')
end

---Escapes special characters before performing string substitution
---@param str string
---@param pattern string
---@param replace string
---@param n? integer
---@return string
---@return integer
local function escape_pattern(str, pattern, replace, n)
  pattern = string.gsub(pattern, '[%(%)%.%+%-%*%?%[%]%^%$%%]', '%%%1') -- escape pattern
  replace = string.gsub(replace, '[%%]', '%%%%') -- escape replacement

  return string.gsub(str, pattern, replace, n)
end

local function list_sessions()
  local sessions, sessions_names = {}, {}

  for _, session in pairs(persisted.list()) do
    local session_name = escape_pattern(session, p_config.save_dir, '')
      :gsub('%%', sep)
      :gsub(vim.fn.expand('~'), sep)
      :gsub('//', '')
      :sub(1, -5)

    if vim.fn.has('win32') == 1 then
      session_name = escape_pattern(session_name, sep, ':\\', 1)
      session_name = escape_pattern(session_name, sep, '\\')
    end

    local branch, dir_path

    if string.find(session_name, '@@', 1, true) then
      local splits = vim.split(session_name, '@@', { plain = true })
      branch = table.remove(splits, #splits)
      dir_path = vim.fn.join(splits, '@@')
    else
      dir_path = session_name
    end

    sessions[session_name] = {
      ['name'] = session_name,
      ['file_path'] = session,
      ['branch'] = branch,
      ['dir_path'] = dir_path,
    }

    if vim.g.persisted_loaded_session and vim.g.persisted_loaded_session == session then
      session_name = fzf_lua.utils.ansi_codes.blue(icons.selected .. session_name)
    else
      session_name = fzf_lua.utils.ansi_codes.grey(icons.dir) .. session_name
    end
    table.insert(sessions_names, session_name)
  end

  return sessions, sessions_names
end

local function parse_selection(selected)
  local str = vim.split(selected, ' ')

  return str[#str]
end

local M = {}

function M.persisted()
  local sessions, sessions_names = list_sessions()

  fzf_lua.fzf_exec(
    sessions_names,
    themes.dropdown_no_preview({
      title = 'Sessions',
      actions = {
        ['default'] = function(selected)
          load_session(sessions[parse_selection(selected[1])])
        end,
        ['ctrl-x'] = function(selected)
          local msg = 'Delete [%s] selected session%s?'
          msg = msg:format(#selected, #selected > 1 and 's' or '')

          if vim.fn.confirm(msg, '&Yes\n&No') == 1 then
            for _, selection_item in ipairs(selected) do
              local session = sessions[parse_selection(selection_item)]
              vim.fn.delete(vim.fn.expand(session.file_path))
            end
          end
        end,
      },
    })
  )
end

return M
