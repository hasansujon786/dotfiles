local headlines = { '◎', '◯', '▣', '□', '◆', '◇', '♥', '⏾' }
local highlights = {
  '@org.headline.level1.org',
  '@org.headline.level2.org',
  '@org.headline.level3.org',
  '@org.headline.level4.org',
  '@org.headline.level5.org',
  '@org.headline.level6.org',
  '@org.headline.level7.org',
  '@org.headline.level8.org',
}

local M = {}

local function get_headings(buf)
  local parser = vim.treesitter.get_parser(buf, 'org')
  if not parser then
    return {}
  end

  local tree = parser:parse()[1]
  if not tree then
    return {}
  end
  local root = tree:root()

  local headings = {}

  -- 1) Collect headings in document order (single traversal)
  local function traverse(node)
    for child in node:iter_children() do
      if child:type() == 'headline' then
        local range = { child:range() }
        local text = vim.treesitter.get_node_text(child, buf) or ''
        local star_prefix = text:match('^(%*+)%s*') or ''
        local star_count = #star_prefix or 1
        local clean_text = text:gsub('^%*+%s*', '')

        table.insert(headings, {
          text = clean_text,
          level = star_count,
          pos = { range[1] + 1, range[2] },
          end_pos = { range[3] + 1, range[4] },
          last = false,
          prefix = '',
          branch = '',
        })
      end
      traverse(child)
    end
  end

  traverse(root)

  if #headings == 0 then
    return headings
  end

  -- 2) Single linear pass with a stack to determine `last` flags
  --    For each heading h:
  --      - pop stack entries with level >= h.level
  --         * if popped.level > h.level -> that popped entry is last (no more siblings)
  --         * if popped.level == h.level -> previous sibling exists -> not last
  --      - push current onto stack
  local stack = {}
  for i = 1, #headings do
    local h = headings[i]
    local L = h.level

    while #stack > 0 and stack[#stack].level >= L do
      local popped = table.remove(stack)
      if popped.level > L then
        popped.last = true
      else -- popped.level == L
        popped.last = false
      end
    end

    table.insert(stack, h)
  end

  -- Remaining entries in stack are last
  for i = #stack, 1, -1 do
    stack[i].last = true
  end

  -- 3) Build prefix/branch in one linear pass using active_levels
  local active_levels = {}
  for _, h in ipairs(headings) do
    local parts = {}
    for lvl = 1, h.level - 1 do
      if active_levels[lvl] then
        table.insert(parts, '│ ')
      else
        table.insert(parts, '  ')
      end
    end

    h.branch = h.last and '└╴' or '├╴'
    h.prefix = table.concat(parts) .. h.branch

    -- Update active_levels for children rendering
    active_levels[h.level] = not h.last
  end

  return headings
end

function M.pick_heading()
  if vim.bo.ft ~= 'org' then
    return vim.notify('Not an org file `pick_heading`')
  end

  local buf = vim.api.nvim_get_current_buf()

  local items = get_headings(buf)
  if not items or #items == 0 then
    return vim.notify('No results found for `pick_heading`')
  end

  Snacks.picker({
    title = 'Org Headings',
    layout = 'dropdown',
    items = items,
    confirm = function(p, item)
      vim.api.nvim_win_set_cursor(p.finder.filter.current_win, item.pos)
      p:close()
    end,
    format = function(item, picker)
      local ret = {} ---@type snacks.picker.Highlight[]

      local level = item.level or 1
      local hl = highlights[level]

      ret[#ret + 1] = { item.prefix, 'SnacksPickerTree' }

      ret[#ret + 1] = { headlines[level], hl }
      ret[#ret + 1] = { ' ' }
      ret[#ret + 1] = { item.text, hl }

      return ret
    end,
  })
end

return M
