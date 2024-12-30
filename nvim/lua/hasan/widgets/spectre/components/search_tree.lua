local fn = require('utils.fn')
local n = require('nui-components')
local Icons = require('hasan.utils.ui.icons')
local engine = require('hasan.widgets.spectre.engine')
local constants = require('hasan.widgets.spectre.constants')

local popup_options = constants.popup_options
local window = constants.hls.window

local function mappings(search_query, replace_query, insert_search_input)
  local is_replace_processing = false

  return function(component)
    return {
      { key = 'i', handler = insert_search_input, mode = { 'n' } },
      {
        mode = { 'n' },
        key = 'r',
        handler = function()
          if is_replace_processing then
            print('it is already running')
            return
          end
          is_replace_processing = true

          local tree = component:get_tree()
          local focused_node = component:get_focused_node()
          if not focused_node then
            is_replace_processing = false
            return
          end

          local has_children = focused_node:has_children()
          local entries = nil

          if has_children then
            entries = tree:get_nodes(focused_node:get_id())
          elseif not has_children then
            entries = { focused_node }
          end
          if not entries then
            is_replace_processing = false
            return
          end

          engine.run_replace(entries, tree, search_query:get_value(), replace_query:get_value())
          vim.schedule(vim.cmd.checktime)
          is_replace_processing = false
        end,
      },
    }
  end
end

local function prepare_node(node, line, component)
  local _, devicons = pcall(require, 'nvim-web-devicons')
  local has_children = node:has_children()

  line:append(string.rep('  ', node:get_depth() - 1))

  if has_children then
    local icon, icon_highlight = devicons.get_icon(node.text, string.match(node.text, '%a+$'), { default = true })

    local chevron = node:is_expanded() and Icons.Other.ChevronSlimDown or Icons.Other.ChevronSlimRight
    line:append(chevron, component:hl_group('SpectreIcon'))
    line:append(' ' .. icon .. ' ', icon_highlight)
    line:append(node.text, component:hl_group('SpectreFileName'))

    return line
  end

  local is_replacing = #node.diff.replace > 0
  local search_highlight_group = component:hl_group(is_replacing and 'SpectreSearchOldValue' or 'SpectreSearchValue')
  local default_text_highlight = component:hl_group('SpectreCodeLine')

  local _, empty_spaces = string.find(node.diff.text, '^%s*')
  local ref = node.ref

  if ref then
    line:append(Icons.Other.SquareCheck .. ' ', component:hl_group('SpectreReplaceSuccess'))
  end

  if #node.diff.search > 0 then
    local code_text = fn.trim(node.diff.text)

    fn.ieach(node.diff.search, function(value, index)
      local start = value[1] - empty_spaces
      local end_ = value[2] - empty_spaces

      if index == 1 then
        line:append(string.sub(code_text, 1, start), default_text_highlight)
      end

      local search_text = string.sub(code_text, start + 1, end_)
      line:append(search_text, search_highlight_group)

      local replace_diff_value = node.diff.replace[index]

      if replace_diff_value then
        local replace_text =
          string.sub(code_text, replace_diff_value[1] + 1 - empty_spaces, replace_diff_value[2] - empty_spaces)
        line:append(replace_text, component:hl_group('SpectreSearchNewValue'))
        end_ = replace_diff_value[2] - empty_spaces
      end

      if index == #node.diff.search then
        line:append(string.sub(code_text, end_ + 1), default_text_highlight)
      end
    end)
  end

  return line
end

local function on_select(origin_winid, exit_zoom)
  return function(node, component)
    local tree = component:get_tree()

    if node:has_children() then
      if node:is_expanded() then
        node:collapse()
      else
        node:expand()
      end

      return tree:render()
    end

    local entry = node.entry

    if vim.api.nvim_win_is_valid(origin_winid) then
      local escaped_filename = vim.fn.fnameescape(entry.filename)
      vim.api.nvim_set_current_win(origin_winid)
      vim.api.nvim_command([[execute "normal! m` "]])
      vim.cmd.edit(escaped_filename)
      vim.api.nvim_win_set_cursor(0, { entry.lnum, entry.col - 1 })

      if type(exit_zoom) == 'function' then
        vim.schedule(exit_zoom)
      end
    end
  end
end

local function search_tree(props)
  local tree = n.tree({
    id = 'search_tree',
    border_style = 'none',
    flex = 1,
    padding = { left = 1, right = 1 },
    hidden = props.hidden,
    data = props.data,
    mappings = mappings(props.search_query, props.replace_query, props.insert_search_input),
    prepare_node = prepare_node,
    on_select = on_select(props.origin_winid, props.exit_zoom),
    window = window,
  }, popup_options)
  -- This hl appear on tree focus
  vim.api.nvim_set_hl(tree._private.namespace, 'NormalFloat', { link = window.highlight.NormalFloat })
  return tree
end

return search_tree
