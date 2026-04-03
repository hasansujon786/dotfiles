local M = {}

-- Walk up from cursor to find the enclosing React component node
local function find_component(node)
  local cur = node
  while cur do
    local t = cur:type()
    if t == 'function_declaration' or t == 'export_statement' then
      -- export_statement wraps function_declaration; check its declaration child
      local decl = cur:field('declaration')[1]
      if decl and decl:type() == 'function_declaration' then
        return decl, 'function_declaration', cur -- return export_statement as "outer" for row
      end
      if t == 'function_declaration' then
        return cur, 'function_declaration', cur
      end
    elseif t == 'variable_declarator' then
      local val = cur:field('value')[1]
      if val and val:type() == 'arrow_function' then
        return cur, 'arrow_function', cur
      end
    end
    cur = cur:parent()
  end
  return nil, nil, nil
end

-- Get the formal_parameters node
local function get_params(comp_node, kind)
  if kind == 'function_declaration' then
    return comp_node:field('parameters')[1]
  elseif kind == 'arrow_function' then
    local arrow = comp_node:field('value')[1]
    return arrow and arrow:field('parameters')[1]
  end
end

-- Get the top-level declaration row (the line we insert the interface above)
local function get_decl_start_row(comp_node, kind, outer)
  if kind == 'function_declaration' and outer and outer:type() == 'export_statement' then
    local row = outer:range()
    return row
  end
  local row = comp_node:range()
  return row
end

function M.generate_props_interface()
  if vim.o.filetype ~= 'typescriptreact' then
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local node = vim.treesitter.get_node()

  if not node then
    vim.notify('No treesitter node at cursor', vim.log.levels.WARN)
    return
  end

  local comp_node, kind, outer = find_component(node)
  if not comp_node then
    vim.notify('Not inside a React component', vim.log.levels.WARN)
    return
  end

  -- Component name
  local name_node = comp_node:field('name')[1]
  local comp_name = name_node and vim.treesitter.get_node_text(name_node, bufnr) or 'Component'
  local props_type = comp_name .. 'Props'

  -- Check if interface already exists just above
  local props_already_exists = false
  local decl_row = get_decl_start_row(comp_node, kind, outer) -- 0-indexed
  if decl_row > 0 then
    local find_interface_start_line = decl_row < 3 and 0 or decl_row - 3
    local prev_lines = vim.api.nvim_buf_get_lines(bufnr, find_interface_start_line, decl_row, false)
    for _, l in ipairs(prev_lines) do
      if l:find('interface ' .. props_type) or l:find('type ' .. props_type) then
        props_already_exists = true
        break
      end
    end
  end

  -- Get params node to check / replace
  local params_node = get_params(comp_node, kind)
  if not params_node then
    vim.notify('Could not find parameters node', vim.log.levels.WARN)
    return
  end

  local params_text = vim.treesitter.get_node_text(params_node, bufnr)
  -- Bail if params are non-trivial (already has something meaningful)
  if params_text ~= '()' and not params_text:match('^%(%s*%)$') then
    vim.notify('Parameters are non-empty, not overwriting', vim.log.levels.WARN)
    return
  end

  -- ── 1. Insert the interface above the declaration ──────────────────────
  local shift = 0
  if props_already_exists == false then
    local interface_lines = {
      'interface ' .. props_type .. ' {',
      '}',
      '',
    }
    shift = #interface_lines
    vim.api.nvim_buf_set_lines(bufnr, decl_row, decl_row, false, interface_lines)
  end

  -- ── 2. Replace () with ({}: XxxProps) ──────────────────────────────────
  -- After insertion the params node row has shifted by #interface_lines rows
  local pr, pc_start, _, pc_end = params_node:range()
  local new_row = pr + shift

  vim.api.nvim_buf_set_text(bufnr, new_row, pc_start, new_row, pc_end, { '({}: ' .. props_type .. ')' })

  -- ── 3. Position cursor on the interface opening brace line ─────────────
  vim.api.nvim_win_set_cursor(0, { decl_row + 1, 14 }) -- line is 1-indexed

  vim.notify('Generated ' .. props_type, vim.log.levels.INFO)
end

return M
