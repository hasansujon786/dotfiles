local is_visual = function()
  -- vim.api.nvim_get_mode().mode is always "n", so using this instead:
  return vim.fn.visualmode() == 'V'
end

local move = function(address, should_move)
  if is_visual() and should_move then
    vim.cmd("'<,'>move " .. address)
    vim.api.nvim_feedkeys('gv=', 'n', true)
  end
  vim.api.nvim_feedkeys('gv', 'n', true)
end

-- keymap('n', keys[1], '<cmd>lua require("hasan.utils.buffer").norm_move_up()<cr>')
-- keymap('n', keys[2], '<cmd>lua require("hasan.utils.buffer").norm_move_down()<cr>')
-- keymap('x', keys[1], ':MoveUp<CR>')
-- keymap('x', keys[2], ':MoveDown<CR>')
local M = {
  norm_move_down = function()
    if not vim.o.modifiable then
      return feedkeys('j')
    end
    vim.cmd.move('+1')
    feedkeys('==', 'n')
  end,
  norm_move_up = function()
    if not vim.o.modifiable then
      return feedkeys('k')
    end
    vim.cmd.move('-2')
    feedkeys('==', 'n')
  end,
  move_down = function(lastline)
    if not vim.o.modifiable then
      feedkeys('gv', 'n')
      return feedkeys('j')
    end
    local count = vim.v.count == 0 and 1 or vim.v.count
    local max = vim.fn.line('$') - lastline
    local movement = vim.fn.min({ count, max })
    local address = "'>+" .. movement
    local should_move = movement > 0
    move(address, should_move)
  end,

  move_up = function(firstline)
    if not vim.o.modifiable then
      feedkeys('gv', 'n')
      return feedkeys('k')
    end
    local count = vim.v.count == 0 and -1 or -vim.v.count
    local max = (firstline - 1) * -1
    local movement = vim.fn.max({ count, max })
    local address = "'<" .. (movement - 1)
    local should_move = movement < 0
    move(address, should_move)
  end,
}

M.add_file_to_buflist = function(filename)
  local set_position = false
  filename = vim.fn.fnameescape(filename)
  local bufnr = vim.fn.bufnr(filename)

  if bufnr == -1 then
    set_position = true
    bufnr = vim.fn.bufnr(filename, true)
  end
  if not vim.api.nvim_buf_is_loaded(bufnr) then
    vim.fn.bufload(bufnr)
    vim.api.nvim_set_option_value('buflisted', true, { buf = bufnr })
  end
  return bufnr, set_position
end

function M.parse_cursor_text(bufnr)
  local root = vim.treesitter.get_node({ bufnr = bufnr })
  if not root then
    return
  end

  local root_type = root:type()
  if root_type == 'string_fragment' or root_type == 'string' or root_type == 'string_content' then
    return vim.treesitter.get_node_text(root, bufnr)
  end

  local function find_node(node)
    for child in node:iter_children() do
      local type = child:type()
      if type == 'string_fragment' or type == 'string' or type == 'string_content' then
        return vim.treesitter.get_node_text(child, bufnr)
      end
      local found = find_node(child)
      if found then
        return found
      end
    end
  end

  return find_node(root)
end

function M.parse_img_str_at_cursor()
  local buf = vim.api.nvim_get_current_buf()
  local text = require('hasan.utils.buffer').parse_cursor_text(buf)
  if type(text) ~= 'string' or text == '' then
    return nil
  end

  local file = vim.fs.normalize(vim.api.nvim_buf_get_name(buf))
  local dir = vim.fs.dirname(file)
  local absolute_path = require('hasan.utils.file').resolve_relative_path(dir, text)

  if vim.fn.filereadable(absolute_path) == 1 then
    return absolute_path
  end
end

function M.create_link(template, cursor_pos, relative_from_head)
  if not template then
    return
  end

  local link = vim.fn.expand('<cWORD>')
  vim.cmd('normal! "_diW')

  vim.schedule(function()
    local line = template:gsub('${link}', link)
    vim.api.nvim_put({ line }, 'v', true, true)

    if cursor_pos then
      local pos = vim.api.nvim_win_get_cursor(0)
      if relative_from_head then
        cursor_pos = (#line * -1) + cursor_pos
      end
      pos[2] = pos[2] + cursor_pos
      vim.api.nvim_win_set_cursor(0, pos)
      vim.cmd('startinsert')
    end
  end)
end

function M.create_link_visual(template)
  if not template then
    return
  end

  local title = require('hasan.utils.visual').get_visual_selection()
  local full_link = vim.fn.expand('<cWORD>')
  vim.cmd('normal! "_diW')

  vim.schedule(function()
    local line = template:gsub('${link}', full_link):gsub('${title}', title)
    vim.api.nvim_put({ line }, 'v', true, true)
  end)
end

---@param buf number
---@param ns integer
---@param lines HighlightLine
---@param start_line? number 0-index
function M.render_lines(buf, ns, lines, start_line)
  start_line = start_line or 0
  local current_line = start_line

  for _, segments in ipairs(lines) do
    local line = ''
    local col = 0

    -- First pass to build full line
    for _, seg in ipairs(segments) do
      line = line .. seg[1]
    end

    -- Set line in buffer
    vim.api.nvim_buf_set_lines(buf, current_line, current_line + 1, false, { line })

    -- Second pass for highlights
    for _, seg in ipairs(segments) do
      local text, hl_group = seg[1], seg[2]
      vim.api.nvim_buf_set_extmark(buf, ns, current_line, col, {
        end_col = col + #text,
        hl_group = hl_group,
      })
      col = col + #text
    end

    current_line = current_line + 1
  end
end

function M.current_commentstring()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local ts_parser = vim.treesitter.get_parser(nil, nil, { error = false })
  if not ts_parser then
    return vim.bo.commentstring
  end
  local row, col = cursor[1] - 1, cursor[2]

  local captures = vim.treesitter.get_captures_at_pos(0, row, col)
  for _, capture in ipairs(captures) do
    local id, metadata = capture.id, capture.metadata
    local metadata_commenstring = metadata['bo.commentstring'] or metadata[id] and metadata[id]['bo.commentstring']
    if metadata_commenstring then
      return metadata_commenstring
    end
  end

  local ts_commentstring, res_level = nil, 0
  ---@param lang_tree vim.treesitter.LanguageTree
  ---@param level integer
  local function traverse(lang_tree, level)
    if not lang_tree:contains({ row, col, row, col + 1 }) then
      return
    end
    local lang = lang_tree:lang()
    local filetypes = vim.treesitter.language.get_filetypes(lang)
    for _, ft in ipairs(filetypes) do
      local ft_commentstring = vim.filetype.get_option(ft, 'commentstring')
      if ft_commentstring ~= '' and level > res_level then
        ts_commentstring = ft_commentstring
      end
    end
    for _, child_lang_tree in pairs(lang_tree:children()) do
      traverse(child_lang_tree, level + 1)
    end
  end
  traverse(ts_parser, 1)
  return ts_commentstring or vim.bo.commentstring
end

return M
