local tree = require('nvim-tree')
local view = require('nvim-tree.view')
local lib = require('nvim-tree.lib')
local api = require('nvim-tree.api')
local M = {}

M.toggle_sidebar = function()
  require('hasan.nebulous').mark_as_alternate_win()
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

M.actions = {
  open_or_edit_in_place = function(cmd)
    return function()
      if vim.b.vinegar then
        api.node.open.replace_tree_buffer()
      else
        cmd()
      end
    end
  end,
  open_n_close = function(cmd)
    return function()
      cmd()
      if view.is_visible() and not vim.b.vinegar then
        view.close()
      end
    end
  end,
  vinegar_edit_or_cd = function()
    local node = api.tree.get_node_under_cursor()
    if node.extension and vim.b.vinegar then
      api.node.open.replace_tree_buffer()
    elseif node.extension and not vim.b.vinegar then
      api.node.open.no_window_picker()
    else
      lib.open({ path = node.absolute_path })
      feedkeys('ggj')
    end
  end,
  jump_to_root = function()
    lib.open({ path = vim.loop.cwd() })
    feedkeys('gg', '')
  end,
  system_reveal = function()
    local node = api.tree.get_node_under_cursor()
    vim.cmd('silent !explorer.exe /select,"' .. node.absolute_path .. '"')
  end,
  quickLook = function()
    local node = api.tree.get_node_under_cursor()
    require('hasan.utils.file').quickLook({ node.absolute_path })
  end,
  vinegar_dir_up = function()
    local node = api.tree.get_node_under_cursor()
    if node.name == '..' then
      feedkeys('j')
      vim.schedule(function()
        M.actions.vinegar_dir_up()
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
  git_add = function()
    local node = api.tree.get_node_under_cursor()
    local gs = node.git_status.file

    -- If the current node is a directory get children status
    if gs == nil then
      gs = (node.git_status.dir.direct ~= nil and node.git_status.dir.direct[1])
        or (node.git_status.dir.indirect ~= nil and node.git_status.dir.indirect[1])
    end

    -- If the file is untracked, unstaged or partially staged, we stage it
    if gs == '??' or gs == 'MM' or gs == 'AM' or gs == ' M' then
      vim.cmd('silent !git add ' .. node.absolute_path)

    -- If the file is staged, we unstage
    elseif gs == 'M ' or gs == 'A ' then
      vim.cmd('silent !git restore --staged ' .. node.absolute_path)
    end

    api.tree.reload()
  end,
}

local function tab_win_closed(winnr)
  local tabnr = vim.api.nvim_win_get_tabpage(winnr)
  local bufnr = vim.api.nvim_win_get_buf(winnr)
  local buf_info = vim.fn.getbufinfo(bufnr)[1]
  local tab_wins = vim.tbl_filter(function(w)
    return w ~= winnr
  end, vim.api.nvim_tabpage_list_wins(tabnr))
  local tab_bufs = vim.tbl_map(vim.api.nvim_win_get_buf, tab_wins)
  if buf_info.name:match('.*NvimTree_%d*$') then -- close buffer was nvim tree
    -- Close all nvim tree on :q
    if not vim.tbl_isempty(tab_bufs) then -- and was not the last window (not closed automatically by code below)
      api.tree.close()
    end
  else -- else closed buffer was normal buffer
    if #tab_bufs == 1 then -- if there is only 1 buffer left in the tab
      local last_buf_info = vim.fn.getbufinfo(tab_bufs[1])[1]
      if last_buf_info.name:match('.*NvimTree_%d*$') then -- and that buffer is nvim tree
        vim.schedule(function()
          if #vim.api.nvim_list_wins() == 1 then -- if its the last buffer in vim
            -- vim.cmd "quit"                                        -- then close all of vim
            P('last win')
          else -- else there are more tabs open
            vim.api.nvim_win_close(tab_wins[1], true) -- then close only the tab
          end
        end)
      end
    end
  end
end

vim.api.nvim_create_autocmd('WinClosed', {
  callback = function()
    local winnr = tonumber(vim.fn.expand('<amatch>'))
    local is_floating_win = vim.api.nvim_win_get_config(winnr).relative ~= ''
    if is_floating_win then
      return
    end

    vim.schedule_wrap(tab_win_closed(winnr))
  end,
  nested = true,
})

return M
