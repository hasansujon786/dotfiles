local Job = require('plenary.job')

local M = {}

M.config_root = function()
  local configDir = os.getenv('PVIM')
  if configDir then
    configDir = configDir .. '/config'
  else
    configDir = vim.fn.stdpath('config')
  end
  return configDir
end

M.open_settings = function()
  local path = vim.fs.normalize(M.config_root() .. '\\lua\\hasan\\core\\state.lua')
  vim.cmd.edit(path)
end

function M.openInCode(only_file)
  local positin = vim.api.nvim_win_get_cursor(0)
  local buf = vim.api.nvim_buf_get_name(0)
  local cmd = ''

  if only_file then
    cmd = string.format('! code --goto "%s":%d:%d', buf, positin[1], positin[2] + 1)
  else
    cmd = string.format('! code "%s" --goto "%s":%d:%d', vim.loop.cwd(), buf, positin[1], positin[2] + 1)
  end
  vim.cmd(cmd)
end

local js = {
  comment = '\\/\\/',
  log = 'console.log(',
}
local filetype_options = {
  lua = {
    comment = '--',
    log = 'print(',
  },
  dart = {
    comment = '\\/\\/',
    log = 'print(',
  },
  yaml = {
    comment = '\\#',
  },
  javascript = js,
  typescript = js,
  javascriptreact = js,
  typescriptreact = js,
}

function M.delete_lines_with(what_to_delete)
  local opts = filetype_options[vim.bo.filetype]
  if not opts or not opts[what_to_delete] then
    return
  end

  local prefix = '^\\s*'
  vim.cmd('g/' .. prefix .. opts[what_to_delete] .. '/d')
end

-- M.delete_all_lines_with('comment')
-- M.delete_all_lines_with('log')
-- require('hasan.utils.file').delete_lines_with('comment')

function M.reload()
  if vim.bo.buftype == '' then
    -- if vim.fn.exists(':LspStop') ~= 0 then
    --   vim.cmd('LspStop')
    -- end

    for name, _ in pairs(package.loaded) do
      if name:match('^config') or name:match('^hasan') or name:match('^core') then
        package.loaded[name] = nil
        R(name)
        -- P(name)
      end
    end
    P('Neovim reloaded')
  end
end

local on_windows = vim.loop.os_uname().version:match('Windows')
function M.join_paths(...) -- Function from nvim-lspconfig
  local path_sep = on_windows and '\\' or '/'
  local result = table.concat({ ... }, path_sep)
  return result
end

function M.smart_save_buffer()
  if state.file.auto_format then
    vim.cmd([[silent noa write]])
  else
    -- vim.lsp.buf.format({ async = false })
    require('conform').format({ lsp_fallback = true })
    vim.cmd([[silent write]])
  end
end

function M.quickLook(args)
  local bg_job = nil
  bg_job = Job:new({
    command = 'C:\\Users\\hasan\\AppData\\Local\\Programs\\QuickLook\\QuickLook.exe',
    args = args,
    -- cwd = vim.loop.cwd(),
  })
  bg_job:start()

  -- bg_job:after_success(vim.schedule_wrap(function(_)
  --   -- on_pub_get(j:result())
  --   bg_job = nil
  --   P('after_success')
  -- end))
  bg_job:after_failure(vim.schedule_wrap(function(_)
    -- on_pub_get(j:stderr_result(), true)
    bg_job = nil
    vim.notify('There someting went wrong while opening QuickLook', vim.log.levels.WARN)
  end))
end

return M

-- del lines            %s/\v(print).*/
-- insert end of lines  %s/\v(regex).*\zs/ \1
-- wrap all lines with quote %s/^\|$/'/g

-- :g/\zs-- /d only first match from a line
-- :g/foo/d - Delete all lines containing the string “foo”. ...
-- :g!/foo/d - Delete all lines not containing the string “foo”.
-- :g/^#/d - Remove all comments from a Bash script. ...
-- :g/^$/d - Remove all blank lines. ...
-- :g/^\s*$/d - Remove all blank lines.
