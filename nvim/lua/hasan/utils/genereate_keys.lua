-- Serializer for inline table formatting
local function serialize_inline(val)
  local t = type(val)

  if t == 'string' then
    return string.format('%q', val)
  elseif t == 'number' or t == 'boolean' then
    return tostring(val)
  elseif t == 'table' then
    local parts = {}

    -- Array-style values first
    for i, v in ipairs(val) do
      if type(v) == 'table' and v.__code then
        table.insert(parts, v.__code) -- write literal code
      else
        table.insert(parts, serialize_inline(v))
      end
    end

    -- Key-value pairs
    for k, v in pairs(val) do
      if type(k) ~= 'number' then
        local key
        if type(k) == 'string' and k:match('^[%a_][%w_]*$') then
          key = k .. ' = '
        else
          key = '[' .. serialize_inline(k) .. '] = '
        end
        if type(v) == 'table' and v.__code then
          table.insert(parts, v.__code) -- write literally
          -- table.insert(parts, key .. v.__code)
        else
          table.insert(parts, key .. serialize_inline(v))
        end
      end
    end

    return '{ ' .. table.concat(parts, ', ') .. ' }'
  else
    return 'nil'
  end
end

-- Top-level pretty print for arrays
local function serialize_top_level_array(name, tbl)
  local lines = { 'local ' .. name .. ' = {' }
  for _, v in ipairs(tbl) do
    table.insert(lines, '  ' .. serialize_inline(v) .. ',')
  end
  table.insert(lines, '}')
  return table.concat(lines, '\n')
end

-- Write all M functions from current buffer using Treesitter
---@param file file*
local function write_functions(file)
  local ts = vim.treesitter

  local lang = vim.bo.filetype
  local parser = ts.get_parser(0, lang)
  local tree = parser:parse()[1]
  local root = tree:root()

  local functions = {}

  local function get_node_text(node)
    return vim.treesitter.get_node_text(node, 0)
  end

  local function is_M_function(node)
    -- function M.name(...) ... end
    if node:type() == 'function_definition' or node:type() == 'function_declaration' then
      local name_node = node:field('name')[1]
      if name_node then
        local full_name = get_node_text(name_node)
        return full_name:match('^M%.')
      end
    end

    -- M.name = function(...) ... end
    if node:type() == 'assignment_statement' then
      local left = node:child(0)
      local right = node:child(2)
      if right and (right:type() == 'function_definition' or right:type() == 'function_declaration') then
        local left_text = get_node_text(left)
        return left_text:match('^M%.')
      end
    end

    return false
  end

  local function find_M_functions(node)
    if is_M_function(node) then
      table.insert(functions, get_node_text(node))
    end
    for child in node:iter_children() do
      find_M_functions(child)
    end
  end

  find_M_functions(root)

  for _, fn_text in ipairs(functions) do
    file:write(fn_text .. '\n\n')
  end
end

-- Main module
return {
  run = function(maps_common, maps, path, opts)
    local file = io.open(path, 'w')
    if file then
      file:write(opts.header)
      -- Write all functions assigned to M first
      write_functions(file)

      -- Write tables
      file:write(serialize_top_level_array('maps_common', maps_common) .. '\n')
      file:write(serialize_top_level_array('maps', maps) .. '\n')

      -- Write footer if any
      if opts.footer then
        file:write(opts.footer)
      end

      file:close()
      print('File written successfully to ' .. path)
    else
      print('Error: Could not open file.')
    end
  end,
  copyContent = function(from, to)
    -- Open the source file for reading
    local sourceFile, err = io.open(from, 'r')
    if not sourceFile then
      print('Error opening source file:', err)
      return
    end

    -- Read the entire content
    local content = sourceFile:read('*a')
    sourceFile:close()

    -- Open the destination file for writing
    local destFile, err = io.open(to, 'a')
    if not destFile then
      print('Error opening destination file:', err)
      return
    end

    -- Write the content
    destFile:write('\n-------------------------------------------------------------------------------\n')
    destFile:write('-- Generated from "' .. from .. '"')
    destFile:write('\n-------------------------------------------------------------------------------\n')
    destFile:write(content)
    destFile:close()

    print('Content copied successfully from ' .. from .. ' to ' .. to)
  end,
}
