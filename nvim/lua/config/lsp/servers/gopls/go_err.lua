local M = {}

local ts = vim.treesitter

---@class InlineErrNodes
---@field block TSNode       -- the body of the if statement
---@field call TSNode        -- the function call expression
---@field cond TSNode        -- the condition variable ("err")
---@field decl TSNode        -- the short variable declaration (optional)
---@field initializer TSNode -- the inline initializer (optional)
---@field ["if"] TSNode      -- the whole if statement text
---@field lhs TSNode

local query = ts.query.parse(
  'go',
  [[
(
  (short_var_declaration
    left: (expression_list (identifier) @lhs (#eq? @lhs "err"))
    right: (expression_list (call_expression) @call)
  )? @decl

  (if_statement
    initializer: (
      (short_var_declaration
        left: (expression_list (identifier) @lhs (#eq? @lhs "err"))
        right: (expression_list (call_expression) @call)
      ) @initializer
    )?

    condition: (binary_expression
      left: (identifier) @cond (#eq? @cond "err")
      right: (nil)
    )
    consequence: (block) @block
  ) @if
)
    ]]
)

---@return InlineErrNodes|nil
local function get_nodes(bufnr, cursor_row)
  local parser = ts.get_parser(bufnr, 'go')
  if not parser then
    return
  end

  local tree = parser:parse()[1]
  local root = tree:root()
  cursor_row = cursor_row - 1 -- 0-indexed

  local selected_match

  for _, match, _ in query:iter_matches(root, bufnr) do
    local if_node
    for id, nodes in pairs(match) do
      if query.captures[id] == 'if' then
        if_node = nodes[1]
        break
      end
    end

    if if_node then
      local s_row, _, e_row, _ = if_node:range()
      if cursor_row >= s_row and cursor_row <= e_row then
        selected_match = match -- This is the one under cursor
        break
      end
    end
  end

  if not selected_match then
    return nil
  end

  -- collect captures
  local data = {}
  for id, nodes in pairs(selected_match) do
    local name = query.captures[id]
    if name then
      data[name] = nodes[1]
    end
  end

  -- If no initializer, pick the closest decl above this if (not any global err)
  if not data.initializer and data['if'] and data.decl then
    local if_start_row = data['if']:range()
    local decl_row = data.decl:range()
    if decl_row > if_start_row then
      -- Ignore declarations that are *after* this if
      data.decl = nil
    else
      -- Search for the *closest* declaration above
      local closest_decl
      local closest_row = -1
      for _, match, _ in query:iter_matches(root, bufnr) do
        for id, nodes in pairs(match) do
          if query.captures[id] == 'decl' then
            local d = nodes[1]
            local d_row = d:range()
            if d_row < if_start_row and d_row > closest_row then
              closest_row = d_row
              closest_decl = d
            end
          end
        end
      end
      data.decl = closest_decl
    end
  end

  return data
end

function M.toggle_inline_err()
  local bufnr = vim.api.nvim_get_current_buf()
  local data

  local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))
  data = get_nodes(bufnr, cursor_row)

  if not data or not data['if'] then
    vim.notify('No inline err block under cursor', 'info', { title = 'GoErrDeclToggle' })
    return
  end

  local decl_text = vim.treesitter.get_node_text(data.initializer or data.decl, bufnr) or nil
  local block_text = vim.treesitter.get_node_text(data.block, bufnr)

  local start_row = (data.initializer or data.decl):range() -- start from decl if exists
  local _, _, end_row = data['if']:range()

  local code_text = ''

  -- toggle logic
  if data.initializer then
    local if_line = string.format('if err != nil %s', block_text)
    code_text = decl_text .. '\n' .. if_line
  else
    code_text = string.format('if %s; err != nil %s', decl_text, block_text)
  end

  -- Convert new lines to array
  local new_code_lines = {}
  for line in code_text:gmatch('([^\n]*)\n?') do
    if line ~= '' then
      table.insert(new_code_lines, line)
    end
  end

  vim.api.nvim_buf_set_lines(bufnr, start_row, end_row + 1, false, new_code_lines)

  -- re-indent the inserted code
  vim.cmd(string.format('normal %dGV%dG=', start_row + 1, start_row + #new_code_lines))
  vim.api.nvim_win_set_cursor(0, { start_row + 1 + (data.initializer and 1 or 0), cursor_col })
  vim.fn['repeat#set'](t('<Plug>(GoErrDeclToggle)'))
end

return M
