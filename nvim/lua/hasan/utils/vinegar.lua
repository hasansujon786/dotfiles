local api = vim.api
local tree = require('nvim-tree')
local view = require('nvim-tree.view')
local lib = require('nvim-tree.lib')
local M = {}

M.toggle_sidebar = function()
  local readonly = api.nvim_buf_get_option(0, 'readonly')
  local modifiable = api.nvim_buf_get_option(0, 'modifiable')
  local filetype = api.nvim_buf_get_option(0, 'filetype')

  if filetype == 'NvimTree' then
    vim.cmd([[NvimTreeClose]])
  elseif readonly or not modifiable then
    vim.cmd([[NvimTreeOpen]])
  else
    vim.cmd([[NvimTreeFocus]])
    -- vim.cmd([[NvimTreeFindFile]])
    -- tree.find_file(true, api.nvim_get_current_buf(), true)
  end
end

local alt_file = nil
local pre_alt_file = nil

-- function ShowAlt()
--   local st = ''
--   if alt_file then
--     st = 'alt_file: ' .. alt_file
--   end
--   if pre_alt_file then
--     st = st .. '     pre_alt_file: ' .. pre_alt_file
--   end
--   print(st)
-- end

function M.vinegar()
  alt_file = vim.fn.expand('%')
  pre_alt_file = vim.fn.expand('#')

  if view.is_visible() then
    view.close()
  end
  tree.open_replacing_current_buffer()
  vim.b.vinegar = true
end

function M.alternate_file()
  if vim.o.filetype == 'NvimTree' then
    --If vinegar win: Close tree and open alt file
    if alt_file and vim.w.vinegar then
      view.close()
      vim.cmd('e ' .. alt_file)
      alt_file = pre_alt_file and pre_alt_file ~= '' and pre_alt_file or nil
      return
    end

    -- If sidebar: just close the tree
    if view.is_visible() and vim.w.vinegar == nil then
      view.close()
      return
    end
  end

  -- store curret native values
  local current_file = vim.fn.expand('%')
  local current_alt_file = vim.fn.expand('#')

  if current_alt_file and current_alt_file ~= '' then
    return vim.fn['hasan#utils#feedkeys']('<c-^>', 'n')
  end

  if alt_file and alt_file ~= current_file and alt_file ~= '' then
    return vim.cmd('e ' .. alt_file)
  end

  if alt_file == current_file and pre_alt_file and pre_alt_file ~= '' then
    return vim.cmd('e ' .. pre_alt_file)
  end

  vim.cmd([[echo 'No alternate file']])
end

local function open()
  feedkeys(vim.b.vinegar and 'E' or 'zZ')
end
M.actions = {
  open = open,
  edit_in_place = function()
    feedkeys(vim.b.vinegar and 'E' or 'zE')
  end,
  open_n_close = function()
    open()
    if view.is_visible() and not vim.b.vinegar then
      view.close()
    end
  end,
  vinegar_edit_or_cd = function(node)
    if node.extension and vim.b.vinegar then
      feedkeys('E')
    elseif node.extension and not vim.b.vinegar then
      feedkeys('zE')
    else
      lib.open({ path = node.absolute_path })
      feedkeys('ggj')
    end
  end,
  cd_root = function()
    lib.open({ path = vim.loop.cwd() })
    feedkeys('gg', '')
  end,
  system_reveal = function(node)
    vim.cmd('silent !explorer.exe /select,"' .. node.absolute_path .. '"')
  end,
  quickLook = function(node)
    require('hasan.utils.file').quickLook({ node.absolute_path })
  end,
  vinegar_dir_up = function(node)
    if node.name == '..' then
      feedkeys('j')
      vim.schedule(function()
        node = lib.get_node_at_cursor()
        M.actions.vinegar_dir_up(node)
      end)
    end
    if node == nil or node.parent == nil then
      return
    end

    local cwd = node.parent.absolute_path
    local open_path = vim.fn.fnamemodify(cwd, ':h')
    if cwd == open_path then
      return
    end

    lib.open({ path = open_path })
    require('nvim-tree.actions.finders.find-file').fn(cwd)
  end,
}

return M
