-- local luv = vim.loop
-- local api = vim.api
-- local lib = require('nvim-tree.lib')
-- local log = require('nvim-tree.log')
-- local colors = require('nvim-tree.colors')
-- local renderer = require('nvim-tree.renderer')
-- local utils = require('nvim-tree.utils')
-- local change_dir = require('nvim-tree.actions.change-dir')
-- local legacy = require('nvim-tree.legacy')
-- local core = require('nvim-tree.core')
-- local tree = require('nvim-tree')
local view = require('nvim-tree.view')
local M = {}

M.toggle_sidebar = function()
  local readonly = vim.api.nvim_buf_get_option(0, 'readonly')
  local modifiable = vim.api.nvim_buf_get_option(0, 'modifiable')
  local filetype = vim.api.nvim_buf_get_option(0, 'filetype')

  if filetype == 'NvimTree' then
    vim.cmd([[NvimTreeClose]])
  elseif readonly or not modifiable then
    vim.cmd([[NvimTreeOpen]])
  else
    vim.cmd([[NvimTreeFindFile]])
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
  require('nvim-tree').open_replacing_current_buffer()
  vim.w.vinegar = true
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

return M
