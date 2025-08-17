vim.g.skip_ts_context_commentstring_module = true -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring/issues/82

vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0

local data_path = vim.fs.normalize(vim.fn.stdpath('data'))
vim.g.sqlite_clib_path = data_path .. '/sqlite-ddl-win/sqlite3.dll'
_G.has_pvim = os.getenv('PVIM') and true or false
_G.plugin_path = data_path .. '/lazy'
_G.mason_path = data_path .. '/mason/packages'
_G.org_root_path = vim.fs.normalize(vim.fn.expand('~/my_vault/orgfiles'))
_G.repoes_path = os.getenv('REPOES') or vim.fn.expand('~/')

---Reload lua module
---@param module_name string
---@param msg? string
---@return table | function | Void module
R = function(module_name, msg)
  if pcall(require, 'plenary') then
    local plenary_reload = require('plenary.reload').reload_module

    plenary_reload(module_name)
    if msg then
      vim.notify(string.format('[%s] - %s', module_name, msg), vim.log.levels.INFO, { title = 'Theme' })
    end
    return require(module_name)
  end
end

---@param str string
_G.insert = function(str)
  vim.api.nvim_put({ str }, 'v', true, true)
end

---@param str string
function _G.t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

---@param key string
---@param mode? 'm'|'n'
function _G.feedkeys(key, mode)
  mode = mode or 'm'
  vim.api.nvim_feedkeys(t(key), mode, false)
end

_G.keymap = vim.keymap.set

function _G.handle_win_cmd(wincmd, lazySave)
  if lazySave then
    vim.cmd(wincmd)
    require('hasan.nebulous').mark_as_alternate_win()
  else
    require('hasan.nebulous').mark_as_alternate_win()
    vim.cmd(wincmd)
  end
end

---Fire user event
---@param event string
function _G.fire_user_cmds(event)
  vim.api.nvim_exec_autocmds('User', { pattern = event })
end

function _G.augroup(group)
  vim.api.nvim_create_augroup(group, { clear = true })

  return function(autocmds)
    autocmds(function(event, command, opts)
      opts = opts and opts or {}
      -- opts.group = id
      opts.group = group
      local is_function = type(command) == 'function'
      opts.callback = is_function and command or nil
      opts.command = not is_function and command or nil

      vim.api.nvim_create_autocmd(event, opts)
    end)
  end
end

---Protected `require` function
---@param module_name string
---@return table | function | Void module
---@return boolean loaded if module was loaded or not
function _G.prequire(module_name)
  local available, module = pcall(require, module_name)
  if available then
    return module, true
  else
    local source = debug.getinfo(2, 'S').source:sub(2)
    source = source:gsub(os.getenv('HOME'), '~') --[[@as string]]
    local msg = string.format('"%s" requested in "%s" not available', module_name, source)
    vim.schedule(function()
      vim.notify_once(msg, vim.log.levels.WARN)
    end)

    ---@class Void Void has eveything and nothing
    local void = setmetatable({}, { ---@type Void
      __index = function(self)
        return self
      end,
      __newindex = function() end,
      __call = function() end,
    })

    return void, false
  end
end
