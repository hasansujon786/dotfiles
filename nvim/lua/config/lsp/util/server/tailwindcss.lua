---------------------------------------------------
--------- Conceal html class ----------------------
---------------------------------------------------
-- Source: https://www.reddit.com/r/neovim/comments/10kix9l/conceal_html_class_attribute_values_im_talking_to/
local namespace = vim.api.nvim_create_namespace('class_conceal')
local group = vim.api.nvim_create_augroup('class_conceal', { clear = true })
local M = {}
local hasNvim9 = vim.fn.has('nvim-0.9') == 1

local function del_buffer_extmark()
  if vim.b.class_conceal_ns_ids ~= nil then
    for _, id in pairs(vim.b.class_conceal_ns_ids) do
      vim.api.nvim_buf_del_extmark(0, namespace, id)
    end
  end
end

local function conceal_html_class(bufnr)
  local language_tree = vim.treesitter.get_parser(bufnr, 'html')
  local syntax_tree = language_tree:parse()
  local root = syntax_tree[1]:root()
  local parser = hasNvim9 and vim.treesitter.query.parse or vim.treesitter.parse_query

  local query = parser(
    'html',
    [[
    ((attribute
        (attribute_name) @att_name (#eq? @att_name "class")
        (quoted_attribute_value (attribute_value) @class_value) (#set! @class_value conceal "…")))

    ((attribute
        (attribute_name) @att_name (#eq? @att_name "className")
        (quoted_attribute_value (attribute_value) @class_value) (#set! @class_value conceal "…")))
    ]]
  )

  del_buffer_extmark()
  local ns_ids = {}

  for _, captures, metadata in query:iter_matches(root, bufnr, root:start(), root:end_()) do
    local start_row, start_col, end_row, end_col = captures[2]:range()
    local ns_id = vim.api.nvim_buf_set_extmark(bufnr, namespace, start_row, start_col, {
      end_line = end_row,
      end_col = end_col,
      conceal = metadata[2].conceal,
    })
    table.insert(ns_ids, ns_id)
  end
  vim.b.class_conceal_ns_ids = ns_ids
end

function M.setup_conceal(bufnr)
  if vim.b.class_conceal_active == false then
    return
  end

  vim.wo.conceallevel = 2
  vim.b.class_conceal_active = true
  conceal_html_class(bufnr)

  vim.api.nvim_create_autocmd({ 'TextChanged', 'InsertLeave' }, {
    group = group,
    buffer = bufnr,
    -- pattern = '*.html',
    callback = function()
      if vim.b.class_conceal_active then
        conceal_html_class(bufnr)
      end
    end,
  })
end

function M.toggle_conceallevel()
  if not vim.b.class_conceal_active then
    vim.b.class_conceal_active = true
    M.setup_conceal(0)
  else
    del_buffer_extmark()

    vim.wo.conceallevel = 0
    vim.b.class_conceal_ns_ids = nil
    vim.b.class_conceal_active = false
  end
end

---------------------------------------------------
--------- Peek tailwind styles --------------------
---------------------------------------------------
-- Source: https://github.com/MaximilianLloyd/Dotfiles/blob/master/nvim/.config/nvim/lua/maximilianlloyd/init.lua
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

function M.setup(bufnr)
  if state.treesitter.auto_conceal_html_class then
    require('config.lsp.util.server.tailwindcss').setup_conceal(bufnr)
  end

  keymap('n', 'gK', M.peekTwStyles, { desc = 'Peek tailwind styles', buffer = bufnr })
end

return M
