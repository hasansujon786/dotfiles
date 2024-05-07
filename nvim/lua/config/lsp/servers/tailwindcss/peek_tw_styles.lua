---------------------------------------------------
--------- Peek tailwind styles --------------------
---------------------------------------------------
-- Source: https://github.com/MaximilianLloyd/Dotfiles/blob/master/nvim/.config/nvim/lua/maximilianlloyd/init.lua
-- Similar feature: https://github.com/MaximilianLloyd/tw-values.nvim
local M = {}

local twHover = {
  mysplit = function(inputstr, sep, init_col)
    if sep == nil then
      sep = '%s'
    end
    local t = {}

    local offset = 0

    for str in string.gmatch(inputstr, '([^' .. sep .. ']+)') do
      local new_col = init_col + offset
      table.insert(t, {
        str = str,
        col = new_col,
      })
      offset = offset + #str + 1
    end
    return t
  end,
  get_root = function(bufnr)
    local parser = vim.treesitter.get_parser(bufnr, 'tsx')
    -- vim.treesitter.par
    local tree = parser:parse()[1]

    return tree:root()
  end,
}

function M.peekTwStyles(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  -- local root = twHover.get_root(bufnr)
  local cursor = vim.treesitter.get_node({
    bufnr = bufnr,
  })

  if cursor == nil then
    print('No cursor found')
    return
  end

  if cursor:type() ~= 'string_fragment' then
    print('Cursor is not a string_fragment')
    return
  end

  local parsed_cursor = vim.treesitter.get_node_text(cursor, bufnr)

  -- Get lsp clients and find tailwind
  local clients = vim.lsp.get_active_clients()

  local tw = nil

  for _, client in pairs(clients) do
    if client.name == 'tailwindcss' then
      tw = client
    end
  end

  if tw == nil then
    print('No tailwindcss client found')
    return
  end

  local results = {
    '.test {',
  }

  local range = { vim.treesitter.get_node_range(cursor) }
  local classes = twHover.mysplit(parsed_cursor, ' ', range[2])
  local index = 0
  local longest = 0

  for _, class in ipairs(classes) do
    tw.request('textDocument/hover', {
      textDocument = vim.lsp.util.make_text_document_params(),
      position = {
        line = range[1],
        -- Only this
        character = class.col, --range[2]
      },
    }, function(err, result, ctx, config)
      index = index + 1

      if err then
        print('Error getting tailwind config')
        return
      end

      -- print(vim.inspect(result.contents))
      local pre_text = result.contents.value
      local extracted = vim.split(pre_text, '\n')

      table.remove(extracted, 1)
      table.remove(extracted, #extracted)

      for _, value in ipairs(extracted) do
        table.insert(results, #results + 1, value)

        if value:len() > longest then
          longest = #value
        end
      end

      if index == #classes then
        table.insert(results, #results + 1, '}')
        local height = #results + 1

        vim.lsp.util.open_floating_preview(results, 'css', {
          border = 'rounded',
          width = longest,
          height = height,
        })
      end
    end, bufnr)
  end
end

-- local embedded_classes = vim.treesitter.query.parse(
--   'tsx',
--   [[
-- (jsx_element
--   (jsx_opening_element
--     (jsx_attribute
--       (property_identifier ) @attr_name
--       (#match? @attr_name "className")
--       (string
--       (string_fragment) @values
--       )
--       )
--     )
--   )
-- ]]
-- )

return M
