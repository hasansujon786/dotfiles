local engine = require('hasan.widgets.spectre.engine')
local fn = require('utils.fn')
local n = require('nui-components')
local Icons = require('hasan.utils.ui.icons')
local search_tree = require('hasan.widgets.spectre.components.search_tree')

local M = {}

function M.toggle()
  if M.renderer then
    return M.renderer:focus()
  end
  local width = 46
  local height = vim.api.nvim_list_uis()[1].height - 1

  local renderer = n.create_renderer({
    width = width,
    height = height,
    relative = 'editor',
    position = { row = 0, col = '100%' },
  })

  local signal = n.create_signal({
    search_query = '',
    replace_query = '',
    search_paths = {},
    is_replace_field_visible = false,
    is_case_insensitive_checked = false,
    search_info = '',
    search_results = {},
  })

  local subscription = signal:observe(function(prev, curr)
    local diff = fn.isome({ 'search_query', 'is_case_insensitive_checked', 'search_paths' }, function(key)
      return not vim.deep_equal(prev[key], curr[key])
    end)

    if diff then
      if #curr.search_query > 2 then
        engine.search(curr, signal)
      else
        signal.search_info = ''
        signal.search_results = {}
      end
    end

    if not (prev.replace_query == curr.replace_query) and #curr.search_query > 2 then
      signal.search_results = engine.process(curr)
    end
  end)

  local function move_cursor_to_eol()
    if vim.api.nvim_get_mode().mode == 'i' then
      feedkeys('A')
    end
  end
  local actions = {
    toggle_replace_input = function(is_checked)
      signal.is_replace_field_visible = is_checked

      if is_checked then
        local replace_component = renderer:get_component_by_id('replace_query')

        renderer:schedule(function()
          replace_component:focus()
          move_cursor_to_eol()
        end)
      end
    end,
  }

  renderer:add_mappings({
    {
      mode = { 'n' },
      key = '<leader>q',
      handler = function()
        renderer:close()
      end,
    },
    {
      mode = { 'n', 'i' },
      key = '<c-t>',
      handler = function()
        local is_visible = not signal.is_replace_field_visible:get_value()
        actions.toggle_replace_input(is_visible)
        if not is_visible then
          local search_component = renderer:get_component_by_id('search_query')

          renderer:schedule(function()
            search_component:focus()
            move_cursor_to_eol()
          end)
        end
      end,
    },
  })

  renderer:on_unmount(function()
    subscription:unsubscribe()
    M.renderer = nil
  end)

  M.renderer = renderer

  local body = n.columns(
    n.rows(
      1,
      n.checkbox({
        border_style = 'none',
        default_sign = Icons.ui.ChevronRight,
        checked_sign = Icons.ui.ChevronDown,
        padding = { top = 1, left = 1, bottom = 1 },
        value = signal.is_replace_field_visible,
        on_change = function(is_checked)
          actions.toggle_replace_input(is_checked)
        end,
        window = {
          highlight = {
            NormalFloat = 'Normal',
          },
        },
      })
    ),
    n.rows(
      10,
      n.columns(
        { size = 3 },
        n.text_input({
          autofocus = true,
          flex = 1,
          max_lines = 1,
          id = 'search_query',
          border_label = 'Search',
          on_change = fn.debounce(function(value)
            signal.search_query = value
          end, 400),
          -- window = {
          --   blend = 0,
          --   highlight = {
          --     FloatBorder = 'Normal',
          --     NormalFloat = 'String',
          --   },
          -- },
        }),
        n.checkbox({
          label = 'Aa',
          default_sign = '',
          checked_sign = '',
          border_style = 'rounded',
          value = signal.is_case_insensitive_checked,
          on_change = function(is_checked)
            signal.is_case_insensitive_checked = is_checked
          end,
        })
      ),
      n.text_input({
        size = 1,
        max_lines = 1,
        id = 'replace_query',
        border_label = 'Replace',
        on_change = fn.debounce(function(value)
          signal.replace_query = value
        end, 400),
        hidden = signal.is_replace_field_visible:map(function(value)
          return not value
        end),
      }),
      n.text_input({
        size = 1,
        max_lines = 1,
        border_label = 'Files to include',
        value = signal.search_paths:map(function(paths)
          return table.concat(paths, ',')
        end),
        on_change = fn.debounce(function(value)
          signal.search_paths = fn.ireject(fn.imap(vim.split(value, ','), fn.trim), function(path)
            return path == ''
          end)
        end, 400),
      }),
      n.rows(
        {
          flex = 0,
          hidden = signal.search_info:map(function(value)
            return value == ''
          end),
        },
        n.paragraph({
          is_focusable = false,
          lines = signal.search_info,
          padding = { left = 1, right = 1 },
        })
      ),
      n.gap(1),
      search_tree({
        search_query = signal.search_query,
        replace_query = signal.replace_query,
        data = signal.search_results,
        origin_winid = renderer:get_origin_winid(),
        hidden = signal.search_results:map(function(value)
          return #value == 0
        end),
      })
      -- n.gap(1),
      -- n.columns(
      --   {
      --     size = 1,
      --     on_state_change = function(state)
      --       return {
      --         hidden = not (state.search_results and #state.replace_value > 0)
      --       }
      --     end
      --   },
      --   n.gap({flex = 1}),
      --   n.button(
      --     {
      --       label = "Replace All",
      --       on_press = function()
      --       end
      --     }
      --   ),
      --   n.gap(1),
      --   n.button(
      --     {
      --       label = "Clear",
      --       on_press = function()
      --       end
      --     }
      --   )
      -- )
    )
  )

  renderer:render(body)
  renderer.layout._.float.win_options = { winblend = 0, winhighlight = 'Normal:Normal' }
end

return M
