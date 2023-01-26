-- Source: https://www.reddit.com/r/neovim/comments/10kix9l/conceal_html_class_attribute_values_im_talking_to/
local namespace = vim.api.nvim_create_namespace('class_conceal')
local group = vim.api.nvim_create_augroup('class_conceal', { clear = true })
local M = {}

local conceal_html_class = function(bufnr)
  local language_tree = vim.treesitter.get_parser(bufnr, 'html')
  local syntax_tree = language_tree:parse()
  local root = syntax_tree[1]:root()

  local query = vim.treesitter.parse_query(
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

  for _, captures, metadata in query:iter_matches(root, bufnr, root:start(), root:end_()) do
    local start_row, start_col, end_row, end_col = captures[2]:range()
    vim.api.nvim_buf_set_extmark(bufnr, namespace, start_row, start_col, {
      end_line = end_row,
      end_col = end_col,
      conceal = metadata[2].conceal,
    })
  end
end

M.setup_tailwindcss = function(bufnr)
  vim.wo.conceallevel = 2
  conceal_html_class(bufnr)

  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'TextChanged', 'InsertLeave' }, {
    group = group,
    buffer = bufnr,
    -- pattern = '*.html',
    callback = function()
      conceal_html_class(bufnr)
    end,
  })
end

M.toggle_conceallevel = function()
  if vim.wo.conceallevel == 0 then
    M.setup_tailwindcss(0)
  else
    vim.wo.conceallevel = 0
    -- vim.api.nvim_del_augroup_by_id(group)
  end
end

return M
