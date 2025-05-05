vim.g.skip_ts_context_commentstring_module = true -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring/issues/82

local data_path = vim.fn.stdpath('data')
vim.g.sqlite_clib_path = data_path .. '/sqlite-ddl-win/sqlite3.dll'
_G.has_pvim = os.getenv('PVIM') and true or false
_G.config_path = vim.fn.stdpath('config')
_G.dap_adapter_path = data_path .. '/dap_adapters' -- 'C:\\Users\\hasan\\AppData\\Local\\nvim-data\\dap_adapters\\'
_G.plugin_path = data_path .. '/lazy'
_G.path_mason = data_path .. '/mason'
_G.org_root_path = vim.fn.expand('~/my_vault/orgfiles')
vim.hl = vim.highlight

P = function(...)
  local hasNvim9 = vim.fn.has('nvim-0.9') == 1
  if hasNvim9 then
    vim.print(...)
  else
    vim.pretty_print(...)
  end
  return ...
end

R = function(moduleName, message)
  if pcall(require, 'plenary') then
    local plenary_reload = require('plenary.reload').reload_module

    plenary_reload(moduleName)
    if message then
      vim.notify(string.format('[%s] - %s', moduleName, message), vim.log.levels.INFO)
    end
    return require(moduleName)
  end
end

_G.insert = function(str)
  vim.api.nvim_put({ str }, 'v', true, true)
end

---Show custom message popup
---@param msg string Content of the notification to show to the user.
---@param level integer|nil One of the values from |vim.log.levels|.
---@param opts table|nil Optional parameters. Unused by default.
function _G.notify(msg, level, opts)
  require('hasan.widgets.notify').notify(msg, level, opts)
end

function _G.t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end
function _G.feedkeys(key, mode)
  mode = mode == nil and 'm' or mode
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

function _G.command(name, callback, opts)
  vim.api.nvim_create_user_command(name, callback, opts or {})
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

-- prequire {{{

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
-- }}}
