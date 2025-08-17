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

  -- {
  --   _path = "C:/Users/hasan/dotfiles",
  --   dir = "C:\\Users\\hasan\\dotfiles",
  --   file = "C:\\Users\\hasan\\dotfiles",
  --   idx = 1,
  --   score = 1000,
  --   text = "C:\\Users\\hasan\\AppData\\Local\\nvim-data\\sessions\\C%Users%hasan%dotfiles.vim"
  -- }

  return sessions
end

function M.persisted()
  Snacks.picker.pick({
    layout = 'dropdown',
    source = 'Persisted Sessions',
    format = 'file',
    finder = list_sessions,
    win = {
      input = {
        keys = {
          -- Every action will always first change the cwd of the current tabpage to the project
          ['<c-x>'] = { 'delete_session', mode = { 'i', 'n' } },
          ['<c-e>'] = { { 'tcd', 'picker_explorer' }, mode = { 'n', 'i' } },
          ['<c-f>'] = { { 'tcd', 'picker_files' }, mode = { 'n', 'i' } },
          ['<c-g>'] = { { 'tcd', 'picker_grep' }, mode = { 'n', 'i' } },
          ['<c-r>'] = { { 'tcd', 'recent' }, mode = { 'n', 'i' } },
          ['<c-w>'] = { { 'tcd' }, mode = { 'n', 'i' } },
          ['<c-t>'] = { 'open_new_tab', mode = { 'n', 'i' } },
        },
      },
    },
    confirm = function(p, item)
      p:close()
      fire_user_cmds('PersistedPickerLoadPre')
      vim.schedule(function()
        persisted.load({ session = item.text })
      end)
      fire_user_cmds('PersistedPickerLoadPost')
    end,
    actions = {
      delete_session = function(p, _)
        local items = p:selected({ fallback = true })
        local msg = (#items == 1) and 'Delete the selected session?' or 'Delete the selected sessions?'

        if vim.fn.confirm(msg, '&Yes\n&No', 1) == 1 then
          for _, item in ipairs(items) do
            vim.fn.delete(vim.fn.expand(item.text))
          end

          p:find({
            refresh = true,
            on_done = function()
              feedkeys('<right>', 'n')
            end,
          })
        else
          feedkeys('<right>', 'n')
        end
      end,
      recent = function(_, item)
        Snacks.picker.pick('recent', { filter = { cwd = item.file } })
      end,
      open_new_tab = function(p, item)
        vim.cmd('tabnew')
        Snacks.notify('New tab opened')
        p:close()
        Snacks.picker.pick('files', { cwd = item.file })
      end,
    },
  })
end

return M
