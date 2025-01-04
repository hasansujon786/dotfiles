-- local ts_utils = require('nvim-treesitter.ts_utils')
local ts = vim.treesitter

-- Function to parse the current source block
local function parse_current_src_block(bufnr)
  local block_node, block_type = nil, nil

  local node = ts.get_node({ bufnr = bufnr })

  -- Traverse upwards to find the enclosing `#+BEGIN_` block
  while node do
    local node_type = node:type()
    if node_type == 'src_block' or node_type == 'block' then
      block_node = node
      local block_tag_node = node:child(1) -- #+BEGIN_`SRC`
      block_type = block_tag_node and ts.get_node_text(block_tag_node, bufnr)
    end

    node = block_node == nil and node:parent() or nil
  end

  local block = {}
  local is_src_block = block_type == 'SRC'

  -- Traverse the block_node
  if block_node and is_src_block then
    local language_node = block_node:child(2) -- Extract filetype from #+BEGIN_SRC `lua`
    block.language = language_node and ts.get_node_text(language_node, bufnr)

    -- Parse contents from nodes
    for child_node in block_node:iter_children() do
      if child_node:type() == 'contents' then
        block.body = ts.get_node_text(child_node, bufnr)
        return block, block_node
      end
    end
  end

  vim.notify('No source block found at cursor position')
  return nil, nil
end

local M = {}

function M.create_system_executor(program)
  return function(block)
    local tempfile = vim.fn.tempname()
    vim.fn.writefile(vim.split(block.body, '\n'), tempfile)
    local result = vim.system({ program, tempfile }, { text = true }):wait()
    return vim.split(result.stdout, '\n')
  end
end

local executors = {
  lua = function(block)
    local results = {}

    -- Override the `print` function temporarily
    local original_print = print
    print = function(...)
      local args = { ... }
      for _, v in ipairs(args) do
        table.insert(results, tostring(v))
      end
    end

    -- Execute the code
    local func, err = loadstring(block.body)
    if not func then
      table.insert(results, 'Error: ' .. err)
    else
      local success, exec_err = pcall(func)
      if not success then
        table.insert(results, 'Execution Error: ' .. exec_err)
      end
    end

    -- Restore the original print function
    print = original_print

    return results
  end,
  javascript = M.create_system_executor('node'),
}

local float_win = nil
local scrach_buf = vim.api.nvim_create_buf(false, true)

local show_result = function(result, language, parent)
  local parent_config = vim.api.nvim_win_get_config(parent.win)
  local parent_is_float = parent_config.relative ~= ''

  local width = parent_config.width - 4
  local height = 4
  if #result > height then
    height = math.min(10, #result)
  end
  local col = math.floor((parent_config.width - width) / 2) - 1
  local row = math.floor(parent_config.height - height) - (parent_is_float and 1 or 3)
  local title = string.format(' %s ', language)
  local zindex = (parent_config.zindex or 10) + 1

  vim.api.nvim_buf_set_lines(scrach_buf, 0, -1, false, result)

  local win_conf = {
    relative = 'win',
    col = col,
    row = row,
    width = width,
    height = height,
    zindex = zindex,

    title = title,
    title_pos = 'right',
    border = 'rounded',
  }

  if float_win then
    vim.api.nvim_win_set_config(float_win.win, win_conf)
  else
    local parent_augroup = vim.api.nvim_create_augroup('SRC_BLOCK_PARETNT', { clear = true })
    local conf = require('hasan.utils').merge({
      buf = scrach_buf,
      enter = true,
      wo = {
        wrap = true,
        number = true,
        signcolumn = 'no',
        winhighlight = 'FloatTitle:NeoTreeFloatTitle,Normal:Normal',
      },
      bo = { modifiable = true },
    }, win_conf)

    float_win = Snacks.win(conf)

    vim.api.nvim_create_autocmd('WinClosed', {
      buffer = float_win.buf,
      group = float_win.augroup,
      callback = function()
        if float_win then
          vim.api.nvim_del_augroup_by_id(parent_augroup)
          float_win = nil
        end
      end,
    })

    local function close_if_move_to_other_win(ev)
      vim.schedule(function()
        if not float_win then
          return
        end

        local cur_win = vim.api.nvim_get_current_win()
        local buf_changed = ev.event == 'BufWinLeave'
        local win_changed = not (cur_win == parent.win or cur_win == float_win.win)

        if win_changed or buf_changed then
          if float_win then
            float_win:close()
          end
        end
      end)
    end

    vim.api.nvim_create_autocmd('WinLeave', {
      buffer = float_win.buf,
      group = float_win.augroup,
      callback = close_if_move_to_other_win,
    })

    vim.api.nvim_create_autocmd({ 'WinClosed', 'WinLeave', 'BufWinLeave' }, {
      group = parent_augroup,
      buffer = parent.buf,
      callback = close_if_move_to_other_win,
    })
  end
end

local function get_executor(language)
  return executors[language]
end

M.execute = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local winnr = vim.api.nvim_get_current_win()

  local block = parse_current_src_block(bufnr)

  if block == nil or block.language == nil or block.language == '' then
    vim.notify('No valid language found')
    return
  end

  local executor = get_executor(block.language)
  if executor ~= nil then
    local result = executor(block)
    if not result or #result == 0 then
      result = { ' <<<Broken Code>>> ' }
    end
    show_result(result, block.language, { win = winnr, buf = bufnr })
    return
  end

  local msg = 'No valid executor for `%s` language'
  vim.notify(msg:format(block.language))
end

return M
