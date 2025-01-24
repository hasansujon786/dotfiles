local persisted = require('persisted')
local p_config = require('persisted.config')

local sep = require('persisted.utils').dir_pattern()

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

---Fire an event
---@param event string
local function fire(event)
  vim.api.nvim_exec_autocmds('User', { pattern = 'Persisted' .. event })
end

local M = {}

local function list_sessions()
  local sessions = {}

  for index, session in pairs(persisted.list()) do
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

    sessions[index] = {
      branch = branch,
      text = session,
      dir = dir_path,
      file = dir_path,
    }
  end

  return sessions
end

function M.persisted()
  Snacks.picker.pick({
    layout = 'dropdown',
    source = 'Persisted Sessions',
    items = list_sessions(),
    win = {
      input = {
        keys = {
          ['<c-x>'] = { 'delete_session', mode = { 'i', 'n' } },
        },
      },
    },
    confirm = function(p, item)
      -- dd(item)
      p:close()
      fire('PickerLoadPre')
      vim.schedule(function()
        persisted.load({ session = item.text })
      end)
      fire('PickerLoadPost')
    end,
    actions = {
      delete_session = function(p, item)
        local msg = 'Delete selected session?'
        -- msg = msg:format(#item, #selected > 1 and 's' or '')

        if vim.fn.confirm(msg, '&Yes\n&No', 1) == 1 then
          vim.fn.delete(vim.fn.expand(item.text))
          p:close()
        end
      end,
    },
  })
end

return M
