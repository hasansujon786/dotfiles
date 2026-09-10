local M = {}

--- Converts a string (PascalCase, camelCase, etc.) into snake_case,
--- stripping any leading underscores.
---@param str string
---@return string
local function to_snake_case(str)
  if not str or str == '' then
    return ''
  end

  -- Strip all leading underscores
  local body = str:gsub('^%_+', '')
  if body == '' then
    return ''
  end

  -- Insert underscore between lowercase/digit and uppercase (e.g. HomeTab -> Home_Tab)
  local result = body:gsub('([a-z0-9])([A-Z])', '%1_%2')

  -- Insert underscore before a capital letter if followed by lowercase (e.g. APIResponse -> API_Response)
  result = result:gsub('([A-Z]+)([A-Z][a-z])', '%1_%2')

  -- Return lowercased result
  return result:lower()
end

--- Walks up the Tree-sitter AST from the current cursor position
--- to find the enclosing `class_definition` node and extracts its name.
---@return string|nil class_name The name of the class, or nil if not inside a class.
function M.get_current_class_name()
  if vim.bo.filetype ~= 'dart' then
    return nil
  end

  local node = vim.treesitter.get_node()
  if not node then
    return nil
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local cur = node

  while cur do
    if cur:type() == 'class_definition' then
      local name_node = cur:field('name')[1]
      if name_node then
        local raw_name = vim.treesitter.get_node_text(name_node, bufnr)

        -- If cursor is inside a private State class (e.g., _HomeTabScreenState),
        -- strip trailing "State" so it resolves to "HomeTabScreen" -> "home_tab_screen.dart"
        if raw_name:match('^%_.*State$') then
          raw_name = raw_name:gsub('State$', '')
        end

        return raw_name
      end
    end
    cur = cur:parent()
  end

  return nil
end

--- Renames the current buffer's file to a new filename inside the same directory.
---@param new_filename string The new filename (e.g., "home_tab_screen.dart")
function M.rename_current_file(new_filename)
  local current_filepath = vim.api.nvim_buf_get_name(0)

  if current_filepath == '' or vim.bo.buftype ~= '' then
    vim.notify('Current buffer is not a valid file on disk', vim.log.levels.WARN)
    return
  end

  -- Get current file directory and construct path cleanly across platforms
  local current_dir = vim.fn.fnamemodify(current_filepath, ':h')
  local new_path = vim.fs and vim.fs.joinpath and vim.fs.joinpath(current_dir, new_filename)
    or (current_dir .. '/' .. new_filename)

  if current_filepath == new_path then
    vim.notify('Filename already matches class name', vim.log.levels.INFO)
    return
  end

  -- local ok, file_ops = pcall(require, 'nvim-file-operations')
  -- if not ok then
  --   vim.notify('nvim-file-operations plugin is not loaded', vim.log.levels.ERROR)
  --   return
  -- end
  -- file_ops.rename({
  --   old_name = current_filepath,
  --   new_name = new_path,
  -- })

  Snacks.rename.rename_file({
    from = current_filepath,
    to = new_path,
  })
end

function M.sync_filename_with_class()
  local class_name = M.get_current_class_name()
  if not class_name or class_name == '' then
    vim.notify('Not inside a Dart class', vim.log.levels.WARN)
    return
  end

  local ext = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':e')
  ext = (ext ~= '') and ext or 'dart'

  local normalized_name = to_snake_case(class_name)
  M.rename_current_file(normalized_name .. '.' .. ext)
end

return M
