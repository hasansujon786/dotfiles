-- local function custom_highlight(input)
--   return { { 0, #input, 'InputHighlight' } }
-- end

local M = {}

local function get_highest_sementic_tokens(semantic_tokens)
  -- Filter out tokens with hl_group_link == "@lsp"
  local filtered = vim.tbl_filter(function(token)
    return token.opts.hl_group_link ~= '@lsp'
  end, semantic_tokens)

  -- Sort descending by priority
  table.sort(filtered, function(a, b)
    return a.opts.priority > b.opts.priority
  end)
  return filtered[1]
end

local function get_treesitter_hl(treesitter)
  if not treesitter or #treesitter <= 0 then
    return nil
  end

  local filtered = vim.tbl_filter(function(token)
    return token.hl_group_link ~= '@spell'
  end, treesitter)

  return filtered[#filtered]
end

function M.get_active_hl_at_cursor()
  local highlight = ''
  local items = vim.inspect_pos(0, nil, nil, {
    syntax = false,
    extmarks = false,
    semantic_tokens = true,
    treesitter = true,
  })

  local found_token = get_highest_sementic_tokens(items.semantic_tokens)
  if found_token and found_token.opts.hl_group then
    highlight = found_token.opts.hl_group
  end

  if highlight == '' then
    local hl = get_treesitter_hl(items.treesitter)
    if hl and hl.hl_group then
      highlight = hl.hl_group
    end
  end
  return highlight
end

function M.winhighlight(highlights)
  return table.concat(
    vim.tbl_map(function(key)
      return key .. ':' .. highlights[key]
    end, vim.tbl_keys(highlights)),
    ','
  )
end

return M
