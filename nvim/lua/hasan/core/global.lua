local data_path = vim.fn.stdpath('data')
_G.has_pvim = os.getenv('PVIM') and true or false
_G.org_root_path = 'C:\\Users\\hasan\\vimwiki'
_G.org_home_path = 'C:\\Users\\hasan\\vimwiki\\home.org'
_G.dap_adapter_path = data_path .. '/dap_adapters' -- 'C:\\Users\\hasan\\AppData\\Local\\nvim-data\\dap_adapters\\'
_G.plugin_path = data_path .. '/lazy'
_G.path_mason = data_path .. '/mason'

-- Sneak ==============================
vim.g['sneak#target_labels'] = ';wertyuopzbnmfLGKHWERTYUIQOPZBNMFJ0123456789'
vim.g['sneak#label'] = 1 -- use <tab> to jump through lebles
vim.g['sneak#use_ic_scs'] = 1 -- case insensitive sneak
vim.g['sneak#prompt'] = '  '
-- vim-visual-multi ===================
vim.g.VM_leader = '<leader>vv'
vim.g.VM_theme_set_by_colorscheme = 0
-- emmet ==============================
vim.g.user_emmet_leader_key = '<C-c>'
-- quick-scoope =======================
vim.g.qs_highlight_on_keys = { 'f', 'F', 't', 'T' }
-- vim-caser ==========================
vim.g.caser_prefix = '<leader>cs'

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

_G.feedkeys = function(key, mode)
  mode = mode == nil and '' or mode
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

_G.keymap = function(mode, lhs, rhs, opts)
  local def_opts = { silent = true, noremap = true }
  opts = vim.tbl_deep_extend('force', def_opts, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

_G.handle_win_cmd = function(wincmd, lazySave)
  if lazySave then
    vim.cmd(wincmd)
    require('hasan.nebulous').mark_as_alternate_win()
  else
    require('hasan.nebulous').mark_as_alternate_win()
    vim.cmd(wincmd)
  end
end

_G.command = function(name, callback, opts)
  vim.api.nvim_create_user_command(name, callback, opts or {})
end

-- prequire {{{

---Protected `require` function
---@param module_name string
---@return table | function | Void module
---@return boolean loaded if module was loaded or not
_G.prequire = function(module_name)
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
