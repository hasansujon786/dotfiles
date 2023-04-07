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

M.setup_conceal = function(bufnr)
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

M.toggle_conceallevel = function()
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

return M
